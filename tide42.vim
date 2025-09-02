
"████████╗██╗██████╗ ███████╗██╗  ██╗██████╗ 
"╚══██╔══╝██║██╔══██╗██╔════╝██║  ██║╚════██╗
"   ██║   ██║██║  ██║█████╗  ███████║ █████╔╝
"   ██║   ██║██║  ██║██╔══╝  ╚════██║██╔═══╝ 
"   ██║   ██║██████╔╝███████╗     ██║███████╗
"   ╚═╝   ╚═╝╚═════╝ ╚══════╝     ╚═╝╚══════╝
"  Terminal Integrated Developer Environment 
"                   -42-                     
"                                            
"=======================================================
" tide42 (formerly xtide86) — see LICENSE for details

" ── GENERAL ────────────────────────────────────────────────────────────
syntax on
filetype plugin indent on
let g:default_colorscheme = "default"
let g:tide42_config_dir = fnamemodify(expand('<sfile>'), ':h')
let colorscheme_file = g:tide42_config_dir . '/colorscheme.vim'
if filereadable(colorscheme_file)
  execute 'source ' . colorscheme_file
else
  colorscheme default
endif
set noswapfile
let g:using_vim_scheme = 0
set termguicolors
set mouse=nvi
set laststatus=2
set winminheight=1
set shell=/bin/bash
let g:NERDTreeWinSize=10
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeQuitOnOpen=0
let NERDTreeRespectWildIgnore=1
let NERDTreeDirArrows=1
let NERDTreeShowLineNumbers=0
let NERDTreeLimitedSyntax=0

" ── PLUGINS ────────────────────────────────────────────────────────────
call plug#begin('~/.local/share/tide42/plugged')
Plug 'preservim/nerdtree'  " File explorer tree
Plug 'tpope/vim-surround'  " Easily change surrounding characters (quotes, brackets, tags, etc.)
Plug 'tpope/vim-commentary'  " Toggle comments on lines or visual selections
Plug 'vim-airline/vim-airline' " Customizable status/tabline
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder core binary (requires install step)
Plug 'junegunn/fzf.vim'  " Vim/Neovim integration for fzf
Plug 'nvim-lua/plenary.nvim'  " Lua utility functions for many Neovim plugins
Plug 'nvim-telescope/telescope.nvim'  " Extendable fuzzy finder for files, grep, buffers, etc.
Plug 'MunifTanjim/nui.nvim'  " UI component library for Neovim (used by some plugins)
Plug 'jackMort/ChatGPT.nvim'  " ChatGPT integration inside Neovim
Plug 'brenoprata10/nvim-highlight-colors'  " Highlight color codes with a swatch
Plug 'nvim-tree/nvim-web-devicons'  " Adds filetype icons to plugins like NERDTree, Telescope, Bufferline
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }  "Tab cycle with close buttons and icons
Plug 'lewis6991/gitsigns.nvim'  " Git diff signs + hunk actions
call plug#end()

" ── PLUGIN CONFIGURATION ───────────────────────────────────────────────
lua << EOF
require("chatgpt").setup({
  api_key_cmd = "echo $OPENAI_API_KEY",
  openai_params = {
    model = "gpt-4",
  }
})

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
}

require('nvim-highlight-colors').setup {
    render = 'virtual',
    virtual_symbol = '■',
    virtual_symbol_position = 'inline',
    enable_hex = true,
    enable_short_hex = true,
    enable_rgb = true,
    enable_hsl = true,
}

require('bufferline').setup {
    options = {
        numbers = "none",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
        custom_filter = function(buf_number)
            local buftype = vim.api.nvim_buf_get_option(buf_number, 'buftype')
            return buftype == ''
        end,
        close_command = function(buf_number)
            local buffers = vim.tbl_filter(function(b)
                return vim.api.nvim_buf_is_valid(b) and
                       vim.api.nvim_buf_get_option(b, 'buftype') == '' and
                       b ~= buf_number
            end, vim.api.nvim_list_bufs())
            local is_active = buf_number == vim.api.nvim_get_current_buf()
            if is_active and #buffers == 0 then
                vim.notify("Cannot close the last buffer. Force close with :Q or :BD to refresh.", vim.log.levels.WARN)
                return
            end
            if not vim.api.nvim_buf_is_valid(buf_number) then
                vim.notify("Buffer does not exist or is invalid.", vim.log.levels.ERROR)
                return
            end
            if is_active and #buffers > 0 then
                vim.api.nvim_set_current_buf(buffers[1])
            end
            pcall(vim.api.nvim_buf_delete, buf_number, { force = true })
        end,
    }
}

-- Function to handle mouse clicks and block tabline clicks in terminal buffers
function _G.conditional_mouse_click()
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    local mousepos = vim.fn.getmousepos()
    -- Check if click is on tabline (adjust screenrow if needed based on your setup)
    if mousepos.screenrow <= 2 and buftype == 'terminal' then
        vim.notify("Double click to force tab switching in terminal buffer", vim.log.levels.INFO)
        -- Feed an empty key sequence to prevent further event propagation
        vim.api.nvim_feedkeys("", "n", false)
        return
    end
    -- Allow default mouse behavior for non-tabline clicks or non-terminal buffers
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true), "n", true)
end

-- Set up buffer-local mouse mappings for terminal buffers
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
        if buftype == 'terminal' then
            -- Map <LeftMouse> to our conditional function in terminal buffers
            vim.keymap.set('n', '<LeftMouse>', ':lua _G.conditional_mouse_click()<CR>', { buffer = true, silent = true })
        else
            -- Remove buffer-local mapping to restore default behavior
            pcall(vim.keymap.del, 'n', '<LeftMouse>', { buffer = true })
        end
    end,
})

-- Existing conditional buffer cycling
function _G.conditional_bufferline_cycle(direction)
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    if buftype == '' then
        if direction == 'next' then
            vim.cmd('BufferLineCycleNext')
        elseif direction == 'prev' then
            vim.cmd('BufferLineCyclePrev')
        end
    else
        vim.notify("Buffer cycling is only allowed in file editor buffers", vim.log.levels.INFO)
    end
end

require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
    signcolumn = true,
    numhl      = false,
    linehl     = false,
    watch_gitdir = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        -- Hunk navigation
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(gs.next_hunk)
          return '<Ignore>'
        end, {expr=true, buffer=bufnr})
        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(gs.prev_hunk)
          return '<Ignore>'
        end, {expr=true, buffer=bufnr})
        -- Actions
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr})
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer=bufnr})
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr})
        vim.keymap.set('n', '<leader>hb', gs.blame_line, {buffer=bufnr})
    end
}
EOF

" ── FUNCTION COMMANDS ──────────────────────────────────────────────────
if !exists(':MaximizeTerminalBuffer')
  command! MaximizeTerminalBuffer call s:MaximizeTerminalBuffer()
endif
if !exists(':MaximizeIPythonBuffer')
  command! MaximizeIPythonBuffer call MaximizeIPythonBuffer()
endif
if !exists(':EnlargedWindow')
  command! EnlargedWindow call s:EnlargeWindow()
endif
if !exists(':ResetWindowsMaxEditor')
  command! ResetWindowsMaxEditor call s:ResetWindowSizes(1)
endif
if !exists(':ResetWindowsDefault')
  command! ResetWindowsDefault call s:ResetWindowSizes(0)
endif

" ── KEYMAPS ────────────────────────────────────────────────────────────
" Ensure global <LeftMouse> mapping is removed to avoid conflicts
silent! unmap <LeftMouse>

" Key mappings for buffer cycling (unchanged)
nnoremap <silent> <TAB> :lua _G.conditional_bufferline_cycle('next')<CR>
nnoremap <silent> <S-TAB> :lua _G.conditional_bufferline_cycle('prev')<CR>
nnoremap <silent> <leader>q :ResetUI<CR>
nnoremap <silent> <TAB> :BufferLineCycleNext<CR>
nnoremap <silent> <S-TAB> :BufferLineCyclePrev<CR>
nnoremap <leader>s :call <SID>MaximizeTerminalBuffer('left')<CR>
nnoremap <leader>x :call <SID>MaximizeTerminalBuffer('right')<CR>
nnoremap <silent> <leader>c :MaximizeIPythonBuffer<CR>
nnoremap <silent> <leader>b :call <SID>FocusNERDTree()<CR>
nnoremap <silent> <leader>z :call <SID>FocusFileEditor()<CR>
nnoremap <silent> <leader>v :EnlargedWindow<CR>
nnoremap <expr> <leader>i ":vertical resize " . input('Resize to: ') . "<CR>"
nnoremap <expr> <leader>u ":resize " . input('Resize to: ') . "<CR>"
nnoremap <leader>h ggVG
xnoremap <silent> <leader>p :<C-u>call SendToIPython()<CR>
xnoremap <silent> <leader>l :<C-u>call SendToTermiC()<CR>
nnoremap <silent> <leader>n :RestartIPython<CR>
vnoremap <silent> <leader>m :<C-u>call AppendToEditor()<CR>
nnoremap <silent> <leader>o :ChatGPT<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>g :call Grid(5, 10)<CR>
nnoremap <leader>f :call Grid(10, 10)<CR>
nnoremap <leader>w :Telescope buffers<CR>
nnoremap <leader>e :Telescope find_files<CR>
nnoremap <leader>r :Telescope live_grep<CR>
nnoremap <leader>y :call ToggleScheme()<CR>
inoremap jk <Esc>
tnoremap jk <C-\><C-n>
command! Hs split
command! Q call ForceQuitAndKillTmux()
command! BD lua vim.api.nvim_buf_delete(0, { force = true })
autocmd FileType nerdtree nnoremap <buffer> <leader>w :wincmd l \| :Telescope buffers<CR>

" ── SESSION INIT  ──────────────────────────────────────────────────────
let shell_path = $SHELL
let shell_name = fnamemodify(shell_path, ':t')
autocmd VimEnter * echom "Detected shell: " . shell_name
autocmd! VimEnter *
autocmd VimEnter * NERDTree $HOME
autocmd VimEnter * vertical resize 1
autocmd VimEnter * wincmd l
autocmd VimEnter * topleft split
autocmd VimEnter * terminal ipython
autocmd VimEnter * resize 3
autocmd VimEnter * belowright split

"── DETECT SHELL ──
let shell_path = $SHELL
let shell_name = fnamemodify(shell_path, ':t')
autocmd VimEnter * echom "Detected shell: " . shell_name

if shell_name == 'zsh'
    if executable('/opt/homebrew/bin/zsh')
        set shell=/opt/homebrew/bin/zsh
        autocmd VimEnter * terminal zsh -i -c 'termic cpp; exec zsh -i'
        let terminal_resize = 2
    elseif executable('/usr/local/bin/zsh')
        set shell=/usr/local/bin/zsh
        autocmd VimEnter * terminal zsh -i -c 'termic cpp; exec zsh -i'
        let terminal_resize = 2
    elseif executable('/usr/bin/zsh')
        set shell=/usr/bin/zsh
        autocmd VimEnter * terminal zsh -i -c 'termic cpp; exec zsh -i'
        let terminal_resize = 2
    elseif executable('/bin/zsh')
        set shell=/bin/zsh
        autocmd VimEnter * terminal zsh -i -c 'termic cpp; exec zsh -i'
        let terminal_resize = 2
    else
        set shell=/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
        autocmd VimEnter * echom "No valid Zsh shell found, falling back to bash"
    endif

elseif shell_name == 'bash'
    if executable('/opt/homebrew/bin/bash')
        set shell=/opt/homebrew/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
    elseif executable('/usr/local/bin/bash')
        set shell=/usr/local/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
    elseif executable('/usr/bin/bash')
        set shell=/usr/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
    elseif executable('/bin/bash')
        set shell=/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
    else
        set shell=/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
        autocmd VimEnter * echom "No valid Bash shell found, falling back to /bin/bash"
    endif

elseif shell_name == 'fish'
    if executable('/opt/homebrew/bin/fish')
        set shell=/opt/homebrew/bin/fish
        autocmd VimEnter * terminal fish -c 'termic cpp; exec fish -i'
        let terminal_resize = 2
    elseif executable('/usr/local/bin/fish')
        set shell=/usr/local/bin/fish
        autocmd VimEnter * terminal fish -c 'termic cpp; exec fish -i'
        let terminal_resize = 2
    elseif executable('/usr/bin/fish')
        set shell=/usr/bin/fish
        autocmd VimEnter * terminal fish -c 'termic cpp; exec fish -i'
        let terminal_resize = 2
    elseif executable('/bin/fish')
        set shell=/bin/fish
        autocmd VimEnter * terminal fish -c 'termic cpp; exec fish -i'
        let terminal_resize = 2
    else
        set shell=/bin/bash
        autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
        let terminal_resize = 2
        autocmd VimEnter * echom "No valid Fish shell found, falling back to bash"
    endif

else
    set shell=/bin/bash
    autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
    let terminal_resize = 2
    autocmd VimEnter * echom "Unknown shell detected, falling back to bash"
endif


" ── SESSION INIT CONTINUED ─────────────────────────────────────────────
autocmd VimEnter * belowright vs
autocmd VimEnter * vertical resize
autocmd VimEnter * terminal
execute 'autocmd VimEnter * resize ' . terminal_resize
autocmd VimEnter * wincmd j
autocmd VimEnter * wincmd l

" ── TIDE42 FUNCTIONS ───────────────────────────────────────────────────

" ── FORCE CLOSE TAB ────────────────────────────────────────────────────
command! BD call s:ForceDeleteBuffer()
function! s:ForceDeleteBuffer() abort
    let l:current_buf = bufnr('%')
    let l:buffers = filter(getbufinfo(), 'v:val.listed && v:val.bufnr != ' . l:current_buf . ' && getbufvar(v:val.bufnr, "&buftype") == ""')
    if len(l:buffers) > 0
        execute 'buffer ' . l:buffers[0].bufnr
    else
        enew
    endif
    call luaeval('vim.api.nvim_buf_delete(' . l:current_buf . ', { force = true })')
endfunction
nnoremap <silent> <leader>bd :BD<CR>

" ── RESET UI ───────────────────────────────────────────────────────────
if !exists(':ResetUI')
  command! ResetUI call s:ResetUI()
if !exists(':MaximizeTerminalBuffer')
  command! MaximizeTerminalBuffer call s:MaximizeTerminalBuffer()
endif
if !exists(':MaximizeIPythonBuffer')
  command! MaximizeIPythonBuffer call MaximizeIPythonBuffer()
endif
if !exists(':EnlargedWindow')
  command! EnlargedWindow call s:EnlargeWindow()
endif
if !exists(':ResetWindowsMaxEditor')
  command! ResetWindowsMaxEditor call s:ResetWindowSizes(1)
endif
if !exists(':ResetWindowsDefault')
  command! ResetWindowsDefault call s:ResetWindowSizes(0)
endif
if !exists(':MaximizeTerminalBuffer')
  command! MaximizeTerminalBuffer call s:MaximizeTerminalBuffer()
endif
if !exists(':MaximizeIPythonBuffer')
  command! MaximizeIPythonBuffer call MaximizeIPythonBuffer()
endif
if !exists(':EnlargedWindow')
  command! EnlargeWindow call s:EnlargeWindow()
endif
if !exists(':ResetWindowsMaxEditor')
  command! ResetWindowsMaxEditor call s:ResetWindowSizes(1)
endif
if !exists(':ResetWindowsDefault')
  command! ResetWindowsDefault call s:ResetWindowSizes(0)
endif

function! s:ResetUI() abort
  try
    " Save all buffers to avoid data loss
    silent! wall
    " Wipe all buffers to clear session state
    silent! bufdo bwipeout!
    " Close all windows
    silent! only
    " Source the configuration file
    execute 'source ' . g:tide42_config_dir . '/tide42.vim'
    " Re-run VimEnter autocommands to recreate UI
    doautocmd VimEnter
    " Reset window sizes to default
    call s:ResetWindowSizes(0)
    echom "tide42 UI reset: Wiped all buffers, sourced config, and restored default layout"
  catch
    echom "Error resetting UI: " . v:exception
  endtry
endfunction

" ── TOGGLE NVIM COLORSCHEMES ───────────────────────────────────────────
function! ToggleScheme()
  if g:using_vim_scheme
    execute 'colorscheme ' . g:default_colorscheme
    let g:using_vim_scheme = 0
  else
    let g:default_colorscheme = g:colors_name
    colorscheme vim
    let g:using_vim_scheme = 1
  endif
endfunction

" ── FORCE-QUIT ─────────────────────────────────────────────────────────
function! ForceQuitAndKillTmux() abort
  try
    if empty($TMUX)
      echom "Not in a tmux session, quitting Neovim only"
      execute "quitall!"
      return
    endif
    silent !tmux list-panes -s -F '\#P' | xargs -I {} tmux send-keys -t {} 'exit' C-m 2>/tmp/tmux_kill_session.log
    silent !tmux kill-session -t $(tmux display-message -p '\#S') 2>>/tmp/tmux_kill_session.log
    sleep 100m
    execute "quitall!"
  catch
    echom "Error during :Q: " . v:exception
    execute "quitall!"
  endtry
endfunction

" ── PREVENT REPEAT CALLS ───────────────────────────────────────────────
let s:is_running = 0
let s:last_run = 0
let s:debounce_ms = 500

" ── SEND TO IPYTHON ────────────────────────────────────────────────────
function! SendToIPython() abort
  let current_time = reltimefloat(reltime()) * 1000
  if exists('s:last_run') && current_time - s:last_run < get(s:, 'debounce_ms', 500)
    echom "SendToIPython: Debounced (too soon, " . printf('%.0f', current_time - s:last_run) . "ms since last)"
    return
  endif
  let s:last_run = current_time
  echom "SendToIPython: Starting (Mapping: " . maparg('<leader>p', 'x') . ")"
  try
    normal! gv
    normal! y
    echom "SendToIPython: Yanked " . (line("'>") - line("'<") + 1) . " lines"
    let yanked_text = substitute(@", '\n\+$', '', '')
    let current_win = winnr()
    let ipython_win = 0
    for w in range(1, winnr('$'))
      if getbufvar(winbufnr(w), '&buftype') == 'terminal' && bufname(winbufnr(w)) =~ 'ipython'
        let ipython_win = w
        break
      endif
    endfor
    if ipython_win > 0
      echom "SendToIPython: Found IPython window " . ipython_win
      execute ipython_win . 'wincmd w'
      normal! p
      echom "SendToIPython: Pasted text"
      call feedkeys("\<CR>", 'nt')
      sleep 50m
      wincmd k
      if winnr() == ipython_win
        execute '1wincmd w'
      endif
      let total_windows = winnr('$')
      if total_windows >= 3
        execute '1wincmd w'
        execute 'resize +35'
        execute total_windows . 'wincmd w'
        execute 'resize +5'
        execute '2wincmd w'
        execute 'resize -5'
        execute '1wincmd w'
      elseif total_windows == 2
        execute '1wincmd w'
        execute 'resize +5'
        execute '2wincmd w'
        execute 'resize +5'
        execute '1wincmd w'
      endif
      startinsert
      echom "SendToIPython: complete"
    else
      echom "Error: IPython terminal window not found"
    endif
  finally
    if mode() =~# '[vV]'
      execute "normal! \<Esc>"
    endif
  endtry
endfunction

" ── SEND TO TERMIC ─────────────────────────────────────────────────────
function! SendToTermiC() abort
  let current_time = reltimefloat(reltime()) * 1000
  if exists('s:last_run') && current_time - s:last_run < get(s:, 'debounce_ms', 500)
    echom "SendToTermiC: Debounced (too soon, " . printf('%.0f', current_time - s:last_run) . "ms since last)"
    return
  endif
  let s:last_run = current_time
  echom "SendToTermiC: Starting (Mapping: " . maparg('<leader>l', 'x') . ")"
  try
    normal! gv
    normal! y
    echom "SendToTermiC: Yanked " . (line("'>") - line("'<") + 1) . " lines"
    let yanked_text = substitute(@", '\n\+$', '', '')
    let current_win = winnr()
    let termic_win = 0
    for w in range(1, winnr('$'))
      if getbufvar(winbufnr(w), '&buftype') == 'terminal' && bufname(winbufnr(w)) =~ 'termic'
        let termic_win = w
        break
      endif
    endfor
    if termic_win > 0
      echom "SendToTermiC: Found TermiC window " . termic_win
      execute termic_win . 'wincmd w'
      normal! p
      echom "SendToTermiC: Pasted text"
      call feedkeys("\<CR>", 'nt')
      normal! a\<Esc>
      sleep 100m
      let total_windows = winnr('$')
      let ipython_win = 0
      for w in range(1, winnr('$'))
        if getbufvar(winbufnr(w), '&buftype') == 'terminal' && bufname(winbufnr(w)) =~ 'ipython'
          let ipython_win = w
          break
        endif
      endfor
      if ipython_win > 0
        execute ipython_win . 'wincmd w'
        execute 'resize -5'
        execute 'vertical resize -10'
      endif
      execute termic_win . 'wincmd w'
      execute 'resize +35'
      execute 'vertical resize 1000'
      let bottom_win = 0
      for w in range(1, winnr('$'))
        if bufname(winbufnr(w)) =~ 'NERD' || getbufvar(winbufnr(w), '&buftype') == ''
          let bottom_win = w
          break
        endif
      endfor
      if bottom_win > 0
        execute bottom_win . 'wincmd w'
        execute 'resize +5'
        execute 'vertical resize -5'
      endif
      execute termic_win . 'wincmd w'
      if mode() =~# '[iR]'
        execute "normal! \<Esc>"
      endif
      startinsert
      echom "SendToTermiC: complete"
    else
      echom "Error: TermiC terminal window not found"
    endif
  finally
    if mode() =~# '[vV]'
      execute "normal! \<Esc>"
    endif
  endtry
endfunction

" ── APPEND TO EDITORS ──────────────────────────────────────────────────
function! AppendToEditor() abort
  if !exists('s:last_run')
    let s:last_run = 0
    let s:debounce_ms = 100
  endif
  let current_time = reltimefloat(reltime()) * 1000
  if current_time - s:last_run < s:debounce_ms
    return
  endif
  let s:last_run = current_time
  try
    let src_buf = bufnr('%')
    let current_win = winnr()
    if mode() =~# '[vV\<C-v>]'
      normal! gv"zy
      let src_lines = split(getreg('z'), '\n')
    else
      echom "Error: Not in visual mode"
      return
    endif
    if empty(src_lines)
      echom "Error: No content in selection"
      return
    endif
    let editor_win = 0
    for w in range(1, winnr('$'))
      let buf = winbufnr(w)
      if getbufvar(buf, '&buftype') == '' && bufname(buf) !~ 'NERD'
        let editor_win = w
        break
      endif
    endfor
    if editor_win == 0
      echom "Error: No suitable editor buffer found"
      return
    endif
    execute editor_win . 'wincmd w'
    execute 'resize 35'
    let editor_buf = bufnr('%')
    let last_line = line('$')
    call appendbufline(editor_buf, last_line, src_lines)
    execute (last_line + len(src_lines)) . "normal! $"
    startinsert
  catch
    echom "Error: " . v:exception
  endtry
endfunction

" ── FOCUS: FILE EDITOR ─────────────────────────────────────────────────
function! s:FocusFileEditor() abort
  let l:editor_win = 0
  for w in range(1, winnr('$'))
    let l:buf = winbufnr(w)
    if getbufvar(l:buf, '&buftype') == '' && bufname(l:buf) !~ 'NERD'
      let l:editor_win = w
      break
    endif
  endfor
  if l:editor_win > 0
    execute l:editor_win . 'wincmd w'
    execute 'vertical resize'
    execute 'resize'
    execute 'resize -1'
    echom "SET FOCUS | File Editor"
  else
    echom "Error: File editor window not found"
  endif
endfunction

" ── FOCUS: NERDTREE ────────────────────────────────────────────────────
function! s:FocusNERDTree() abort
  let l:nerdtree_win = 0
  for w in range(1, winnr('$'))
    let l:buf = winbufnr(w)
    if getbufvar(l:buf, '&filetype') == 'nerdtree'
      let l:nerdtree_win = w
      break
    endif
  endfor
  if l:nerdtree_win > 0
    execute l:nerdtree_win . 'wincmd w'
    execute 'vertical resize 40'
    execute 'resize'
    execute 'resize -1'
    echom "SET FOCUS | NERDTree"
  else
    echom "Error: NERDTree window not found"
  endif
endfunction

" ── FOCUS: IPYTHONS ────────────────────────────────────────────────────
function! MaximizeIPythonBuffer() abort
  silent! try
    let l:initial_win = winnr()
    let l:terminal_wins = []
    let l:ipython_win = 0
    let l:nerdtree_win = 0
    let l:editor_win = 0
    for w in range(1, winnr('$'))
      let l:buf = winbufnr(w)
      let l:bufname = bufname(l:buf)
      if getbufvar(l:buf, '&buftype') == 'terminal'
        if l:bufname =~ 'ipython'
          let l:ipython_win = w
        else
          call add(l:terminal_wins, w)
        endif
      elseif getbufvar(l:buf, '&filetype') == 'nerdtree'
        let l:nerdtree_win = w
      else
        let l:editor_win = w
      endif
    endfor
    if l:ipython_win == 0
      echo "Error: Could not find IPython buffer"
      execute l:initial_win . 'wincmd w'
      return
    endif
    execute l:ipython_win . 'wincmd w'
    for w in range(1, winnr('$'))
      if w != l:ipython_win
        execute w . 'wincmd w'
        silent! resize 1
      endif
    endfor
    execute l:ipython_win . 'wincmd w'
    silent! wincmd _
    if l:nerdtree_win > 0
      execute l:nerdtree_win . 'wincmd w'
      silent! vertical resize 15
    endif
    execute l:ipython_win . 'wincmd w'
    redraw
    echo "SET SIZE | Focus: (IPython)"
  finally
    if winnr() != l:ipython_win
      execute l:initial_win . 'wincmd w'
    endif
  endtry
endfunction

" ── MAX TERMINAL ───────────────────────────────────────────────────────
function! s:MaximizeTerminalBuffer(direction = 'left') abort
  silent! try
    let l:initial_win = winnr()
    let l:terminal_wins = []
    let l:ipython_win = 0
    let l:editor_win = 0
    let l:nerdtree_win = 0
    for w in range(1, winnr('$'))
      let l:buf = winbufnr(w)
      let l:bufname = bufname(l:buf)
      if getbufvar(l:buf, '&buftype') == 'terminal'
        if l:bufname =~ 'ipython'
          let l:ipython_win = w
        else
          call add(l:terminal_wins, w)
        endif
      elseif getbufvar(l:buf, '&filetype') == 'nerdtree'
        let l:nerdtree_win = w
      else
        let l:editor_win = w
      endif
    endfor
    echo "Debug: Terminal wins: " . string(l:terminal_wins) . " | IPython win: " . l:ipython_win . " | NERDTree win: " . l:nerdtree_win . " | Editor win: " . l:editor_win
    if len(l:terminal_wins) < 2 || l:ipython_win == 0
      echo "Error: Could not find dual terminal windows or IPython terminal"
      execute l:initial_win . 'wincmd w'
      return
    endif
    execute l:terminal_wins[0] . 'wincmd w'
    let l:middle_win = winnr()
    echo "Debug: Selected terminal_wins[0] as middle_win: " . l:middle_win
    wincmd k
    if getbufvar(winbufnr(winnr()), '&buftype') != 'terminal' || bufname(winbufnr(winnr())) =~ 'ipython'
      execute l:middle_win . 'wincmd w'
    else
      execute l:middle_win . 'wincmd w'
      wincmd j
      if getbufvar(winbufnr(winnr()), '&buftype') != 'terminal' && getbufvar(winbufnr(winnr()), '&filetype') != 'nerdtree'
        let l:middle_win = winnr()
      else
        echo "Error: Could not identify middle horizontal window"
        execute l:initial_win . 'wincmd w'
        return
      endif
    endif
    echo "Debug: Middle window finalized: " . l:middle_win
    for w in range(1, winnr('$'))
      if w != l:middle_win && w != l:terminal_wins[1]
        execute w . 'wincmd w'
        if w == l:ipython_win
          silent! resize 3
          echo "Debug: Resized IPython (win " . w . ") to height 3"
        else
          silent! resize 1
          echo "Debug: Resized window " . w . " to height 1"
        endif
      endif
    endfor
    execute l:middle_win . 'wincmd w'
    silent! wincmd _
    echo "Debug: Maximized middle window (win " . l:middle_win . ") vertically"
    if l:nerdtree_win > 0
      execute l:nerdtree_win . 'wincmd w'
      silent! vertical resize 15
      echo "Debug: Resized NERDTree (win " . l:nerdtree_win . ") to width 15"
    endif
    if a:direction == 'right'
      execute l:terminal_wins[1] . 'wincmd w'
      echo "Debug: Focused right terminal (win " . l:terminal_wins[1] . ")"
      silent! vertical resize 1000
      silent! wincmd _
      echo "Debug: Applied vertical resize 1000 and wincmd _ to right terminal"
    else
      execute l:terminal_wins[0] . 'wincmd w'
      echo "Debug: Focused left terminal (win " . l:terminal_wins[0] . ")"
      silent! vertical resize 1000
      silent! wincmd _
      echo "Debug: Applied vertical resize 1000 and wincmd _ to left terminal"
    endif
    redraw
    echo "SET SIZE | Focus: (Shell Prompt (Default: TermiC | Shell)) - " . a:direction
  finally
    if winnr() != (a:direction == 'right' ? l:terminal_wins[1] : l:terminal_wins[0])
      execute l:initial_win . 'wincmd w'
    endif
  endtry
endfunction

" ── MAX CURRENT ────────────────────────────────────────────────────────
function! s:EnlargeWindow() abort
  wincmd _
  echom "SET SIZE | Focus: (Currently Selected Buffer)"
endfunction

" ── RESTART IPYTHON ────────────────────────────────────────────────────
command! RestartIPython call s:RestartIPython()
function! s:RestartIPython() abort
  let current_win = winnr()
  let ipython_win = 0
  let ipython_buf = 0
  for w in range(1, winnr('$'))
    let buf = winbufnr(w)
    if getbufvar(buf, '&buftype') == 'terminal' && bufname(buf) =~ 'ipython'
      let ipython_win = w
      let ipython_buf = buf
      break
    endif
  endfor
  if ipython_buf > 0 && (term_getstatus(ipython_buf) =~ 'finished' || !bufexists(ipython_buf))
    execute ipython_win . 'wincmd w'
    execute 'bdelete! ' . ipython_buf
    let ipython_buf = 0
  endif
  if ipython_buf == 0
    execute 'topleft split'
    execute 'terminal ipython'
    execute 'resize 1'
  else
  endif
  execute current_win . 'wincmd w'
endfunction

" ── GRID: 5x5 or 10x10 ─────────────────────────────────────────────────
function! Grid(...) abort
    if exists('b:grid_row_grp') || exists('b:grid_prev_cc')
        call matchdelete(b:grid_row_grp)
        let &colorcolumn = b:grid_prev_cc
        unlet b:grid_row_grp b:grid_prev_cc
        echo "GRID | Grid Off"
        return
    endif
    if a:1 < 1 || a:2 < 1
        echoerr "Row and column intervals must be positive"
        return
    endif
    let [dr, dc] = [a:1, a:2]
    if a:0 < 4
        let nr = line('$')
        let nc = 0
        let i = 1
        while i <= nr
            let k = virtcol('$')
            let nc = nc < k ? k : nc
            let i += 1
        endwhile
    else
        let [nr, nc] = [a:3, a:4]
    endif
    if nr < 1 || nc < 1
        echo "Buffer too small for grid"
        return
    endif
    let nc = max([dc, nc])
    let rows = range(1, nr, dr)
    let cols = range(dc, nc, dc)
    if empty(rows)
        echoerr "No rows to highlight"
        return
    endif
    let pat = '\V' . join(map(rows, '"\\%" . v:val . "l"'), '\|')
    let b:grid_row_grp = matchadd('ColorColumn', pat)
    let b:grid_prev_cc = &colorcolumn
    let &colorcolumn = join(cols, ',')
    echo "GRID | Grid On " . dr . ", cols every " . dc
endfunction
endif
