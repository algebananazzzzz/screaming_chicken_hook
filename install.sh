#!/usr/bin/env bash
# ChickenHook — screaming chicken notifications for AI coding tools
# Usage: curl -fsSL https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main/install.sh | bash
#    or: git clone ... && ./install.sh
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/algebananazzzzz/screaming_chicken_hook/main"
SOUND_DST="$HOME/Library/Sounds/chicken.aiff"
NOTIFIER="/opt/homebrew/bin/terminal-notifier"

CLAUDE_CFG="$HOME/.claude/settings.json"
GEMINI_CFG="$HOME/.gemini/settings.json"
AIDER_CFG="$HOME/.aider.conf.yml"
CODEX_TOML="$HOME/.codex/config.toml"
CODEX_HOOKS="$HOME/.codex/hooks.json"
COCO_CFG="$HOME/Library/Application Support/coco/coco.yaml"

# ━━ Phase 1: bootstrap (plain — gum not yet available) ━━━━━━━━━━━━━━━━━━━━━━━

[[ "$(uname)" == "Darwin" ]] || { echo "✗ ChickenHook requires macOS."; exit 1; }
command -v brew &>/dev/null    || { echo "✗ Homebrew required. Install: https://brew.sh"; exit 1; }

if ! command -v gum &>/dev/null; then
  echo "  → Installing gum (Charm TUI)..."
  brew install gum >/dev/null 2>&1 || { echo "✗ brew install gum failed"; exit 1; }
  echo "  ✓ gum installed"
fi

# ━━ Phase 2: styled output ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── colours ──────────────────────────────────────────────────────────────────
C_ORANGE=214   # primary / accent
C_GREEN=82     # success
C_BLUE=75      # info
C_YELLOW=220   # skip / warn
C_RED=196      # error
C_GRAY=242     # muted

ok()      { gum style --foreground $C_GREEN  "  ✓  $*"; }
info()    { gum style --foreground $C_BLUE   "  ›  $*"; }
skip()    { gum style --foreground $C_YELLOW "  ~  $*"; }
muted()   { gum style --foreground $C_GRAY   "      $*"; }
err()     { gum style --foreground $C_RED    "  ✗  $*" >&2; exit 1; }
section() {
  echo ""
  gum style \
    --foreground $C_ORANGE --bold \
    "  ◆  $*"
  gum style --foreground $C_GRAY "     $(printf '─%.0s' {1..44})"
}

# ── banner ───────────────────────────────────────────────────────────────────
gum style \
  --foreground $C_ORANGE --border-foreground $C_ORANGE --border double \
  --align center --width 54 --margin "1 2" --padding "1 2" \
  "🐔   C H I C K E N H O O K   🐔" \
  "" \
  "Screaming chicken notifications" \
  "for your AI coding tools."

# ━━ Prerequisites ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Prerequisites"

# terminal-notifier
if command -v terminal-notifier &>/dev/null; then
  ok "terminal-notifier already installed"
else
  gum spin --spinner dot \
    --title "$(gum style --foreground $C_BLUE "  Installing terminal-notifier...")" \
    --show-error \
    -- brew install terminal-notifier \
    || err "brew install terminal-notifier failed"
  ok "terminal-notifier installed"
fi

ok "gum ready"

# ━━ Sound ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Sound"
mkdir -p "$HOME/Library/Sounds"

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "bash" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || true
fi

if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/chicken.aiff" ]]; then
  cp "$SCRIPT_DIR/chicken.aiff" "$SOUND_DST"
  ok "chicken.aiff → ~/Library/Sounds/ (local)"
else
  gum spin --spinner dot \
    --title "$(gum style --foreground $C_BLUE "  Downloading chicken.aiff...")" \
    --show-error \
    -- curl -fsSL "$REPO_RAW/chicken.aiff" -o "$SOUND_DST" \
    || err "Failed to download chicken.aiff"
  ok "chicken.aiff → ~/Library/Sounds/"
fi

# ━━ Detect AI tools ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
section "Detecting AI tools"
TOOLS=()

_detect() {
  local name="$1" cfg="$2" cmd="$3"
  if [[ -f "$cfg" ]] || command -v "$cmd" &>/dev/null 2>&1; then
    TOOLS+=("$name")
    ok "$name"
  else
    muted "$name — not found"
  fi
}

_detect "Claude Code" "$CLAUDE_CFG"  "claude"
_detect "Gemini CLI"  "$GEMINI_CFG"  "gemini"
_detect "Aider"       "$AIDER_CFG"   "aider"
_detect "Codex CLI"   "$CODEX_TOML"  "codex"

# Coco: check command OR config
if command -v coco &>/dev/null || [[ -f "$COCO_CFG" ]]; then
  TOOLS+=("Coco")
  ok "Coco"
else
  muted "Coco — not found"
fi

if [[ ${#TOOLS[@]} -eq 0 ]]; then
  echo ""
  gum style \
    --foreground $C_YELLOW --border-foreground $C_YELLOW --border rounded \
    --align center --width 54 --margin "1 2" --padding "1 2" \
    "No AI tools detected." \
    "" \
    "Install Claude Code, Gemini CLI, Aider," \
    "Codex CLI, or Coco first."
  exit 0
fi

# ━━ Select tools ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
SELECTED=$(gum choose --no-limit \
  --header "$(gum style --foreground $C_ORANGE --bold "  🐔  Which tools should the chicken watch over?")" \
  --cursor-prefix "  • " \
  --selected-prefix "  ✓ " \
  --unselected-prefix "  • " \
  --selected.foreground="$C_ORANGE" \
  --cursor.foreground="$C_ORANGE" \
  --selected="*" \
  "${TOOLS[@]}" </dev/tty) || true

if [[ -z "$SELECTED" ]]; then
  gum style --foreground $C_YELLOW "  Nothing selected. Exiting."
  exit 0
fi

# ━━ Configure functions ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

configure_claude() {
  section "Claude Code"
  command -v python3 &>/dev/null || err "python3 required for JSON merging"
  mkdir -p "$(dirname "$CLAUDE_CFG")"
  [[ -f "$CLAUDE_CFG" ]] || echo '{}' > "$CLAUDE_CFG"

  gum spin --spinner dot \
    --title "$(gum style --foreground $C_BLUE "  Configuring ~/.claude/settings.json...")" \
    -- python3 - "$CLAUDE_CFG" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except (json.JSONDecodeError, ValueError) as e:
    print(f"Failed to parse {path}: {e}", file=sys.stderr)
    sys.exit(1)

notifier = "/opt/homebrew/bin/terminal-notifier"

notification_hook = {
    "type": "command",
    "command": f'{notifier} -message "Claude needs your attention" -title "Claude Code" -sound chicken',
    "timeout": 10
}
stop_hook = {
    "type": "command",
    "command": f'{notifier} -message "Claude finished" -title "Claude Code" -sound chicken',
    "timeout": 10
}

def has_chicken(entries):
    return any("-sound chicken" in h.get("command", "")
               for e in entries for h in e.get("hooks", []))

hooks = cfg.setdefault("hooks", {})

notif = hooks.setdefault("Notification", [])
if not has_chicken(notif):
    notif.append({"hooks": [notification_hook]})

stop = hooks.setdefault("Stop", [])
if not has_chicken(stop):
    stop.append({"hooks": [stop_hook]})

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF

  ok "Claude Code configured"
  muted "~/.claude/settings.json → Notification + Stop hooks"
}

configure_gemini() {
  section "Gemini CLI"
  command -v python3 &>/dev/null || err "python3 required for JSON merging"
  mkdir -p "$HOME/.gemini"
  [[ -f "$GEMINI_CFG" ]] || echo '{}' > "$GEMINI_CFG"

  gum spin --spinner dot \
    --title "$(gum style --foreground $C_BLUE "  Configuring ~/.gemini/settings.json...")" \
    -- python3 - "$GEMINI_CFG" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except (json.JSONDecodeError, ValueError) as e:
    print(f"Failed to parse {path}: {e}", file=sys.stderr)
    sys.exit(1)

notifier = "/opt/homebrew/bin/terminal-notifier"

notification_hook = {
    "type": "command",
    "command": f'{notifier} -message "Gemini needs your attention" -title "Gemini CLI" -sound chicken',
    "timeout": 10
}
after_agent_hook = {
    "type": "command",
    "command": f'{notifier} -message "Gemini finished" -title "Gemini CLI" -sound chicken',
    "timeout": 10
}

def has_chicken(entries):
    return any("-sound chicken" in h.get("command", "")
               for e in entries for h in e.get("hooks", []))

hooks = cfg.setdefault("hooks", {})

notif = hooks.setdefault("Notification", [])
if not has_chicken(notif):
    notif.append({"hooks": [notification_hook]})

after = hooks.setdefault("AfterAgent", [])
if not has_chicken(after):
    after.append({"hooks": [after_agent_hook]})

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF

  ok "Gemini CLI configured"
  muted "~/.gemini/settings.json → Notification + AfterAgent hooks"
}

configure_aider() {
  section "Aider"
  local notif_cmd="$NOTIFIER -message 'Aider finished' -title 'Aider' -sound chicken"

  if [[ -f "$AIDER_CFG" ]]; then
    if grep -q "\-sound chicken" "$AIDER_CFG" 2>/dev/null; then
      skip "Aider already configured"
      return
    fi
    if grep -q "notifications_command" "$AIDER_CFG" 2>/dev/null; then
      python3 -c "
import re
path = '$AIDER_CFG'
cmd  = '$notif_cmd'
with open(path, 'r') as f:
    content = f.read()
content = re.sub(r'^notifications_command:.*$', f'notifications_command: \"{cmd}\"', content, flags=re.MULTILINE)
with open(path, 'w') as f:
    f.write(content)
"
      ok "Aider notifications_command updated"
    else
      cat >> "$AIDER_CFG" <<YAML

# ChickenHook
notifications: true
notifications_command: "$notif_cmd"
YAML
      ok "Aider configured"
    fi
  else
    cat > "$AIDER_CFG" <<YAML
# ChickenHook
notifications: true
notifications_command: "$notif_cmd"
YAML
    ok "Aider configured"
  fi
  muted "~/.aider.conf.yml → notifications_command"
}

configure_codex() {
  section "Codex CLI"
  command -v python3 &>/dev/null || err "python3 required"
  mkdir -p "$HOME/.codex"

  if [[ ! -f "$CODEX_TOML" ]]; then
    cat > "$CODEX_TOML" <<TOML
[features]
codex_hooks = true

notify = ["$NOTIFIER", "-message", "Codex finished", "-title", "Codex CLI", "-sound", "chicken"]
TOML
    ok "Codex config.toml created"
  else
    gum spin --spinner dot \
      --title "$(gum style --foreground $C_BLUE "  Configuring ~/.codex/config.toml...")" \
      -- python3 - "$CODEX_TOML" <<'PYEOF'
import sys, re

path = sys.argv[1]
with open(path, 'r') as f:
    content = f.read()

changed = False

if 'codex_hooks' not in content:
    if '[features]' in content:
        content = content.replace('[features]', '[features]\ncodex_hooks = true', 1)
    else:
        content += '\n[features]\ncodex_hooks = true\n'
    changed = True

if 'notify' not in content:
    notifier = "/opt/homebrew/bin/terminal-notifier"
    content += f'\nnotify = ["{notifier}", "-message", "Codex finished", "-title", "Codex CLI", "-sound", "chicken"]\n'
    changed = True

if changed:
    with open(path, 'w') as f:
        f.write(content)
PYEOF
    ok "Codex config.toml updated"
  fi

  if [[ -f "$CODEX_HOOKS" ]]; then
    gum spin --spinner dot \
      --title "$(gum style --foreground $C_BLUE "  Configuring ~/.codex/hooks.json...")" \
      -- python3 - "$CODEX_HOOKS" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except (json.JSONDecodeError, ValueError):
    cfg = {}

notifier = "/opt/homebrew/bin/terminal-notifier"

stop_hook = {
    "type": "command",
    "command": f'{notifier} -message "Codex finished" -title "Codex CLI" -sound chicken',
    "timeout": 10
}
notif_hook = {
    "type": "command",
    "command": f'{notifier} -message "Codex needs your attention" -title "Codex CLI" -sound chicken',
    "timeout": 10
}

def has_chicken(entries):
    return any("-sound chicken" in h.get("command", "")
               for e in entries for h in e.get("hooks", []))

hooks = cfg.setdefault("hooks", {})

stop = hooks.setdefault("Stop", [])
if not has_chicken(stop):
    stop.append({"hooks": [stop_hook]})

notif = hooks.setdefault("Notification", [])
if not has_chicken(notif):
    notif.append({"hooks": [notif_hook]})

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
PYEOF
    ok "Codex hooks.json updated"
  else
    cat > "$CODEX_HOOKS" <<JSON
{
  "hooks": {
    "Stop": [{"hooks": [{"type": "command", "command": "$NOTIFIER -message \"Codex finished\" -title \"Codex CLI\" -sound chicken", "timeout": 10}]}],
    "Notification": [{"hooks": [{"type": "command", "command": "$NOTIFIER -message \"Codex needs your attention\" -title \"Codex CLI\" -sound chicken", "timeout": 10}]}]
  }
}
JSON
    ok "Codex hooks.json created"
  fi
  muted "~/.codex/config.toml + hooks.json → Stop + Notification"
}

_coco_edit_yaml() {
  if [[ ! -f "$COCO_CFG" ]]; then
    skip "coco.yaml not found, skipping direct config"
    return
  fi
  if grep -q "\-sound chicken" "$COCO_CFG" 2>/dev/null; then
    skip "Coco already configured"
    return
  fi
  cat >> "$COCO_CFG" <<YAML

hooks:
  - type: command
    command: '$NOTIFIER -message "Coco needs your attention" -title "Coco" -sound chicken'
    matchers:
      - event: notification
  - type: command
    command: '$NOTIFIER -message "Coco finished" -title "Coco" -sound chicken'
    matchers:
      - event: stop
      - event: subagent_stop
YAML
  ok "Coco yaml configured"
  muted "~/Library/Application Support/coco/coco.yaml"
}

configure_coco() {
  section "Coco"
  if command -v coco &>/dev/null; then
    gum spin --spinner dot \
      --title "$(gum style --foreground $C_BLUE "  Installing ChickenHook as Coco Plugin...")" \
      --show-error \
      -- coco plugin install --type=github algebananazzzzz/screaming_chicken_hook --yes \
    && {
      ok "Coco Plugin installed"
      muted "Restart Coco to activate"
    } || {
      info "Plugin install failed, falling back to direct yaml edit..."
      _coco_edit_yaml
    }
  else
    _coco_edit_yaml
  fi
}

# ━━ Run ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

while IFS= read -r tool; do
  case "$tool" in
    "Claude Code") configure_claude ;;
    "Gemini CLI")  configure_gemini ;;
    "Aider")       configure_aider  ;;
    "Codex CLI")   configure_codex  ;;
    "Coco")        configure_coco   ;;
  esac
done <<< "$SELECTED"

# ━━ Done ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
gum style \
  --foreground $C_GREEN --border-foreground $C_GREEN --border rounded \
  --align center --width 54 --margin "1 2" --padding "1 2" \
  "🐔   Setup Complete!   🐔" \
  "" \
  "The chicken watches over you now." \
  "Go touch grass. It'll call you back."
echo ""
