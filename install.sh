#!/usr/bin/env bash
set -euo pipefail

# Prompt user to confirm installation and system update
echo "[tide42] This script will install the Tide42 command line IDE and requires an updated system to proceed.
On compiled distros, this may take significant time, network usage.
System updates may interrupt your work."
read -p "[tide42] Would you like to continue? (y/N): " response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
  echo "[tide42] Installation aborted."
  exit 1
fi

echo "[+] Installing Tide42..."

# === Legacy xtide86 alias ===
cat <<EOF | sudo tee /usr/local/bin/xtide86 > /dev/null

#!/usr/bin/env bash
echo "[XTide86] XTide86 has been renamed to Tide42."
exec tide42 "\$@"
EOF
sudo chmod +x /usr/local/bin/xtide86 || {
  echo "[tide42] Error: Failed to create or chmod /usr/local/bin/xtide86"
  exit 1
}

# === Detect OS and Package Manager ===
detect_os_and_pkg() {
  OS=$(uname -s)
  case "$OS" in
    Darwin)
      PKG_MANAGER="brew"
      INSTALL_CMD="brew install"
      INSTALL_PATH="/usr/local/bin/tide42"
      [ -d "/opt/homebrew/bin" ] && INSTALL_PATH="/opt/homebrew/bin/tide42" # Apple Silicon support
      ;;
    Linux)
      if [ -f "/etc/gentoo-release" ] || ( [ -f "/etc/os-release" ] && grep -qi "ID=gentoo" /etc/os-release ); then
        PKG_MANAGER="emerge"
        INSTALL_CMD="sudo emerge --ask=n --quiet-build"
        INSTALL_PATH="/usr/local/bin/tide42"
      elif [ -f "/etc/arch-release" ]; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
        INSTALL_PATH="/usr/local/bin/tide42"
      elif [ -f "/etc/debian_version" ]; then
        PKG_MANAGER="apt"
        INSTALL_CMD="sudo apt install -y"
        INSTALL_PATH="/usr/local/bin/tide42"
      else
        PKG_MANAGER="unknown"
        INSTALL_CMD="echo 'Please install manually:'"
        INSTALL_PATH="/usr/local/bin/tide42"
      fi
      ;;
    *)
      PKG_MANAGER="unknown"
      INSTALL_CMD="echo 'Please install manually:'"
      INSTALL_PATH="/usr/local/bin/tide42"
      ;;
  esac
  echo "[tide42] Detected OS: $OS"
  echo "[tide42] Using package manager: $PKG_MANAGER"
  echo "[tide42] Install path: $INSTALL_PATH"
}
update_package_manager() {
  case "$PKG_MANAGER" in
    apt)
      echo "[tide42] Updating apt..."
      sudo apt update
      ;;
    pacman)
      echo "[tide42] Updating pacman..."
      sudo pacman -Sy
      ;;
    brew)
      echo "[tide42] Updating Homebrew..."
      brew update
      ;;
    emerge)
      echo "[tide42] Updating Portage..."
      sudo emerge --sync || {
        echo "[tide42] Warning: emerge --sync failed. Continuing with current Portage tree."
      }
      ;;
    *)
      echo "[tide42] Skipping package manager update (unsupported or unknown)."
      ;;
  esac
}

# === Run OS detection and update ===
detect_os_and_pkg

read -p "[tide42] Update package manager and install dependencies? (y/N): " dep_response
if [[ "$dep_response" =~ ^[Yy]$ ]]; then
  update_package_manager

  # === Install system packages ===
  echo "[tide42] Installing tide42 dependencies..."

# === Define packages ===
PKG_TMUX="tmux"
PKG_NCURSES="ncurses-term"
PKG_NVIM="neovim"
PKG_PY3="python3"
PKG_PIP="python3-pip"
PKG_IPY="python3-ipython"
PKG_CURL="curl"
PKG_GIT="git"
PKG_RG="ripgrep"
PKG_NODE="nodejs"
PKG_NPM="npm"
PKG_CLANGD="clangd"
case "$PKG_MANAGER" in
  pacman)
    PKG_NCURSES="ncurses"
    PKG_PIP="python-pip"
    PKG_IPY="ipython"
    PKG_NODE="nodejs"
    PKG_NPM="npm"
    PKG_CLANGD="clang"
    ;;
  brew)
    PKG_NCURSES="ncurses"
    PKG_PIP=""
    PKG_IPY="ipython"
    PKG_NODE="node"
    PKG_NPM=""
    PKG_CLANGD="llvm"
    ;;
  emerge)
    PKG_TMUX="app-misc/tmux"
    PKG_NCURSES="sys-libs/ncurses"
    PKG_NVIM="app-editors/neovim"
    PKG_PY3="dev-lang/python"
    PKG_PIP="dev-python/pip"
    PKG_IPY="dev-python/ipython"
    PKG_CURL="net-misc/curl"
    PKG_GIT="dev-vcs/git"
    PKG_RG="sys-apps/ripgrep"
    PKG_NODE="net-libs/nodejs"
    PKG_NPM=""
    PKG_CLANGD="sys-devel/clang"
    ;;
esac
if [ "$PKG_MANAGER" = "brew" ]; then
  brew tap homebrew/cask-fonts || true
  brew install --cask font-hack-nerd-font || true
elif [ "$PKG_MANAGER" = "emerge" ]; then
  echo "[tide42] Checking for guru overlay for ripgrep..."
  if ! eselect repository list | grep -q guru; then
    echo "[tide42] Adding guru overlay for ripgrep..."
    sudo eselect repository enable guru
    sudo emerge --sync guru || {
      echo "[tide42] Warning: Failed to sync guru overlay. ripgrep may not be available."
    }
  fi
  echo "[tide42] Note: Powerline fonts are not available in the main Portage repository."
  echo "[tide42] Install manually with: git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh"
  echo "[tide42] After installation, run: fc-cache -vf ~/.local/share/fonts/"
fi

# === Check which packages are already installed ===
# Map each package to the command it provides
pkg_already_installed() {
  case "$1" in
    tmux|app-misc/tmux)           command -v tmux >/dev/null 2>&1 ;;
    ncurses-term|ncurses|sys-libs/ncurses) command -v infocmp >/dev/null 2>&1 ;;
    neovim|app-editors/neovim)    command -v nvim >/dev/null 2>&1 ;;
    python3|dev-lang/python)      command -v python3 >/dev/null 2>&1 ;;
    python3-pip|python-pip|dev-python/pip) command -v pip3 >/dev/null 2>&1 || command -v pip >/dev/null 2>&1 ;;
    python3-ipython|ipython|dev-python/ipython) command -v ipython >/dev/null 2>&1 || command -v ipython3 >/dev/null 2>&1 ;;
    curl|net-misc/curl)           command -v curl >/dev/null 2>&1 ;;
    git|dev-vcs/git)              command -v git >/dev/null 2>&1 ;;
    ripgrep|sys-apps/ripgrep)     command -v rg >/dev/null 2>&1 ;;
    nodejs|node|net-libs/nodejs)  command -v node >/dev/null 2>&1 ;;
    npm)                          command -v npm >/dev/null 2>&1 ;;
    clangd|clang|llvm|sys-devel/clang) command -v clangd >/dev/null 2>&1 ;;
    *)                            return 1 ;;
  esac
}

ALL_PKGS="$PKG_TMUX $PKG_NCURSES $PKG_NVIM $PKG_PY3 $PKG_PIP $PKG_IPY $PKG_CURL $PKG_GIT $PKG_RG $PKG_NODE $PKG_NPM $PKG_CLANGD"
PKG_LIST=""
for p in $ALL_PKGS; do
  [ -z "$p" ] && continue
  if pkg_already_installed "$p"; then
    echo "[tide42] Found: $p (skipping)"
  else
    PKG_LIST="$PKG_LIST $p"
  fi
done
PKG_LIST="${PKG_LIST# }"

# === Install packages ===
if [ -z "$PKG_LIST" ]; then
  echo "[tide42] All dependencies already installed."
elif [ "$PKG_MANAGER" = "unknown" ]; then
  echo "[tide42] Unknown package manager. Please install these manually:"
  for p in $PKG_LIST; do echo "- $p"; done
  echo "For ripgrep, see: https://github.com/BurntSushi/ripgrep#installation"
  exit 1
else
  echo "[tide42] Packages to install: $PKG_LIST"
  if [ "$PKG_MANAGER" = "emerge" ]; then
    emerge -pv $PKG_LIST || {
      echo "[tide42] Error: Some packages are unavailable or have conflicts. Check USE flags or overlays."
      echo "Try running: emerge -pv $PKG_LIST"
      exit 1
    }
  fi
  echo "[tide42] Installing packages: $PKG_LIST"
  $INSTALL_CMD $PKG_LIST || {
    echo "[tide42] Error: Failed to install packages. Check your package manager."
    echo "For ripgrep, see: https://github.com/BurntSushi/ripgrep#installation"
    echo "Run 'emerge -pv $PKG_LIST' to diagnose issues."
    exit 1
  }
fi

else
  echo "[tide42] Skipping package manager update and dependency install."
fi

# === Install vim-plug for tide42 isolated setup ===
if [ ! -f ~/.local/share/tide42/site/autoload/plug.vim ]; then
  echo "Installing vim-plug for tide42's Neovim..."
  mkdir -p ~/.local/share/tide42/site/autoload
  curl -fLo ~/.local/share/tide42/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || {
    echo "[tide42] Error: Failed to install vim-plug."
    exit 1
  }
fi

# === Resolve the script's directory ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === Copy nvim config to isolated tide42 dir ===
TIDE_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tide42"
TIDE_CONF_FILE="$TIDE_CONF_DIR/tide42.vim"
echo "Checking for existing tide42 Neovim config..."
echo "[tide42] Installing Neovim config to $TIDE_CONF_DIR (isolated from default nvim)..."
if [ ! -f "$SCRIPT_DIR/tide42.vim" ]; then
  echo "Error: tide42.vim not found in $SCRIPT_DIR. Please ensure the file exists."
  exit 1
fi
mkdir -p "$TIDE_CONF_DIR"
cp -f "$SCRIPT_DIR/tide42.vim" "$TIDE_CONF_FILE" || {
  echo "[tide42] Error: Failed to copy tide42.vim to $TIDE_CONF_FILE."
  exit 1
}

# === Create persistent colorscheme file if it doesn't exist ===
COLORSCHEME_FILE="$TIDE_CONF_DIR/colorscheme.vim"
if [ ! -f "$COLORSCHEME_FILE" ]; then
  cat <<EOF > "$COLORSCHEME_FILE"
"████████╗██╗██████╗ ███████╗██╗ ██╗██████╗
"╚══██╔══╝██║██╔══██╗██╔════╝██║ ██║╚════██╗
" ██║ ██║██║ ██║█████╗ ███████║ █████╔╝
" ██║ ██║██║ ██║██╔══╝ ╚════██║██╔═══╝
" ██║ ██║██████╔╝███████╗ ██║███████╗
" ╚═╝ ╚═╝╚═════╝ ╚══════╝ ╚═╝╚══════╝
" Terminal Integrated Developer Environment
" -42-
"
"=======================================================
" Default nvim colorschemes include:
" blue darkblue default delek desert elflord evening habamax industry
" koehler lunaperche morning murphy pablo peachpuff quiet retrobox ron shine
" slate sorbet torte unokai
" vim (used to set transparency, respects default terminal emulator settings)
" wildcharm zaibatsu zellner
colorscheme retrobox " <--- replace with your preferred default
" ── GRID STYLING ───────────────────────────────────────────────────
augroup Grid
    autocmd!
    autocmd ColorScheme * highlight clear ColorColumn | highlight ColorColumn ctermbg=239 guibg=#4e4e4e
highlight ColorColumn ctermbg=239 guibg=#4e4e4e
" ── UI & COLORS ───────────────────────────────────────────────────
set cursorline
set number
set relativenumber
augroup WindowLineNumbers
    autocmd!
    autocmd TermOpen * setlocal norelativenumber
    autocmd BufWinEnter,WinEnter * if &buftype ==# 'terminal' | setlocal norelativenumber | else | setlocal relativenumber | endif
augroup END
set list
" Without space marker
set listchars=tab:>-,eol:♦,trail:.,extends:>,precedes:<,
" With space marker
"set listchars=tab:>-,eol:♦,trail:.,extends:>,precedes:<,space:‧
" Medieval Set:
"set listchars=tab:⟭➳◎,eol:⚔,trail:♞,extends:♛,precedes:♚,space:␣,
augroup CursorHighlights
  autocmd!
  autocmd ColorScheme,VimEnter * highlight clear CursorLine | highlight CursorLine cterm=underline gui=underline
augroup END
highlight Visual ctermbg=110 guibg=#87afd7
highlight MatchParen ctermbg=100 guibg=#878700
EOF
  echo "[tide42] Created persistent colorscheme file at $COLORSCHEME_FILE"
fi

# === Copy tide42.sh and termic.sh to system path ===
echo "Installing tide42 and TermiC launch scripts..."

# === Check if files exist ===
for script in "$SCRIPT_DIR/tide42.sh" "$SCRIPT_DIR/termic.sh"; do
  if [ ! -f "$script" ]; then
    echo "Error: $script not found in $SCRIPT_DIR. Please ensure the file exists."
    exit 1
  fi
done

# === Set executable permissions locally (temporary for copying) ===
echo "Setting temporary executable permissions for tide42.sh and termic.sh..."
if ! chmod +x "$SCRIPT_DIR/tide42.sh" "$SCRIPT_DIR/termic.sh"; then
  echo "Error: Failed to set executable permissions on scripts."
  exit 1
fi

# === Copy tide42.sh to /usr/local/bin ===
echo "Creating wrapper script at /usr/local/bin/tide42..."
cat <<EOF | sudo tee /usr/local/bin/tide42 > /dev/null

#!/usr/bin/env bash
SCRIPT_DIR="$SCRIPT_DIR"
bash "\$SCRIPT_DIR/tide42.sh" "\$@"
EOF
sudo chmod +x /usr/local/bin/tide42 || {
  echo "[tide42] Error: Failed to create or chmod /usr/local/bin/tide42"
  exit 1
}
echo "Wrapper script created."
echo "tide42.sh installed to /usr/local/bin/tide42."

# === Copy termic.sh to /usr/local/bin ===
echo "Copying termic.sh to /usr/local/bin/..."
if ! sudo cp -f "$SCRIPT_DIR/termic.sh" /usr/local/bin/termic; then
  echo "Error: Failed to copy termic.sh to /usr/local/bin. Check permissions or disk space."
  exit 1
fi
echo "termic.sh installed to /usr/local/bin/termic."

# === Ensure destination files are executable ===
echo "Ensuring installed scripts are executable..."
if ! sudo chmod 755 /usr/local/bin/tide42 /usr/local/bin/termic; then
  echo "Error: Failed to set executable permissions on installed scripts."
  exit 1
fi

# === Try apt install for system-wide fallback (skip for Gentoo) ===
if [ "$PKG_MANAGER" != "emerge" ] && ! command -v ipython3 &> /dev/null; then
  echo "Attempting to install ipython3 via apt..."
  sudo apt update
  sudo apt install -y python3-ipython || echo "Warning: apt install failed. You may need to install IPython manually."
fi

# === Install man page ===
MANPAGE_SOURCE="$SCRIPT_DIR/tide42.1"
MANPAGE_TARGET="/usr/share/man/man1/tide42.1.gz"
if [ -f "$MANPAGE_SOURCE" ]; then
    echo "[tide42] Compressing man page..."
    TMP_MANPAGE_GZ="$(mktemp --suffix=.gz)"
    trap 'rm -f "$TMP_MANPAGE_GZ"' EXIT
    if gzip -n -f -c "$MANPAGE_SOURCE" > "$TMP_MANPAGE_GZ"; then
        echo "[tide42] Installing man page to $MANPAGE_TARGET..."
        sudo cp "$TMP_MANPAGE_GZ" "$MANPAGE_TARGET"
        sudo mandb -q /usr/share/man
        echo "[tide42] Man page installed. Try: man tide42"
    else
        echo "[tide42] Error: Failed to compress man page."
    fi
    rm -f "$TMP_MANPAGE_GZ"
    trap - EXIT
else
    echo "[tide42] Warning: tide42.1 not found. Skipping man page install."
fi

# === Desktop launcher ===
GLOBAL_INSTALL=false
if [ "${1:-}" == "--global" ]; then
  GLOBAL_INSTALL=true
fi
if [ "$GLOBAL_INSTALL" = true ]; then
  echo "Installing system-wide .desktop launcher..."
  sudo cp ./tide42.desktop /usr/share/applications/ || {
    echo "[tide42] Error: Failed to copy tide42.desktop to /usr/share/applications."
    exit 1
  }
  sudo cp ./tide42.png /usr/share/icons/hicolor/64x64/apps/ || {
    echo "[tide42] Error: Failed to copy tide42.png to /usr/share/icons/hicolor/64x64/apps."
    exit 1
  }
  sudo update-desktop-database /usr/share/applications || true
else
  echo "Installing user-local .desktop launcher..."
  if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    echo "[tide42] GUI detected, installing launcher..."
    if [ -f "$HOME/.local/share/applications" ]; then
      rm -f "$HOME/.local/share/applications"
    fi
    mkdir -p "$HOME/.local/share/applications"
    cp ./tide42.desktop "$HOME/.local/share/applications/" || {
      echo "[tide42] Error: Failed to copy tide42.desktop to $HOME/.local/share/applications."
      exit 1
    }
    mkdir -p "$HOME/.local/share/icons/hicolor/64x64/apps/"
    cp ./tide42.png "$HOME/.local/share/icons/hicolor/64x64/apps/" || {
      echo "[tide42] Error: Failed to copy tide42.png to $HOME/.local/share/icons/hicolor/64x64/apps."
      exit 1
    }
    update-desktop-database "$HOME/.local/share/applications" || true
  else
    echo "[tide42] No GUI detected -- skipping .desktop launcher install."
  fi
fi

# === Write tide42 tmux.conf (always regenerate to apply updates) ===
TMUX_CONF="$TIDE_CONF_DIR/tmux.conf"
{
  DEFAULT_TERMINAL="xterm-256color"
  if [ -n "$TERM" ] && [ "$TERM" != "xterm" ] && [ "$TERM" != "linux" ]; then
    DEFAULT_TERMINAL="$TERM"
  else
    if command -v gnome-terminal > /dev/null; then
      DEFAULT_TERMINAL="xterm-256color"
    elif command -v konsole > /dev/null; then
      DEFAULT_TERMINAL="konsole-256color"
    elif command -v xfce4-terminal > /dev/null; then
      DEFAULT_TERMINAL="xterm-256color"
    elif command -v alacritty > /dev/null; then
      DEFAULT_TERMINAL="alacritty"
    elif command -v kitty > /dev/null; then
      DEFAULT_TERMINAL="kitty"
    fi
  fi
  mkdir -p "$TIDE_CONF_DIR"
  cat <<EOF > "$TMUX_CONF"
# tide42: Default terminal config
set -g default-terminal "$DEFAULT_TERMINAL"
set -as terminal-overrides ',*:Tc'
set -g mouse on

# Keybindings
unbind C-b
set-option -g prefix C-q
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R
set-window-option -g mode-keys vi
bind-key -n C-M-a resize-pane -R 999 \; select-pane -t 1
bind-key -n C-M-d resize-pane -L 999 \; select-pane -t 0
bind-key -n C-M-s resize-pane -x 50%
bind-key -n C-M-z resize-pane -x 25%
bind-key -n C-M-x resize-pane -x 30%
bind-key -n C-M-c resize-pane -x 60%
bind-key -n C-M-v resize-pane -x 75%

set-environment -g NVIM_APPNAME tide42
EOF
  echo "[tide42] Written tmux config at $TMUX_CONF"
}

# === Install Neovim plugins with isolated setup ===

echo "Installing Neovim plugins for tide42..."
NVIM_APPNAME=tide42 nvim -u "$TIDE_CONF_FILE" +PlugInstall +qall
echo "[tide42] Installed! Launch with 'tide42' or from the app menu."
echo "[tide42] Share feedback: github.com/logicmagix/tide42/discussions"
echo "[tide42] Bugs or ideas? DM @logicmagix on X or email logicmagix@protonmail.com"
      
