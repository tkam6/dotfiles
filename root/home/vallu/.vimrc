" === OPTIONS ===
scriptencoding utf-8
set encoding=utf-8
" No newline at the end of files automatically inserted! Hooray!
" set binary
" set nofixeol
" set noeol
set expandtab
set incsearch
set relativenumber
set number
" Far-right cursor position info
set ruler
set tabstop=4
set cursorline
set colorcolumn=80
" Make backspace work in insert mode
set backspace=indent,eol,start
set splitright
set syntax=on
set title
set titlestring=%y\ %F\ %m\ %r
set termguicolors
" Directory tree
set wildmenu
set wildmode=longest:list,full
set wrap
" Display non-display characters
set list
set listchars=eol:§,space:·,tab:→·,trail:•,extends:»,precedes:«
set fillchars=eob:␀
" Always show open buffer list
set showtabline=2
set showmatch
set matchpairs+=<:>
set autoindent
" set smartindent
set background=dark


" === AUTOCMD ===
" For noeol and nofixeol
" autocmd BufReadPost * setlocal noeol
" autocmd BufNewFile * setlocal noeol


" Cursor visual styles
" let &t_EI = "\033[2 q" " NORMAL  █
" let &t_SI = "\033[5 q" " INSERT  |

" === DIRECTORY TREE VARILABLES ===
let g:netrw_winsize=-28
let g:netrw_banner=0
let g:netrw_liststyle=3


" === COLOURS ===
highlight Normal cterm=NONE gui=NONE
highlight CursorLine cterm=NONE gui=NONE
highlight CursorLineNr cterm=NONE gui=NONE
highlight TabLineSel cterm=NONE gui=NONE
highlight Normal guibg=#000000
highlight CursorLine guibg=#454545
highlight CursorLineNr guifg=#F8FF00
highlight ColorColumn guibg=#502000
highlight LineNr guifg=#757575
highlight TabLine guibg=#303030 guifg=#FFFFFF
highlight TabLineFill guibg=#000000
highlight TabLineSel guibg=#50AA10 guifg=#FFFFFF
highlight NonText guifg=#801400
highlight SpecialKey guifg=#4A0600 guibg=NONE
highlight EndOfBuffer guifg=#CC0000
highlight SignColumn guibg=#000000 guifg=#FF0000
highlight TrailingWS guifg=#CC0000 guibg=#CCCCCC
" match oru thadava thaan vara mudiyum, athanala ithu payanpaduthu
" call matchadd('TrailingWS', '\s\+$')


" === KEYMAPS ===
" ca tn tabnew
" ca th tabp
" ca tl tabn
map <F1>  :tabp<CR>
map <F2>  :tabn<CR>
map <F3>  <nop>
map <F4>  :help<CR>
" inoremap <F1> <Esc>:tabp<CR>i
" inoremap <F2> <Esc>:tabn<CR>i
inoremap <F1> <C-o>:tabp<CR>
inoremap <F2> <C-o>:tabn<CR>
inoremap <F3> <nop>
inoremap <F4> :help<CR>
map <Space> $
map <BS>    ^
" Keep selection when indenting by visual selection
vnoremap < <gv
vnoremap > >gv
" Insert matching characters automatically, pure Vim solution HAHAHAHAHA
" inoremap ( ()<Left>
" inoremap { {}<Left>
" inoremap [ []<Left>
" inoremap ' ''<Left>
" inoremap " ""<Left>
" inoremap        (    ()<C-G>U<Left> 
" inoremap <expr> )    strpart(getline('.'), col('.')-1, 1) == ")" ? "\<C-G>U\<Right>" : ")"
noremap  <F6> :set list!<CR>
vnoremap <F6> :set list!<CR>


" === CUSTOM COMMANDS ===
command! -bang -nargs=* W write<bang> <args>
command! -bang -nargs=* Q quit<bang> <args>
command! -bang -nargs=* Qa quitall<bang> <args>
command! -bang -nargs=* QA quitall<bang> <args>


" === PLUGIN MANAGER ===
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()

  " Plug 'itchyny/lightline.vim'
  " Plug 'sheerun/vim-polyglot'
  " Plug 'davidhalter/jedi-vim'
  " Plug 'ervandew/supertab'
  " Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
  " Plug 'vim-python/python-syntax'
  " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " Plug 'jiangmiao/auto-pairs'

call plug#end()
