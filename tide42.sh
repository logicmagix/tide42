#!/usr/bin/env bash
# tide42 - a terminal IDE powered by tmux and nvim
# Copyright (C) 2025 Pavle Dzakula
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program  is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Credits
# This project includes `termic.sh` from [Yusuf Kagan Hanoglu/Max Schillinger/TermiC], licensed under the [GPL3] License.

# === Initialize ===

set -e
echo "[tide42] Running..."
VERSION_PATH="$(dirname "$0")/VERSION"
TIDE_VERSION="unknown"
if [ -f "$VERSION_PATH" ]; then
  TIDE_VERSION="$(cat "$VERSION_PATH")"
fi
GIT_BRANCH=$(git -C "$(dirname "$0")" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
TIDE_VERSION="$TIDE_VERSION ($GIT_BRANCH)"
IS_LOW_COLOR=false
IS_QUIET=false
FILENAME=""
COLOR_FLAG_PROVIDED=false
UPDATE_PROCESSED=false
COLORSCHEME_PROCESSED=false
SESSION_NAME="tide42"
TIDE_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tide42"
TIDE_CONF_FILE="$TIDE_CONF_DIR/tide42.vim"
TMUX_CONF="$TIDE_CONF_DIR/tmux.conf"

# === Detect IPython binary ===
if command -v ipython >/dev/null 2>&1; then
  export TIDE42_IPYTHON_CMD="ipython"
elif command -v ipython3 >/dev/null 2>&1; then
  export TIDE42_IPYTHON_CMD="ipython3"
else
  export TIDE42_IPYTHON_CMD="ipython"
fi

# === Define pane border settings in tmux.conf ===

PANE_BORDER_CONFIG=$(cat <<EOF
# Unfocused pane border
set -g pane-border-style fg=black
set -g pane-active-border-style fg=brightred
set -g pane-border-format "#{pane_index} "
set -g pane-border-style "fg=black,bg=default,dim"
EOF
)
log() {
  $IS_QUIET || echo "[tide42] $@"
}


# === Portable sed (GNU/BSD) ===

inplace_sed() {
  # usage: inplace_sed 's/old/new/' <file>
  if sed --version >/dev/null 2>&1; then
    # GNU sed
    sed -i "$1" "$2"
  else
    # BSD sed (macOS)
    sed -i '' "$1" "$2"
  fi
}


while [ $# -gt 0 ]; do
  case "$1" in
    
    --whereami)
      SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
      SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
      log "Script path: $SCRIPT_PATH"
      log "Source directory: $SCRIPT_DIR"
      exit 0
      ;;
    
    --gui)
      shift
      # Detect default terminal emulator and re-launch tide42 inside it
      TERM_CMD=""
      if [ -n "${TERMINAL:-}" ] && command -v "$TERMINAL" >/dev/null 2>&1; then
        TERM_CMD="$TERMINAL"
      elif command -v x-terminal-emulator >/dev/null 2>&1; then
        TERM_CMD="x-terminal-emulator"
      elif command -v gnome-terminal >/dev/null 2>&1; then
        TERM_CMD="gnome-terminal"
      elif command -v konsole >/dev/null 2>&1; then
        TERM_CMD="konsole"
      elif command -v xfce4-terminal >/dev/null 2>&1; then
        TERM_CMD="xfce4-terminal"
      elif command -v foot >/dev/null 2>&1; then
        TERM_CMD="foot"
      elif command -v alacritty >/dev/null 2>&1; then
        TERM_CMD="alacritty"
      elif command -v kitty >/dev/null 2>&1; then
        TERM_CMD="kitty"
      elif command -v wezterm >/dev/null 2>&1; then
        TERM_CMD="wezterm"
      elif command -v mate-terminal >/dev/null 2>&1; then
        TERM_CMD="mate-terminal"
      elif command -v tilix >/dev/null 2>&1; then
        TERM_CMD="tilix"
      elif command -v terminator >/dev/null 2>&1; then
        TERM_CMD="terminator"
      elif command -v urxvt >/dev/null 2>&1; then
        TERM_CMD="urxvt"
      elif command -v xterm >/dev/null 2>&1; then
        TERM_CMD="xterm"
      fi
      if [ -z "$TERM_CMD" ]; then
        echo "[tide42] Error: No terminal emulator found."
        exit 1
      fi
      log "Detected terminal: $TERM_CMD"
      case "$TERM_CMD" in
        gnome-terminal)  exec gnome-terminal -- tide42 "$@" ;;
        konsole)         exec konsole -e tide42 "$@" ;;
        xfce4-terminal)  exec xfce4-terminal -e "tide42 $*" ;;
        foot)            exec foot tide42 "$@" ;;
        alacritty)       exec alacritty -e tide42 "$@" ;;
        kitty)           exec kitty tide42 "$@" ;;
        wezterm)         exec wezterm start -- tide42 "$@" ;;
        mate-terminal)   exec mate-terminal -e "tide42 $*" ;;
        tilix)           exec tilix -e "tide42 $*" ;;
        terminator)      exec terminator -e "tide42 $*" ;;
        urxvt)           exec urxvt -e tide42 "$@" ;;
        xterm)           exec xterm -e tide42 "$@" ;;
        *)               exec "$TERM_CMD" -e tide42 "$@" ;;
      esac
      ;;

    --lite)
      shift
      log "[tide42] Launching in lite mode (no tmux)..."
      exec env NVIM_APPNAME=tide42 nvim -u "$TIDE_CONF_FILE" "$@"
      ;;
    
    --quiet|-q)
      IS_QUIET=true
      ;;
    
    --low-color|-lc) # 88 Color
      IS_LOW_COLOR=true
      COLOR_FLAG_PROVIDED=true
      log "Enabling low-color (88-color) mode. Warning: Home/End keys may not work."
      mkdir -p "$(dirname "$TMUX_CONF")"
      cat <<EOF > "$TMUX_CONF"
# tide42: 88-color config
set -g default-terminal "xterm-88color"
set -sa terminal-overrides ",xterm-88color*:colors=88"
set -g mouse on
$PANE_BORDER_CONFIG

# Session persistence
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'
set-environment -g TMUX_PLUGIN_MANAGER_PATH '$TIDE_CONF_DIR/tmux/plugins/'
set -g @resurrect-dir '$TIDE_CONF_DIR/tmux/resurrect'

# Initialize TPM (must be last)
run '$TIDE_CONF_DIR/tmux/plugins/tpm/tpm'
EOF
      log "Applied 88-color config with pane border settings."
      ;;
    
    --colorscheme|-cs)
      shift
      if [ -z "$1" ]; then
        log "Error: --colorscheme requires a colorscheme name."
        log "Colorschemes inlcude: blue darkblue default delek desert elflord evening habamax industry
             koehler lunaperche morning murphy pablo peachpuff quiet retrobox ron shine slate sorbet torte unokai vim 
             wildcharm zaibatsu zellner"
        exit 1
      fi
      COLORSCHEME="$1"
      VALID_COLORSCHEMES="blue darkblue default delek desert elflord evening habamax industry koehler lunaperche morning murphy pablo peachpuff quiet retrobox ron shine slate sorbet torte unokai vim wildcharm zaibatsu zellner"
      if ! echo "$VALID_COLORSCHEMES" | grep -qw "$COLORSCHEME"; then
        log "Warning: '$COLORSCHEME' is not a recognized default Neovim colorscheme."
        log "Valid colorschemes: $VALID_COLORSCHEMES"
        log "Proceeding anyway, but ensure '$COLORSCHEME' is installed."
      fi
      COLORSCHEME_FILE="$TIDE_CONF_DIR/colorscheme.vim"
      mkdir -p "$TIDE_CONF_DIR"
      if [ -f "$COLORSCHEME_FILE" ]; then
        cp "$COLORSCHEME_FILE" "$COLORSCHEME_FILE.bak"
        if grep -q "^colorscheme " "$COLORSCHEME_FILE"; then
	  inplace_sed "s/^colorscheme .*/colorscheme $COLORSCHEME \" <--- replace with your preferred default/" "$COLORSCHEME_FILE"	
        else
          echo "colorscheme $COLORSCHEME \" <--- replace with your preferred default" >> "$COLORSCHEME_FILE"
        fi
      else
        cat <<EOF > "$COLORSCHEME_FILE"
" Default nvim colorschemes include:
" blue darkblue default delek desert elflord evening habamax industry
" koehler lunaperche morning murphy pablo peachpuff quiet retrobox ron shine
" slate sorbet torte unokai
" vim (used to set transparency, respects default terminal emulator settings)
" wildcharm zaibatsu zellner
colorscheme $COLORSCHEME " <--- replace with your preferred default
EOF
      fi
      log "Updated colorscheme to '$COLORSCHEME' in $COLORSCHEME_FILE"
      COLORSCHEME_PROCESSED=true
      shift
      ;;
    
    --check-update)
      log "Checking for available updates…"
      SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
      SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
      cd "$SCRIPT_DIR" || { log "Error: Cannot access directory $SCRIPT_DIR"; exit 1; }
      if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        log "Error: This directory is not a Git repository."
        exit 1
      fi
      CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || echo "detached")"
      if [ "$CURRENT_BRANCH" = "detached" ]; then
        log "Error: You are in a detached HEAD state. Cannot check for updates."
        exit 1
      fi
      # Prefer 'stable' if present
      CHECK_BRANCH="$CURRENT_BRANCH"
      if git ls-remote --heads origin stable >/dev/null 2>&1; then
        CHECK_BRANCH="stable"
      fi
      log "Checking branch: $CHECK_BRANCH"
      git fetch --tags --prune origin "$CHECK_BRANCH" || {
        log "Error: Failed to fetch updates from origin."
        exit 1
      }
      LOCAL_HASH="$(git rev-parse HEAD)"
      REMOTE_HASH="$(git rev-parse "origin/$CHECK_BRANCH")"
      VERSION_FILE="$SCRIPT_DIR/VERSION"
      VERSION_NUMBER="unknown"
      [ -f "$VERSION_FILE" ] && VERSION_NUMBER="$(<"$VERSION_FILE")"
      if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
        SHORT_HASH="$(git rev-parse --short HEAD)"
        log "Already up to date: v$VERSION_NUMBER ($CHECK_BRANCH@$SHORT_HASH)"
        exit 0
      else
        SHORT_LOCAL="$(git rev-parse --short HEAD)"
        SHORT_REMOTE="$(git rev-parse --short "origin/$CHECK_BRANCH")"
        REMOTE_VERSION="$(git show "origin/$CHECK_BRANCH":VERSION 2>/dev/null || echo "unknown")"
        log "Update available: $VERSION_NUMBER ($CHECK_BRANCH@$SHORT_LOCAL) → $REMOTE_VERSION ($CHECK_BRANCH@$SHORT_REMOTE)"
        exit 0
      fi
      ;;
    
    --update)
      UPDATE_PROCESSED=true
      log "Checking for updates from GitHub..."
      SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
      SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
      cd "$SCRIPT_DIR" || { log "Error: Cannot access directory $SCRIPT_DIR"; exit 1; }
      if [ ! -d .git ]; then
        log "Error: This directory is not a Git repository."
        exit 1
      fi
      CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")
      [ "$CURRENT_BRANCH" = "detached" ] && {
        log "Error: You are in a detached HEAD state. Cannot auto-update."
        exit 1
      }
      log "Current branch: $CURRENT_BRANCH"
      git fetch origin "$CURRENT_BRANCH" --prune || {
        log "Error: Failed to fetch updates from origin."
        exit 1
      }
      LOCAL_HASH=$(git rev-parse HEAD)
      REMOTE_HASH=$(git rev-parse "origin/$CURRENT_BRANCH")
      VERSION_FILE="$SCRIPT_DIR/VERSION"
      VERSION_NUMBER="unknown"
      [ -f "$VERSION_FILE" ] && VERSION_NUMBER=$(<"$VERSION_FILE")
      if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
        SHORT_HASH=$(git rev-parse --short HEAD)
        log "Already on the latest version: v$VERSION_NUMBER ($CURRENT_BRANCH@$SHORT_HASH)"
        exit 0
      fi
      log "Updating from $LOCAL_HASH to $REMOTE_HASH (v$VERSION_NUMBER)"
      log "Discarding local changes and syncing to latest commit..."
      git reset --hard "origin/$CURRENT_BRANCH" || {
        log "Error: Failed to reset to latest version."
        exit 1
      }
      log "Update complete."
      
      # === Re-run install script if present ===
      
      INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"
      if [ -f "$INSTALL_SCRIPT" ]; then
        log "Running installer to apply updates..."
        chmod +x "$INSTALL_SCRIPT"
        if ! "$INSTALL_SCRIPT" --quiet; then
          log "Warning: Installer failed."
        else
          log "Installer ran successfully."
        fi
      else
        log "No installer found. Skipping install step."
      fi
      exit 0
      ;;
    
    --version)
      log "tide42 version $TIDE_VERSION"
      exit 0
      ;;
    
    --help|-h)
      echo "Usage: tide42 [--color | --low-color] [--colorscheme <name>] [--update] [--quiet] [--version] [filename]"
      echo ""
      echo "Options:"
      echo " --whereami Display git installation directory"
      echo " --gui Detect terminal emulator and launch tide42 inside it"
      echo " --lite Launch without tmux for quick editing or low-resource systems"
      echo " --low-color, -lc Enable 88-color mode (warning: Home/End keys may not work)"
      echo " --colorscheme <name> Set the Neovim colorscheme (e.g., desert, retrobox)"
      echo " --quiet, -q Suppress log output"
      echo " --check-update Check for available updates without installing"
      echo " --update Pull latest Git changes to clean repo and reinstall"
      echo " --version Show current version"
      echo " --help, -h Show this help message"
      echo " [filename] Open specified file in Neovim"
      exit 0
      ;;
    *)
      if [ -z "$FILENAME" ]; then
        FILENAME="$1"
      else
        log "Error: Only one filename can be provided."
        exit 1
      fi
      ;;
  esac
  shift
done

# === Exit if --update or --colorscheme was processed ===

if [ "$UPDATE_PROCESSED" = true ]; then
  log "Update process completed, exiting."
  exit 0
fi
if [ "$COLORSCHEME_PROCESSED" = true ]; then
  log "Colorscheme update completed, exiting."
  exit 0
fi

# === Apply environment variables ===

if [ "$IS_LOW_COLOR" = true ]; then
  export TERM="xterm-88color"
  unset COLORTERM
  export NVIM_NO_COLOR=1
  log "Using 88-color mode. Note: Home/End keys may not function."
else
  export TERM="xterm-256color"
  export COLORTERM=truecolor
  unset NVIM_NO_COLOR
  log "Setting default 256 colors."
fi

# === Write default tmux.conf only if no color flag provided ===

if [ "$COLOR_FLAG_PROVIDED" = false ]; then
  if [ ! -f "$TMUX_CONF" ]; then
    mkdir -p "$(dirname "$TMUX_CONF")"
    log "No tmux.conf found. Writing default tide42 config."
    cat <<EOF > "$TMUX_CONF"
# tide42: Default 256-color scheme
set -g default-terminal "tmux-256color"
set -sa terminal-overrides ",*:Tc"
set -g mouse on
$PANE_BORDER_CONFIG

# Session persistence
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'
set-environment -g TMUX_PLUGIN_MANAGER_PATH '$TIDE_CONF_DIR/tmux/plugins/'
set -g @resurrect-dir '$TIDE_CONF_DIR/tmux/resurrect'

# Initialize TPM (must be last)
run '$TIDE_CONF_DIR/tmux/plugins/tpm/tpm'
EOF
  fi
fi

# === Check for existing session ===

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  if tmux list-clients -t "$SESSION_NAME" >/dev/null 2>&1; then
    tmux detach-client -s "$SESSION_NAME" 2>/dev/null || true
    log "Detached existing clients to apply new color profile."
  else
    log "Detached session '$SESSION_NAME' found."
  fi
  if [ -n "$FILENAME" ]; then
    if tmux list-panes -t "$SESSION_NAME":0.0 >/dev/null 2>&1; then
      tmux select-pane -t "$SESSION_NAME":0.0
      tmux send-keys -t "$SESSION_NAME":0.0 C-c ":qall!" C-m "NVIM_APPNAME=tide42 nvim -u \"$TIDE_CONF_FILE\" \"$FILENAME\"" C-m
      log "Opened $FILENAME in left pane of existing session."
    else
      log "Warning: Left pane not available. Attaching without opening $FILENAME."
    fi
  fi
  if tmux attach-session -t "$SESSION_NAME"; then
    exit 0
  else
    log "Error: Failed to attach to session '$SESSION_NAME'. Try 'tmux kill-session -t $SESSION_NAME'."
    exit 1
  fi
fi
# === Start new tmux session ===

tmux -f "$TMUX_CONF" new-session -d -s "$SESSION_NAME"
tmux source-file "$TMUX_CONF"

# Bootstrap TPM plugins (runs in background to avoid blocking startup)
if [ -x "$TIDE_CONF_DIR/tmux/plugins/tpm/bin/install_plugins" ]; then
  "$TIDE_CONF_DIR/tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 &
fi

tmux split-window -h

# === Set keybindings ===

tmux unbind C-b
tmux set-option -g prefix C-q
tmux bind-key h select-pane -L
tmux bind-key j select-pane -D
tmux bind-key k select-pane -U
tmux bind-key l select-pane -R
tmux set-window-option -g mode-keys vi
tmux bind-key -n C-M-a resize-pane -R 999 \; select-pane -t 1
tmux bind-key -n C-M-d resize-pane -L 999 \; select-pane -t 0
tmux bind-key -n C-M-s resize-pane -x 50%
tmux bind-key -n C-M-z resize-pane -x 25%
tmux bind-key -n C-M-x resize-pane -x 30%
tmux bind-key -n C-M-c resize-pane -x 60%
tmux bind-key -n C-M-v resize-pane -x 75%

# === Startup UI ===

tmux resize-pane -t "$SESSION_NAME":0.0 -R 46
tmux select-pane -t "$SESSION_NAME":0.0

# === Open file in pane 0 ===

if [ -n "$FILENAME" ]; then
  tmux send-keys -t "$SESSION_NAME":0.0 "NVIM_APPNAME=tide42 nvim -u \"$TIDE_CONF_FILE\" \"$FILENAME\"" C-m
else
  tmux send-keys -t "$SESSION_NAME":0.0 "NVIM_APPNAME=tide42 nvim -u \"$TIDE_CONF_FILE\"" C-m
fi

# === Preload right pane 1 with nvim if desired ===

tmux send-keys -t "$SESSION_NAME":0.1 "NVIM_APPNAME=tide42 nvim -u \"$TIDE_CONF_FILE\"" C-m

# === Attach to the session ===

tmux attach-session -t "$SESSION_NAME"
