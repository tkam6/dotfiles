" =============
" ===== OPTIONS
" =============
scriptencoding utf-8
set encoding=utf-8
set expandtab
set incsearch
set relativenumber
set number
set ruler
set tabstop=4
set cursorline
set colorcolumn=80
set backspace=indent,eol,start
set splitright
set syntax=on
set title
set titlestring=%y\ %F\ %m\ %r
set termguicolors
set wildmenu
set wildmode=longest:list,full
set wrap
set list
" set listchars=eol:§,space:·,tab:→·,trail:•,extends:»,precedes:«
set listchars=space:·,tab:«-»,precedes:🡰,extends:🡲,eol:¶
set fillchars=eob:&
set showtabline=2
set showmatch
set matchpairs+=<:>
set autoindent
set background=dark

" ==========================
" ===== CURSOR VISUAL STYLES
" ==========================
" let &t_EI = "\033[2 q" " NORMAL  █
" let &t_SI = "\033[5 q" " INSERT  |


" === COLOURS ===
highlight Normal cterm=NONE gui=NONE
highlight CursorLine cterm=NONE gui=NONE
highlight CursorLineNr cterm=NONE gui=NONE
highlight TabLineSel cterm=NONE gui=NONE
" highlight Normal guibg=#000000
highlight CursorLine guibg=#303030
highlight CursorLineNr guifg=#F8FF00
highlight ColorColumn guibg=#202050
highlight LineNr guifg=#757575
highlight TabLine guibg=#303030 guifg=#FFFFFF
highlight TabLineFill guibg=#000000
highlight TabLineSel guibg=#50AA10 guifg=#FFFFFF
highlight NonText guifg=#505050
highlight SpecialKey guifg=#505050
highlight EndOfBuffer guifg=#808080
highlight SignColumn guibg=#000000 guifg=#FF0000
highlight TrailingWS guibg=#CC5050 guifg=#FFFFFF
match TrailingWS /\s\+$/


" =============
" ===== KEYMAPS
" =============
"inoremap <F1> <C-o>:tabp<CR>
"inoremap <F2> <C-o>:tabn<CR>
map      <F1>    :tabp<CR>
map      <F2>    :tabn<CR>
map      <F3>    <nop>
map      <F4>    :help<CR>
map      <Space> $
map      <BS>    ^
noremap  <F6>    :set list!<CR>
inoremap <F1>    <Esc>:tabp<CR>i
inoremap <F2>    <Esc>:tabn<CR>i
vnoremap <       <gv
vnoremap >       >gv
vnoremap <F6>    :set list!<CR>
" stop Fn keys getting inserted literally in INS mode
let fn_key_num = 1
while fn_key_num <= 12
    execute 'inoremap' '<F' .. fn_key_num .. '>' '<nop>'
    let fn_key_num = fn_key_num + 1
endwhile


" =====================
" ===== CUSTOM COMMANDS
" =====================
command! -bang -nargs=* W write<bang> <args>
command! -bang -nargs=* Q quit<bang> <args>
command! -bang -nargs=* Qa quitall<bang> <args>
command! -bang -nargs=* QA quitall<bang> <args>


" ====================
" ===== PLUGIN MANAGER
" ====================
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
