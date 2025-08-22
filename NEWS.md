# Tide42 NEWS:

#
08.22.25
- Tabs can be cycled through the file editor buffer. Only inactive tabs may be closed. 
 
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


