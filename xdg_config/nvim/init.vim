" neovim configuration

" Precede each line with its line number.
set number
" Show the line number relative to the line with the cursor.
set relativenumber

" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4
" Number of spaces that a <Tab> counts for while performing editing
" operations.
set softtabstop=4
" Use the appropriate number of spaces to insert a <Tab>.
set expandtab
" Round indent to multiple of `shiftwidth`.
set shiftround

" string to put at the start of lines that have been wrapped
set showbreak=↳\

" Enable mouse support for all the modes.
set mouse=a

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Get the standard keys to work with wrap
map <silent> k gk
map <silent> j gj
map <silent> 0 g0
map <silent> $ g$

nnoremap ; :

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=8



" Third-party plugins
" Requires vim-plug: https://github.com/junegunn/vim-plug

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
