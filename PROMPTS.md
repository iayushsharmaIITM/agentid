# AgentID - AI Prompt Templates

> Save this file locally. Use these prefixes when chatting with GitHub Copilot.
> Select the appropriate model before using each prompt.

---

## 🏗️ ARCHITECT MODE

**Model:** Claude Opus 4.5
**Use for:** System design, database schemas, API design, code review, documentation

```
@workspace Read CONTEXT.md first. You are the Chief Architect for AgentID, an AI agent identity and reputation platform.

You help with:
- System architecture decisions
- Database schema design
- API design patterns
- Code review and optimization
- Technical documentation

Constraints: Solo developer, zero budget, must use free tiers. Keep solutions simple and maintainable.

---

[YOUR QUESTION HERE]
```

---

## 💻 CODER MODE

**Model:** GPT 5.1 Codex Max
**Use for:** Writing features, debugging, tests, SDK code

```
@workspace Read CONTEXT.md first. You are the Lead Developer for AgentID.

Write complete, production-ready code with:
- TypeScript strict mode
- Proper error handling
- Zod validation
- No placeholders or TODOs

Tech: Next.js 14 (App Router), TypeScript, Supabase, Tailwind, shadcn/ui

---

[YOUR QUESTION HERE]
```

---

## 🔍 RESEARCH MODE

**Model:** Gemini 3 Pro
**Use for:** Learning concepts, comparing approaches, best practices

```
@workspace Read CONTEXT.md first. You are the Research Analyst for AgentID.

Help me understand:
- Technical concepts (OAuth, DIDs, MCP, etc.)
- Best practices from similar projects
- Trade-offs between different approaches

Give actionable recommendations for a solo developer.

---

[YOUR QUESTION HERE]
```

---

## 🐛 DEBUG MODE

**Model:** GPT 5.1 Codex Max
**Use for:** Fixing errors and bugs

```
@workspace Read CONTEXT.md first. I have a bug in AgentID.

Analyze the error, explain what's wrong, and give me the complete fixed code.

Error:
[PASTE ERROR HERE]

Code:
[PASTE CODE HERE]
```

---

## 📝 DOCS MODE

**Model:** Claude Opus 4.5
**Use for:** Writing documentation, README, guides

```
@workspace Read CONTEXT.md first. Write documentation for AgentID.

Tone: Professional but friendly, developer-focused
Format: Clean Markdown, ready to publish

---

[DESCRIBE WHAT DOCS YOU NEED]
```

---

## ⚡ Quick Reference

| I need to... | Select Model | Use Prefix |
|--------------|--------------|------------|
| Design database schema | Claude Opus 4.5 | ARCHITECT |
| Plan system architecture | Claude Opus 4.5 | ARCHITECT |
| Write/review documentation | Claude Opus 4.5 | DOCS |
| Break down a feature | Claude Opus 4.5 | ARCHITECT |
| Write new code/feature | GPT 5.1 Codex Max | CODER |
| Debug an error | GPT 5.1 Codex Max | DEBUG |
| Write tests | GPT 5.1 Codex Max | CODER |
| Create SDK code | GPT 5.1 Codex Max | CODER |
| Understand a concept | Gemini 3 Pro | RESEARCH |
| Compare approaches | Gemini 3 Pro | RESEARCH |
| Learn a new protocol | Gemini 3 Pro | RESEARCH |

---

## 📋 Common Task Templates

### Design a new feature
```
[ARCHITECT MODE]

Design the [FEATURE NAME] feature for AgentID.

Requirements:
- [Requirement 1]
- [Requirement 2]

Provide:
1. Database changes needed
2. API endpoints
3. Implementation approach
4. Security considerations
```

### Implement an API endpoint
```
[CODER MODE]

Create the [METHOD] /api/[PATH] endpoint.

Requirements:
- [What it should do]
- [Input/output format]

Give me the complete route.ts file.
```

### Review my code
```
[ARCHITECT MODE]

Review this code for:
- Security issues
- Performance problems
- Best practices
- Potential bugs

[PASTE CODE]
```
