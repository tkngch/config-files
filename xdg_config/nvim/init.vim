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

" List mode to display tabs and spaces.
set list
set listchars=tab:→\ ,extends:⇉,precedes:⇇,trail:␠,nbsp:␣

" string to put at the start of lines that have been wrapped
set showbreak=↳\

" Enable mouse support for all the modes.
set mouse=a

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=8

" Use the clipboard for all operations
set clipboard+=unnamedplus

" Highlight the yanked text
au TextYankPost * lua vim.highlight.on_yank()


" map <Esc> to exit terminal-mode:
tnoremap <Esc> <C-\><C-n>

" use `ALT+{h,j,k,l}` to navigate windows from any mode:
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Alt+Tab to audo-complete
inoremap <A-Tab> <C-n>
inoremap <A-S-Tab> <C-p>

" Get the standard keys to work with wrap
map <silent> k gk
map <silent> j gj
map <silent> 0 g0
map <silent> $ g$

nnoremap ; :
let mapleader=' '


" Third-party plugins
" Requires vim-plug: https://github.com/junegunn/vim-plug
call plug#begin(stdpath('data') . '/plugged')

" lua module, required by telescope
Plug 'nvim-lua/plenary.nvim'
" fuzzy finder for files, buffers, and more
Plug 'nvim-telescope/telescope.nvim'
" configurations for Neovim's built-in language server client
Plug 'neovim/nvim-lspconfig'
" to change the working directory to the project root
Plug 'airblade/vim-rooter'
" to comment/uncomment code
Plug 'tomtom/tcomment_vim'
" to enable syntax-highlighting for many languages
Plug 'sheerun/vim-polyglot'
" to indicate added, modified and removed lines with a version control system
Plug 'mhinz/vim-signify'
" file system explorer
Plug 'preservim/nerdtree'
" color scheme
Plug 'joshdick/onedark.vim'

" Initialize plugin system
call plug#end()

" LSP
lua << EOF
require('lspconfig').pyright.setup{}
EOF

" Find files using Telescope command-line sugar.
nnoremap <leader>fd <cmd>Telescope file_browser<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fs <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

lua << EOF
require('telescope').setup{
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = { vertical = { mirror = true, }, },
  }
}
EOF

" nerdtree
map <leader>tt :NERDTreeToggle<CR>

" onedark
try
    colorscheme onedark
catch
endtry
