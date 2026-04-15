# Changelog

## [1.3.2] - 2026-04-15
### Fixed
- Pyright LSP install failure on fresh systems: pinned `mason.nvim` to `v1.11.0` and `mason-lspconfig.nvim` to `v1.32.0` (v2.0 changed `ensure_installed` semantics and broke first-launch server installation)

## [1.3.1] - 2026-04-12
### Fixed
- TermiC: Quoted `$fullPrompt` variable to prevent bash glob expansion of `*` in /tmp
- TermiC: Replaced `sed` insert with `head`/`tail` to fix `}` being parsed as a sed command terminator

## [1.3.0] - 2026-03-23
### Added
- LSP support via nvim-lspconfig with Mason auto-install for pyright (Python) and clangd (C/C++)
- Autocompletion engine via nvim-cmp with LSP and buffer word sources
- New plugins: nvim-lspconfig, mason.nvim, mason-lspconfig.nvim, nvim-cmp, cmp-nvim-lsp, cmp-buffer
- Completion keybindings: Ctrl+Space (trigger), Enter (confirm), Ctrl+j/k (navigate)
- Toggle autocomplete on/off with \a (off by default; Ctrl+Space still triggers completion manually)
- Bufferline diagnostics powered by nvim_lsp
- Splash screen during tmux and nvim buffer initialization
- --separator-color (-sc) flag to set Neovim window separator color (persists across sessions)
- --separator-width (-sw) flag to set Neovim window separator width: thick, double, medium, or thin
- --border-width (-bw) flag to set tmux pane border width: thick, double, medium, or thin
- --border-color (-bc) flag to set active tmux pane border color
- --gui flag: desktop launcher auto-detects default terminal emulator
- --check-update added to --help menu
- Full block separator characters for Neovim window borders (default: thick)
- Heavy pane border lines for better visibility between tmux panes
- IPython binary auto-detection (ipython or ipython3)
- ARM architecture dependencies added to installer
- install.sh prompts before updating package manager and installing dependencies
- install.sh skips already-installed packages (avoids unnecessary recompilation on Gentoo)

### Changed
- tmux.conf regenerated on every install and launch to ensure config updates take effect
- TMUX_CONF now points to ~/.config/tide42/tmux.conf
- --colorscheme (-cs) now sets the colorscheme and launches tide42 instead of exiting
- --low-color simplified to write directly without backup logic
- Default config block simplified to single existence check
- Quieter man page install (mandb -q)

### Fixed
- Gray/darkgray color names corrected to match expected brightness
- Man page: added missing keybindings (\j, \c, \v), removed duplicate \n entry, fixed empty OPTIONS section

### Removed
- Dead code: unused ResetWindowSizes command and conditional_bufferline_cycle function
- Duplicate command definitions and redundant variable declarations
- Mouse support block (already included in default config write)

## [1.2.2] - 2025-08-14
### Added
- Seperate Highlight augroup and Grid Styling blocks from tide42.vim in colorscheme.vim
- Set persistent default colorscheme
- Added colorscheme flag and error relevant error messages.
- Added uninstall.sh with option to remove repo directory if desired.
- Added new hotkey \q to restart UI
- Added plugins gitsigns, bufferline, and nvim-web-devicons
- Mapped hotkeys for new plugins \hs \hb \hr [c / ]c TAB and SHIFT + TAB

## [1.2.2] - 2025-08-12
### Added
- Updated Telescope setup in tide42.vim to force horizontal layout with preview on the right.
- Set preview_cutoff=10 to show previews in narrow windows.
- Configured prompt_position="top", preview_width=0.5, width=0.9, height=0.8 for consistent UI across systems.
- Ensured plugin path uses ~/.local/share/tide42/plugged for isolated setup.
- Fixed <leader>w, <leader>e, <leader>r to use Telescope commands (:Telescope buffers, find_files, live_grep).
- Fixed --lite mode by using env NVIM_APPNAME=tide42 nvim -u "$TIDE_CONF_FILE" for reliable execution.
- Added Neovim version check (>=0.9) for NVIM_APPNAME support in tide42.sh.
- Renamed Neovim config to ~/.config/tide42/tide42.vim for clarity and isolation.
- Added XDG_CONFIG_HOME support with fallback to ~/.config/tide42 in both scripts.
- Updated install.sh to copy init.vim as tide42.vim and install plugins in ~/.local/share/tide42.
- Added --check-version flag


## [1.2.1] - 2025-07-30
### Added
- Reformatted default UI and added new hotkeys for buffer manipulation.

## [1.2.1] - 2025-06-03
### Added
- RestartIpython function impemented for improved robustness of the REPL workflow for GUI-driven Python tasks.

## [1.2.0] - 2025-06-01
### Changed
- `--update` now defaults to forced updates, discarding local changes and syncing to remote.
- Users with local mods should maintain a fork or avoid `--update`.
- Project renamed to `tide42` (formerly `xtide86`)
- Installer, wrapper, and manpage updated accordingly
- Legacy support for `xtide86 --update` remains functional

### Added
- `--force-update` flag to reset local changes and reinstall from latest Git tag
- `--lite`, `-li` mode for running `nvim` without tmux (quick edit mode)
- Help output and manpage expanded with clearer flag documentation

### Fixed
- Swapfile suppression for NERDTree buffers to avoid `.swp` file spam
- False positive dirty state in updater due to untracked/generated files
- `.gitignore` restored to ignore `install.sh`, manpages, and swapfiles

### Notes
- Declared `1.2.0` as first stable release after extended field testing
- Internals cleaned, redundant permissions removed from `install.sh`


## [1.1.0] - 2025-05-28
### Added
- Full 256-color support using `tmux-256color`
- Enhanced color handling in `tide42.sh` and `init.vim`
- Open existing and new files in `tide42.sh`
- Update from repo capability in `tide42.sh`


## [1.0.0] - 2025-05-24
- Initial release of tide42 with core tmux/nvim integration

