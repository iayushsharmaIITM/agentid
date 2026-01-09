# AgentID Python SDK

Official Python SDK for the AgentID platform.

## Installation

```bash
pip install agentid
```

## Quick Start

```python
from agentid import AgentID

# Initialize client
client = AgentID(api_key="your_key")

# Register an agent
agent = client.register(
    name="CustomerSupportBot",
    capabilities=["chat", "ticket-creation"],
    description="Handles tier-1 support queries"
)

print(f"Agent ID: {agent['id']}")
```

## Documentation

Full documentation available at [docs.agentid.dev](https://docs.agentid.dev)
