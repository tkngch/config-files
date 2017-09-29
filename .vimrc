" vimrc

" make vim more useful than vi. this option needs to come first in vimrc.
set nocompatible


"""""""""""
" Plugins "
"""""""""""

filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" Plugin 'chriskempson/base16-vim'
Plugin 'flazz/vim-colorschemes'
" Plugin 'scrooloose/syntastic'
Plugin 'tomtom/tcomment_vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'majutsushi/tagbar'
Plugin 'w0rp/ale'  " Asynchronous Lint Engine
Plugin 'ap/vim-buftabline'  " takes over the tabline and renders the buffer list in it
Plugin 'scrooloose/nerdtree'  " allows you to explore your filesystem and to open files and directories
" Plugin 'reedes/vim-wordy'  " Uncover usage problems in your writing
" Plugin 'vim-scripts/LanguageTool'  " Grammar checker for English, French, German (etc.)
" Plugin 'rhysd/vim-grammarous'  " A powerful grammar checker for Vim using LanguageTool
Plugin 'maverickg/stan.vim'  " Vim syntax highlighting for Stan modeling language


" Plugin 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on


"""""""""""""""""""
" Persistent Undo "
"""""""""""""""""""

" create undodir
if !isdirectory($HOME."/.cache/vim_undo")
    call mkdir($HOME."/.cache/vim_undo", "", 0700)
endif

" List of directory names for undo files, separated with commas.
set undodir=~/.cache/vim_undo

" automatically saves undo history to an undo file when writing a buffer to a
" file, and restores undo history from the same file on buffer read
set undofile

""""""""""""""""""""""""""""""""""""""""""""
" Color Scheme                             "
" depends: base16-vim and vim-colorschemes "
""""""""""""""""""""""""""""""""""""""""""""

syntax enable
set background=dark
" lucius does not seem to define the color of buffer tab, but gruvbox does.
" Load gruvbox first and let lucius over-ride some colours.
" colorscheme gruvbox
colorscheme lucius
" colorscheme Tomorrow-Night-Eighties

" " in GUI or color console, enable coloring and search highlighting
" if &t_Co > 2 || has("gui_running")
"     " syntax enable
"     " set background=dark
"     colorscheme base16-eighties
"
"     " when there is a previous search pattern, highlight all its matches
"     set hlsearch
" endif

" number of colors
set t_Co=256

" autocmd FileType javascript colorscheme lucius
" autocmd FileType tex colorscheme zenburn
" autocmd FileType sh colorscheme hemisu
" autocmd FileType bib colorscheme zenburn
" autocmd FileType python colorscheme wombat256mod

" trailing whitespace and column; must define AFTER colorscheme, setf, etc!
hi ColorColumn ctermbg=black guibg=darkgray
hi WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+\%#\@<!$/

" a comma separated list of screen columns that are highlighted with ColorColumn hl-ColorColumn
" highligh only when the line is too long
autocmd FileType python call matchadd('ColorColumn', '\%80v', 100)

" highlight too long line
autocmd FileType python highlight ColorColumn ctermbg=magenta


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


"""""""""""""
" File Type "
"""""""""""""

" when this option is set, the FileType autocommand event is triggered
filetype on

let g:tex_flavor = "latex"
autocmd BufRead sup.* set filetype=mail
autocmd BufRead alot.* set filetype=mail
autocmd BufRead mutt-* set filetype=mail
autocmd BufRead *.R set filetype=r


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
autocmd FileType mail set nonumber

" show the line number relative to the line with the cursor in front of each line
set relativenumber

" show the line and column number of the cursor position, separated by a comma
" set ruler

" show (partial) command in the last line of the screen
set showcmd

" highlight the screen line of the cursor
set cursorline


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


"""""""""""""""""
" Line Wrapping "
"""""""""""""""""

" Change the way text is displayed.  This is comma separated list of flags:
" lastline	When included, as much as possible of the last line in a window will be displayed.
" uhex		Show unprintable characters hexadecimal as <xx> instead of using ^C and ~C
set display=lastline,uhex

" wrap long lines at a character in 'breakat' rather than at the last character that fits on the screen
set linebreak

" lines longer than the width of the window will wrap and displaying continues on the next line
" set wrap

" string to put at the start of lines that have been wrapped
set showbreak=↳\

" maximum width of text that is being inserted.  A longer line will be broken after white space to get this width.
" set textwidth=80
" autocmd FileType text set textwidth=100
autocmd FileType tex set textwidth=100
autocmd FileType rnoweb set textwidth=100  " Rnw file
" autocmd FileType python set textwidth=78
" autocmd FileType mail set textwidth=72


"""""""""
" Mouse "
"""""""""

" name of the terminal type for which mouse codes are to be recognized
set ttymouse=xterm2

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

" index based folding for python
autocmd FileType python set foldmethod=indent


" fold out of paragraphs separated by blank lines: >
autocmd FileType tex set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
autocmd FileType tex set foldmethod=expr
autocmd FileType rnoweb set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
autocmd FileType rnoweb set foldmethod=expr



""""""""""""
" Encoding "
""""""""""""

" sets the character encoding used inside Vim
set encoding=utf-8

" sets the character encoding for the file of this buffer.
setglobal fileencoding=utf-8

" do not prepend a BOM (Byte Order Mark)
set nobomb


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

" """""""""""""""""""""
" " plugin: syntastic "
" """""""""""""""""""""
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_cpp_compiler_options = ' -std=c++11'
"
" " let g:syntastic_error_symbol = "☠"
" " let g:syntastic_warning_symbol = "⚠"
" " let g:syntastic_style_error_symbol = "☢"
" " let g:syntastic_style_warning_symbol = "☹"


""""""""""""""""""
" Spell Checking "
""""""""""""""""""

autocmd FileType rst setlocal spell spelllang=en_gb
autocmd FileType rst syntax spell toplevel  " spell check

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd FileType markdown syntax spell toplevel  " spell check

autocmd FileType text setlocal spell spelllang=en_gb
autocmd FileType text syntax spell toplevel  " spell check

autocmd FileType tex setlocal spell spelllang=en_us
autocmd FileType tex syntax spell toplevel  " spell check
autocmd FileType rnoweb setlocal spell spelllang=en_us
autocmd FileType rnoweb syntax spell toplevel  " spell check

autocmd FileType help syntax spell notoplevel  " no spell check

autocmd FileType vim syntax spell notoplevel

autocmd FileType mail setlocal spell spelllang=en_gb
autocmd FileType mail syntax spell toplevel  " spell check


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
autocmd FileType rst setlocal complete+=k,kspell
autocmd FileType text setlocal complete+=k,kspell
autocmd FileType tex setlocal complete+=k,kspell
autocmd FileType rnoweb setlocal complete+=k,kspell
autocmd FileType mail setlocal complete+=k,kspell


" """""""""""""""""""""""""
" " plugin: YouCompleteMe "
" """""""""""""""""""""""""
"
" " global config file
" " let g:ycm_global_ycm_extra_conf="$HOME/.vim/.ycm_extra_conf.py"
" let g:ycm_global_ycm_extra_conf="~/.vim/.ycm_extra_conf.py"
" let g:ycm_server_python_interpreter="/usr/bin/python"
"
" " use <c-n> and <c-p> instead of <tab>
" let g:ycm_key_list_select_completion=[]
" let g:ycm_key_list_previous_completion=[]
"
" " YCM will populate the location list automatically every time it gets new diagnostic data.
" " See :help location-list in Vim to learn more about the location list.
" let g:ycm_always_populate_location_list = 1
"
" let g:ycm_filetype_blacklist = {
"       \ 'tagbar' : 1,
"       \ 'qf' : 1,
"       \ 'notes' : 1,
"       \ 'markdown' : 1,
"       \ 'unite' : 1,
"       \ 'text' : 1,
"       \ 'vimwiki' : 1,
"       \ 'pandoc' : 1,
"       \ 'infolog' : 1,
"       \ 'mail' : 1,
"       \ 'tex': 1
"       \}

"""""""""""""""""""""
" plugin: UltiSnips "
"""""""""""""""""""""

" let g:UltiSnipsSnippetDirectories=['UltiSnips', 'ultisnips']
let g:UltiSnipsSnippetDirectories=['ultisnips', 'bundle/vim-snippets/UltiSnips']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


""""""""""""""""""""
" plugin: tcomment "
""""""""""""""""""""

autocmd FileType pyrex setlocal commentstring=#\ %s
autocmd FileType stan setlocal commentstring=//\ %s


""""""""""""""""""
" plugin: tagbar "
""""""""""""""""""

" Open the tagbar on the left.
" let g:tagbar_left = 1

" sort tags according to their order in the source file
let g:tagbar_sort = 0


""""""""""""""""""""""""""
" plugin: vim-grammarous "
""""""""""""""""""""""""""
" let g:grammarous#languagetool_cmd='/usr/bin/languagetool'
" command GC GrammarousCheck
" command GR GrammarousReset


"""""""""""""""
" plugin: ale "
"""""""""""""""

" enable  all linters available for a given filetype
let g:ale_linters = {'cpp': 'all'}


""""""""""""
" Bindings "
""""""""""""

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"get the standard keys to work with wrap
map <silent> k gk
map <silent> j gj
map <silent> 0 g0
map <silent> $ g$

" switch between buffers
noremap <C-p> :bprevious<CR>
noremap <C-n> :bnext<CR>

nnoremap ; :

" switch between buffers
" nnoremap <C-m> :buffers<CR>:buffer<Space>

" noremap <C-e> :Explore<CR>
" noremap <C-m> :wall<CR>:make!<CR>

" Dictionary Lookup        "
" depends: sdcv (stardict) "
function! SearchWord()
    let expl=system('sdcv -n ' . expand("<cword>"))
    windo if expand("%")=="dictionary" | q! | endif
    " 25vsp diCt-tmp
    20sp dictionary
    setlocal buftype=nofile bufhidden=hide noswapfile
    1s/^/\=expl/
    1
endfunction

" <F2> is [12~ (check with Ctrl-V then F2)
noremap [12~ :call SearchWord()<CR>
noremap <F2> :call SearchWord()<CR>


" delete buffer, but do no exit
function! DeleteBufferNotExit()
    let n_listed_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    echo n_listed_buffers
    " let n_open_windows = winnr("$")
    if (n_listed_buffers == 0)
        echo "No buffer to delete"
    elseif (n_listed_buffers == 1)
        bd
        Explore
    elseif (n_listed_buffers > 1)
        bd
    endif
endfunction

noremap <C-x> :call DeleteBufferNotExit() <CR>


" clear highlight and clear the screen
" <F5> is [15~
noremap <1b>[15~ :nohlsearch<CR>:edit<CR>:redraw!<CR>
noremap <F5> :nohlsearch<CR>:edit<CR>:redraw!<CR>

"By pressing ctrl + r in the visual mode you will be prompted to enter text to
"replace with.
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left><left>

" :CDC to change to directory of current file
command CDC cd %:p:h

noremap [19~ :TagbarToggle<CR>
noremap <F8> :TagbarToggle<CR>

noremap [18~ :NERDTreeToggle<CR>
noremap <F7> :NERDTreeToggle<CR>

command Make AsyncRun make

" press the bound key and clang-format will format the current line in NORMAL
" mode or the selected region in VISUAL mode.
map <F10> :pyf /usr/share/clang/clang-format.py<cr>


""""""""
" Misc "
""""""""

" Use visual bell instead of beeping.
set visualbell
" When no beep or flash is wanted, use ":set vb t_vb="
set t_vb=
autocmd GUIEnter * set vb t_vb=

" When a file has been detected to have been changed outside of Vim and it has
" not been changed inside of Vim, automatically read it again.
set autoread

" allow backspacing over everything in insert mode
set backspace=eol,start,indent

" set the number of commands that are remembered (default: 50)
set history=100

" command history file
set viminfo+=n/home/takao/.cache/viminfo

" end-of-line (<EOL>) formats
set fileformats=unix,dos

" strings to use in 'list' mode and for the :list command
set list
set listchars=tab:↹·,extends:⇉,precedes:⇇,nbsp:␠,trail:␠,nbsp:␣

" Set 7 lines to the cursors - when moving vertical..
set scrolloff=7

" Set extra options when running in GUI mode
" if has("gui_running")
"     set guioptions-=T  " remove toolbar at the top with icons
"     set guioptions-=r  " remove right-hand scrollbar
"     set guioptions-=L  " remove left-hand scrollbar
"     set guicursor+=a:blinkon0
" endif

" This autocommand jumps to the last known position in a file just after
" opening it, if the '" mark is set: >
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" augroup encrypted
"     au!
"
"     " First make sure nothing is written to ~/.viminfo while editing
"     " an encrypted file.
"     autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
"     " We don't want a swap file, as it writes unencrypted data to disk
"     autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
"     " Switch to binary mode to read the encrypted file
"     autocmd BufReadPre,FileReadPre      *.gpg set bin
"     autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
"     autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg1 --decrypt 2> /dev/null
"     " Switch to normal mode for editing
"     autocmd BufReadPost,FileReadPost    *.gpg set nobin
"     autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
"     autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
"
"     " Convert all text to encrypted text before writing
"     autocmd BufWritePre,FileWritePre    *.gpg   '[,']!gpg1 --default-recipient-self -ae 2>/dev/null
"     " Undo the encryption so we are back in the normal text, directly
"     " after the file has been written.
"     autocmd BufWritePost,FileWritePost  *.gpg   u
"
"     " Fold entries by default
"     autocmd BufReadPre,FileReadPre      *.gpg set foldmethod=indent
"     autocmd BufReadPre,FileReadPre      *.gpg set foldlevelstart=0
"     autocmd BufReadPre,FileReadPre      *.gpg set foldlevel=0
"
" augroup END
"
highlight MatchParen cterm=underline ctermbg=none ctermfg=none

" Last but not least, allow for local overrides
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
