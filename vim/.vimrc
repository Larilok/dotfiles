set nocompatible
filetype plugin indent on
au FileType python setlocal expandtab shiftwidth=2

let g:mapleader=','

" TODO: is it usefull
nnoremap ; :
nnoremap : ;
nnoremap <CR> o<Esc>
nnoremap <S-CR> O<Esc>
nnoremap n nzz
nnoremap N Nzz

" correct scrolling in tmux with 'set -g mouse on'
set mouse=a

" Avoid unintentional switches to Ex mode
nmap Q q

if has("autocmd")
  autocmd BufRead *.sql set filetype=postgersql
endif

scriptencoding utf-8
" source  ~/vim/plugs/def_plugs.vim
call plug#begin('$HOME/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'

Plug 'Valloric/YouCompleteMe'
"colorschemes
Plug 'morhetz/gruvbox'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'easymotion/vim-easymotion'
" badass statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" vim and tmux nav w/ C-[hjkl]
Plug 'christoomey/vim-tmux-navigator'

" syntax highlighting and improved indentation
Plug 'pangloss/vim-javascript'

" providing linting, acts as a Vim LSP client
Plug 'w0rp/ale'

call plug#end()

"''''''''''''''''''''''''''''''
"
" SETTINGS & KEYBINDINGS
"
"''''''''''''''''''''''''''''''

set backspace=indent,eol,start   " def in Nvim
set showcmd
set showmode
set scrolloff=5

" syntax highlighting
syntax on
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum""]]"

set t_Co=256
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
"let g:gruvbox_termcolors=16

set shortmess+=a " show abriviations only `[w]` instead of `[written]`
set shortmess+=t " truncate file messages at start
set shortmess+=T " truncate non-file messages in middle
set shortmess+=A " no swapfile attention message

set laststatus=2 " always show status L
set statusline=%f "tail of the filename
set statusline+=\ c:%c  "column number
set statusline+=%=  " to the right side
set lazyredraw " macro works fine, cos not updating screen during macro playback

set formatoptions+=j      " remove comment leader when joining comment lines
set formatoptions+=n      " recognize number lists, needs 'autoindent'
set autoindent            " def in Nvim

" indicate all unnessesary stuff
set list                    "show whitespaces
set listchars=nbsp:⦸
set listchars+=tab:▷┅
set listchars+=extends:»
set listchars+=trail:•
set listchars+=precedes:«

set number
set relativenumber        " convenient numers
set numberwidth=5
set expandtab
set tabstop=2
set shiftwidth=2
set smarttab

set nocursorline
set nocursorcolumn

set virtualedit=block     "convenient selection in virtual mode

" Annoying things
set noswapfile
set nobackup
set splitright
set splitbelow

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

" Folds setup
if has('folding')
  if has('windows ')
    let &fillchars='vert: '       "less cluttered vertical window separators
  endif
  set foldmethod=indent           "Lines with equal indent form a fold.
  set foldlevelstart=3           "TODO: get used to folding and set to 99
  nnoremap <S-tab> za
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
endif

nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?


nmap <Leader>n :NERDTreeToggle<CR>
map <Leader> <Plug>(easymotion-prefix)
nnoremap <Leader>o :only<CR>
nnoremap <Leader>p :echo expand('%')<CR>    " usefull when status line get truncated by a lot of splits
nnoremap <Leader>r :redraw!<Enter>
" append ';' to the end of the linemap
nnoremap <Leader>; m`A;<Esc>``
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" ---------- VIM-TMUX-NAVIGATOR Settings -------------------
" Write the current buffer, but only if changed before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1


" ---------- ALE Settings -------------------
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_linters = {
\   'javascript': ['eslint'],
\}
let g:airline#extensions#ale#enabled = 1

" Moving text around easly
xnoremap <silent> K :call <SID>move_up()<CR>
xnoremap <silent> J :call <SID>move_down()<CR>

function! s:Visual()
    return visualmode() == 'V'
endfunction

function! s:Move(address, should_move)
  if s:Visual() && a:should_move
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction

function! s:move_up() abort range
  let l:count=v:count ? -v:count : -1
  let l:max=(a:firstline - 1) * -1
  let l:movement=max([l:count, l:max])
  let l:address="'<" . (l:movement -1)
  let l:should_move=l:movement < 0
  call s:Move(l:address, l:should_move)
endfunction

function! s:move_down() abort range
  let l:count=v:count ? -v:count : 1
  let l:max=line('$') - a:lastline
  let l:movement=min([l:count, l:max])
  let l:address="'>+" . l:movement
  let l:should_move=l:movement > 0
  call s:Move(l:address, l:should_move)
endfunction


" source $VIMRUNTIME/defaults.vim
set wildmenu
set wildmode=longest:full,full
" NERDTree config

let g:NERDTreeWinSize=40
let g:NERDTreeMouseMode=2
let g:NERDTreeCreatePrefix='silent keepalt keepjumps'

if &term =~ "xterm"
  " 256 colors
  let &t_Co = 256
  " restore screen after quitting
  let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
  let &t_te = "\<Esc>[?47l\<Esc>8"
  if has("terminfo")
    let &t_Sf = "\<Esc>[3%p1%dm"
    let &t_Sb = "\<Esc>[4%p1%dm"
  else
    let &t_Sf = "\<Esc>[3%dm"
    let &t_Sb = "\<Esc>[4%dm"
  endif
endif
