
" tide42 (formerly xtide86) - a terminal IDE powered by tmux and nvim
" Copyright (C) 2025 Pavle Dzakula
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the# GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program. If not, see <https://www.gnu.org/licenses/>.
" Credits

"This project includes `termic.sh` from [Yusuf Kagan Hanoglu/Max Schillinger/TermiC], licensed under the [GPL3] License.

" Disable swapfile globally
set noswapfile

" Re-enable it for normal files (but never for NERDTree)
autocmd BufWinEnter * if &filetype !=# 'nerdtree' | setlocal swapfile | endif

syntax on
filetype plugin indent on

" Plugin management with vim-plug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'jackMort/ChatGPT.nvim'
call plug#end()

" Configure ChatGPT.nvim
lua << EOF
require("chatgpt").setup({
  api_key_cmd = "echo $OPENAI_API_KEY",
  openai_params = {
    model = "gpt-4",
  }
})
EOF

" General settings for window management
set termguicolors
set mouse=nvi
set laststatus=2
set winminheight=1
set shell=/bin/bash
let g:NERDTreeWinSize=10
let NERDTreeShowHidden=1

" Visual settings
set cursorline
set cursorcolumn
set number
set relativenumber
augroup WindowLineNumbers
    autocmd!
    autocmd TermOpen * setlocal norelativenumber
    autocmd BufWinEnter,WinEnter * if &buftype ==# 'terminal' | setlocal norelativenumber | else | setlocal relativenumber | endif
augroup END
set list
set listchars=tab:>-,eol:$,trail:.,extends:>,precedes:<,space:.
" Medieval Set:
"set listchars=tab:⟭➳◎,eol:⚔,trail:♞,extends:♛,precedes:♚,space:␣,

" Custom highlights
augroup CursorHighlights
  autocmd!
  autocmd ColorScheme,VimEnter * highlight clear CursorLine | highlight CursorLine cterm=underline gui=underline
  autocmd ColorScheme,VimEnter * highlight clear CursorColumn | highlight CursorColumn ctermbg=230 guibg=#4e4e4e
augroup END
highlight clear CursorLine
highlight CursorLine cterm=underline gui=underline
highlight clear CursorColumn
highlight CursorColumn ctermbg=230 guibg=#4e4e4e
augroup CustomHighlights
  autocmd!
  autocmd ColorScheme,VimEnter * highlight clear Visual | highlight Visual ctermbg=230 guibg=#4e4e4e
  autocmd ColorScheme,VimEnter * highlight clear Search | highlight Search ctermbg=230 guibg=#4e4e4e ctermfg=230 guifg=#4e4e4e
  autocmd ColorScheme,VimEnter * highlight clear MatchParen | highlight MatchParen ctermbg=230 guibg=#4e4e4e
augroup END
highlight Visual ctermbg=230 guibg=#4e4e4e
highlight Search ctermbg=230 guibg=#4e4e4e ctermfg=230 guifg=#4e4e4e
highlight MatchParen ctermbg=230 guibg=#4e4e4e
" Colors:
" Light Brown: ctermbg=95 guibg=#875f5f
" Brown: ctermbg=94 guibg=#875f00
" Olive Green: ctermbg=100 guibg=#878700
" Lime Green: ctermbg=154 guibg=#afff00
" Neon Green: ctermbg=118 guibg=#87ff00
" Neon Pink: ctermbg=198 guibg=#ff0087
" Purple: ctermbg=56 guibg=#5f00d7
" Cyan: ctermbg=48 guibg=#00ff87
" Dark Teal: ctermbg=23 guibg=#005f5f
" Orange: ctermbg=208 guibg=#ff8700
" Deep Red: ctermbg=124 guibg=#af0000
" Soft Blue: ctermbg=110 guibg=#87afd7
" Gray: ctermbg=230 guibg=#4e4e4e


" Key mappings and commands
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

nnoremap <leader>s :call <SID>MaximizeTerminalBuffer('left')<CR>
nnoremap <leader>x :call <SID>MaximizeTerminalBuffer('right')<CR>
nnoremap <silent> <leader>c :MaximizeIPythonBuffer<CR>
nnoremap <silent> <leader>b :ResetWindowsDefault<CR>
nnoremap <silent> <leader>z :ResetWindowsMaxEditor<CR>
nnoremap <silent> <leader>v :EnlargedWindow<CR>
nnoremap <leader>i :vertical resize <C-r>=input('Resize to: ')<CR><CR>
xnoremap <silent> <leader>p :<C-u>call SendToIPython()<CR>
xnoremap <silent> <leader>l :<C-u>call SendToTermiC()<CR>
nnoremap <silent> <leader>n :RestartIPython<CR>
vnoremap <silent> <leader>m :<C-u>call AppendToEditor()<CR>
nnoremap <silent> <leader>o :ChatGPT<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>g :call Grid(5, 10)<CR>  " Lift 5x10 gate
nnoremap <leader>f :call Grid(10, 10)<CR> " Lift 10x10 gate
nnoremap <leader>w :W<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>e :Files<CR>
inoremap jk <Esc>
tnoremap jk <C-\><C-n>
command! Hs split
command! Q call ForceQuitAndKillTmux()

" Initialization
autocmd! VimEnter *
autocmd VimEnter * colorscheme default
autocmd VimEnter * NERDTree
autocmd FileType nerdtree nnoremap <buffer> <leader>w :wincmd l \| :W<CR>
autocmd VimEnter * vertical resize 18
autocmd VimEnter * wincmd l
autocmd VimEnter * topleft split
autocmd VimEnter * terminal ipython
autocmd VimEnter * resize 26
autocmd VimEnter * belowright split
autocmd VimEnter * terminal bash -c 'termic cpp; exec bash -i'
autocmd VimEnter * belowright vs
autocmd VimEnter * vertical resize 45
autocmd VimEnter * terminal
autocmd VimEnter * resize 12
autocmd VimEnter * wincmd j
autocmd VimEnter * wincmd l


" Command :Q to force quit all Vim buffers and kill the tmux session
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


" Guard to prevent repeated calls
let s:is_running = 0
let s:last_run = 0
let s:debounce_ms = 500  " Only allow one run every 500ms


" Send to IPython
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

" Send to TermiC
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
    " Ensure visual mode is exited
    if mode() =~# '[vV]'
      execute "normal! \<Esc>"
    endif
  endtry
endfunction

" Append any buffer selection to editor buffer
function! AppendToEditor() abort
  " Initialize debounce variables
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

function! s:ResetWindowSizes(maximize_editor) abort
  let current_win = winnr()
  let ipython_win = 0
  let term_win = 0
  let nerdtree_win = 0
  let edit_win = 0
  for w in range(1, winnr('$'))
    let buf = winbufnr(w)
    let bufname = bufname(buf)
    if getbufvar(buf, '&filetype') == 'nerdtree'
      let nerdtree_win = w
    elseif getbufvar(buf, '&buftype') == 'terminal'
      if bufname =~ 'ipython'
        let ipython_win = w
      elseif bufname =~ 'termic'
        let term_win = w
      endif
    else
      let edit_win = w
    endif
  endfor
  if nerdtree_win > 0
    execute nerdtree_win . 'wincmd w'
    vertical resize 18
  endif
  if ipython_win > 0
    execute ipython_win . 'wincmd w'
    resize 12
    setlocal winfixheight
  endif
  if term_win > 0
    execute term_win . 'wincmd w'
    if !a:maximize_editor
      vertical resize 33  
      resize 12          
    else
      vertical resize 1   " Minimize width when maximizing editor
      resize 1           " Minimize height when maximizing editor
    endif
  endif
  if edit_win > 0
    execute edit_win . 'wincmd w'
  else
    wincmd l
    let edit_win = winnr()
  endif
  if a:maximize_editor
    wincmd _  " Maximize height
    wincmd |  " Maximize width
  else
    vertical resize 89  " Default editor width
  endif
  wincmd j
  wincmd l
  if nerdtree_win > 0
    execute nerdtree_win . 'wincmd w'
    vertical resize 18
  endif
  if edit_win > 0
    execute edit_win . 'wincmd w'
  else
    wincmd j
    wincmd l
  endif
  echom "SET SIZE | " . (a:maximize_editor ? "Focus : (File Editor)" : "Reset Default Configuration") . ""
endfunction

" Focus IPython buffer
function! MaximizeIPythonBuffer() abort
  silent! try
    " Save initial window
    let l:initial_win = winnr()
    " Find all terminal windows
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
        silent! resize 1 " Minimize to smallest possible height
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
function! s:EnlargeWindow() abort
  wincmd _
  echom "SET SIZE | Focus: (Currently Selected Buffer)"
endfunction

" Command to restart IPython terminal
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

" Grid: Draw 10x10 or 5X10 grid
function! Grid(...) abort
    if exists('b:grid_row_grp') || exists('b:grid_prev_cc')
        call matchdelete(b:grid_row_grp)
        let &colorcolumn = b:grid_prev_cc
        unlet b:grid_row_grp b:grid_prev_cc
"       echo "PORTCULLIS | Gates have been raised"
        return
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
"   echo "PORTCULLIS | Gates have been lowered: rows every " . dr . ", cols every " . dc
    echo "GRID | Grid On " . dr . ", cols every " . dc
endfunction


" Grid styling
augroup Grid
    autocmd!
    autocmd ColorScheme * highlight clear ColorColumn | highlight ColorColumn ctermbg=239 guibg=#4e4e4e
highlight ColorColumn ctermbg=239 guibg=#4e4e4e
