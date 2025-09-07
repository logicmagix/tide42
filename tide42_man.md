NAME
       tide42 - an ultra-efficient, Neovim-based terminal IDE for Python and C/C++ with dynamic buffer control and tmux integration

DESCRIPTION
       tide42  is  a terminal-based development environment that combines tmux, Neovim, IPython, and C/C++ shells (via TermiC) in a vertically split, buffer-managed interface designed for rapid prototyping and efficient
       scripting.

       tide42 automatically launches a tmux session with Neovim buffers configured for:

       • Code editing

       • IPython REPL

       • TermiC (lightweight live shell for C/C++)

OPTIONS
COLORSCHEMES
       blue darkblue default delek desert elflord evening habamax industry koehler lunaperche morning murphy pablo peachpuff quiet retrobox ron shine slate sorbet torte unokai vim (used to set transparency, respects de‐
       fault terminal emulator settings) wildcharm zaibatsu zellner

       --colorscheme, -cs
              Set Tide42 colorscheme. Use the flag with no name to see a list of included themes.

       --lite,
              Launch without tmux for quick editing or low-resource systems

       --whereami,
              Display git installation directory.

       --low-color, -lc
              Enable 88-color mode (limited compatibility; some keybindings like Home/End may not function correctly).

       --quiet, -q
              Suppress verbose logging messages during initialization.

       --check-update
              Check for updates without writing new files.

       --update
              Self-update tide42 from the GitHub repository. Requires a clean working directory.

       --version
              Print the installed version and exit.

       --help, -h
              Display this help message and exit.

       filename
              Optional. Open the specified file directly in Neovim within the tide42 environment.

FEATURES
       • Visual theme toggles (GRID, Portcullis, listchars)

       • Seamless switching between buffers using intuitive hotkeys

       • Smart paste into IPython (\ p) and TermiC (\ l) buffers

       • Optional OpenAI API integration (\ o)

       • Session persistence via tmux (resume where you left off after SSH reconnection)

       • Hotkey support for maximizing panes, launching fuzzy finders, resizing windows, and more

KEYBINDINGS
       Keybindings within tide42 use Vim and Tmux conventions.

       :Q     Force quit tide42

       :BD    Force close current tab

       Esc Esc
              Close opened plugin window

       Ctrl + q + d
              Exit and save tmux session

       Ctrl + ww
              Cycle vim buffers

       Ctrl + a
              Maximize left buffer

       Ctrl + s
              Equalize left and right buffers

       Ctrl + d
              Maximize right buffer

       Ctrl + Alt + z
              Adjust active buffer 25%

       Ctrl + Alt + x
              Adjust active buffer 30%

       Ctrl + Alt + c
              Adjust active buffer 60%

       Ctrl + Alt + v
              Adjust active buffer 75%

       jk / Escape
              Enter command mode

       Shift r
              Refresh NERDTree within buffer

       \ q    Restart Tide42 UI

       \ f/g  Toggle grid on/off

       \ n    Restart IPython

       \ w    Fuzzy buffer selector

       \ r    Ripgrep search

       \ t    New tab

       \ y    Toggle Colorscheme

       \ e    Telescope file finder

       [c     Jump to the previous Git hunk in the current buffer.

       ]c     Jump to the next Git hunk in the current buffer.

       <leader>hs
              Stage the current hunk.

       <leader>hu
              Undo staging of the current hunk.

       <leader>hr
              Reset the current hunk to its state in HEAD.

       <leader>hb
              Show blame information for the current line.

       \ m    Paste to nvim file editor from any buffer

       \ h    Select all text within buffer

       \ p    Paste selection into IPython

       \ l    Paste selection into TermiC

       \ n    Open new Ipython buffer

       \ i    Quick vertical resize

       \ u    Quick horizontal resize

       \ z, \ s, \ x, \ b
              Preset layout configurations

       Tab    Cycle to the next tab

       Shift + Tab
              Cycle to the previous tab

USAGE
       tide42
       Launch the IDE session with tmux and Neovim buffers.
       tide42 filename.py
       Open a specific file in the edit buffer at launch.

INSTALLATION
       Clone the repository and run:
              chmod +x install.sh && ./install.sh
       Optionally, run:
              sudo ./install.sh --man
       To install this man page.

REQUIREMENTS
       - tmux - neovim >= 0.9.0 - bash - IPython (Anaconda3 recommended) - TermiC (for C/C++ shell support) - vim-plug for plugin management

FILES
       /usr/local/bin/tide42 /usr/local/bin/termic /usr/share/man/man1/tide42.1.gz

AUTHOR
       Created by Pavle Dzakula (@logicmagix) Inspired by terminal-first workflows and father-son engineering.

LICENSE
       GNU General Public License v3.0 or later

SEE ALSO
       tmux(1), nvim(1), ipython(1), termic(1)

version 1.2.2                                                                                             May 2025                                                                                                TIDE42(1)
