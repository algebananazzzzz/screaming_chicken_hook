#!/usr/bin/env bash
# ChickenHook — uninstall
# The chicken is leaving. You will regret this.
set -euo pipefail

NOTIFIER_STR="-sound chicken"
SOUND_DST="$HOME/Library/Sounds/chicken.aiff"
CLAUDE_CFG="$HOME/.claude/settings.json"
GEMINI_CFG="$HOME/.gemini/settings.json"
AIDER_CFG="$HOME/.aider.conf.yml"
CODEX_TOML="$HOME/.codex/config.toml"
CODEX_HOOKS="$HOME/.codex/hooks.json"
COCO_CFG="$HOME/Library/Application Support/coco/coco.yaml"

# ── styled output (assumes gum installed; fallback to plain) ──────────────────
if command -v gum &>/dev/null; then
  ok()      { gum style --foreground 82  "  ✓  $*"; }
  info()    { gum style --foreground 75  "  ›  $*"; }
  skip()    { gum style --foreground 220 "  ~  $*"; }
  muted()   { gum style --foreground 242 "      $*"; }
  err()     { gum style --foreground 196 "  ✗  $*" >&2; exit 1; }
  section() {
    echo ""
    gum style --foreground 196 --bold "  ◆  $*"
    gum style --foreground 242 "     $(printf '─%.0s' {1..44})"
  }

  gum style \
    --foreground 196 --border-foreground 196 --border double \
    --align center --width 54 --margin "1 2" --padding "1 2" \
    "🐔   C H I C K E N H O O K   🐔" \
    "" \
    "Uninstall" \
    "" \
    "The chicken is leaving." \
    "You will regret this."
else
  ok()      { echo "  ✓  $*"; }
  info()    { echo "  ›  $*"; }
  skip()    { echo "  ~  $*"; }
  muted()   { echo "      $*"; }
  err()     { echo "  ✗  $*" >&2; exit 1; }
  section() { echo ""; echo "──  $*  ──"; }
  echo "🐔 ChickenHook — Uninstall"
  echo "The chicken is leaving. You will regret this."
fi

# ── sound file ────────────────────────────────────────────────────────────────
section "Sound"
if [[ -f "$SOUND_DST" ]]; then
  rm "$SOUND_DST"
  ok "chicken.aiff removed from ~/Library/Sounds/"
else
  skip "chicken.aiff not found, already gone"
fi

# ── Claude Code ───────────────────────────────────────────────────────────────
section "Claude Code"
if [[ -f "$CLAUDE_CFG" ]] && grep -q "$NOTIFIER_STR" "$CLAUDE_CFG" 2>/dev/null; then
  python3 - "$CLAUDE_CFG" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except Exception:
    sys.exit(0)

hooks = cfg.get("hooks", {})

for event in list(hooks.keys()):
    hooks[event] = [
        entry for entry in hooks[event]
        if not any("-sound chicken" in h.get("command", "")
                   for h in entry.get("hooks", []))
    ]
    if not hooks[event]:
        del hooks[event]

if not hooks:
    cfg.pop("hooks", None)

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF
  ok "Claude Code hooks removed"
else
  skip "Claude Code — not configured"
fi

# ── Gemini CLI ────────────────────────────────────────────────────────────────
section "Gemini CLI"
if [[ -f "$GEMINI_CFG" ]] && grep -q "$NOTIFIER_STR" "$GEMINI_CFG" 2>/dev/null; then
  python3 - "$GEMINI_CFG" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except Exception:
    sys.exit(0)

hooks = cfg.get("hooks", {})

for event in list(hooks.keys()):
    hooks[event] = [
        entry for entry in hooks[event]
        if not any("-sound chicken" in h.get("command", "")
                   for h in entry.get("hooks", []))
    ]
    if not hooks[event]:
        del hooks[event]

if not hooks:
    cfg.pop("hooks", None)

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF
  ok "Gemini CLI hooks removed"
else
  skip "Gemini CLI — not configured"
fi

# ── Aider ─────────────────────────────────────────────────────────────────────
section "Aider"
if [[ -f "$AIDER_CFG" ]] && grep -q "$NOTIFIER_STR" "$AIDER_CFG" 2>/dev/null; then
  python3 -c "
import re
with open('$AIDER_CFG', 'r') as f:
    content = f.read()
# Remove ChickenHook block
content = re.sub(r'\n# ChickenHook\nnotifications: true\nnotifications_command:.*\n?', '', content)
# Remove standalone notifications_command with chicken
content = re.sub(r'^notifications_command:.*chicken.*\n?', '', content, flags=re.MULTILINE)
with open('$AIDER_CFG', 'w') as f:
    f.write(content)
"
  ok "Aider notifications_command removed"
else
  skip "Aider — not configured"
fi

# ── Codex CLI ─────────────────────────────────────────────────────────────────
section "Codex CLI"
if [[ -f "$CODEX_TOML" ]] && grep -q "chicken" "$CODEX_TOML" 2>/dev/null; then
  python3 -c "
import re
with open('$CODEX_TOML', 'r') as f:
    content = f.read()
content = re.sub(r'\nnotify\s*=\s*\[.*chicken.*\]\n?', '\n', content)
with open('$CODEX_TOML', 'w') as f:
    f.write(content)
"
  ok "Codex config.toml notify removed"
else
  skip "Codex config.toml — not configured"
fi

if [[ -f "$CODEX_HOOKS" ]] && grep -q "chicken" "$CODEX_HOOKS" 2>/dev/null; then
  python3 - "$CODEX_HOOKS" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except Exception:
    sys.exit(0)

hooks = cfg.get("hooks", {})

for event in list(hooks.keys()):
    hooks[event] = [
        entry for entry in hooks[event]
        if not any("-sound chicken" in h.get("command", "")
                   for h in entry.get("hooks", []))
    ]
    if not hooks[event]:
        del hooks[event]

if not hooks:
    cfg.pop("hooks", None)

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF
  ok "Codex hooks.json cleaned"
else
  skip "Codex hooks.json — not configured"
fi

# ── Coco ──────────────────────────────────────────────────────────────────────
section "Coco"
if command -v coco &>/dev/null; then
  if coco plugin list 2>/dev/null | grep -q "screaming_chicken_hook"; then
    coco plugin uninstall screaming_chicken_hook 2>/dev/null \
      && ok "Coco Plugin uninstalled" \
      || skip "Coco plugin uninstall failed — remove manually"
  else
    skip "ChickenHook Coco Plugin not installed"
  fi
fi

if [[ -f "$COCO_CFG" ]] && grep -q "$NOTIFIER_STR" "$COCO_CFG" 2>/dev/null; then
  python3 -c "
import re
with open('$COCO_CFG', 'r') as f:
    content = f.read()
# Remove ChickenHook hooks block appended to yaml
content = re.sub(r'\nhooks:\n(  - type: command\n    command:.*chicken.*\n(    matchers:\n      - event: .*\n)+)+', '', content)
with open('$COCO_CFG', 'w') as f:
    f.write(content.rstrip() + '\n')
"
  ok "Coco yaml hooks removed"
fi

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
if command -v gum &>/dev/null; then
  gum style \
    --foreground 242 --border-foreground 242 --border rounded \
    --align center --width 54 --margin "1 2" --padding "1 2" \
    "🪦   Goodbye, Chicken.   🪦" \
    "" \
    "Silence restored. Douyin awaits." \
    "Your AI will wait. It has no choice." \
    "" \
    "You'll be back."
else
  echo "🪦 Goodbye, Chicken. Silence restored."
  echo "   Your AI will wait. It has no choice."
  echo "   You'll be back."
fi
echo ""
