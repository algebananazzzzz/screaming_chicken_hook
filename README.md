# 🐔 ChickenHook

![Chicken Screaming on Tree](assets/chicken-screaming.jpg)

> _I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. You're welcome. Please star the repo ;)._

---

## The Story

If you're anything like me, you haven't touched code in months. I'm a self-proclaimed 10x AI Vibe Engineer — I describe what I want, my AI builds it, I review, repeat. The AI is the engineering team. I'm the CEO of Prompts. It works surprisingly well, until it doesn't.

The problem is the gap between when the AI finishes and when I actually notice.

I'd fire off a prompt, then drift — check Douyin, grab water, get pulled into something else. The AI would finish in 30 seconds and just... wait. Blinking cursor. Infinite patience. And I'd come back 40 minutes later wondering why my session felt slow. The answer was always me.

I tried the built-in Mac notification sound. It's too soft. Too polite. It blends into background noise and I've trained myself to ignore it without even realising. I needed something that would cut through — something I physically could not tune out.

So I built this. I set the notification sound to a chicken screaming.

It sounds ridiculous. It works completely. The moment my AI finishes, a chicken screams from my speakers. I've never once missed it. My response time went from "whenever I wander back" to "within seconds." That single change genuinely skyrocketed my throughput — more prompts per hour, tighter feedback loops, less context lost between sessions.

ChickenHook automates the whole setup. One command and your AI tools — Claude Code, Gemini CLI, Aider, Codex, Coco — all scream a chicken at you when they're done.

---

## Before and After

| Without ChickenHook | With ChickenHook |
|---|---|
| <img src="assets/mr-incredible-uncanny.png" width="240"/> | <img src="assets/mr-incredible-canny.jpg" width="240"/> |
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
