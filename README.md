# 🐔 ChickenHook

![Chicken Screaming on Tree](assets/chicken-screaming.jpg)

> _I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. You're welcome. Please star the repo ;)._

---

## The Story

I run Ghostty with sessions spread across multiple tabs and windows. I'm a 10x AI Vibe Engineer — I haven't touched real code in months. Fire a prompt, AI does the work, I review and repeat. It compounds fast.

The problem: I can never tell when a session finishes. I send a prompt, switch to another tab, open Douyin or IG reels "for a second" — and one reel becomes fifty. Or I just fall asleep. By the time I come back, the AI has been sitting idle for 30 minutes waiting for a single keystroke. That dead time adds up. A lot.

I tried configuring notifications. The Mac default sound is too soft, too easy to tune out. It doesn't cut through reels audio. It doesn't wake you up.

Then I saw someone post a DJ remix of the screaming chicken on my feed. Pure sigma energy. Unignorable. I immediately knew.

I set it as my notification sound. That one change genuinely skyrocketed my throughput. The chicken does not let you procrastinate. You cannot "one more reel" when a chicken is screaming at you.

ChickenHook automates the full setup — one command, and your AI tools all scream a chicken when they're done.

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
