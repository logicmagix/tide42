
<pre><code>

                          ████████╗██╗██████╗ ███████╗██╗  ██╗██████╗ 
                          ╚══██╔══╝██║██╔══██╗██╔════╝██║  ██║╚════██╗
                             ██║   ██║██║  ██║█████╗  ███████║ █████╔╝
                             ██║   ██║██║  ██║██╔══╝  ╚════██║██╔═══╝ 
                             ██║   ██║██████╔╝███████╗     ██║███████╗
                             ╚═╝   ╚═╝╚═════╝ ╚══════╝     ╚═╝╚══════╝
                            Terminal Integrated Developer Environment 
                                             -42-                     

</code></pre>
## License

tide42 is licensed under the GNU General Public License v3.0 or later.  
See the [LICENSE](./LICENSE) file for full details.

## TermiC Support

tide42 includes `termic.sh`, a lightweight, interactive C/C++ environment launcher. It will be installed automatically to `/usr/local/bin/termic` unless it already exists.

This script is licensed under GPLv3 and included with permission.

## Terminal IDE 42:
An ultra-efficient Neovim based IDE for Python and C/C++ prototyping.
*Formerly known as Xtide86*

## Latest Version 
1.2.2

### Why the name?

Tide42 is inspired in part by *The Hitchhiker’s Guide to the Galaxy*, where "42" is famously revealed as the Answer to the Ultimate Question of Life, the Universe, and Everything. 

This project reflects that same spirit: a terminal IDE that encourages curiosity, simplicity, and discovery--*you ask the questions*. Tide42 is meant to be your solution, leaving the questions in your hands.

## Latest News

# 02.25.26
- Session persistence via TPM + tmux-resurrect + tmux-continuum. Sessions auto-save every 5 minutes and auto-restore on next launch. :Q clears saved sessions for a fresh start.
- --gui flag: Desktop launcher now auto-detects the default terminal emulator instead of relying on Terminal=true
- install.sh skips already-installed packages instead of reinstalling them (avoids unnecessary recompilation on Gentoo)
- IPython binary auto-detection: tide42 detects whether ipython or ipython3 is available and uses the correct one
- --check-update added to --help menu
- Man page fixes: added missing keybindings (\j, \c, \v), removed duplicate \n entry, fixed empty OPTIONS section
- Quieter man page install
- tmux.conf is now regenerated on every install and launch to ensure config updates take effect
- Heavy pane border lines for better visibility between tmux panes
- install.sh now prompts before updating package manager and installing dependencies
- --border-color (-bc) flag to set the active tmux pane border color
- --colorscheme (-cs) now sets the colorscheme and launches tide42 instead of exiting



<pre><code>
Ctrl+Alt     |\
================
qw           | qwertyuiop
asdfg        | sfghjl
zx           | zxcvbnm
</code></pre>


## Flags
- Set colorscheme: --colorscheme, -cs
- Low Color: --low-color, -lc
- Check version: --version
- Silence log: --quiet
- Help: --help
- Install location: --whereami
- Lite mode: --lite
- Check for updates: --check-update
- Update: --update

## Controls

## Keyboard hotkey layout quick reference:

## Quit or Detach
Tmux based command: `Ctrl-q` + `d` (or gui exit button) = Exit and save tmux state (lost on restart of PC) 
Nvim based command `:Q` = Force-quit the program (reset for new session)
## Force close tab
`:BD` = Force close tab (unsaved work will be lost)
## Close plugin window
`Esc Esc` = Close opened plugin window
## Cycle nvim buffers within selected tmux buffer
`Ctrl+ww` = Cycle between vim buffers within a tmux buffer
## Manually select vim buffer within selected tmux buffer
`Ctrl+w` + <-, ^, ->, v = Selects vim buffer within current tmux buffer
## Display NERDTree
`\j` = Display NERDTree in any buffer.
## Restart IPython
`\n` = Restart IPython buffer if process exits.
## Fuzzy Finder
`\w` = fzf selects vim buffer from menu within current tmux buffer (fuzzy finder, vim plugin)
## Telescope
`\e` = Locate file within current directory
## Ripgrep
`\r` = ripgrep within file
## New tab
`\t` = Open new tab with No Name file
## Toggle Colorscheme
`\y` = toggle between default and alternate colorscheme
## Quick vertical resize within horizontal nvim buffer
`\i` = vertical resize <NUMBER>
## Quick horizontal resize
`\u` = resize <NUMBER>
## AI
`\o` = optional OpenAI ChatGPT implementation with API key (stored in a global variable)
## Send to IPython
`\p` = Paste selected text into IPython buffer and expand buffer, entering insert mode
## Send to TermiC
`\l` = Paste selected text into TermiC buffer and expand buffer, entering insert mode
## Append to Editor
`\m` = Paste selected text into nvim file editor buffer from any buffer: terminal, ipython, or termic
## Restart Tide42 UI
`\q` = Close all active buffers within tmux panel and restart Tide42 UI

## Tmux buffer controls (work in insert or command mode)
##
`Ctrl+Alt+a` = Maximize left tmux buffer
##
`Ctrl+Alt+s` = Split tmux buffers
##
`Ctrl+Alt+d` = Maximize right tmux buffer
##
`Ctrl+Alt+z` = Push active buffer 25%
##
`Ctrl+Alt+x` = Push active buffer 30%
##
`Ctrl+Alt+c` = Push active buffer 60%
##
`Ctrl+Alt+v` = Push active buffer 75%
##
`Ctrl+q`  + <-, -> = Switch between tmux buffers (selected buffer matches tmux bar color on the bottom)

## Gitsigns (Git hunk navigation & actions)
`[c]` = Jump to previous Git hunk  
`]c` = Jump to next Git hunk  
`\hs` = Stage current hunk  
`\hu` = Undo staging of current hunk  
`\hr` = Reset current hunk  
`\hb` = Blame current line

## Bufferline
`<TAB>` = Cycle to next buffer  
`<S-TAB>` = Cycle to previous buffer

## Grid
##
`\f` = Grid (10x10)
##
`\g` = Grid (5x10)

## NeoVim buffer presets
##
`\z` = Focus file editor with NERDTree hidden
##
`\b` = Focus file editor and show NERDTree
##
`\s` = Maximize and enter TermiC buffer (left)
##
`\x` = Maximize and enter Terminal buffer(right)
##
`\c` = Maximize IPython buffer (upper)
##
`\v` = Currently selected buffer

##


## Additional NeoVim commands for ease of buffer management
##
`jk` = Command mode from nvim buffer
##
`:Hs` = Quick command for horizontal split

## Tips
##
- To save all tabs at once use :wall or :wa
- To cycle terminal buffers within the current selected buffer use \w otherwise cycle file editor tabs with Tab and Shift + Tab.
- Tide42 will detect and run the Friendly Interactive Shell but this causes significant loss in performance due to errors in the terminal buffer when resized. Bash or zsh are recommended.
- Edit your highlight and grid colors in $HOME/tide42/colorscheme.vim
- If you would like to map tide42 to a keyboard shortcut the best method is to use this command and substitute your terminal name: <gnome-terminal> -- bash -c "/usr/local/bin/tide42; exec bash"
- \h to select all when in nvim command mode followed by  \p or \l for efficient transfer of text into IPython or TermiC
- Once in insert mode in any ``nvim`` buffer, the recommended way of entering command mode is `jk`
- NERDTree may be refreshed with Shift+r after performing operations in the terminal buffer.
- All NeoVim commands can also be used in any other buffer eg. /Documents to find and jump to ~/Documents directory.
- Quickly enter focused and expanded file editor mode with Ctrl + Alt + A/D (make sure you are in the correct tmux buffer), \i + <Enter>
- Fine tune tmux buffer size with hold Ctrl + q + arrow keys.
- Open/close NERDTree with \z and \i + <Enter>
- Switch between tty sessions and retain tide42 session through tmux. Handy if connecting through SSH.
- If you're running tide42 inside a tmux or custom terminal session, you might run into issues when trying to save root-owned files from within Neovim:
Using commands like :w !sudo tee % in NeoVim may silently fail to prompt for a password and kick you out after 3 attempts.
Solutions:
Use a GUI editor instead within a tide42 terminal buffer to avoid leaving your session:
ex. sudoedit /etc/systemd/system/...
Launch a root nvim in a nested terminal within tide42:


## tide42 Remote SSH Session
##
Work remotely. Drop connection. Pick up exactly where you left off.
Instructions:
- ssh user@remotehost
- run tide42 and use any buffer for file transfers or processing.
- Do your work. Close the laptop. Disconnect. Go outside.
- ssh user@remotehost
- run tide42 to reconnect to tmux protected tide42 session.

## Features

- Full ``tmux`` and ``nvim`` '-powered terminal IDE with dynamic buffer management
- Seamless integration with ``IPython``
- ``TermiC`` support with quick pasting and testing C/C++ (smaller blocks recommended or lambda specific functions) see ``Termic`` 
  documentation at https://github.com/hanoglu/TermiC)
- Hotkey support for sending code directly into live interpreter sessions
- Single-interface fallback for simple edits
- Quick launch from Gnome via icon or keyboard shortcut
- Works in the tty as well as the terminal emulator

## Requirements

- ``tmux``
- ``neovim`` 0.9.0+ (tested on 0.9.5 and 0.12)
- ``vim-plug`` curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
- ``TermiC`` wget "https://raw.githubusercontent.com/hanoglu/TermiC/main/TermiC.sh"  (live C/C++ shell)
- ``Anaconda3`` with ``IPython`` (preferred, but may work with base ``IPython``)
- ``bash`` or ``zsh``
- Works on ARM. Tested on a Raspberry Pi5. Nvim 0.9.5 and 0.12 had to be built from source. Check your distro and dependencies on ARM.
- Works on 32 bit systems. Newer versions of nvim must be built from source.

## Installation
# Make the script executable (one-time setup)
- chmod +x install.sh
- ./install
- tide42 to start session

# If downloading .zip:
- Go to https://github.com/logicmagix/tide42 and click "Code" > "Download ZIP".
- Extract the ZIP to a directory (e.g., ~/tide42/).
- Run the installation script:
- cd ~/tide42/
- ./install.sh

## Updating tide42

# To update tide42 to the latest version, you must have a cloned Git repository.

- tide42 --update

## Notes:

- The sudo command may prompt for your password to modify /usr/local/bin.
- If you used a ZIP download, you cannot use tide42 --update unless you convert the directory to a Git repository.

## Usage
- Launch tide42 from your terminal or assigned launcher with tide42 or tide42 <FILENAME>. It will:
- Open a tmux session with vertically split nvim, TermiC, and IPython
- Send text from the file editor to the live interpreter buffer with ggVG(select all) \p for ipython and \l for TermiC
- Automatic insert mode and buffer sizing for paste to Termic and paste to IPython functions.
- Support session save (Ctrl+q+d) and reset with :Q
- To uninstall, chmod +x uninstall.sh and ./uninstall.sh from repo directory

# Without tmux?
- To run Tide42 without tmux, use the flag --lite.

# Customization
- See ~/.config/tide42/tide42.vim for plugin configuration, UI tweaks, and terminal behavior.
Feel free to remix buffer sizes and colors to match your workflow.

- Use this one liner to set up your OpenAI API key: echo `'export OPENAI_API_KEY="your_api_key_here"' >> ~/.$(basename $SHELL)rc && source ~/.$(basename $SHELL)rc`

- If you are using X11 or a modern fork, you can set your transparency settings in your terminal emulator and use \y in Tide42 to toggle transparency on/off.

# TermiC Support
- tide42 includes termic.sh, a lightweight live shell.
It installs automatically to /usr/local/bin/termic.
Licensed under GPLv3 and included with permission.

Pull requests, stars, and forks welcome 

## Screenshots
- See tide42 in action:

### 	

### The Tide42 default startup interface
![Config](Screenshots/Screenshot0.png)
- Tide42 autodetects bash or zsh

### Tide42 and Nvim now have seperate configurations.
![Bash](Screenshots/Screenshot1.png)
- Customize nvim to your liking seperately from Tide42

### Integrated Ipython usage example
![Wayland/Ipython](Screenshots/Screenshot2.png)
- Tide42 intergrates nicely with Hyprland hotkeys on Wayland

### Termic C/C++ Live Shell usage example
![TermiC cpp](Screenshots/Screenshot3.png)
- Test and execute c or cpp code within Tide42 using Termic

### AI prompt in Tide42 (requires API key)
![OpenAI](Screenshots/Screenshot4.png)
- Alternately use local models within the terminal buffer

### Search open buffers
![Buffers](Screenshots/Screenshot5.png)
- Scroll through open buffers and select from the list.

### Search files
![Files](Screenshots/Screenshot6.png)
- Quickly search for files.

### Ripgrep search
![Ripgrep](Screenshots/Screenshot7.png)
- Fast ripgrep within files with preview.

### Study and Reference
![Reference](Screenshots/Screenshot8.png)
- Easily read pdf study material or your favorite terminal browser to reference material while you work.

### Tide42 works well in a minimal tty environment.
![TTY](Screenshots/Screenshot9.png)
- Seamless tty functionality with custom bindings makes the SSH experience feel like using a WM.

### Tested and working on Macbook Air(Apple Silicon) / Macbook Pro(x86_64)
![Macbook-Air](Screenshots/Screenshot10.png)
![Macbook-Pro](Screenshots/Screenshot11.png)

<pre><code>
                                          ███ ███ ███ ███
                                          ███████████████
                                      ███ ███████████████   ███
                                      █   ███████ ███████   █
                                      █       ███████       █
                                  ██ ███ ██  ███ █ ███  ██ ███ ██
                             ████ █████████  ████ ████  █████████    ████
                             █    ████ ████  ███ █ ███  ████ ████    █
                             █      █ █ █    █████████    █ █ █      █
                         ██ ███ ██  ██ ███ █ █████████ █ ███ ██  ██ ███ ██
                         █████████  ██████████       ██████████  █████████
                         ████ ████  ████      █ ███ █      ████  ████ ████
                          ██ █ ██   ████ ███████   ███████ ████   ██ █ ██
                          ███ ███ █ ████  █      █      █  ████ █ ███ ███
                          ████████████████ ███ █████ ███ ████████████████
                          █████             ███████████             █████
                          █████  █████████  ███     ███  █████████  █████
                          ██  ████████████  ██  █ █  ██  ████████████  ██
                          █████████  █████  █  ██ ██  █  █████  █████████
                          █████████  █████  █         █  █████  █████████
                         ██████████  █████  █  ██ ██  █  █████  ██████████
                        ██████████████████   █  █   █  █   ████████████████
                                         █           █   █ █
                                          █   █         █ █ █
                                           █      █   █   █ █
                                            █           █ █ █
                                           █   █    █ █  █ █
                                          █             █ █
                                         █        █ █ █ █
</code></pre>

## Built With

tide42 uses and integrates the following open-source tools:
- [NeoVim](https://neovim.io/) – Hyper-extensible Vim-based text editor.
- [Vim](https://www.vim.org/) – Highly configurable text editor built to make creating and changing any kind of text very efficient.
- [tmux](https://github.com/tmux/tmux) – Terminal multiplexer for managing multiple terminal sessions.
- [Anaconda3](https://www.anaconda.com/) – Python/R distribution for data science and machine learning.
- [IPython](https://ipython.org/) – Interactive Python shell with rich functionality.
- [vim-plug](https://github.com/junegunn/vim-plug) – Minimalist Vim plugin manager by [Junegunn Choi](https://github.com/junegunn).
- [NERDTree](https://github.com/preservim/nerdtree) – File system explorer for Vim by [Vineet Sinha](https://github.com/vineet-sinha).
- [TermiC](https://github.com/hanoglu/TermiC) – Terminal integration utility by [Yusuf Kagan Hanoglu
Max Schillinger].
- [vim-plug](https://github.com/junegunn/vim-plug)
- [NERDTree](https://github.com/preservim/nerdtree)
- [vim-surround](https://github.com/tpope/vim-surround) – Surroundings management by [Tim Pope](https://github.com/tpope).
- [vim-commentary](https://github.com/tpope/vim-commentary) – Comment/uncomment code quickly by [Tim Pope](https://github.com/tpope).
- [vim-airline](https://github.com/vim-airline/vim-airline) – Lean & mean status/tabline for Vim.
- [fzf](https://github.com/junegunn/fzf) – General-purpose command-line fuzzy finder by [Junegunn Choi](https://github.com/junegunn).
- [fzf.vim](https://github.com/junegunn/fzf.vim) – Vim/Neovim integration for fzf by [Junegunn Choi](https://github.com/junegunn).
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) – Lua utility functions for Neovim by [nvim-lua](https://github.com/nvim-lua).
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) – Highly extendable fuzzy finder over lists (https://github.com/nvim-telescope).
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim) – UI component library for Neovim by [Munif Tanjim](https://github.com/MunifTanjim).
- [ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim) – ChatGPT integration for Neovim by [Jack Mort](https://github.com/jackMort).
- [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) – Highlight color codes with their actual color by [Breno Prata](https://github.com/brenoprata10).
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) – Adds file type icons to Neovim by [kyazdani42](https://github.com/kyazdani42) & contributors.
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) – Tab-like bufferline with icons by [Akinsho](https://github.com/akinsho).
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) – Git signs in the gutter + hunk actions by [Lewis Warren](https://github.com/lewis6991).

Thanks to the developers of these projects for making powerful tools free and accessible.
