/**
 * AgentID TypeScript SDK
 * 
 * Official TypeScript/JavaScript client for the AgentID platform.
 */

export interface AgentIDConfig {
  apiKey: string
  baseUrl?: string
}

export interface RegisterAgentParams {
  name: string
  description: string
  capabilities?: string[]
}

export interface LogActionParams {
  action_type: string
  status: 'success' | 'failure' | 'pending'
  metadata?: Record<string, any>
}

export interface Agent {
  id: string
  owner_id: string
  name: string
  description: string
  capabilities: string[]
  status: 'active' | 'suspended' | 'revoked'
  created_at: string
  updated_at: string
}

export interface Reputation {
  score: number
  total_actions: number
  successful_actions: number
  failed_actions: number
  success_rate: number
  last_calculated: string
}

export interface VerificationResult {
  verified: boolean
  agent: Agent
  reputation: Reputation
  owner: {
    name: string
    company?: string
    verified: boolean
  }
}

/**
 * AgentID client for managing AI agent identities and reputation.
 * 
 * @example
 * ```typescript
 * const client = new AgentID({ apiKey: 'your_key' })
 * 
 * const agent = await client.register({
 *   name: 'MyAgent',
 *   capabilities: ['chat', 'search'],
 *   description: 'A helpful AI assistant'
 * })
 * ```
 */
export class AgentID {
  private apiKey: string
  private baseUrl: string

  constructor(config: AgentIDConfig) {
    this.apiKey = config.apiKey
    this.baseUrl = config.baseUrl?.replace(/\/$/, '') || 'https://agentid.dev/api'
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`
    const response = await fetch(url, {
      ...options,
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
    })

    if (!response.ok) {
      throw new Error(`AgentID API error: ${response.statusText}`)
    }

    return response.json()
  }

  /**
   * Register a new AI agent.
   */
  async register(params: RegisterAgentParams): Promise<Agent> {
    return this.request<Agent>('/agents/register', {
      method: 'POST',
      body: JSON.stringify(params),
    })
  }

  /**
   * Verify an agent's identity.
   */
  async verify(agentId: string): Promise<VerificationResult> {
    return this.request<VerificationResult>(`/agents/${agentId}/verify`, {
      method: 'POST',
    })
  }

  /**
   * Get details about an agent.
   */
  async getAgent(agentId: string): Promise<Agent> {
    return this.request<Agent>(`/agents/${agentId}`)
  }

  /**
   * Log an action performed by an agent (builds reputation).
   */
  async logAction(agentId: string, params: LogActionParams): Promise<{ success: boolean }> {
    return this.request<{ success: boolean }>(`/agents/${agentId}/actions`, {
      method: 'POST',
      body: JSON.stringify(params),
    })
  }

  /**
   * Get the reputation score for an agent.
   */
  async getReputation(agentId: string): Promise<Reputation> {
    return this.request<Reputation>(`/agents/${agentId}/reputation`)
  }
}

export default AgentID
