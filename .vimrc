set encoding=utf-8
scriptencoding utf-8


"""""""""""
" Plugins "
"""""""""""

" Remember to install latex package for amsmath.
" Step 1. Download the package from here: http://www.drchip.org/astronaut/vim/index.html#LATEXPKGS
" Step 2. Open amsmath.vba with vim
" Step 3. :so %

" Enable completion where available. This setting must be set before ALE is loaded.
" Completion uses language servers (e.g., pyls for python, metals for scala), so the
" language servers need to be installed.
let g:ale_completion_enabled = 1

filetype off

if empty(glob('~/.vim/autoload/plug.vim'))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'tomtom/tcomment_vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'  " Asynchronous Lint Engine
Plug 'maverickg/stan.vim'  " Vim syntax highlighting for Stan modeling language
" Plug 'derekwyatt/vim-scala'

if executable('fzf')
    Plug 'junegunn/fzf.vim'  " Requires fzf on $PATH
endif

" Initialize plugin system
call plug#end()

filetype plugin indent on


"""""""""""""""""""
" Persistent Undo "
"""""""""""""""""""

" create undodir
if !isdirectory($HOME.'/.cache/vim_undo')
    call mkdir($HOME.'/.cache/vim_undo', '', 0700)
endif

" List of directory names for undo files, separated with commas.
set undodir=~/.cache/vim_undo

" automatically saves undo history to an undo file when writing a buffer to a
" file, and restores undo history from the same file on buffer read
set undofile


"""""""""""""""""""""""
" Color Scheme        "
"""""""""""""""""""""""

syntax enable
set background=dark

colorscheme default

" number of colors
set t_Co=256

" trailing whitespace and column; must define AFTER colorscheme, setf, etc!
hi ColorColumn ctermbg=black guibg=darkgray
hi WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+\%#\@<!$/

" highlight column 80 and onward
hi ColorColumn ctermbg=darkgray guibg=darkgray
" augroup highlight_first_columns
"     autocmd FileType python let &colorcolumn=join(range(80,999),',')
"     autocmd FileType r let &colorcolumn=join(range(80,999),',')
" augroup end

" Change the vimdiff highlighting colours, to be easier on eyes.
" https://stackoverflow.com/questions/2019281/load-different-colorscheme-when-using-vimdiff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red


"""""""""""""""
" Status Line "
"""""""""""""""

" the last window always have the statusline
set laststatus=2

set statusline=
set statusline+=%n:  " buffer number
set statusline+=\ %f  " relative path
set statusline+=\ %m%r%h%w  " flags
set statusline+=\ %{tagbar#currenttag('>\ %s','','f')}  " show current tag's full hierarchy
set statusline+=%=  " seperate between right- and left-aligned
set statusline+=%{&spelllang}
set statusline+=\ %y  " file type
set statusline+=\ (row:%l/%L,\ col:%c)  " line and column


"""""""""""""""""""""
" Window Management "
"""""""""""""""""""""

" When on, splitting a window will put the new window below the current one. |:split|
" set splitbelow

" When on, splitting a window will put the new window right of the current one.
" |:vsplit|
" set splitright

"""""""""""""
" File Type "
"""""""""""""

" when this option is set, the FileType autocommand event is triggered
filetype on

augroup set_mail_filetype
    autocmd BufRead sup.* set filetype=mail
    autocmd BufRead alot.* set filetype=mail
    autocmd BufRead mutt-* set filetype=mail
    autocmd BufRead neomutt-* set filetype=mail
    autocmd BufRead *.R set filetype=r
augroup end


""""""""""""""""
" Backup Files "
""""""""""""""""

" backup a file while editing
set writebackup

" delete backup when the file is successfully saved
set nobackup


""""""""""""""""""""
" Bracket Matching "
""""""""""""""""""""

" redraw the screen while executing macros, registers and other commands
" set nolazyredraw

" do not redraw the screen while executing macros, registers and other commands
set lazyredraw

" when a bracket is inserted, briefly jump to the matching one
" set showmatch
set noshowmatch

" tenths of a second to show the matching paren, when 'showmatch' is set
" set matchtime=1

" highlight the character under the cursor if it is a paird bracket.
" cterm determines the style, which can be none, underline or bold, while
" ctermbg and ctermfg are, as their names suggest, background and foreground
" colors
highlight MatchParen cterm=underline ctermbg=none ctermfg=none


""""""""""""""""""
" Line Numbering "
""""""""""""""""""

" line numbers
set number

" show the line number relative to the line with the cursor in front of each line
set relativenumber

" show the line and column number of the cursor position, separated by a comma
" set ruler

" show (partial) command in the last line of the screen
set showcmd

" highlight the screen line of the cursor
" set cursorline


""""""""""
" Search "
""""""""""

" while typing a search command, show where the pattern, as it was typed so far, matches
set incsearch

" ignore case in search patterns
set ignorecase

" override the 'ignorecase' option if the search pattern contains upper case characters
set smartcase


"""""""""""""""
" Indentation "
"""""""""""""""

" copy indent from current line when starting a new line
set autoindent

" do smart autoindenting when starting a new line
" set smartindent  " this messes up gqap

" when in unclosed parentheses, indent to the unclosed parentheses
" set cino=(0

" number of spaces to use for each step of (auto)indent
set shiftwidth=4

" in insert mode: use the appropriate number of spaces to insert a <Tab>
set expandtab

" number of spaces that a <Tab> counts for while performing editing operations
set softtabstop=4

" round indent to multiple of 'shiftwidth'
set shiftround

" a <Tab> in front of a line inserts blanks according to 'shiftwidth'
set smarttab

" Disable auto-indentation when editing Python scripts.
" By default, when you insert :, for example, vim indents the line you are
" editing. I find this annoying.
augroup disable_python_autoindentation
    autocmd FileType python setlocal indentkeys=
augroup end


"""""""""""""""""
" Line Wrapping "
"""""""""""""""""

" Change the way text is displayed.  This is comma separated list of flags:
" lastline	When included, as much as possible of the last line in a window will be displayed.
" uhex		Show unprintable characters hexadecimal as <xx> instead of using ^C and ~C
set display=lastline,uhex

" wrap long lines at a character in 'breakat' rather than at the last character that fits on the
" screen
set linebreak

" lines longer than the width of the window will wrap and displaying continues on the next line
" set wrap

" string to put at the start of lines that have been wrapped
set showbreak=↳\

" maximum width of text that is being inserted.  A longer line will be broken after white space to
" get this width.
" set textwidth=88
" augroup set_textwidth
"     autocmd FileType python setlocal textwidth=79
" augroup end


"""""""""
" Mouse "
"""""""""

" name of the terminal type for which mouse codes are to be recognized
if !has('nvim')
    " This option is removed in neovim
    set ttymouse=xterm2
endif

" enable the use of the mouse in all modes
set mouse=a


"""""""""""
" Folding "
"""""""""""

" sets 'foldlevel' when starting to edit another buffer in a window
" all folds closed (value zero), some folds closed (one) or no folds closed (99)
set foldlevelstart=99

" the kind of folding used for the current window
set foldmethod=syntax

augroup set_folding_option
    " index based folding for python
    autocmd FileType python set foldmethod=indent

    " fold out of paragraphs separated by blank lines: >
    autocmd FileType tex set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
    autocmd FileType tex set foldmethod=expr
    autocmd FileType rnoweb set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
    autocmd FileType rnoweb set foldmethod=expr
augroup end


""""""""""""
" Encoding "
""""""""""""

" sets the character encoding for the file of this buffer.
setglobal fileencoding=utf-8

" do not prepend a BOM (Byte Order Mark)
set nobomb


""""""""""""""""""
" Spell Checking "
""""""""""""""""""

augroup set_spellcheck_options
    autocmd FileType rst setlocal spell spelllang=en_gb
    autocmd FileType rst syntax spell toplevel  " spell check

    autocmd FileType markdown setlocal spell spelllang=en_gb
    autocmd FileType markdown syntax spell toplevel  " spell check

    autocmd FileType text setlocal spell spelllang=en_gb
    autocmd FileType text syntax spell toplevel  " spell check

    autocmd FileType tex setlocal spell spelllang=en_gb
    autocmd FileType tex syntax spell toplevel  " spell check
    autocmd FileType rnoweb setlocal spell spelllang=en_gb
    autocmd FileType rnoweb syntax spell toplevel  " spell check

    autocmd FileType help syntax spell notoplevel  " no spell check

    autocmd FileType vim syntax spell notoplevel

    autocmd FileType mail setlocal spell spelllang=en_gb
    autocmd FileType mail syntax spell toplevel  " spell check
augroup end


"""""""""""""""""""
" Word Completion "
"""""""""""""""""""

" This option specifies a function to be used for Insert mode omni completion with CTRL-X CTRL-O.
" set omnifunc=syntaxcomplete#Complete

" This option specifies how keyword completion |ins-completion| works when CTRL-P or CTRL-N are used.  It is also used for whole-line completion |i_CTRL-X_CTRL-L|.
" . scan the current buffer ('wrapscan' is ignored)
" w scan buffers from other windows
" b scan other loaded buffers that are in the buffer list
" u scan the unloaded buffers that are in the buffer list
" U scan the buffers that are not in the buffer list
" k scan the files given with the 'dictionary' option
" kspell  use the currently active spell checking |spell|
" k{dict} scan the file {dict}.  Several "k" flags can be given, patterns are valid too.
" s scan the files given with the 'thesaurus' option
" s{tsr} scan the file {tsr}.  Several "s" flags can be given, patterns are valid too.
" i scan current and included files
" d scan current and included files for defined name or macro |i_CTRL-X_CTRL-D|
" ] tag completion
" t same as "]"
" The default is ".,w,b,u,t,i"

" Do not scan included files (can be very slow with C++)
set complete-=i

" list of file names, that are used to lookup words for keyword completion commands
" pacman -S words
set dictionary+=/usr/share/dict/words

" this option specifies how keyword completion ins-completion works when CTRL-P or CTRL-N are used.
" k	scan the files given with the 'dictionary' option
" kspell  use the currently active spell checking spell
augroup set_autocomplete_options
    autocmd FileType rst setlocal complete+=k,kspell
    autocmd FileType text setlocal complete+=k,kspell
    autocmd FileType tex setlocal complete+=k,kspell
    autocmd FileType rnoweb setlocal complete+=k,kspell
    autocmd FileType mail setlocal complete+=k,kspell
augroup end


"""""""""""""""""""""""
" Filename Completion "
"""""""""""""""""""""""

" command-line completion operates in an enhanced mode
set wildmenu

" completion mode that is used for the character specified with 'wildchar'
" complete till longest common string, also start 'wildmenu' if it is enabled
set wildmode=longest:full

" a file that matches with one of these patterns is ignored when expanding wildcards
set wildignore+=*.o,*.pyc


""""""""""""
" Bindings "
""""""""""""

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"get the standard keys to work with wrap
" map <silent> k gk
" map <silent> j gj
" map <silent> 0 g0
" map <silent> $ g$

let mapleader=' '

nnoremap ; :

function! SearchWord()
    " Look up the word under the cursor in a dictionary (stardict).
    " This method requires 'sdcv' (stardict console version) installed.
    " Inspired by https://github.com/chusiang/vim-sdcv
    " Informed by https://vim.fandom.com/wiki/Display_output_of_shell_commands_in_new_window
    let expl=system('sdcv -n ' . expand('<cword>'))
    windo if expand("%")=="dictionary" | q! | endif
    20sp dictionary
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    execute '1s/^/\=expl/'
    setlocal nomodifiable
    1
endfunction

" <F2> is [12~ (check with Ctrl-V then F2)
noremap [12~ :call SearchWord()<CR>
noremap <F2> :call SearchWord()<CR>
nnoremap <leader>sw :call SearchWord()<CR>

" :CDC to change to directory of current file
command CDC cd %:p:h

" press the bound key and clang-format will format the current line in NORMAL
" mode or the selected region in VISUAL mode.
" map <F10> :pyf /usr/share/clang/clang-format.py<cr>

nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>



"""""""""
" netrw "
"""""""""
" netrw is the file browser that ships with vim.

" Suppress the banner
let g:netrw_banner = 0

" Set the default listing style:
" 0: thin listing (one file per line)
" 1: long listing (one file per line with time stamp information and file size)
" 2: wide listing (multiple files in columns)
" 3: tree style listing
let g:netrw_liststyle = 3

" specify initial size of new windows made with "o" (see |netrw-o|), "v" (see
" |netrw-v|), |:Hexplore| or |:Vexplore|.  The g:netrw_winsize is an integer describing
" the percentage of the current netrw buffer's window to be used for the new window.
" If g:netrw_winsize is less than zero, then the absolute value of g:netrw_winsize will
" be used to specify the quantity of lines or columns for the new window.
let g:netrw_winsize = -30

nnoremap <leader>ee :Lexplore<CR><c-w><c-p>


"""""""""""""""""""""
" plugin: UltiSnips "
"""""""""""""""""""""

let g:UltiSnipsSnippetDirectories=['ultisnips']
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsListSnippets='<s-tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'


""""""""""""""""""""
" plugin: tcomment "
""""""""""""""""""""

augroup set_tcomment_options
    autocmd FileType pyrex setlocal commentstring=#\ %s
    autocmd FileType stan setlocal commentstring=//\ %s
augroup end


""""""""""""""""""
" plugin: tagbar "
""""""""""""""""""

" sort tags according to their order in the source file
let g:tagbar_sort = 0

" noremap [19~ :TagbarToggle<CR>
" noremap <F8> :TagbarToggle<CR>
nnoremap <leader>tt :TagbarToggle<CR>


"""""""""""""""
" plugin: ale "
"""""""""""""""

" Note: outputs from linters appear in loclist. You can open loclist with :lopen <height>

" enable  all linters available for a given filetype
" See [here](https://github.com/dense-analysis/ale/tree/master/ale_linters)
" for available options.
let g:ale_linters = {}
let g:ale_linters['cpp'] = ['all']
let g:ale_linters['python'] = ['pylint', 'pydocstyle']
let g:ale_linters['r'] = ['lintr']
let g:ale_linters['sh'] = ['shell', 'shellcheck']
let g:ale_linters['vim'] = ['vint']
" let g:ale_linters['scala'] = ['metals', 'scalastyle', 'sbtserver', 'scalac']
let g:ale_linters['scala'] = ['metals', 'sbtserver', 'scalac']

" See
" [here](https://github.com/dense-analysis/ale/tree/master/autoload/ale/fixers)
" for available options.
let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers['c'] = ['clang-format']
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['json'] = ['prettier']
let g:ale_fixers['markdown'] = ['prettier']
let g:ale_fixers['python'] = ['black']
let g:ale_fixers['r'] = ['styler']
let g:ale_fixers['scala'] = ['scalafmt']
let g:ale_python_black_options = '--line-length=79'

" Fix files when they are saved.
let g:ale_fix_on_save = 1

" Use ALE's function for omnicompletion.
" set omnifunc=ale#completion#OmniFunc

" ALE Automatic completion implementation replaces |completeopt| before opening
" the omnicomplete menu with <C-x><C-o>. In some versions of Vim, the value set
" for the option will not be respected. If you experience issues with Vim
" automatically inserting text while you type, set the following option in
" vimrc, and your issues should go away. Note: documentation is shown in popups.
" if !has('nvim')
"     set completeopt=menu,menuone,popup,noselect,noinsert
" endif
set completeopt=menu,menuone,popup

nmap <leader>ah :ALEHover<CR>
nmap <leader>ag :ALEGoToDefinitionInSplit<CR>


"""""""""""""
" Formatter "
"""""""""""""
" when you select lines and hit gq (the default mapping unless you remapped
" it). It will filter the lines through autopep8 and writes the nicely
" formatted version in place.  The hyphen '-' at the end of the command is
" required for autopep8 to read the lines from the standard in.
" augroup set_formatter_options
"     " autocmd FileType python setlocal formatprg=autopep8\ -
"     autocmd FileType java setlocal formatprg=astyle\ --style=java
" augroup end



"""""""""""""""
" plugin: fzf "
"""""""""""""""

if executable('fzf')
    nnoremap <leader>ff :FZF<CR>
    nnoremap <leader>fb :Buffers<CR>
    nnoremap <leader>ft :BTags<CR>
    if executable('rg')
        " Requires ripgrep
        nnoremap <leader>fs :Rg<CR>
    endif
endif


""""""""
" Misc "
""""""""

" Use visual bell instead of beeping.
set visualbell
" When no beep or flash is wanted, use ":set vb t_vb="
set t_vb=
augroup set_beep_options
    autocmd GUIEnter * set vb t_vb=
augroup end

" When a file has been detected to have been changed outside of Vim and it has
" not been changed inside of Vim, automatically read it again.
set autoread

" allow backspacing over everything in insert mode
set backspace=eol,start,indent

" set the number of commands that are remembered (default: 50)
set history=100

" command history file
if !has('nvim')
    set viminfo+=n/home/takao/.cache/viminfo
else
    " for neovim
    set viminfo+=n/home/takao/.cache/nviminfo
endif

" end-of-line (<EOL>) formats
set fileformats=unix,dos

" strings to use in 'list' mode and for the :list command
set list
set listchars=tab:↹·,extends:⇉,precedes:⇇,nbsp:␠,trail:␠,nbsp:␣

" Set 7 lines to the cursors - when moving vertical..
set scrolloff=7

" Set extra options when running in GUI mode
if has('gui_running')
    set guioptions-=T  " remove toolbar at the top with icons
    set guioptions-=r  " remove right-hand scrollbar
    set guioptions-=L  " remove left-hand scrollbar
    set guicursor+=a:blinkon0
endif

augroup make_on_save
    " Call make after every tex file save.
    autocmd BufWritePost *.tex make
    autocmd BufWritePost *.Rnw make
augroup end

highlight MatchParen cterm=underline ctermbg=none ctermfg=none

" Last but not least, allow for local overrides
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
