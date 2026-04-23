# 🐔 ChickenHook

![Chicken Screaming on Tree](assets/chicken-screaming.jpg)

> _I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. You're welcome. Please star the repo ;)._

---

## The Story

I'm a 10x AI Vibe Engineer — I haven't touched real code in months, and honestly I'm at peace with that. My setup is Ghostty running multiple Claude, Codex, and Coco sessions across tabs and windows simultaneously. Different models for different tasks, all running in parallel. It's a good system.

The problem is keeping track of when any of them actually finish.

I'll fire off a prompt, jump to another tab to start something else, and somewhere along the way I drift — Douyin, Instagram reels, or just falling asleep. One reel turns into fifty. And every one of those sessions is just sitting there, done, waiting for me to type the next thing. Dead time I didn't even know I was losing.

I tried setting up notifications. The default Mac notification sound does nothing for me — it's too gentle, completely ignorable when you're in a reels spiral or half-asleep. I needed something that would actually make me stop.

Then I saw someone post a DJ remix of the screaming chicken on my feed, and something clicked. Pure, unignorable sigma energy. I set it as my notification sound immediately.

That single change skyrocketed my throughput. The chicken doesn't negotiate. You cannot "just one more reel" when a chicken is screaming through your speakers. ChickenHook automates the whole setup so you don't have to figure it out yourself.

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
