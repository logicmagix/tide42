# Changelog

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

