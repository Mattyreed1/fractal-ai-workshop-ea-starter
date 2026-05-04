#!/usr/bin/env bash
# install.sh — symlink workshop skills into ~/.claude/skills/
#
# Run from the repo root:
#   bash install.sh
#
# Idempotent: skips skills that are already linked.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.claude/skills"

mkdir -p "$TARGET"

echo "Installing Fractal AI Workshop EA Starter skills..."
echo ""

for skill in "$REPO_ROOT/claude-skills"/*/; do
    name=$(basename "$skill")
    link="$TARGET/$name"

    if [[ -e "$link" || -L "$link" ]]; then
        echo "  ⚠  $name → already exists at $link"
        echo "     Skipping. Remove it manually if you want to re-link:"
        echo "       rm $link"
        continue
    fi

    ln -s "$skill" "$link"
    echo "  ✓  $name → linked to $link"
done

echo ""
echo "Done. Restart Claude Code to load the new skills."
echo ""
echo "Verify by asking CC: 'do I have a skill for setting up an openclaw VPS?'"
echo "Expected: yes — recommends 'openclaw-vps-setup'."
