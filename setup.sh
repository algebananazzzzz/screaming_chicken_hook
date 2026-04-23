#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOUND_SRC="$SCRIPT_DIR/chicken.aiff"
SOUND_DST="$HOME/Library/Sounds/chicken.aiff"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
COCO_YAML="$HOME/Library/Application Support/coco/coco.yaml"
NOTIFIER="/opt/homebrew/bin/terminal-notifier"

# ── helpers ──────────────────────────────────────────────────────────────────
ok()   { echo "✓ $1"; }
info() { echo "  $1"; }
err()  { echo "✗ $1" >&2; exit 1; }

# ── 1. terminal-notifier ─────────────────────────────────────────────────────
if command -v terminal-notifier &>/dev/null; then
  ok "terminal-notifier already installed"
else
  info "Installing terminal-notifier via brew..."
  if ! command -v brew &>/dev/null; then
    err "Homebrew not found. Install it first: https://brew.sh"
  fi
  brew install terminal-notifier || err "brew install terminal-notifier failed"
  ok "terminal-notifier installed"
fi

# ── 2. sound file ────────────────────────────────────────────────────────────
if [[ ! -f "$SOUND_SRC" ]]; then
  err "chicken.aiff not found at $SOUND_SRC — clone the full repo"
fi
mkdir -p "$HOME/Library/Sounds"
cp "$SOUND_SRC" "$SOUND_DST"
ok "chicken.aiff installed to ~/Library/Sounds/"

# ── 3. Claude Code ───────────────────────────────────────────────────────────
if ! command -v python3 &>/dev/null; then
  err "python3 not found — required for JSON config merging"
fi

mkdir -p "$(dirname "$CLAUDE_SETTINGS")"
if [[ ! -f "$CLAUDE_SETTINGS" ]]; then
  echo '{}' > "$CLAUDE_SETTINGS"
fi

python3 - "$CLAUDE_SETTINGS" <<'PYEOF'
import sys, json, copy

path = sys.argv[1]
with open(path, 'r') as f:
    cfg = json.load(f)

notification_hook = {
    "type": "command",
    "command": "/opt/homebrew/bin/terminal-notifier -message \"Claude needs your attention\" -title \"Claude Code\" -sound chicken",
    "timeout": 10
}
stop_hook = {
    "type": "command",
    "command": "/opt/homebrew/bin/terminal-notifier -message \"Claude finished\" -title \"Claude Code\" -sound chicken",
    "timeout": 10
}

hooks = cfg.setdefault("hooks", {})

def has_chicken(hook_list):
    return any("-sound chicken" in h.get("command", "") for entry in hook_list for h in entry.get("hooks", []))

# Notification
notif_list = hooks.setdefault("Notification", [])
if not has_chicken(notif_list):
    notif_list.append({"hooks": [notification_hook]})

# Stop
stop_list = hooks.setdefault("Stop", [])
if not has_chicken(stop_list):
    stop_list.append({"hooks": [stop_hook]})

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF

ok "Claude Code configured"

# ── 4. Coco ──────────────────────────────────────────────────────────────────
if [[ ! -f "$COCO_YAML" ]]; then
  info "coco not found, skipping"
else
  if grep -q "\-sound chicken" "$COCO_YAML" 2>/dev/null; then
    ok "coco already configured, skipping"
  else
    cat >> "$COCO_YAML" <<'YAML'

hooks:
  - type: command
    command: '/opt/homebrew/bin/terminal-notifier -message "Coco needs your attention" -title "Coco" -sound chicken'
    matchers:
      - event: notification
  - type: command
    command: '/opt/homebrew/bin/terminal-notifier -message "Coco finished" -title "Coco" -sound chicken'
    matchers:
      - event: stop
      - event: subagent_stop
YAML
    ok "coco configured"
  fi
fi

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
echo "🐔 ChickenHook setup complete! The chicken watches over you now."
