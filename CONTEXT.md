# AgentID - Project Context

> **For AI Assistants:** Read this file first to understand the project.

## What is AgentID?

AgentID is an open-source AI agent identity and reputation platform.
Think of it as a "credit score + passport for AI agents."

### The Problem We Solve
- AI agents are exploding (10M+ in 2026, billions by 2029)
- No standard way to verify "who" an agent is
- No reputation system to know if an agent is trustworthy
- No accountability when agents make mistakes

### Our Solution
A unified trust layer providing:
1. **Identity** — Register and verify AI agents
2. **Authentication** — Secure agent-to-agent and agent-to-service auth
3. **Reputation** — Trust scores based on agent behavior
4. **Governance** — Audit logs and compliance tools

## Creator

- **Developer:** Solo developer (2nd year AI/DS student)
- **GitHub:** iayushsharmaIITM
- **Constraints:** Zero budget, must use free tiers only
- **Timeline:** 16-week MVP

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Next.js 14 (App Router), TypeScript, Tailwind CSS, shadcn/ui |
| **Backend** | Next.js API Routes |
| **Database** | Supabase (PostgreSQL) |
| **Auth** | Supabase Auth |
| **Hosting** | Vercel (free tier) |
| **SDKs** | Python (PyPI), TypeScript (npm) |

## Architecture Principles

1. **Keep it simple** — Solo developer must maintain everything
2. **Managed services** — No DevOps overhead (use Supabase, Vercel)
3. **Free tiers only** — Until there's revenue
4. **Security-first** — Identity is sensitive, security is non-negotiable
5. **Developer experience** — Easy to integrate, great docs

## Current Phase

**Phase 1: MVP Development (Weeks 1-8)**
- Core identity features
- Basic reputation system
- Python & TypeScript SDKs

## Database Schema

### Tables

#### `owners`
Companies or individuals who own AI agents.
- id: uuid (PK)
- email: text (unique)
- name: text
- company: text (nullable)
- verified: boolean
- created_at: timestamp
- updated_at: timestamp

#### `agents`
Registered AI agent identities.
- id: uuid (PK)
- owner_id: uuid (FK -> owners.id)
- name: text
- description: text
- capabilities: text[]
- api_key_hash: text
- status: enum ('active', 'suspended', 'revoked')
- created_at: timestamp
- updated_at: timestamp

#### `actions`
Log of agent activities for reputation scoring.
- id: uuid (PK)
- agent_id: uuid (FK -> agents.id)
- action_type: text
- metadata: jsonb
- status: enum ('success', 'failure', 'pending')
- created_at: timestamp

#### `reputation_scores`
Calculated trust scores for agents.
- id: uuid (PK)
- agent_id: uuid (FK -> agents.id, unique)
- score: decimal (0-100)
- total_actions: integer
- successful_actions: integer
- failed_actions: integer
- last_calculated: timestamp

## API Endpoints

### Agents
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/agents/register` | Register a new agent |
| GET | `/api/agents/:id` | Get agent details |
| POST | `/api/agents/:id/verify` | Verify agent identity |
| PATCH | `/api/agents/:id` | Update agent info |
| DELETE | `/api/agents/:id` | Revoke agent |

### Actions
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/agents/:id/actions` | Log an action |
| GET | `/api/agents/:id/actions` | Get action history |

### Reputation
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/agents/:id/reputation` | Get reputation score |

## Coding Standards

- TypeScript strict mode ("strict": true)
- Functional components with hooks (no classes)
- Server Components by default in Next.js
- Zod for all input validation
- Proper error handling with typed errors
- Small, focused functions (< 50 lines)
- Comments only for complex logic
- Conventional commits

## File Structure

```
agentid/
├── apps/
│   ├── web/                      # Next.js app
│   │   ├── app/
│   │   │   ├── (marketing)/      # Public pages
│   │   │   ├── (dashboard)/      # Protected pages
│   │   │   ├── api/              # API routes
│   │   │   ├── layout.tsx
│   │   │   └── globals.css
│   │   ├── components/
│   │   ├── lib/
│   │   └── ...
│   └── docs/                     # Documentation site
├── packages/
│   ├── sdk-python/               # Python SDK
│   ├── sdk-typescript/           # TypeScript SDK
│   └── core/                     # Shared types
├── supabase/
│   └── migrations/               # SQL migrations
├── CONTEXT.md                    # This file
├── PROMPTS.md                    # AI prompt templates
└── README.md
```

## Environment Variables

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Quick Commands

```bash
# Development
cd apps/web
npm run dev           # Start dev server
npm run build         # Build for production
npm run lint          # Run ESLint

# Database
# Run migrations in Supabase SQL editor
```

## Links

- **Repository:** github.com/iayushsharmaIITM/agentid
