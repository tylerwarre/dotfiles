"""""""""""""""""""""""""""""""""""""
"	Tyler Warren					"
"	vim 8.1.2269 on Ubuntu 20.04	"
"	v1.2 Updated 7-29-21			"
"	Place at ~/.vim/vimrc			"
"""""""""""""""""""""""""""""""""""""

" Base file copied from /usr/share/vim
" TODO Port behave-dark theme: https://github.com/fnky/behave-theme
" TODO Setup COC autocomplete
"
" Requirements
" 1) vim-plug
" 2) jedi-language-server (pip)

" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.


" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Add line numbers to vim
set number
" Set tabs and shiftwidth to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
" Uses vimrc in current directory
set exrc
" Removes error ding
set noerrorbells
" Searches as you type
set incsearch
" Keeps an 8 line buffer on either side of the screen
set scrolloff=8
" Adds bar to the left for linting and markers
set signcolumn=yes
syntax on

" Vim-Plug
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'ycm-core/YouCompleteMe'
Plug 'preservim/nerdcommenter'

call plug#end()

" Sets vim theme
colorscheme gruvbox
set background=dark
let mapleader = " "

noremap L <end>
noremap H <home>

" Found from: https://stackoverflow.com/questions/597687/how-to-quickly-change-variable-names-in-vim
nnoremap <leader>r gd:%s/<C-R>///gc<left><left><left>
