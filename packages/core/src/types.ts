/**
 * Core TypeScript types shared across the AgentID platform.
 */

export type AgentStatus = 'active' | 'suspended' | 'revoked'
export type ActionStatus = 'success' | 'failure' | 'pending'

export interface Owner {
  id: string
  email: string
  name: string
  company?: string
  verified: boolean
  created_at: string
  updated_at: string
}

export interface Agent {
  id: string
  owner_id: string
  name: string
  description: string
  capabilities: string[]
  api_key_hash: string
  status: AgentStatus
  created_at: string
  updated_at: string
}

export interface Action {
  id: string
  agent_id: string
  action_type: string
  metadata: Record<string, any>
  status: ActionStatus
  created_at: string
}

export interface ReputationScore {
  id: string
  agent_id: string
  score: number
  total_actions: number
  successful_actions: number
  failed_actions: number
  last_calculated: string
}

export interface ApiResponse<T> {
  data?: T
  error?: {
    code: string
    message: string
  }
}
