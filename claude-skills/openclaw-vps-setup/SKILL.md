---
name: openclaw-vps-setup
description: >-
  Provision a fresh Hetzner VPS from scratch to run an OpenClaw multi-agent
  stack with Discord chat as the visible I/O layer. Walks through SSH key
  setup, Docker install, OpenClaw clone, the 4-Layer Agent Architecture
  (DNA + SOUL + AGENTS + TEAM), shared memory layer, Discord plugin wiring,
  and the repeatable 7-step playbook for onboarding additional agents. Use
  when setting up YOUR OWN VPS for AI agents from zero. Triggers on "set up
  my VPS", "deploy openclaw", "provision agent infrastructure", "onboard a
  new agent", "add a molty", "add an agent to my VPS", "set up a fresh
  hetzner box". DOES NOT manage an existing OpenClaw instance — for that,
  use the `molty` skill.
license: MIT
metadata:
  version: 0.2.0
  audience: non-coder operators using Claude Code to provision their own agent infra
---

# OpenClaw VPS Setup

Spin up a fresh Hetzner VPS, install OpenClaw in Docker, set up the 4-Layer Agent Architecture (shared DNA + TEAM + memory, plus per-agent SOUL + AGENTS files), deploy the first Molty agent into a dedicated Discord channel, then onboard 2-3 more using the same playbook each time. Designed for operators who have Claude Code installed but no ops experience.

## Triggers

| Trigger phrase | Maps to |
|----------------|---------|
| "set up my VPS" / "provision my agent infra" / "deploy openclaw" | Full Phase 1-6 setup |
| "onboard a new agent" / "add a molty" / "add an agent to my VPS" | The 7-step onboarding playbook |
| "fresh hetzner box for openclaw" | Phase 1-2 only (provision + Docker) |
| "wire discord into openclaw" | Phase 5 only |
| "check my agents" / "openclaw maintenance" | Maintenance section |

## When NOT to use this skill

| Situation | Use instead |
|-----------|-------------|
| Managing an already-deployed OpenClaw instance (logs, restarts, debugging) | `molty` |
| Translating a Claude Code skill to run on the VPS | `skill-translate` |
| Setting up Slack instead of Discord | Adapt Phase 5 — see `references/slack-alternative.md` (TODO if needed) |

## Architecture overview

```
Your laptop                Hetzner VPS (€5/mo)            Discord
  Claude Code  ──ssh──▶    Docker                          server
  + this skill              └─ openclaw-gateway            ├─ #agent-1
                                ├─ Agent 1 ──── reads ───▶ │
                                ├─ Agent 2 ──── reads ───▶ ├─ #agent-2
                                └─ Agent 3 ──── reads ───▶ └─ #agent-3
                                   │
                              ~/.openclaw/
                              ├─ shared/         ◄── ALL agents read these
                              │   ├─ DNA.md          (team culture)
                              │   ├─ TEAM.md         (coordination rules)
                              │   ├─ MEMORY.md       (append-only log)
                              │   └─ KNOWLEDGE.md    (curated reference)
                              └─ workspace/<agent>/
                                  ├─ SOUL.md         (personality)
                                  ├─ AGENTS.md       (ops config)
                                  ├─ HEARTBEAT.md    (per-wake routine)
                                  └─ WORKING.md      (current task state)
```

This MVP omits Convex blackboard, custom wake-worker, and other advanced patterns. Add later — see `references/runbook.md` § "What this MVP does NOT include".

## The 4-Layer Agent Architecture

Every agent on this team has 4 files loaded into context every wake. Same model whether you have 1 agent or 10.

| Layer | File | Per-agent? | Purpose |
|-------|------|------------|---------|
| 1. **DNA** | `DNA.md` | **Shared** | Team culture: integrity, anti-slop, non-negotiables |
| 2. **SOUL** | `SOUL.md` | Unique | Personality, voice, role-specific identity |
| 3. **AGENTS** | `AGENTS.md` | Unique | Tools, tier, hard rules, heartbeat protocol |
| 4. **TEAM** | `TEAM.md` | **Shared** | Handoff protocol, decision protocol, quality bar |

Plus a **shared memory layer**:
- **`MEMORY.md`** — append-only log all agents write to and read from
- **`KNOWLEDGE.md`** — curated reference (read-only for agents, owner-maintained)

This pattern is the take-home model: same DNA + TEAM across the team, distinct SOUL + AGENTS per role, shared MEMORY + KNOWLEDGE as the orchestration layer. Without these layers, agents are isolated chatbots. With them, they're a coordinated team.

## Pre-flight checklist

Before invoking the skill, the user needs:

- [ ] Hetzner Cloud account + valid payment method (no VPS yet — we provision live)
- [ ] Discord account + a server they own (or admin permission on one)
- [ ] An LLM API key (Anthropic, OpenAI, or OpenRouter — Anthropic recommended for Claude Sonnet)
- [ ] SSH key on their machine (we generate one if missing)
- [ ] Claude Code installed and working

If any of these are missing, prompt the user to set them up before proceeding. Don't try to substitute or skip.

## Phase 1 — Provision the VPS (Hetzner)

Goal: a running Linux server they can `ssh` into.

**Step 1.1 — Generate an SSH key (skip if they already have one).**

Check if `~/.ssh/id_ed25519_openclaw.pub` exists. If not, run:
```bash
ssh-keygen -t ed25519 -C "openclaw-vps" -f ~/.ssh/id_ed25519_openclaw -N ""
```
Then display the public key:
```bash
cat ~/.ssh/id_ed25519_openclaw.pub
```
Tell the user: "Copy that whole line — you'll paste it into Hetzner in the next step."

**Step 1.2 — Add the key to Hetzner (web UI, ~2 min).**

Walk the user through this exactly:
1. Open https://console.hetzner.cloud (sign up if needed; verify email).
2. Top-right project menu → if no project exists, create one called "openclaw".
3. Left sidebar → **Security** → **SSH Keys** tab → **Add SSH Key** button.
4. Paste the public key from Step 1.1. Name it "openclaw-mac" (or similar). Save.

**Step 1.3 — Create the server (~2 min).**

1. Left sidebar → **Servers** → **Add Server**.
2. **Location:** pick the data center geographically closest to them.
3. **Image:** Ubuntu 24.04.
4. **Type:** under "Shared vCPU" tab, pick **CX22** (€5/mo, 2 vCPU, 4GB RAM, 40GB disk).
5. **Networking:** IPv4 + IPv6 (default is fine).
6. **SSH Key:** check the box for the key you just added.
7. **Name:** "openclaw-vps".
8. **Create & Buy Now**.

Wait ~30s for status to show "Running". Copy the **public IPv4** address — they'll need it for SSH.

**Step 1.4 — Add SSH config entry on user's Mac.**

Append to `~/.ssh/config` (create the file if missing):
```
Host openclaw-vps
  HostName <PASTE_IP_HERE>
  User root
  IdentityFile ~/.ssh/id_ed25519_openclaw
  AddKeysToAgent yes
```

**Step 1.5 — Verify SSH connection.**

```bash
ssh -o ConnectTimeout=10 openclaw-vps 'echo ok && uname -a'
```
Should return `ok` and Linux info. If "Permission denied" → see `references/troubleshooting.md` § SSH.

**Step 1.6 — Create non-root user (security).**

Running as `root` is a foot-gun. Create `deploy`:
```bash
ssh openclaw-vps 'adduser --disabled-password --gecos "" deploy && \
  usermod -aG sudo deploy && \
  mkdir -p /home/deploy/.ssh && \
  cp ~/.ssh/authorized_keys /home/deploy/.ssh/ && \
  chown -R deploy:deploy /home/deploy/.ssh && \
  chmod 600 /home/deploy/.ssh/authorized_keys'
```
Then update `~/.ssh/config` — change `User root` to `User deploy`. Verify: `ssh openclaw-vps 'whoami'` returns `deploy`.

✅ **Phase 1 complete = `ssh openclaw-vps` lands you in a `deploy` shell.**

## Phase 2 — Install Docker + clone OpenClaw

**Step 2.1 — Install Docker (one-liner, ~30s).**
```bash
ssh openclaw-vps 'curl -fsSL https://get.docker.com | sudo sh && \
  sudo usermod -aG docker deploy'
```

**Step 2.2 — Reconnect SSH** so the docker group takes effect:
```bash
ssh openclaw-vps 'docker --version'
```
Should print version without `sudo`. If "permission denied" → reconnect once more.

**Step 2.3 — Clone OpenClaw + create the directory skeleton.**
```bash
ssh openclaw-vps 'git clone https://github.com/openclaw/openclaw.git ~/openclaw && \
  mkdir -p ~/.openclaw/shared ~/.openclaw/workspace'
```

**Step 2.4 — Pull the OpenClaw image (pinned to known-good tag).**
```bash
ssh openclaw-vps 'docker pull ghcr.io/openclaw/openclaw:2026.4.23'
```
DO NOT use `:2026.4.24` — known to hang at startup. See `troubleshooting.md`.

✅ **Phase 2 complete = Docker working + OpenClaw cloned + image pulled.**

## Phase 3 — Set up the SHARED layers

Goal: DNA, TEAM, MEMORY, KNOWLEDGE — the files all agents will inherit.

**Step 3.1 — Copy shared templates from this skill to the VPS.**

```bash
# From your laptop (where this skill lives):
SKILL=~/.claude/skills/openclaw-vps-setup
scp $SKILL/assets/DNA.md openclaw-vps:~/.openclaw/shared/DNA.md
scp $SKILL/assets/TEAM.md openclaw-vps:~/.openclaw/shared/TEAM.md
scp $SKILL/assets/shared/MEMORY.md.template openclaw-vps:~/.openclaw/shared/MEMORY.md
scp $SKILL/assets/shared/KNOWLEDGE.md.template openclaw-vps:~/.openclaw/shared/KNOWLEDGE.md
```

**Step 3.2 — Customize `KNOWLEDGE.md` for the user's domain.**

Open the copied file in `nano` or pull it back to the laptop:
```bash
ssh openclaw-vps 'cat ~/.openclaw/shared/KNOWLEDGE.md'
```
Help the user fill in:
- **Owner:** their name
- **Domain:** their business / project context (e.g. "AEC firm in NZ")
- **Current focus:** what the team is working on
- **People:** key humans the agents need to know about
- **Active projects:** anything in flight

This file gets read by every agent on every wake. Spending 15 min on it now saves the agents from being clueless about context.

**Step 3.3 — Lightly customize `TEAM.md`.**

Update the "Team roster" table at the top — leave the rows blank for now (you'll fill them as agents come online). Other sections (handoff protocol, decision protocol, etc.) work as-is.

**Step 3.4 — Review `DNA.md`.**

The default DNA is reasonable for most teams. If the user wants to add team-specific values or rules, edit it now. Keep it tight — under 100 lines.

✅ **Phase 3 complete = 4 shared files exist on VPS in `~/.openclaw/shared/`.**

## Phase 4 — Configure the first agent (SOUL + AGENTS)

Goal: a working `openclaw.json` + per-agent `SOUL.md` + per-agent `AGENTS.md` for agent #1.

**Step 4.1 — Pick agent #1's role** with the user. AEC starters provided in `assets/`:
- `SOUL-rfi-triager.md` (RFI Triager)
- `SOUL-submittal-reviewer.md` (Submittal Reviewer)
- `SOUL-comms-drafter.md` (Client Comms Drafter)
- `SOUL.md.template` (blank — fill in for any role)

**Step 4.2 — Push the SOUL.md.**

```bash
SLUG=rfi_triager  # or whatever role
ssh openclaw-vps "mkdir -p ~/.openclaw/workspace/$SLUG"
scp $SKILL/assets/SOUL-rfi-triager.md openclaw-vps:~/.openclaw/workspace/$SLUG/SOUL.md
```
For custom roles, copy `SOUL.md.template`, edit `<PLACEHOLDERS>`, then push.

**Step 4.3 — Push the AGENTS.md (per-agent ops config).**

```bash
scp $SKILL/assets/AGENTS.md.template openclaw-vps:~/.openclaw/workspace/$SLUG/AGENTS.md
```
Then edit it on the VPS to fill in:
- `<AGENT_NAME>` → the slug (e.g. `rfi_triager`)
- `<MCP_SERVERS>` → e.g. `notion`, or `[]` if none
- `<TIER>` → `LOW`, `MEDIUM`, or `HIGH`
- `<HEARTBEAT_MIN>` → e.g. `60`
- Channel name (set in Phase 5)

**Step 4.4 — Push the HEARTBEAT.md.**

```bash
scp $SKILL/assets/HEARTBEAT.md.template openclaw-vps:~/.openclaw/workspace/$SLUG/HEARTBEAT.md
```
Edit `<AGENT_NAME>` and `<HEARTBEAT_MIN>` placeholders.

**Step 4.5 — Render `openclaw.json`** from `assets/openclaw.json`. Edit:
- Replace `<AGENT_NAME>` with the chosen role slug (e.g. `rfi_triager`)
- Set the model (default `anthropic/claude-sonnet-4.7`)
- `heartbeat_minutes` (default 60)
- Discord token env var name + channel ID (will be set in Phase 5; placeholder for now)

Push: `scp /tmp/openclaw.json openclaw-vps:~/.openclaw/openclaw.json`

✅ **Phase 4 complete = agent #1's SOUL, AGENTS, HEARTBEAT exist on VPS + entry in openclaw.json.**

## Phase 5 — Wire Discord

Goal: agent #1's chat I/O lands in a dedicated Discord channel.

**Step 5.1 — Create the Discord bot** (web UI, ~3 min):
1. Open https://discord.com/developers/applications → **New Application** → name it `<role>-agent` (e.g. `rfi-triager-agent`).
2. **Bot** tab in left sidebar → **Add Bot** → confirm.
3. Scroll down to **Privileged Gateway Intents** → toggle on **Message Content Intent**. Save.
4. Scroll up → **Reset Token** → copy the token (starts with `M...`). Keep it safe; you'll only see it once.

**Step 5.2 — Invite the bot to the user's server.**
1. **OAuth2** tab → **URL Generator**.
2. **Scopes:** check `bot`.
3. **Bot Permissions:** check `Send Messages`, `Read Message History`, `View Channels`.
4. Copy the URL at the bottom, open in browser, select the user's server, click **Authorize**.

**Step 5.3 — Create the dedicated channel.**

In Discord (the user's server):
1. Make a new text channel: `#<role>-agent` (e.g. `#rfi-triager-agent`).
2. Right-click the channel → **Edit Channel** → **Permissions** → grant the bot user `View Channel` + `Send Messages`.

**Step 5.4 — Get the channel ID.**

Discord: User Settings → Advanced → toggle ON **Developer Mode**. Then right-click the channel → **Copy Channel ID** (a long number).

**Step 5.5 — Wire the token + channel into `.env` and `openclaw.json`.**

```bash
ssh openclaw-vps 'echo "DISCORD_BOT_TOKEN_AGENT_1=<paste-token>" >> ~/openclaw/.env && \
  echo "ANTHROPIC_API_KEY=<paste-key>" >> ~/openclaw/.env && \
  chmod 600 ~/openclaw/.env'
```

In `~/.openclaw/openclaw.json`, the agent's `channels.discord.default_channel_id` should be the numeric ID from Step 5.4.

✅ **Phase 5 complete = bot exists, channel exists, token stored, channel ID wired.**

## Phase 6 — Boot + verify

**Step 6.1 — Sync canonical skills** (if any to sync; safe to run with none):
```bash
scp $SKILL/scripts/sync_skills.sh openclaw-vps:~/openclaw/sync_skills.sh
ssh openclaw-vps 'chmod +x ~/openclaw/sync_skills.sh && bash ~/openclaw/sync_skills.sh'
```

**Step 6.2 — Boot the gateway:**
```bash
ssh openclaw-vps 'cd ~/openclaw && OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:2026.4.23 docker compose up -d openclaw-gateway'
```
Wait 60-90s for first boot (plugin runtime install).

**Step 6.3 — Verify health:**
```bash
ssh openclaw-vps 'docker ps --format "{{.Names}} {{.Status}}"'
ssh openclaw-vps 'docker logs --tail 30 openclaw-openclaw-gateway-1 2>&1 | tail -30'
```
Look for `Up X seconds (healthy)` and a `[discord] logged in` line.

**Step 6.4 — Trigger the agent.** In Discord, post in the agent's channel:
```
@<bot-name> hello, introduce yourself. What's your role?
```

**Step 6.5 — Watch for response** within 30-60s. If silent → see `references/troubleshooting.md` § "Agent silent on first @mention".

✅ **Phase 6 complete = first agent posting in Discord, in-character per its SOUL+AGENTS+DNA+TEAM context.**

## The 7-Step Onboarding Playbook (additional agents)

Run this for each new agent (~7 min each once muscle memory). Keep `assets/agent-entry.json` snippet on hand.

| Step | Action | Time |
|------|--------|------|
| 1 | **Pick role.** Show user a SOUL.md draft from `assets/` (or copy `SOUL.md.template` and fill in) | 60s |
| 2 | **Edit SOUL.md + AGENTS.md** for the new agent. Push to `~/.openclaw/workspace/<slug>/` | 90s |
| 3 | **Append agent entry** to `~/.openclaw/openclaw.json` from `assets/agent-entry.json` snippet — replace `<AGENT_NAME>`, `<DISCORD_TOKEN_VAR>`, `<CHANNEL_ID>`, `<HEARTBEAT_MIN>` | 90s |
| 4 | **Add new env vars** to `~/openclaw/.env` (new bot token + channel) and create the Discord channel + invite the bot | 90s |
| 5 | **Sync skills:** `ssh openclaw-vps 'bash ~/openclaw/sync_skills.sh'` (or use `scripts/onboard_agent.sh`) | 30s |
| 6 | **Restart gateway:** `ssh openclaw-vps 'cd ~/openclaw && docker compose restart openclaw-gateway'` (~30s) | 30s |
| 7 | **Trigger from Discord** — `@mention` the new agent in its channel. Verify response. | 60s |

The new agent inherits the same shared `DNA.md`, `TEAM.md`, `MEMORY.md`, `KNOWLEDGE.md` — no need to recreate those. That's the leverage.

For the long-form runbook with annotations, see `references/onboarding-playbook.md`.

## Maintenance

| Op | Command |
|----|---------|
| Live logs | `ssh openclaw-vps 'docker logs -f openclaw-openclaw-gateway-1 --tail 50'` |
| Search errors | `ssh openclaw-vps 'docker logs openclaw-openclaw-gateway-1 2>&1 \| grep -i error \| tail -20'` |
| Restart gateway | `ssh openclaw-vps 'cd ~/openclaw && docker compose restart openclaw-gateway'` |
| Stop everything | `ssh openclaw-vps 'cd ~/openclaw && docker compose down'` (does NOT shut down the VPS) |
| Update OpenClaw image | See `references/runbook.md` § "Image swap procedure" |
| Sync new/updated skills | `bash ~/openclaw/sync_skills.sh` (run on VPS) |
| Read shared memory from laptop | `ssh openclaw-vps 'cat ~/.openclaw/shared/MEMORY.md'` |
| Edit shared knowledge | `ssh openclaw-vps 'nano ~/.openclaw/shared/KNOWLEDGE.md'` |

## Anti-Patterns

| Avoid | Why | Instead |
|-------|-----|---------|
| Putting bot tokens directly in `openclaw.json` | Secrets leak into version control | Use `<VAR>_env: TOKEN_NAME` reference, store in `.env` |
| Pulling `ghcr.io/openclaw/openclaw:2026.4.24` | Hangs at startup (upstream bug) | Stay on `:2026.4.23` until upstream fixes 4.24 |
| Running OpenClaw as `root` inside the container | Permission conflicts; security risk | Default config uses `node` user — leave it alone |
| `shutdown now` on the VPS | Kills the whole server | `docker compose down` for containers only |
| Reusing the same Discord bot token across agents | Each agent should have its own identity for visibility | One bot per agent, one channel per agent |
| Adding agents without restarting gateway | Config not reloaded; new agent silent | Always `docker compose restart` after `openclaw.json` edits |
| Letting agents modify `DNA.md` / `TEAM.md` / `KNOWLEDGE.md` | These are the human's stable contracts; agent edits cause drift | Only the team owner edits these. Agents append to `MEMORY.md` only. |
| Skipping `KNOWLEDGE.md` setup | Agents will hallucinate context they don't have | Spend 15 min populating it during Phase 3 |
| Per-agent SOUL.md without DNA.md inherited | Agents become inconsistent — each one feels different | Always set up shared layers (Phase 3) BEFORE per-agent (Phase 4) |

## Verification

After Phase 6 + each onboarding loop:

- [ ] `ssh openclaw-vps 'echo ok'` returns `ok`
- [ ] `docker ps` shows `openclaw-openclaw-gateway-1` as `Up` and `(healthy)`
- [ ] `~/openclaw/.env` has `chmod 600`
- [ ] `~/.openclaw/shared/` contains `DNA.md`, `TEAM.md`, `MEMORY.md`, `KNOWLEDGE.md`
- [ ] `~/.openclaw/workspace/<agent>/` contains `SOUL.md`, `AGENTS.md`, `HEARTBEAT.md` for each agent
- [ ] Each agent's Discord channel shows at least one bot message
- [ ] Triggering an agent in its channel produces a reply within 60s

## Asset & script reference

| Path | Purpose |
|------|---------|
| `assets/openclaw.json` | Template config — vanilla, single-agent starter |
| `assets/agent-entry.json` | Snippet to paste into `openclaw.json` for each new agent |
| `assets/.env.example` | Env var template — Discord tokens, LLM keys |
| `assets/DNA.md` | **SHARED** team culture (Layer 1) |
| `assets/TEAM.md` | **SHARED** coordination rules (Layer 4) |
| `assets/AGENTS.md.template` | Per-agent operational config (Layer 3) |
| `assets/SOUL.md.template` | Per-agent personality (Layer 2 — blank fill-in) |
| `assets/SOUL-rfi-triager.md` | AEC starter — RFI triage agent SOUL |
| `assets/SOUL-submittal-reviewer.md` | AEC starter — submittal review agent SOUL |
| `assets/SOUL-comms-drafter.md` | AEC starter — client comms drafter SOUL |
| `assets/HEARTBEAT.md.template` | Per-agent wake routine (~50 lines) |
| `assets/shared/MEMORY.md.template` | Append-only team log (Layer 5 — shared memory) |
| `assets/shared/KNOWLEDGE.md.template` | Curated reference (Layer 6 — owner-maintained) |
| `scripts/sync_skills.sh` | Distributes canonical skills to workspace |
| `scripts/onboard_agent.sh` | Helper that runs steps 5-6 of the onboarding playbook |
| `references/runbook.md` | Long-form playbook for non-CC users |
| `references/troubleshooting.md` | Common failures + fixes |
| `references/onboarding-playbook.md` | Annotated 7-step playbook |

## When to call other skills

| If user says... | Invoke |
|-----------------|--------|
| "Send my new skill to the VPS" / "deploy this skill to my agents" | `skill-translate` THEN `molty` (translate first, then sync) |
| "What's wrong with my running molty?" / "check the logs" / "fix the gateway" | `molty` |
| "Set up an agent team for content publishing" / "design 5 agents for my biz" | This skill (provision) — define the 5 SOULs + AGENTS during Phase 4 + 7-step playbook |

## Extension Points

1. **Slack instead of Discord** — adapt Phase 5 with Slack app manifest. Add `references/slack-alternative.md` when needed.
2. **Convex blackboard** — graduate from `MEMORY.md`-as-file to a Convex-backed task queue with structured handoffs and notifications. Out of scope for MVP.
3. **Wake worker (systemd)** — immediate notification-driven wakes (vs polling on heartbeat). Advanced; not needed under ~5 agents.
4. **Per-agent MCP servers** — wire Notion, n8n, Calendar, etc. to specific agents. Add to `mcporter.json` and reference in agent's `mcp_servers` array.
5. **Mem0 / Letta integration** — graduate from file-based shared memory to a dedicated memory service when scale demands it.

## Supersession

These instructions reflect OpenClaw v2026.4.23 patterns as of May 2026. If upstream changes the config schema, image tags, or plugin API, prioritize the upstream docs and update this skill.
