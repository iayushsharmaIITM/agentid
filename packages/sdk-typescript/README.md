# AgentID TypeScript SDK

Official TypeScript/JavaScript SDK for the AgentID platform.

## Installation

```bash
npm install agentid
# or
yarn add agentid
# or
pnpm add agentid
```

## Quick Start

```typescript
import { AgentID } from 'agentid'

// Initialize client
const client = new AgentID({ apiKey: 'your_key' })

// Register an agent
const agent = await client.register({
  name: 'CustomerSupportBot',
  capabilities: ['chat', 'ticket-creation'],
  description: 'Handles tier-1 support queries'
})

console.log(`Agent ID: ${agent.id}`)
```

## Documentation

Full documentation available at [docs.agentid.dev](https://docs.agentid.dev)
