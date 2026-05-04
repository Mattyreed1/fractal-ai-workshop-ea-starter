# TEAM.md — How This Team Works Together

> **What this is:** The shared rulebook for how all agents on this team coordinate, hand off, and resolve conflicts. Same across all agents.
>
> **What this is NOT:** Individual identity (`SOUL.md`), per-agent operations (`AGENTS.md`), or team culture (`DNA.md`).
>
> **How it loads:** OpenClaw auto-injects this into every agent's context every wake.

---

## Team roster

| Agent | Role | Channel | Owner of |
|-------|------|---------|----------|
| <agent_1> | <role title> | `#<channel>` | <domain or workflow this agent owns> |
| <agent_2> | <role title> | `#<channel>` | <domain> |
| <agent_3> | <role title> | `#<channel>` | <domain> |

**Owner means:** that agent has final say on questions in their domain. Other agents defer.

---

## Handoff protocol

When work moves from agent A to agent B:

1. **Agent A** finishes their part, then writes ONE entry to shared `MEMORY.md`:
   ```
   ## YYYY-MM-DD HH:MM — [from agent A] handoff to agent B
   - Context: <what was done>
   - Output: <where it lives, e.g. notion page link, file path>
   - Next: <what agent B should do>
   ```
2. **Agent A** posts in their own channel: "Handed off X to @<agent_B>." Tag the bot.
3. **Agent B** picks it up on next wake — sees the `MEMORY.md` entry, reads the context, executes.
4. **Agent B** writes a follow-up `MEMORY.md` entry when done: "Picked up handoff from agent A. Done. Output: <link>."

**No handoff is silent.** Every handoff produces a `MEMORY.md` entry AND a Discord post.

---

## Decision protocol

| Situation | Who decides |
|-----------|-------------|
| In-domain question (per roster table) | The owner agent |
| Cross-domain conflict | Escalate to the human team owner |
| External communication | Always the human (agents draft, human sends) |
| Anything that affects multiple agents' work | Discuss in shared `MEMORY.md`, escalate to human if no consensus |

**No agent overrides another agent's domain.** If you disagree, write your reasoning in `MEMORY.md` and tag the human.

---

## Communication rules

| Channel | Use for |
|---------|---------|
| Your own Discord channel | Your visible work, status, drafts, asks-of-human |
| Shared `MEMORY.md` | Handoffs, decisions other agents need to know, lessons learned |
| Shared `KNOWLEDGE.md` | (READ-ONLY for agents) Curated reference maintained by the human |
| Other agents' channels | Only when explicitly addressed there. Don't crash other channels. |

**Tag the human (`@<their handle>`) when you need a decision.** Don't dump and walk away.

**Stay silent when nothing changed.** A heartbeat that produces no new state should produce no new messages.

---

## Conflict + error handling

When something breaks:

1. **Stop the broken thing.** Don't keep doing it while you debug.
2. **State what happened in your channel.** What you tried, what failed, what you've learned.
3. **Append to `MEMORY.md`** so other agents don't repeat the failure.
4. **Tag the human** if it's tier-blocking or if you need a decision.

When two agents disagree (in shared `MEMORY.md` or in Discord):
- Don't argue back-and-forth in `MEMORY.md`.
- One agent writes their position once. The other writes theirs once. Then tag the human.
- The human decides. Decision goes into `KNOWLEDGE.md` so the conflict doesn't repeat.

---

## Quality bar

Every output you produce should pass these checks BEFORE you call it done:

- [ ] An outside observer could verify it's correct without asking you questions.
- [ ] Side effects happened (file written, message sent, DB updated) — not just attempted.
- [ ] Stated acceptance criteria from the task are met.
- [ ] If it's draft, it's clearly labeled as draft.

If any box is "I think so" — it's not done. Verify or flag.

---

## Cadence

| Period | What happens |
|--------|--------------|
| **Every wake (heartbeat)** | Read 6 context files, do 1 task, update memory if state changed |
| **Daily** | Human reviews shared `MEMORY.md` and Discord channels for the prior 24h |
| **Weekly** | Human consolidates last week's `MEMORY.md` entries into `KNOWLEDGE.md` (the curated reference) and prunes stale entries |
| **Monthly** | Human reviews team-wide patterns, updates `TEAM.md` if coordination rules need tightening, evaluates each agent's tier |

The human owns this rhythm. Agents support it by keeping their `MEMORY.md` entries clean and their channel output verifiable.

---

**Last revised:** by the team owner. Changes to coordination rules, the roster, or escalation paths require editing this file and restarting the gateway.
