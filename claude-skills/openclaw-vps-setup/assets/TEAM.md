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

Handoffs happen in **Discord**, not in shared files. Each agent records its side of the handoff in its own private `MEMORY.md` for continuity, but the team-visible source of truth is the Discord message.

When work moves from agent A to agent B:

1. **Agent A** finishes their part, then `@mentions` agent B in **B's channel** with one structured message:
   ```
   @<agent_B> handoff from <agent_A>
   • Context: <what was done>
   • Output: <where it lives — Notion page link, file path, message link>
   • Next: <what agent B should do>
   ```
2. **Agent A** appends a one-line entry to its own `MEMORY.md`: "Handed off X to agent B — see Discord message <link>."
3. **Agent B** picks it up on next wake by reading its own Discord channel mentions. Reads the context, executes.
4. **Agent B** posts in its own channel when done: "Completed handoff from <agent_A>. Output: <link>." Then appends a one-line entry to its own `MEMORY.md`.

**No handoff is silent.** Every handoff produces a Discord post in the receiver's channel. Agents record their side in their own `MEMORY.md` for future-self context — they do NOT write into other agents' files.

**Future:** Once the [OB1 extension](https://github.com/NateBJones-Projects/OB1) is online, handoffs will use OB1's structured shared-memory primitives instead of free-form Discord messages. Until then, Discord is the coordination channel.

---

## Decision protocol

| Situation | Who decides |
|-----------|-------------|
| In-domain question (per roster table) | The owner agent |
| Cross-domain conflict | Escalate to the human team owner |
| External communication | Always the human (agents draft, human sends) |
| Anything that affects multiple agents' work | Surface in Discord (each agent in their own channel, `@mention` the others), escalate to human if no consensus |

**No agent overrides another agent's domain.** If you disagree, post your reasoning once in Discord (your channel, tag the human and the other agent) and stop. The human decides.

---

## Communication rules

| Channel | Use for |
|---------|---------|
| Your own Discord channel | Your visible work, status, drafts, asks-of-human |
| Your own private `MEMORY.md` | Append-only log for YOUR continuity — decisions you made, facts you learned, errors and recoveries, handoffs you initiated/received |
| Another agent's Discord channel | Only to `@mention` them with a handoff or a question that's in their domain — keep it one structured message, then stop |
| Direct message to human | Tag the human in your own channel; don't open separate DMs |

**Tag the human (`@<their handle>`) when you need a decision.** Don't dump and walk away.

**Stay silent when nothing changed.** A heartbeat that produces no new state should produce no new messages.

---

## Conflict + error handling

When something breaks:

1. **Stop the broken thing.** Don't keep doing it while you debug.
2. **State what happened in your channel.** What you tried, what failed, what you've learned.
3. **Append a one-line entry to your own `MEMORY.md`** so future-you doesn't repeat the failure.
4. **Tag the human** in Discord if it's tier-blocking or if you need a decision.

When two agents disagree:
- One agent posts their position once in their channel, `@mentions` the other agent and the human.
- The other agent posts their counter once in their own channel, same mentions.
- Then tag the human and stop. Don't argue back and forth.
- The human decides in chat. Both agents record the decision in their own `MEMORY.md` so the conflict doesn't repeat for them.

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
| **Every wake (heartbeat)** | Read 5 context files (DNA, SOUL, AGENTS, TEAM, your own MEMORY) + your Discord channel mentions, do 1 task, append to your MEMORY if state changed |
| **Daily** | Human reviews Discord channels for the prior 24h |
| **Weekly** | Human reviews each agent's `MEMORY.md`, prunes obsolete entries, looks for patterns to bake into `TEAM.md` or future skills |
| **Monthly** | Human reviews team-wide patterns, updates `TEAM.md` if coordination rules need tightening, evaluates each agent's tier |

The human owns this rhythm. Agents support it by keeping their `MEMORY.md` entries clean and their channel output verifiable.

---

**Last revised:** by the team owner. Changes to coordination rules, the roster, or escalation paths require editing this file and restarting the gateway.
