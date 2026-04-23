# 🐔 ChickenHook

![Chicken Screaming on Tree](assets/chicken-screaming.jpg)

> _I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. You're welcome. Please star the repo ;)._

---

## The Problem

You are a **10x AI Vibe Engineer™**. You have not written a single line of code for months. Your AI is your entire engineering team. Your job title is technically "CEO of Prompts."

And yet. The machines keep finishing without you noticing.

**Scenario A — Flow blindness:** You're deep in flow. The notification pops up quietly in the corner. You don't notice. The AI has been sitting idle for 11 minutes waiting for your next prompt. You are the bottleneck in your own one-man AI company.

**Scenario B — Douyin drift:** You open Douyin "just for a sec" while waiting. 47 minutes later you surface, having watched a guy trip over a cat 6 times. Your AI finished in 30 seconds and has been staring at a blinking cursor ever since.

## The Solution

A chicken. Screaming. From your speakers.

ChickenHook wires a genuine screaming chicken sound into your AI coding tools. When your AI finishes or needs your attention, a chicken screams at you until you come back to the keyboard.

You cannot ignore a chicken.

## Value Add

Your AI works at 1000x human speed. You scroll Douyin at 0.001x. ChickenHook bridges the gap. Every minute the AI waits is a minute you spent watching a guy trip over a cat.

---

## Before and After

| Without ChickenHook | With ChickenHook |
|---|---|
| ![uncanny](assets/mr-incredible-uncanny.png) | ![canny](assets/mr-incredible-canny.jpg) |
| AI finished 40 minutes ago. You're still on Douyin. | Chicken screamed at 31 seconds. You came back. |
| It wrote 200 files while you were asleep. It had no stop condition. | You did not sleep. The chicken had opinions about that. |
| "I don't know what I'm building anymore." | Sir. The chicken called you back 4 minutes in. |

---

## What It Does

- Installs `terminal-notifier` and `gum` via Homebrew automatically
- Downloads `chicken.aiff` → `~/Library/Sounds/`
- Detects which AI tools you have installed
- Interactive TUI to choose which tools to configure
- Wires the chicken into each selected tool

### Supported Tools

| Tool | Config |
|------|--------|
| Claude Code | `~/.claude/settings.json` — Notification + Stop hooks |
| Gemini CLI | `~/.gemini/settings.json` — Notification + AfterAgent hooks |
| Aider | `~/.aider.conf.yml` — notifications_command |
| Codex CLI | `~/.codex/config.toml` + `hooks.json` — notify + Stop |
| Coco | Plugin install via `coco plugin install` |

Safe to run multiple times — idempotent, won't break existing config.

---

## Requirements

- macOS
- [Homebrew](https://brew.sh) — everything else installs automatically

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/install.sh | bash
```

Or clone and run:

```bash
git clone git@github.com:algebananazzzzz/screaming_chicken_hook.git
cd screaming_chicken_hook
./install.sh
```

---

## Uninstall

```bash
./uninstall.sh
```

Or:

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/uninstall.sh | bash
```

---

### Coco-only

This repo is a valid Coco Plugin. If you only use Coco:

```bash
brew install terminal-notifier
coco plugin install --type=github algebananazzzzz/screaming_chicken_hook
```

The chicken copies itself to `~/Library/Sounds/` on first hook fire.
