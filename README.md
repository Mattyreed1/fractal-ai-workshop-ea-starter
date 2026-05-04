# Fractal AI Workshop EA Starter

Everything you need to run a Claude Code Executive Assistant + a 2-3 agent VPS team.

Built during the **Fractal AI Workshop** with [Matty Reed](https://www.linkedin.com/in/mattyreed1).

## What's inside

| Skill | What it does |
|-------|--------------|
| **`openclaw-vps-setup`** | Provisions a Hetzner VPS, installs OpenClaw in Docker, sets up the 4-Layer Agent Architecture (DNA + SOUL + AGENTS + TEAM) + shared memory layer (MEMORY + KNOWLEDGE), deploys agents into Discord channels |

More skills coming as the workshop expands.

## Install (3 commands)

Requires: macOS or Linux, Claude Code already installed.

```bash
git clone https://github.com/Mattyreed1/fractal-ai-workshop-ea-starter.git ~/fractal-ai-workshop-ea-starter
cd ~/fractal-ai-workshop-ea-starter
bash install.sh
```

This symlinks each skill into `~/.claude/skills/`. Restart Claude Code to load them.

**Verify:** in a fresh CC session, ask: *"do I have a skill for setting up an openclaw VPS?"* — CC should recommend `openclaw-vps-setup`.

## What you'll need beyond this repo

- Hetzner Cloud account (CX22 VPS, ~€5/mo)
- Discord account + a server you own
- An LLM API key (Anthropic recommended)
- ~2 hours for first-time setup

Detailed walkthrough: [`docs/install.md`](docs/install.md)

## How to use it

```
You: "set up my VPS and onboard an RFI triage agent"
Claude Code: [walks through the openclaw-vps-setup skill, step by step]
```

Adding more agents later:

```
You: "onboard a new agent for client comms"
Claude Code: [runs the 7-step onboarding playbook]
```

## The 90-day plan

Don't try to do everything at once. See [`docs/90-day-plan.md`](docs/90-day-plan.md):

- **Week 1:** One VPS running, one agent in Discord, one real task automated
- **Month 1:** 2-3 more agents onboarded, shared memory layer in regular use
- **Quarter 1:** Walk into your next role with a working agent team

## License

MIT. Fork it, modify it, sell it.

## Built by

[Matty Reed](https://www.linkedin.com/in/mattyreed1) / [Fractal AI](https://fractalai.agency)
