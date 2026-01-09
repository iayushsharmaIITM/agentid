-- AgentID Initial Schema
-- Database schema for AI agent identity and reputation platform

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE agent_status AS ENUM ('active', 'suspended', 'revoked');
CREATE TYPE action_status AS ENUM ('success', 'failure', 'pending');

-- ============================================================================
-- OWNERS TABLE
-- ============================================================================
-- Companies or individuals who own AI agents
CREATE TABLE owners (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    company TEXT,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for email lookups
CREATE INDEX idx_owners_email ON owners(email);

-- ============================================================================
-- AGENTS TABLE
-- ============================================================================
-- Registered AI agent identities
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES owners(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    capabilities TEXT[] DEFAULT '{}',
    api_key_hash TEXT NOT NULL,
    status agent_status DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT agents_name_length CHECK (char_length(name) <= 255),
    CONSTRAINT agents_description_length CHECK (char_length(description) <= 1000)
);

-- Indexes for common queries
CREATE INDEX idx_agents_owner_id ON agents(owner_id);
CREATE INDEX idx_agents_status ON agents(status);
CREATE INDEX idx_agents_created_at ON agents(created_at DESC);

-- ============================================================================
-- ACTIONS TABLE
-- ============================================================================
-- Log of agent activities for reputation scoring
CREATE TABLE actions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    status action_status NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_actions_agent_id ON actions(agent_id);
CREATE INDEX idx_actions_status ON actions(status);
CREATE INDEX idx_actions_created_at ON actions(created_at DESC);
CREATE INDEX idx_actions_agent_id_created_at ON actions(agent_id, created_at DESC);

-- ============================================================================
-- REPUTATION_SCORES TABLE
-- ============================================================================
-- Calculated trust scores for agents
CREATE TABLE reputation_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID UNIQUE NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    score DECIMAL(5,2) DEFAULT 50.00 CHECK (score >= 0 AND score <= 100),
    total_actions INTEGER DEFAULT 0,
    successful_actions INTEGER DEFAULT 0,
    failed_actions INTEGER DEFAULT 0,
    last_calculated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT reputation_actions_sum CHECK (total_actions = successful_actions + failed_actions)
);

-- Index for agent lookups
CREATE INDEX idx_reputation_agent_id ON reputation_scores(agent_id);
CREATE INDEX idx_reputation_score ON reputation_scores(score DESC);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Update updated_at timestamp on owners table
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_owners_updated_at
    BEFORE UPDATE ON owners
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agents_updated_at
    BEFORE UPDATE ON agents
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Initialize reputation score when agent is created
CREATE OR REPLACE FUNCTION initialize_reputation_score()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO reputation_scores (agent_id, score, total_actions, successful_actions, failed_actions)
    VALUES (NEW.id, 50.00, 0, 0, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_reputation_on_agent_insert
    AFTER INSERT ON agents
    FOR EACH ROW
    EXECUTE FUNCTION initialize_reputation_score();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE agents ENABLE ROW LEVEL SECURITY;
ALTER TABLE actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reputation_scores ENABLE ROW LEVEL SECURITY;

-- Owners can read their own data
CREATE POLICY "Owners can view own data"
    ON owners FOR SELECT
    USING (auth.uid()::text = id::text);

-- Owners can update their own data
CREATE POLICY "Owners can update own data"
    ON owners FOR UPDATE
    USING (auth.uid()::text = id::text);

-- Owners can view their own agents
CREATE POLICY "Owners can view own agents"
    ON agents FOR SELECT
    USING (owner_id::text = auth.uid()::text OR status = 'active');

-- Owners can insert their own agents
CREATE POLICY "Owners can create own agents"
    ON agents FOR INSERT
    WITH CHECK (owner_id::text = auth.uid()::text);

-- Owners can update their own agents
CREATE POLICY "Owners can update own agents"
    ON agents FOR UPDATE
    USING (owner_id::text = auth.uid()::text);

-- Owners can view actions of their agents
CREATE POLICY "Owners can view own agent actions"
    ON actions FOR SELECT
    USING (agent_id IN (SELECT id FROM agents WHERE owner_id::text = auth.uid()::text));

-- Service role can insert actions (via API)
CREATE POLICY "Service can insert actions"
    ON actions FOR INSERT
    WITH CHECK (true);

-- Anyone can read reputation scores
CREATE POLICY "Anyone can view reputation scores"
    ON reputation_scores FOR SELECT
    USING (true);

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to calculate reputation score
CREATE OR REPLACE FUNCTION calculate_reputation_score(p_agent_id UUID)
RETURNS DECIMAL AS $$
DECLARE
    v_total INTEGER;
    v_successful INTEGER;
    v_failed INTEGER;
    v_success_rate DECIMAL;
    v_score DECIMAL;
BEGIN
    -- Count actions
    SELECT 
        COUNT(*),
        COUNT(*) FILTER (WHERE status = 'success'),
        COUNT(*) FILTER (WHERE status = 'failure')
    INTO v_total, v_successful, v_failed
    FROM actions
    WHERE agent_id = p_agent_id;
    
    -- Calculate success rate
    IF v_total > 0 THEN
        v_success_rate := (v_successful::DECIMAL / v_total::DECIMAL);
        -- Score is weighted: 70% success rate + 30% volume bonus (capped at 30)
        v_score := (v_success_rate * 70) + LEAST(v_total * 0.1, 30);
    ELSE
        v_score := 50.00; -- Default score for new agents
    END IF;
    
    -- Update reputation_scores table
    UPDATE reputation_scores
    SET 
        score = v_score,
        total_actions = v_total,
        successful_actions = v_successful,
        failed_actions = v_failed,
        last_calculated = NOW()
    WHERE agent_id = p_agent_id;
    
    RETURN v_score;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SEED DATA (Optional - for development)
-- ============================================================================

-- Uncomment to add sample data for testing
-- INSERT INTO owners (email, name, company, verified) VALUES
--     ('demo@example.com', 'Demo User', 'Acme Corp', true);
