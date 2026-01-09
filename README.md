# AgentID

**The Trust Layer for AI Agents**

> Identity, Authentication, and Reputation for the Age of Autonomous AI

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub Issues](https://img.shields.io/github/issues/iayushsharmaIITM/agentid)](https://github.com/iayushsharmaIITM/agentid/issues)
[![GitHub Stars](https://img.shields.io/github/stars/iayushsharmaIITM/agentid)](https://github.com/iayushsharmaIITM/agentid/stargazers)

---

## 🌍 The Problem

By 2029, there will be **billions of AI agents** operating autonomously — making purchases, signing contracts, sending emails, writing code.

But today, there's no standard way to:
- ✗ Verify which company/person an agent represents
- ✗ Track an agent's reliability and reputation
- ✗ Hold agents accountable for their actions
- ✗ Enable trust between agents

**AgentID solves this.**

---

## ✨ Features

### 🆔 Identity
Register and verify AI agents with cryptographic identity.

```python
from agentid import AgentID

client = AgentID(api_key="your_key")

# Register your agent
agent = client.register(
    name="CustomerSupportBot",
    capabilities=["chat", "ticket-creation"],
    description="Handles tier-1 support queries"
)

print(agent['id'])  # aid_7x8k2m...
```

### ✅ Verification
Verify any agent's identity before trusting it.

```python
# Verify an agent
result = client.verify(agent_id="aid_7x8k2m...")

if result.verified:
    print(f"Agent owned by: {result.owner.name}")
    print(f"Trust score: {result.reputation.score}/100")
```

### ⭐ Reputation
Automatic trust scoring based on agent behavior.

```python
# Log agent actions (builds reputation)
client.log_action(
    agent_id=agent.id,
    action_type="customer_query_resolved",
    status="success",
    metadata={"ticket_id": "T-1234"}
)

# Check reputation
reputation = client.get_reputation(agent.id)
print(f"Score: {reputation.score}")
print(f"Success rate: {reputation.success_rate}%")
```

### 🔒 Governance (Coming Soon)
Audit logs, compliance reports, and access controls.

---

## 🚀 Quick Start

### Option 1: Managed Cloud (Coming Soon)

```bash
# Install SDK
pip install agentid  # Python
npm install agentid  # TypeScript
```

### Option 2: Self-Hosted

```bash
# Clone the repo
git clone https://github.com/iayushsharmaIITM/agentid.git
cd agentid

# Install dependencies
cd apps/web
npm install

# Set up environment
cp .env.example .env.local
# Edit .env.local with your Supabase credentials

# Run locally
npm run dev
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AgentID                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│   │  Identity   │  │  Reputation │  │  Governance │        │
│   │  Service    │  │  Service    │  │  Service    │        │
│   └──────┬──────┘  └──────┬──────┘  └──────┬──────┘        │
│          │                │                │                │
│          └────────────────┼────────────────┘                │
│                           │                                  │
│                    ┌──────┴──────┐                          │
│                    │  Supabase   │                          │
│                    │ (PostgreSQL)│                          │
│                    └─────────────┘                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗺️ Roadmap

- [x] Project setup
- [ ] Core identity service (register, verify)
- [ ] Action logging
- [ ] Basic reputation scoring
- [ ] Python SDK
- [ ] TypeScript SDK
- [ ] Dashboard UI
- [ ] Agent-to-agent authentication
- [ ] Advanced reputation (PageRank-style)
- [ ] Compliance & audit tools

---

## 🤝 Contributing

We welcome contributions! AgentID is built by a solo developer and every contribution helps.

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📄 License

MIT License - see LICENSE for details.

---

**Built by [@iayushsharmaIITM](https://github.com/iayushsharmaIITM) | [Documentation](docs/) | [Report Bug](https://github.com/iayushsharmaIITM/agentid/issues)**