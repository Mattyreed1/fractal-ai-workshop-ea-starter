# The 90-Day Plan

Most people leave a workshop, get busy, and never apply it. This is the forcing function.

Three phases. Each builds on the last. Don't skip ahead.

---

## Week 1 — Foundation (1-2 hrs/evening)

**Goal:** Get one VPS running, one agent in Discord, one real task automated.

### Day 1 (~30 min)

- [ ] Install the repo + skill (`bash install.sh`, restart CC)
- [ ] Verify CC recognizes `openclaw-vps-setup`
- [ ] Read through the SKILL.md once — you don't need to remember it; CC does

### Day 2 (~60 min)

- [ ] Sign up for Hetzner Cloud, add payment method, create your first SSH key
- [ ] Tell CC: *"set up my VPS using the openclaw-vps-setup skill"*
- [ ] Walk through Phases 1-2 with CC (provision + Docker install)
- [ ] Stop after Phase 2 — confirm `ssh openclaw-vps 'docker --version'` works

### Day 3 (~30 min)

- [ ] Resume with CC: *"continue setting up the OpenClaw stack"*
- [ ] Phase 3 with CC — set up the shared layer: `DNA.md` (the team's shared SOUL — what every agent on this team IS) + `TEAM.md` (how the team coordinates and hands off in Discord)
- [ ] Lightly customize `DNA.md` if your team has unique values or rules. Default is reasonable — keep it under 100 lines.

### Day 4-5 (~90 min)

- [ ] Pick agent #1's role. Use a starter (RFI Triager / Submittal Reviewer / Comms Drafter) or a custom role
- [ ] Phases 4-6 with CC (configure agent, wire Discord, boot)
- [ ] First message in Discord — agent should respond within 30-60s

### Day 6-7

- [ ] Give your agent ONE real task from your actual life or work
- [ ] Note what breaks. Note what surprises you.
- [ ] Don't fix everything yet. Let imperfections stand. Iteration is Week 2.

**Week 1 success metric:** one Discord channel with one agent that has done one real-world task for you.

---

## Month 1 — Expansion

**Goal:** 2-3 agents onboarded. Each with its own private `MEMORY.md`. Discord-based coordination flowing. Weekly rhythm.

### Pattern: one bottleneck per week

Each week:
1. Pick the *most painful* recurring task in your life that's NOT yet automated
2. Decide: agent or classic automation? (Use the COO Audit Lens)
3. If agent: onboard a new one using the 7-step playbook
4. If classic automation: have CC build it via n8n MCP
5. Deploy. Use it for the rest of the week. Note failures.

### Weekly cadence (start now, never stop)

- **Monday morning** (15 min): What's broken? What needs adjusting?
- **Friday afternoon** (15 min): What worked this week? What gets pruned?

### Per-agent MEMORY.md hygiene

End of each week, take 10 min to:
- For each agent, skim its `~/.openclaw/workspace/<agent>/MEMORY.md` — what did it learn, decide, hand off?
- Trim obsolete entries (anything resolved or superseded)
- Spot patterns worth promoting — if a fact has come up 3+ times across agents, post it in Discord as a pinned message so the team sees it consistently
- Keep each agent's `MEMORY.md` under ~2,000 lines (the audit trail matters, but stale noise drowns recent signal)

**When the [OB1 extension](https://github.com/NateBJones-Projects/OB1) is online**, this ritual graduates: stable cross-agent knowledge moves into OB1's structured shared-memory layer instead of being pinned in Discord. Until then, Discord is the cross-agent source of truth.

**Month 1 success metric:** 3 agents online, each handling at least one weekly recurring task. Daily and weekly cadence is muscle memory.

---

## Quarter 1 — Leverage

**Goal:** Walk into your next role with a working agent team and a personal COO Playbook.

### Build out the team

- Add agents for the highest-leverage workflows in your target domain
- Sweet spot: 3-5 agents. Below 5 = blind spots. Above 5 = silos.
- Each agent: clear role (its own `SOUL.md`), defined tier (its own `AGENTS.md`), inherited team identity (shared `DNA.md` — the team's shared SOUL)

### Operate the COO Cadence

- **Daily** (5 min): What shipped, what broke, what's blocked
- **Weekly** (30 min): Bottleneck review, commitments, system changes
- **Monthly** (60 min): Capacity vs demand, error budgets, quality trends, cost vs value
- **Quarterly** (half-day): Strategy → policy updates, kill low-leverage work, redesign risk envelopes

### Track 3 metrics

Pick one of each:
- **Leading** — e.g. "tasks queued"
- **Lagging** — e.g. "tasks completed correctly"
- **Cost** — e.g. "tokens per completed task"

Notion table is fine. Look daily for the first 2 weeks, then weekly.

### Career artifact

By end of Quarter 1, you have:

- A working multi-agent team running on a VPS that costs <€10/mo to operate
- Per-agent `MEMORY.md` files capturing each agent's continuity (graduating to OB1 shared memory when ready)
- A weekly cadence you can sustain solo or scale to a team
- Your own COO Playbook adapted from the one you got in the workshop

**Walk into your next interview / first day with this set up.** Show it to a partner. Ask: *"What if every operator at this firm had this?"*

That's the conversation.

---

## The Test (Playbook §14)

> *"If you leave for two weeks and work still flows, risk stays bounded, truth stays visible, and quality stays high — you built a system."*

By end of Quarter 1, you should be able to leave for a full week and come back to:
- Your agent team has continued the recurring workflows
- Nothing irreversible happened that you wouldn't have approved
- Each agent's `MEMORY.md` plus the Discord channels show you exactly what was done

If yes: you built a system.

If no: that's where Quarter 2 starts.
