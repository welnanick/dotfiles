set scrolloff=3         " keep 3 lines when scrolling
set ai                  " set auto-indenting on for programming
 
set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set number              " show line numbers
set ruler               " show the current row and column
 
set hlsearch            " highlight searches
set incsearch           " do incremental searching
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present
 
set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell
 
set backspace=indent,eol,start " make that backspace key work the way it should
 
syntax enable           " turn syntax highlighting on by default
set t_Co=16
set background=dark
colorscheme solarized
filetype on             " detect type of file
filetype plugin indent on      " load indent file for specific file type

set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4
set smarttab
set colorcolumn=120
highlight OverLength ctermbg=black ctermfg=darkred guibg=#FFD9D9
autocmd VimEnter,WinEnter * match OverLength /\%121v.\+/
