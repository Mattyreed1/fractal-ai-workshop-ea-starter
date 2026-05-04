#!/usr/bin/env bash
# sync_skills.sh — Distribute canonical skills to the OpenClaw agent workspace.
#
# Usage:
#   On the VPS:  bash ~/openclaw/sync_skills.sh
#
# What it does:
#   - Reads skills from a canonical source dir (default: ~/.openclaw/canonical/skills/)
#   - Copies each skill to the agent workspace (~/.openclaw/workspace/skills/)
#   - Backs up any existing skill before overwriting
#   - Reports what was synced
#
# Safe to re-run. Idempotent.

set -euo pipefail

SOURCE_DIR="${OPENCLAW_CANONICAL_SKILLS:-$HOME/.openclaw/canonical/skills}"
TARGET_DIR="${OPENCLAW_WORKSPACE_SKILLS:-$HOME/.openclaw/workspace/skills}"
BACKUP_DIR="$HOME/.openclaw/backups/skills-$(date +%Y%m%d-%H%M%S)"

# === pre-flight ===

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "INFO: canonical source dir not found ($SOURCE_DIR)"
  echo "INFO: nothing to sync — create $SOURCE_DIR and drop skill folders inside, then re-run."
  echo "INFO: each skill should be a directory containing SKILL.md."
  exit 0
fi

mkdir -p "$TARGET_DIR"

# === sync ===

count_synced=0
count_backed_up=0

for skill_path in "$SOURCE_DIR"/*/; do
  [[ -d "$skill_path" ]] || continue
  skill_name=$(basename "$skill_path")

  if [[ ! -f "$skill_path/SKILL.md" ]]; then
    echo "WARN: skipping $skill_name — no SKILL.md found"
    continue
  fi

  target_path="$TARGET_DIR/$skill_name"

  if [[ -d "$target_path" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$target_path" "$BACKUP_DIR/"
    rm -rf "$target_path"
    count_backed_up=$((count_backed_up + 1))
  fi

  cp -r "$skill_path" "$target_path"
  count_synced=$((count_synced + 1))
  echo "  synced: $skill_name"
done

# === report ===

echo ""
echo "Done."
echo "  synced:    $count_synced skill(s) → $TARGET_DIR"
echo "  backed up: $count_backed_up existing skill(s) → $BACKUP_DIR"
echo ""
echo "Next: restart the gateway so agents pick up new skills:"
echo "  cd ~/openclaw && docker compose restart openclaw-gateway"
