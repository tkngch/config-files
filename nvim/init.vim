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

" Turn off the match highlighting.
set nohlsearch

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

" Get the standard keys to work with wrap
map <silent> k gk
map <silent> j gj
map <silent> 0 g0
map <silent> $ g$

nnoremap ; :
let mapleader=' '
let maplocalleader=' '


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

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" nerdtree
map <leader>tt :NERDTreeToggle<CR>

" onedark
set termguicolors
try
    colorscheme onedark
catch
endtry
