# Install Walkthrough

A more detailed companion to the 3-command install in the README. Pair with the Loom video at `<TODO: link>`.

## Prerequisites

You need:

- **macOS or Linux** (Windows users: WSL2 should work, untested)
- **Claude Code** installed and you've used it at least once
- **Terminal** access
- **`git`** installed (`git --version` to check)

You don't need:

- A VPS yet — the `openclaw-vps-setup` skill walks you through provisioning one
- A Discord account yet — set it up when the skill prompts you
- Programming experience — the skill is for non-coders driving CC

## Step-by-step

### 1. Clone the repo

```bash
git clone https://github.com/Mattyreed1/fractal-ai-workshop-ea-starter.git ~/fractal-ai-workshop-ea-starter
```

Lands the repo at `~/fractal-ai-workshop-ea-starter`.

### 2. Run the install script

```bash
cd ~/fractal-ai-workshop-ea-starter
bash install.sh
```

What happens:
- Looks at the `claude-skills/` folder
- For each skill in there, creates a symlink in `~/.claude/skills/<skill-name>`
- Skips any that are already linked

You should see something like:

```
✓  openclaw-vps-setup → linked to /Users/you/.claude/skills/openclaw-vps-setup
```

### 3. Restart Claude Code

Quit and reopen. CC discovers skills on startup, so a restart is needed.

### 4. Verify

In a fresh CC session, type:

```
do I have a skill for setting up an openclaw VPS?
```

Expected: CC recommends `openclaw-vps-setup`. If it doesn't, see Troubleshooting below.

### 5. (Optional) Drop in the CLAUDE.md template

Customize `CLAUDE.md.example` with your name, domain, and preferred behaviors. Save it as:

- `~/.claude/CLAUDE.md` (global — all projects) OR
- `<your-project>/.claude/CLAUDE.md` (per-project)

## Updating later

When the repo gets new content:

```bash
cd ~/fractal-ai-workshop-ea-starter
git pull
```

Symlinks already point at the repo files, so updates apply automatically. New skills require a re-run of `install.sh`.

## Uninstalling

```bash
rm ~/.claude/skills/openclaw-vps-setup
# (and any other skills you linked)
```

Then optionally remove the cloned repo:

```bash
rm -rf ~/fractal-ai-workshop-ea-starter
```

## Troubleshooting

### Symlink already exists

The script skipped a skill because there's already something at `~/.claude/skills/<name>`. Either:

- Remove the existing one (`rm ~/.claude/skills/<name>`) and re-run
- Leave it alone if you intentionally have a custom version

### CC doesn't recognize the skill after restart

1. Confirm the symlink exists: `ls -la ~/.claude/skills/`
2. Confirm the symlink points somewhere real: `cat ~/.claude/skills/openclaw-vps-setup/SKILL.md` should show the skill content
3. Fully quit CC (not just close the window) and reopen

### `git: command not found`

Install git: `brew install git` (macOS) or `sudo apt install git` (Linux).
