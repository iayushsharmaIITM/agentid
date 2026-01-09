import { z } from 'zod'

// Agent registration schema
export const registerAgentSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().min(1).max(1000),
  capabilities: z.array(z.string()).optional().default([]),
})

export type RegisterAgentInput = z.infer<typeof registerAgentSchema>

// Agent update schema
export const updateAgentSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  description: z.string().min(1).max(1000).optional(),
  capabilities: z.array(z.string()).optional(),
  status: z.enum(['active', 'suspended', 'revoked']).optional(),
})

export type UpdateAgentInput = z.infer<typeof updateAgentSchema>

// Action logging schema
export const logActionSchema = z.object({
  action_type: z.string().min(1),
  status: z.enum(['success', 'failure', 'pending']),
  metadata: z.record(z.any()).optional().default({}),
})

export type LogActionInput = z.infer<typeof logActionSchema>

// Owner registration schema
export const registerOwnerSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
  company: z.string().optional(),
})

export type RegisterOwnerInput = z.infer<typeof registerOwnerSchema>
