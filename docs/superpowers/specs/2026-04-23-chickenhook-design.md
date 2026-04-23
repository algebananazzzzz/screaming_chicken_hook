# ChickenHook Design

**Date:** 2026-04-23  
**Status:** Approved

## Overview

Single-file installer (`setup.sh`) that configures a chicken sound notification for LLM terminal tools on macOS. Users clone the repo and run `setup.sh`. No runtime dependencies beyond bash and homebrew.

## Repo Structure

```
ChickenHook/
├── chicken.aiff        # bundled notification sound
├── setup.sh            # installer script
└── README.md           # funny explainer with meme
```

## README

Funny, short README explaining the problem and solution. Tone: dry humor, relatable dev pain.

**Problem statement (two angles):**
1. Claude/Coco finish silently. Notification appears but you're in flow — don't notice, miss it. AI sits idle waiting for next prompt.
2. You go sleep or scroll Douyin while waiting. Lose track of time completely. Need something that physically forces you back to the keyboard.

**Solution:** A chicken screaming on your roof. Literally impossible to ignore.

**Value add (humorous):** Your AI works at 1000x human speed. You scroll Douyin at 0.001x. ChickenHook bridges the gap. ROI: every minute the AI waits is a minute of your life you spent watching a guy trip over a cat. The chicken will not let this happen. The chicken is your productivity. Respect the chicken.

**Meme reference:** "Chicken Screaming on Tree" meme (Know Your Meme, Nov 2025).  
Image: `https://i.kym-cdn.com/entries/icons/original/000/056/069/chickencover_.jpg`  
Source page: https://knowyourmeme.com/memes/chicken-screaming-on-tree

README structure:
1. Meme image embedded at top
2. One-liner pitch
3. What it does (bullet: installs sound, configures Claude + Coco)
4. Install: `git clone ... && cd ChickenHook && ./setup.sh`
5. Requirements: macOS, homebrew (auto-installed if missing)

## Setup Script Flow

### 1. Install terminal-notifier

- Check if `terminal-notifier` is on PATH
- If absent: run `brew install terminal-notifier`
- If brew fails: print error and exit with non-zero code

### 2. Install sound file

- Copy `chicken.aiff` (from repo root, relative to script) → `~/Library/Sounds/chicken.aiff`
- Overwrite unconditionally (ensures correct version)

### 3. Configure Claude Code

- Target: `~/.claude/settings.json`
- If file absent: create minimal `{}` JSON first
- Use `python3 -c` to read, merge, write JSON
- Add `Notification` hook: `terminal-notifier -message "Claude needs your attention" -title "Claude Code" -sound chicken`
- Add `Stop` hook: `terminal-notifier -message "Claude finished" -title "Claude Code" -sound chicken`
- Idempotent: skip hook if `-sound chicken` string already present in that hook list
- Preserves all existing config keys

### 4. Configure Coco (conditional)

- Target: `~/Library/Application Support/coco/coco.yaml`
- Skip entirely if file does not exist — print `coco not found, skipping`
- If exists: check for `-sound chicken` string presence
- If absent: append hook block to end of file:
  ```yaml
  hooks:
    - type: command
      command: '/opt/homebrew/bin/terminal-notifier -message "Coco needs your attention" -title "Coco" -sound chicken'
      matchers:
        - event: notification
    - type: command
      command: '/opt/homebrew/bin/terminal-notifier -message "Coco finished" -title "Coco" -sound chicken'
      matchers:
        - event: stop
        - event: subagent_stop
  ```
- If already present: print `coco already configured, skipping`

### 5. Success output

Print per-step status lines, e.g.:
```
✓ terminal-notifier installed
✓ chicken.aiff installed to ~/Library/Sounds/
✓ Claude Code configured
✓ coco configured          (or: coco not found, skipping)

🐔 ChickenHook setup complete!
```

## Constraints

- macOS only (uses `~/Library/Sounds/`, `terminal-notifier`, homebrew)
- Pure bash + `python3` (no jq, yq, node, or other deps)
- Idempotent: safe to run multiple times
- Non-destructive to existing config (merge, not replace)

## Error Handling

- `brew install` failure → exit 1 with message
- `python3` not found → exit 1 with message (pre-installed on macOS)
- `settings.json` parse failure → exit 1, do not overwrite

## Out of Scope

- Windows/Linux support
- Removing/uninstalling the configuration
- Other LLM tools beyond Claude Code and Coco
