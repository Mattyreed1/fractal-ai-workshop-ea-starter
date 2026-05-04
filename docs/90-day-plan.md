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

### Day 3 (~45 min)

- [ ] Resume with CC: *"continue setting up the OpenClaw stack"*
- [ ] Phase 3 with CC (shared layers — DNA, TEAM, MEMORY, KNOWLEDGE)
- [ ] **Spend 15 min populating `KNOWLEDGE.md` for your domain** (your name, business, current focus, key people, active projects). This pays back 10x.

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

**Goal:** 2-3 agents onboarded. Shared memory layer in regular use. Weekly rhythm.

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

### KNOWLEDGE.md hygiene

End of each week, take 10 min to:
- Move stable facts from MEMORY.md into KNOWLEDGE.md
- Delete obsolete entries
- Keep KNOWLEDGE.md under ~3,000 words (re-read once a month for compounding clarity)

**Month 1 success metric:** 3 agents online, each handling at least one weekly recurring task. Daily and weekly cadence is muscle memory.

---

## Quarter 1 — Leverage

**Goal:** Walk into your next role with a working agent team and a personal COO Playbook.

### Build out the team

- Add agents for the highest-leverage workflows in your target domain
- Sweet spot: 3-5 agents. Below 5 = blind spots. Above 5 = silos.
- Each agent: clear role (SOUL.md), defined tier (AGENTS.md), inherited culture (DNA.md)

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
- A Notion `KNOWLEDGE.md` that captures your domain's institutional knowledge
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
- The shared MEMORY.md and Discord channels show you exactly what was done

If yes: you built a system.

If no: that's where Quarter 2 starts.
