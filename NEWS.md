# Tide42 NEWS:

# 04.15.26
- Fixed pyright LSP install failure on fresh systems: pinned mason.nvim to v1.11.0 and mason-lspconfig.nvim to v1.32.0 (v2.0 changed `ensure_installed` semantics and broke first-launch server installation)

# 04.12.26
- Fixed TermiC glob expansion bug: `*` in function bodies was expanded by bash as a file glob in /tmp
- Fixed TermiC sed insertion bug: `}` in function definitions was interpreted as a sed command terminator
- Replaced sed-based code insertion with head/tail for reliable function definition handling

# 03.23.26
- Toggle autocomplete on/off with \a (off by default)

# 03.06.26
- LSP support added via nvim-lspconfig with Mason for automatic server installation (pyright for Python, clangd for C/C++)
- Autocompletion engine added via nvim-cmp with LSP and buffer word sources
- New completion keybindings: Ctrl+Space (trigger completion), Enter (confirm), Ctrl+j/Ctrl+k (navigate completion menu)
- Bufferline diagnostics now powered by nvim_lsp
- Cleaned up dead and redundant code (removed unused ResetWindowSizes, conditional_bufferline_cycle, duplicate command definitions)
- Added splash screen during tmux and nvim buffer initialization

# 02.26.26
- --separator-color (-sc) flag to set the Neovim window separator color (persists across sessions)
- --separator-width (-sw) flag to set the Neovim window separator width: thick, double, medium, or thin
- --border-width (-bw) flag to set the tmux pane border width: thick, double, medium, or thin
- Full block separator characters for Neovim window borders (default: thick)
- Gray/darkgray color names corrected to match expected brightness

# 02.25.26
- --gui flag: Desktop launcher now auto-detects the default terminal emulator instead of relying on Terminal=true
- install.sh skips already-installed packages instead of reinstalling them (avoids unnecessary recompilation on Gentoo)
- IPython binary auto-detection: tide42 detects whether ipython or ipython3 is available and uses the correct one
- --check-update added to --help menu
- Man page fixes: added missing keybindings (\j, \c, \v), removed duplicate \n entry, fixed empty OPTIONS section, added --gui and --check-update
- Quieter man page install (mandb -q)
- tmux.conf is now regenerated on every install and launch to ensure config updates take effect
- Heavy pane border lines for better visibility between tmux panes
- install.sh now prompts before updating package manager and installing dependencies
- --border-color (-bc) flag to set the active tmux pane border color
- --colorscheme (-cs) now sets the colorscheme and launches tide42 instead of exiting
- TMUX_CONF now points to $TIDE_CONF_DIR/tmux.conf (~/.config/tide42/tmux.conf)
- --low-color: Removed backup logic, just writes directly to the tide42-owned file
- Default config block: Simplified to a single "if file doesn't exist, create it" check -- no marker checking, no backup, no append logic
- Mouse support block: Removed entirely (already included in the default config write)
- tmux new-session: Now uses -f "$TMUX_CONF" to load the config on fresh server start
- tmux source-file: Added immediately after to handle the case where the server was already running

# 09.29.25
- New mapping added to display NERDTree in any buffer or if you have opened a file in the NERDTree buffer. Alternately, use :NERDTreeExplore in the desired buffer.

# 09.26.25
- Tide42 now includes Gentoo in its install logic and prompts users whether they would like to continue with the installation before updating or compiling. 

# 09.07.25
- Mac users may have to run :PlugInstall manually after initial installation. 

# 09.05.25
- Screenshots of Tide42 on a Macbook Air (Apple Silicon) and Macbook Pro(x86_64) have been added.
- Man page currently does not install on Macbooks. The repo directory now contains tide42man.md which is a copy of the man page for Apple user

# 09.04.25
- Added hotkey for  new tab \t

# 09.02.25
- Recent update check changes were reverted due to slow startup and edge cases. Please re-install tide42 if you cloned or updated on 09/02/2025 between6:00pm and 12:00pm EST

# 08.22.25
- The keybind mappings \z and \b now focus the file editor with NERDTree shown or hidden.
- Active and unsaved tabs may be closed with :BD (unsaved work will be lost)
- Tabs can be cycled through the file editor buffer. 
 
# 08.15.25
- Tide42 has a new hotkey \q to restart the UI.
- Added a new flag --colorscheme that can be used to set a desired theme. 
- colorscheme.vim may be edited manually in $HOME/.config/tide42/colorscheme.vim
- This theme will persist throughout updates. 
- Tide42 now uses nvim-highlight-colors swatch display as a default plugin.
- Now includes uninstall script 
- Tide42 now detects bash zsh or fish in either system or user installed locations.

# 08.12.25
- Latest stable version is 1.2.2
- Tide42 now writes a tide42.vim file to ~/config/tide42 avoiding overwriting any exisiting user neovim configuration. Safely install tide42 and keep your custom nvim configs active. Added XDG_CONFIG_HOME support in install.sh and tide42.sh with fallback to ~/.config/tide42. Users can now install Tide42 and keep nvim configurations intact.
- NERDTree starts in $HOME regardless of which directory tide42 is launched from. Cannot navigate higher than $HOME by default. Use sudoedit in the terminal buffer to edit as sudo.
- Default space marker is now blank.. additional options are available and commented out in tide42.vim

# 08.04.25
- Added vim navigation to tide42.sh tmux keybindings sections. Alternate tmux buffers with Ctrl+Q + hjkl.
- Use hold Ctrl + q and arrow keys to resize tmux buffer.


# 08.03.25
- Default colorscheme has been changed from default to retrbox. This allows for better readability if using from a tty or using ssh. This can easily be changed in init.vim and preconfigured colorschemes are listed in the comments for users.
- All tmux buffer hotkeys have been changed to Ctrl + Alt (eg. Ctrl + Alt + a, s, d, z, etc)to avoid nvim conflicts.

# 08.03.25
- Updated initialization blocks to automatically detect the shell and set to either zsh or bash. Additional shell option suggestions are welcome. New highlight deffault color is light blue for better clarity and can be changed with suggested values within the highlights section.   

08.01.25
- Added new functionality for toggling default and alternate colorschemes. Alternate default is colorscheme "vim" which allows for toggling transparency if set properly in the terminal emulator. Hotkey binding is \y. Make sure transparency is set to on in emulators like gnome-terminal. If you do not use transparency you can also select a different alternate colorscheme and switch between the two with \y. 

# 07.28.25
-  Added new bindings Ctrl + f, g, z, x buffer manipulation and tweaked default ui layout.
- Added new binding \h to select all text \h

# 07.26.25
- Changed default ui to maximize the file buffer and minimize all other buffers for a cleaner entry. All buffer manipulation hotkeys remain the same.

# 06.09.25
- Tide42 tested and working on 32bit systems and on the newest nvim version 0.12
- Added autocmd for default colorscheme. Check lines 96 and 154 of init.vim to customize your own palette and theme like habamax, elflord, peachpuff, etc.

# 06.03.25
- Default input layout reformatted with latest push.. feedback requested or alternately change it to your liking in init.vim.
- If you are having issues with the ipython buffer closing when running instances of gui libraries like pygame, use the RestartIPython function with :RestartIPython or \n to create a new buffer. 
- WARNING!! If making your own modifications to tide42 make sure to back then up before running --update as it will wipe and copy over any existing changes in your repo or installed files including init.vim


