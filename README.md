# 🐔 ChickenHook

![Chicken Screaming on Tree](https://i.kym-cdn.com/entries/icons/original/000/056/069/chickencover_.jpg)

> *This is what your computer sounds like after ChickenHook. You're welcome.*

---

## The Problem

You're a modern AI-powered developer. You type a prompt, your AI starts working, and you... leave.

**Scenario A — Flow blindness:** You're deep in flow. The notification pops up quietly in the corner. You don't notice. The AI has been sitting idle for 11 minutes waiting for your next prompt. You are, effectively, the bottleneck.

**Scenario B — Douyin drift:** You open Douyin "just for a sec" while waiting. 47 minutes later you surface, bleary-eyed, having watched a guy trip over a cat 6 times in a row. Your AI finished in 30 seconds. It has been staring at a blinking cursor ever since.

## The Solution

A chicken. Screaming. From your speakers.

ChickenHook wires a genuine screaming chicken sound into your AI coding tools. When your AI finishes — or needs your attention — a chicken screams at you until you come back to the keyboard.

You cannot ignore a chicken.

## Value Add

Your AI works at 1000x human speed. You scroll Douyin at 0.001x. ChickenHook bridges the gap.

ROI: every minute the AI waits is a minute of your life you spent watching a guy trip over a cat. The chicken will not let this happen. The chicken is your productivity. Respect the chicken.

## What It Does

- Installs `terminal-notifier` and `gum` (via Homebrew, if not present)
- Downloads `chicken.aiff` → `~/Library/Sounds/`
- **Detects** which AI tools you have installed
- Lets you **choose** which ones to configure (interactive TUI)
- Configures selected tools with chicken sound hooks

### Supported Tools

| Tool | Config modified |
|------|----------------|
| Claude Code | `~/.claude/settings.json` |
| Gemini CLI | `~/.gemini/settings.json` |
| Aider | `~/.aider.conf.yml` |
| Codex CLI | `~/.codex/config.toml` + `hooks.json` |
| Coco | Plugin install via `coco plugin install` |

Safe to run multiple times — idempotent, non-destructive to existing config.

## Requirements

- macOS
- [Homebrew](https://brew.sh) (everything else installs automatically)

## Install

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/install.sh | bash
```

Or clone and run:

```bash
git clone git@github.com:algebananazzzzz/screaming_chicken_hook.git
cd screaming_chicken_hook
./install.sh
```

That's it. Go write a prompt. Then go touch grass. The chicken will call you back.

### Coco-only install

This repo is also a valid Coco Plugin. If you only use Coco, skip the one-liner and run:

```bash
# Install terminal-notifier first
brew install terminal-notifier

# Install as Coco Plugin (auto-copies chicken.aiff on first hook fire)
coco plugin install --type=github algebananazzzzz/screaming_chicken_hook
```
