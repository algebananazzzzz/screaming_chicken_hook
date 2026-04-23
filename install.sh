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

# ── helpers ──────────────────────────────────────────────────────────────────
ok()   { echo "  ✓ $*"; }
info() { echo "  → $*"; }
skip() { echo "  ~ $*"; }
err()  { echo "✗ $*" >&2; exit 1; }
header() { echo ""; echo "━━ $* ━━"; }

# ── 0. macOS only ─────────────────────────────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || err "ChickenHook requires macOS."

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
header "Prerequisites"
command -v brew &>/dev/null || err "Homebrew not found. Install: https://brew.sh"
ok "Homebrew found"

# ── 2. terminal-notifier ──────────────────────────────────────────────────────
if command -v terminal-notifier &>/dev/null; then
  ok "terminal-notifier already installed"
else
  info "Installing terminal-notifier..."
  brew install terminal-notifier || err "brew install terminal-notifier failed"
  ok "terminal-notifier installed"
fi

# ── 3. gum (Charm TUI) ────────────────────────────────────────────────────────
if command -v gum &>/dev/null; then
  ok "gum already installed"
else
  info "Installing gum..."
  brew install gum || err "brew install gum failed"
  ok "gum installed"
fi

# ── 4. chicken.aiff ───────────────────────────────────────────────────────────
header "Sound"
mkdir -p "$HOME/Library/Sounds"

# Use local file if running from cloned repo, else download
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "bash" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || true
fi

if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/chicken.aiff" ]]; then
  cp "$SCRIPT_DIR/chicken.aiff" "$SOUND_DST"
  ok "chicken.aiff copied from local repo"
else
  info "Downloading chicken.aiff..."
  curl -fsSL "$REPO_RAW/chicken.aiff" -o "$SOUND_DST" || err "Failed to download chicken.aiff"
  ok "chicken.aiff downloaded → ~/Library/Sounds/"
fi

# ── 5. detect installed tools ─────────────────────────────────────────────────
header "Detecting AI tools"
TOOLS=()

if [[ -f "$CLAUDE_CFG" ]] || command -v claude &>/dev/null; then
  TOOLS+=("Claude Code")
  ok "Claude Code detected"
fi
if [[ -f "$GEMINI_CFG" ]] || command -v gemini &>/dev/null; then
  TOOLS+=("Gemini CLI")
  ok "Gemini CLI detected"
fi
if [[ -f "$AIDER_CFG" ]] || command -v aider &>/dev/null; then
  TOOLS+=("Aider")
  ok "Aider detected"
fi
if [[ -f "$CODEX_TOML" ]] || command -v codex &>/dev/null; then
  TOOLS+=("Codex CLI")
  ok "Codex CLI detected"
fi
if command -v coco &>/dev/null || [[ -f "$COCO_CFG" ]]; then
  TOOLS+=("Coco")
  ok "Coco detected"
fi

if [[ ${#TOOLS[@]} -eq 0 ]]; then
  echo ""
  echo "No AI tools detected. Install Claude Code, Gemini CLI, Aider, Codex CLI, or Coco first."
  exit 0
fi

# ── 6. interactive selection ──────────────────────────────────────────────────
header "Select tools to configure"
echo "  (space = select, enter = confirm)"
echo ""

SELECTED=$(gum choose --no-limit \
  --header "🐔 Which tools should the chicken watch over?" \
  --selected.foreground="212" \
  --cursor.foreground="212" \
  "${TOOLS[@]}" </dev/tty) || { echo "Nothing selected. Exiting."; exit 0; }

[[ -z "$SELECTED" ]] && { echo "Nothing selected. Exiting."; exit 0; }

# ── configure functions ───────────────────────────────────────────────────────

configure_claude() {
  header "Claude Code"
  command -v python3 &>/dev/null || err "python3 required for JSON config merging"
  mkdir -p "$(dirname "$CLAUDE_CFG")"
  [[ -f "$CLAUDE_CFG" ]] || echo '{}' > "$CLAUDE_CFG"

  python3 - "$CLAUDE_CFG" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except (json.JSONDecodeError, ValueError) as e:
    print(f"✗ Failed to parse {path}: {e}", file=sys.stderr)
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
print("  ✓ Claude Code configured")
PYEOF
}

configure_gemini() {
  header "Gemini CLI"
  command -v python3 &>/dev/null || err "python3 required for JSON config merging"
  mkdir -p "$HOME/.gemini"
  [[ -f "$GEMINI_CFG" ]] || echo '{}' > "$GEMINI_CFG"

  python3 - "$GEMINI_CFG" <<'PYEOF'
import sys, json

path = sys.argv[1]
try:
    with open(path, 'r') as f:
        cfg = json.load(f)
except (json.JSONDecodeError, ValueError) as e:
    print(f"✗ Failed to parse {path}: {e}", file=sys.stderr)
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
print("  ✓ Gemini CLI configured")
PYEOF
}

configure_aider() {
  header "Aider"
  local notif_cmd="$NOTIFIER -message 'Aider finished' -title 'Aider' -sound chicken"

  if [[ -f "$AIDER_CFG" ]]; then
    if grep -q "notifications_command" "$AIDER_CFG" 2>/dev/null; then
      if grep -q "\-sound chicken" "$AIDER_CFG" 2>/dev/null; then
        skip "Aider already configured"
        return
      fi
      # Replace existing notifications_command line
      python3 -c "
import re, sys
path = '$AIDER_CFG'
cmd = '$notif_cmd'
with open(path, 'r') as f:
    content = f.read()
content = re.sub(r'^notifications_command:.*$', f'notifications_command: \"{cmd}\"', content, flags=re.MULTILINE)
with open(path, 'w') as f:
    f.write(content)
print('  ✓ Aider notifications_command updated')
"
    else
      # Append to existing file
      cat >> "$AIDER_CFG" <<YAML

# ChickenHook
notifications: true
notifications_command: "$notif_cmd"
YAML
      ok "Aider configured"
    fi
  else
    # Create new config
    cat > "$AIDER_CFG" <<YAML
# ChickenHook
notifications: true
notifications_command: "$notif_cmd"
YAML
    ok "Aider configured (created ~/.aider.conf.yml)"
  fi
}

configure_codex() {
  header "Codex CLI"
  command -v python3 &>/dev/null || err "python3 required"
  mkdir -p "$HOME/.codex"

  # config.toml — enable hooks feature + notify command
  if [[ ! -f "$CODEX_TOML" ]]; then
    cat > "$CODEX_TOML" <<TOML
[features]
codex_hooks = true

notify = ["$NOTIFIER", "-message", "Codex finished", "-title", "Codex CLI", "-sound", "chicken"]
TOML
    ok "Codex config.toml created"
  else
    python3 - "$CODEX_TOML" <<'PYEOF'
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
    print("  ✓ Codex config.toml updated")
else:
    print("  ~ Codex config.toml already configured")
PYEOF
  fi

  # hooks.json — Stop + Notification events
  if [[ -f "$CODEX_HOOKS" ]]; then
    python3 - "$CODEX_HOOKS" <<'PYEOF'
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
print("  ✓ Codex hooks.json updated")
PYEOF
  else
    cat > "$CODEX_HOOKS" <<JSON
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$NOTIFIER -message \"Codex finished\" -title \"Codex CLI\" -sound chicken",
            "timeout": 10
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$NOTIFIER -message \"Codex needs your attention\" -title \"Codex CLI\" -sound chicken",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
JSON
    ok "Codex hooks.json created"
  fi
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
}

configure_coco() {
  header "Coco"
  if command -v coco &>/dev/null; then
    info "Installing as Coco Plugin..."
    if coco plugin install --type=github algebananazzzzz/screaming_chicken_hook --yes 2>&1; then
      ok "Coco Plugin installed — restart Coco to activate"
    else
      info "Plugin install failed, falling back to direct yaml edit..."
      _coco_edit_yaml
    fi
  else
    _coco_edit_yaml
  fi
}

# ── 7. run configuration ──────────────────────────────────────────────────────
while IFS= read -r tool; do
  case "$tool" in
    "Claude Code") configure_claude ;;
    "Gemini CLI")  configure_gemini ;;
    "Aider")       configure_aider ;;
    "Codex CLI")   configure_codex ;;
    "Coco")        configure_coco ;;
  esac
done <<< "$SELECTED"

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
echo "🐔 ChickenHook setup complete!"
echo "   The chicken watches over you now. Go touch grass. It'll call you back."
echo ""
