# What Each Skill Does

One section per skill in this repo. Add to this doc as you install more.

---

## `openclaw-vps-setup`

**What:** Provisions a fresh Hetzner VPS to run an OpenClaw multi-agent stack with Discord chat as the visible I/O layer. Sets up the 4-Layer Agent Architecture (DNA + SOUL + AGENTS + TEAM) and the shared memory layer (MEMORY + KNOWLEDGE). Then runs a repeatable 7-step playbook for onboarding additional agents.

**Trigger phrases:**

- *"set up my VPS"* / *"deploy openclaw"* / *"provision my agent infrastructure"*
- *"onboard a new agent"* / *"add a molty"* / *"add an agent to my VPS"*
- *"set up a fresh hetzner box"*

**Prerequisites:**

- Hetzner Cloud account + payment method
- Discord account + a server you own
- LLM API key (Anthropic recommended)
- SSH key on your machine (the skill creates one if missing)
- Claude Code installed

**What it ships with:**

- `assets/openclaw.json` — vanilla starter config
- `assets/agent-entry.json` — snippet to paste per new agent
- `assets/.env.example` — env var template (Discord tokens, LLM keys)
- `assets/DNA.md` — shared team culture (Layer 1 of the 4-layer architecture)
- `assets/TEAM.md` — shared coordination rules (Layer 4)
- `assets/AGENTS.md.template` — per-agent operational config (Layer 3)
- `assets/SOUL.md.template` — per-agent personality (Layer 2 — blank fill-in)
- `assets/SOUL-rfi-triager.md` / `SOUL-submittal-reviewer.md` / `SOUL-comms-drafter.md` — AEC starter SOULs
- `assets/HEARTBEAT.md.template` — per-agent wake routine
- `assets/shared/MEMORY.md.template` — append-only team log
- `assets/shared/KNOWLEDGE.md.template` — curated reference (owner-maintained)
- `scripts/sync_skills.sh` — distributes canonical skills to agent workspace
- `scripts/onboard_agent.sh` — helper for the onboarding playbook
- `references/runbook.md` — long-form playbook for non-CC users
- `references/troubleshooting.md` — common failures + fixes
- `references/onboarding-playbook.md` — annotated 7-step playbook

**Cost to operate:** ~€5/mo (Hetzner CX22 VPS) + LLM token usage. Discord is free.

**Time to first running agent:** ~2 hours for a non-coder following the skill, end-to-end.
