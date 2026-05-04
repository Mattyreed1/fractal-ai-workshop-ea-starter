#!/usr/bin/env bash
# onboard_agent.sh — Steps 5-6 of the 7-step onboarding playbook.
#
# Run this AFTER you've manually:
#   1. Picked the agent's role (and have a SOUL.md ready)
#   2. Edited the SOUL.md
#   3. Appended the agent's entry to ~/.openclaw/openclaw.json
#   4. Added the new bot token to ~/openclaw/.env and created the Discord channel
#
# This script does:
#   5. sync_skills.sh on the VPS
#   6. docker compose restart openclaw-gateway
#   then tells you to do step 7 (trigger from Discord).
#
# Usage:
#   bash scripts/onboard_agent.sh <ssh-host>
#   e.g.  bash scripts/onboard_agent.sh openclaw-vps

set -euo pipefail

SSH_HOST="${1:-openclaw-vps}"

echo "=== Onboarding agent — running steps 5-6 against $SSH_HOST ==="

# Step 5: sync skills
echo ""
echo "[5/7] Syncing canonical skills to agent workspace..."
ssh -o ConnectTimeout=10 "$SSH_HOST" 'bash ~/openclaw/sync_skills.sh'

# Step 6: restart gateway
echo ""
echo "[6/7] Restarting openclaw-gateway..."
ssh -o ConnectTimeout=10 "$SSH_HOST" 'cd ~/openclaw && docker compose restart openclaw-gateway'

# Wait for healthy
echo ""
echo "Waiting up to 90s for gateway to report healthy..."
for i in {1..18}; do
  status=$(ssh -o ConnectTimeout=5 "$SSH_HOST" 'docker inspect -f "{{.State.Health.Status}}" openclaw-openclaw-gateway-1 2>/dev/null || echo missing')
  if [[ "$status" == "healthy" ]]; then
    echo "  gateway healthy after $((i*5))s"
    break
  fi
  if [[ "$i" == "18" ]]; then
    echo "WARN: gateway not healthy after 90s — current status: $status"
    echo "WARN: check logs: ssh $SSH_HOST 'docker logs --tail 50 openclaw-openclaw-gateway-1'"
    exit 1
  fi
  sleep 5
done

# Step 7: tell user to trigger
echo ""
echo "=== Steps 5-6 complete ==="
echo ""
echo "[7/7] NOW DO THIS MANUALLY:"
echo "  Open Discord → your new agent's channel → @mention the bot with a test message."
echo "  e.g. '@<bot-name> hello, introduce yourself'"
echo ""
echo "Verify: bot responds within 30-60s."
echo "If silent: ssh $SSH_HOST 'docker logs --tail 50 openclaw-openclaw-gateway-1' and look for the bot name."
