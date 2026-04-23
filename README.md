# 🐔 ChickenHook

![Chicken Screaming on Tree](https://i.kym-cdn.com/entries/icons/original/000/056/069/chickencover_.jpg)

> *This is what your computer sounds like after ChickenHook. You're welcome.*

---

## The Problem

You are not a developer. You haven't written a line of code since March.

You are a **10x AI Vibe Engineer™** — a highly paid human who describes vibes to machines, reviews what the machines did, and opens Douyin to celebrate. Your AI is your entire engineering team. Your job title is technically "CEO of Prompts." You have strong opinions about tab width in code you didn't write.

And yet. The machines keep finishing without you noticing.

**Scenario A — Flow blindness:** You're deep in flow. The notification pops up quietly in the corner. You don't notice. The AI has been sitting idle for 11 minutes waiting for your next prompt. You are, effectively, the bottleneck. In your own one-man AI company. You are the single point of failure. The bus factor is 1. That bus is a Douyin algorithm.

**Scenario B — Douyin drift:** You open Douyin "just for a sec" while waiting. 47 minutes later you surface, bleary-eyed, having watched a guy trip over a cat 6 times in a row. Your AI finished in 30 seconds. It has been staring at a blinking cursor ever since. It does not get paid overtime. But you should feel bad anyway.

## The Solution

A chicken. Screaming. From your speakers.

ChickenHook wires a genuine screaming chicken sound into your AI coding tools. When your AI finishes — or needs your attention — a chicken screams at you until you come back to the keyboard.

You cannot ignore a chicken.

> *I spent 3% of my Claude Max 20x subscription building this instead of literally anything else. You're welcome. Please star the repo.*

## Value Add

Your AI works at 1000x human speed. You scroll Douyin at 0.001x. ChickenHook bridges the gap.

ROI: every minute the AI waits is a minute of your life you spent watching a guy trip over a cat. The chicken will not let this happen. The chicken is your productivity. Respect the chicken.

---

## The Mr. Incredible Arc of Vibe Coding

*([Mr. Incredible Becoming Uncanny](https://knowyourmeme.com/memes/mr-incredible-becoming-uncanny) — a 1:1 accurate representation of your session)*

<table>
<tr>
<th align="center" width="50%">😵 Without ChickenHook</th>
<th align="center" width="50%">😊 With ChickenHook</th>
</tr>
<tr>
<td align="center"><img src="https://i.imgflip.com/2/5z2ywc.jpg" width="220"/></td>
<td align="center"><img src="https://i.imgflip.com/2/5zvk7e.jpg" width="220"/></td>
</tr>
<tr>
<td>

**"I'll just check Douyin for a sec while it runs."**

It's been 47 minutes. Your AI finished in 30 seconds. It has been waiting in silence, blinking cursor, fully prepared to continue, deeply unbothered, deeply unjudgemental, but you should judge yourself.

</td>
<td>

**The chicken screamed. You came back.**

It has been 31 seconds. The cursor blinks. You are here. The AI continues. The loop is closed. The velocity is maintained. You are, for once, not the bottleneck.

</td>
</tr>
<tr>
<td>

**"Oh. It wrote 200 files I didn't ask for."**

You fell asleep. Or you watched a man trip over a cat 6 times. Either way, the AI kept going. It has no stop condition when you are not there. It is a very enthusiastic intern.

</td>
<td>

**You did not fall asleep.**

The chicken had opinions about that. Loudly. At volume. From your speakers. Your neighbours now also know when your AI finishes. This is a feature.

</td>
</tr>
<tr>
<td>

**"I don't know what I'm building anymore."**

</td>
<td>

**Sir, the chicken called you back 4 minutes in.**

Please write a prompt.

</td>
</tr>
</table>

---

## What It Does

Runs an interactive installer that:

- Installs `terminal-notifier` and `gum` via Homebrew (automatically, you don't need to think)
- Downloads a real chicken screaming sound → `~/Library/Sounds/chicken.aiff`
- Detects which AI tools you have installed
- Lets you **choose** which ones to configure (interactive TUI — it's beautiful, we used Charm)
- Wires the chicken into each selected tool

### Supported Tools

| Tool | Method |
|------|--------|
| Claude Code | `~/.claude/settings.json` — Notification + Stop hooks |
| Gemini CLI | `~/.gemini/settings.json` — Notification + AfterAgent hooks |
| Aider | `~/.aider.conf.yml` — notifications_command |
| Codex CLI | `~/.codex/config.toml` + `hooks.json` — notify + Stop |
| Coco | Plugin install via `coco plugin install` |

Safe to run multiple times — idempotent, non-destructive to existing config. We are not monsters.

---

## Requirements

- macOS *(the chicken is a mac person)*
- [Homebrew](https://brew.sh) — everything else installs automatically

---

## Install

One-liner. Copy. Paste. Walk away. The chicken will handle it from here.

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone git@github.com:algebananazzzzz/screaming_chicken_hook.git
cd screaming_chicken_hook
./install.sh
```

---

## Uninstall

So you've decided to return to silence. To the void. To 47 minutes of Douyin with no consequences.

```bash
./uninstall.sh
```

Or the curl way, for the truly committed:

```bash
curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/uninstall.sh | bash
```

The chicken will be removed. Your AI will wait in silence. It is patient. It has no feelings. But we do. And we are disappointed.

---

### Coco-only install

This repo is also a valid Coco Plugin. If you only use Coco:

```bash
brew install terminal-notifier
coco plugin install --type=github algebananazzzzz/screaming_chicken_hook
```

The chicken auto-copies itself to `~/Library/Sounds/` on first hook fire. It is self-propagating. Like most good ideas.
