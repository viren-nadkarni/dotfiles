let mapleader=','

" important
set nocompatible
set pastetoggle=<F12>
execute pathogen#infect()

" moving around, searching and patterns
set whichwrap+=<,>,h,l,[,]
set autochdir                               "change to directory of file in buffer
set magic                                   "change the way backslashes are used in search patterns
set incsearch                               "show match for partly typed search command
set ignorecase                              "ignore case when using a search pattern
set smartcase                               "override 'ignorecase' when pattern has upper case characters

" displaying text
set scrolloff=4                             "number of screen lines to show around the cursor
set wrap
"set linebreak                              "wrap long lines at a character in 'breakat'
set cmdheight=2                             "number of lines used for the command-line
set lazyredraw                              "don't redraw while executing macros
set list
set listchars=tab:▸\ ,trail:·
set number

" syntax, highlighting and spelling
colorscheme Tomorrow-Night-Bright
set background=dark
set hlsearch
set cursorline                              "highlight the screen line of the cursor
syntax on
filetype plugin indent on

" multiple windows
set hidden                                  "don't unload a buffer when no longer shown in a window
set splitright                              "a new window is put right of the current one
set splitbelow                              "a new window is put below the current one
set laststatus=2
set statusline=%<%f                         "filename
set statusline+=\ %w%h%m%r                  "options
set statusline+=\ [%{&ff}/%Y]               "filetype
set statusline+=\ [%{getcwd()}]             "current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%     "file nav info

" using the mouse
set mouse=a

" messages and info
set showcmd                                 "show (partial) command keys in the status line
set noshowmode
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set noerrorbells                            "don't ring the bell for error messages
set novisualbell                            "don't use visual bell either

" editing text
set undolevels=1000
set textwidth=150                           "line length above which to break a line
set backspace=indent,eol,start              "specifies what <BS>, CTRL-W, etc. can do in Insert mode
set showmatch                               "when inserting a bracket, briefly jump to its match
set nojoinspaces                            "use two spaces after '.' when joining a line

" tabs and indenting
set tabstop=4                               "number of spaces a <Tab> in the text stands for
set shiftwidth=4                            "number of spaces used for each step of (auto)indent
set smarttab                                "a <Tab> in an indent inserts 'shiftwidth' spaces
set softtabstop=4                           "if non-zero, number of spaces to insert for a <Tab>
set expandtab                               "expand <Tab> to spaces in Insert mode
set autoindent
set smartindent

" mapping
set timeoutlen=1000
set ttimeoutlen=50

" reading and writing files
set fileformat=unix
set fileformats=unix,dos
set nowritebackup                           "don't write a backup file before overwriting a file
set nobackup                                "don't keep a backup after overwriting a file
set autoread                                "automatically read a file when it was modified outside of Vim

" the swap file
set noswapfile                              "don't use a swap file for this buffer

" command line editing
set history=1000                            "how many command lines are remembered
set wildmode=list:longest,full              "specifies how command line completion works
set wildignore=*.o,*~,*.pyc                 "list of patterns to ignore files for file name completion
set wildmenu                                "command-line completion shows a list of matches

" multi-byte characters
set encoding=utf8

" terminal
if $TERM=='xterm-256color' || $TERM=='screen-256color' || $COLORTERM=='gnome-terminal'
  set t_Co=256
endif

" gui
if has('gui_running')
  set lines=40
  set columns=100
  set guioptions-=T                         "remove toolbar
  set guioptions-=t                         "don't include tearoff menu items
  set guioptions+=e                         "use a gui tab line
  set guioptions-=c                         "use gui popups for confirmation
  set guioptions+=g                         "make inactive menu items grey
  set guitablabel=%M\ %t                    "modified flag, file name
  if has('gui_win32')
    set guifont=Consolas:h10:cDEFAULT
  endif
endif

map j gj
map k gk

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nmap \ :NERDTreeToggle<CR>

let g:ctrlp_map=';'
let g:syntastic_check_on_open=1
"let g:airline_powerline_fonts=1
"let g:airline#extensions#tabline#enabled=1
