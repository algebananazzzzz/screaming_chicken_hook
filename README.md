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
| Session finished 40 minutes ago. You're still on Douyin. You didn't notice. | The chicken screamed. You came back within seconds. The cursor had company. |
| You fell asleep. The AI kept going. It wrote 200 files you didn't ask for. | You didn't fall asleep. The chicken had something to say about that. |
| "I genuinely don't know what I'm building anymore." | You were never gone long enough to lose the thread. |

---

## What It Does

It's one script. Run it, pick which AI tools you want wired up, and that's it. It installs the chicken sound to the right place on your Mac, hooks it into your notification system, and configures each tool to scream at you when it's done or needs your attention.

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

## Requirements

- macOS
- [Homebrew](https://brew.sh) — the script handles everything else automatically

---

## Install

One line. That's it.

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/install.sh | bash
```

Or if you'd rather clone it first:

```bash
git clone git@github.com:algebananazzzzz/screaming_chicken_hook.git
cd screaming_chicken_hook
./install.sh
```

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

---

### Coco-only

This repo is also a valid Coco Plugin, so if you only use Coco you can skip the script entirely:

```bash
brew install terminal-notifier
coco plugin install --type=github algebananazzzzz/screaming_chicken_hook
```

The chicken copies itself into `~/Library/Sounds/` the first time a hook fires.
