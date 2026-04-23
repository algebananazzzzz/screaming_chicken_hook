# 🐔 ChickenHook

![Chicken Screaming on Tree](assets/chicken-screaming.jpg)

> _I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. Please star the repo if you enjoy the hook :))._

---

## The Story

I would consider myself a very aggressive vibe coder. I run Ghostty with multiple Claude, Codex, and Coco sessions going simultaneously across tabs and windows — different models, different tasks, all in parallel. Ever since I set it up this way, my productivity genuinely skyrocketed.

However, I have a very bad habit.

I fire a prompt, and then what do I do while I wait? Open Douyin. IG reels. Or just fall asleep. And even when I actually see a session finish, I still procrastinate — "one more reel" becomes fifty more. I can feel myself getting stupider with every scroll.

I tried Ghostty's notifications, Claude's built-in sounds. They do nothing for me. Too gentle. Too easy to ignore when you're already three reels deep or half-asleep.

Then I saw someone on my feed recommend using the screaming chicken DJ remix as an alarm clock. I genuinely wanted to do it — but I'm in a dorm. That's not a conversation I'm ready to have with my roommates at 3am.

But for my AI sessions? Absolutely.

The moment I set it up, something changed. Every time that scream hits, something jolts in me — brain goes into overclock mode. There's something about visualising that chicken, sigma enough to stop crossing roads and just stand on a tree screaming, that makes me drop the phone and get back to work. The dead time basically disappeared.

ChickenHook automates the whole setup so you don't have to figure it out yourself.

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
