# 🐔 ChickenHook

![Chicken Screaming on Tree](https://i.kym-cdn.com/entries/icons/original/000/056/069/chickencover_.jpg)

> *This is what your computer sounds like after ChickenHook. You're welcome.*

---

## The Problem

You're a modern AI-powered developer. You type a prompt, Claude/Coco starts working, and you... leave.

**Scenario A:** You're in deep flow. The notification pops up quietly in the corner. You don't notice. The AI has been sitting idle for 11 minutes waiting for your next prompt. You are, effectively, the bottleneck.

**Scenario B:** You open Douyin "just for a sec" while waiting. 47 minutes later you surface, bleary-eyed, having watched a guy trip over a cat 6 times. Your AI finished in 30 seconds. It has been staring at a blinking cursor since.

## The Solution

A chicken. Screaming. From your speakers.

ChickenHook installs a genuine chicken sound (`chicken.aiff`) as your macOS notification sound and wires it into Claude Code and Coco. When your AI finishes — or needs your attention — a chicken screams at you until you come back.

You cannot ignore a chicken.

## Value Add

Your AI works at 1000x human speed. You scroll Douyin at 0.001x. ChickenHook bridges the gap.

ROI: every minute the AI waits is a minute of your life you spent watching a guy trip over a cat. The chicken will not let this happen. The chicken is your productivity. Respect the chicken.

## What It Does

- Installs `terminal-notifier` (via Homebrew, if not present)
- Copies `chicken.aiff` → `~/Library/Sounds/`
- Configures **Claude Code** (`~/.claude/settings.json`) with chicken notification hooks
- Configures **Coco** (`~/Library/Application Support/coco/coco.yaml`) — if installed

Idempotent. Safe to run multiple times.

## Requirements

- macOS
- [Homebrew](https://brew.sh) (for `terminal-notifier` — auto-installed if missing)

## Install

```bash
git clone <repo-url> ChickenHook
cd ChickenHook
./setup.sh
```

That's it. Go write a prompt. Then go touch grass. The chicken will call you back.
