# 🐔 ChickenHook

![Chicken Screaming on Tree](assets/chicken-screaming.jpg)

> _I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. Please star the repo if you enjoy the hook :))._

---

## The Story

I would consider myself a very aggressive vibe coder. I run Ghostty with multiple Claude, Codex, and Coco sessions going simultaneously across tabs and windows — different models, different tasks, all in parallel.

However, I have a very bad habit.

I fire a prompt, and then what do I do while I wait? Open Douyin / IG reels or just fall asleep. And even when I actually see a session finish, I still procrastinate — "one more reel" becomes fifty more. I can feel myself getting stupider with every scroll.

I tried Ghostty's notifications, Claude's built-in sounds. They do nothing for me. Too gentle. Too easy to ignore when you're already three reels deep or half-asleep.

Then the screaming chicken meme popped up on my feed. Something immediately switched in me — if that chicken had enough sigma energy to stop crossing roads and just stand on a tree looking down at the top of the world, maybe I needed that same energy jolting me back to work.

I may have angered a few people around my workdesk. And at the gym — yes, I love vibe code at the gym while waiting between sets. But if you just try this hook once, you'll know exactly what I mean. Every time that scream hits, something jolts in me. There's just something about that chicken that makes me drop the phone and get back to work.

---

## Before and After

| Without ChickenHook | With ChickenHook |
|---|---|
| <img src="assets/mr-incredible-uncanny.png" width="240"/> | <img src="assets/mr-incredible-canny.jpg" width="240"/> |
| Your Claude Session finished 40 minutes ago. You didn't notice as you're already engrossed in reels. | The chicken screamed once. You came back to prompt within seconds. |

---

## Requirements

- macOS
- [Homebrew](https://brew.sh) — the script handles everything else automatically

---

## Install

One line.

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/install.sh | bash
```

---

## What It Does

Run the script, pick which AI tools you want wired up, and that's it. It installs the chicken sound to the right place on your Mac for the AI coding tools you select, and configures each tool to scream at you when it's done or needs your attention.

Supported tools:

| Tool | How it's configured |
|------|---------------------|
| Claude Code | `~/.claude/settings.json` — Notification + Stop hooks |
| Gemini CLI | `~/.gemini/settings.json` — Notification + AfterAgent hooks |
| Aider | `~/.aider.conf.yml` — notifications_command |
| Codex CLI | `~/.codex/config.toml` + `hooks.json` — notify + Stop |
| Coco | Installed as a Coco Plugin via `coco plugin install` |

Safe to run more than once — it won't double-up or break anything that's already configured.

---

## Uninstall

If for some reason you want the silence back:

```bash
./uninstall.sh
```

Or:

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/uninstall.sh | bash
```
