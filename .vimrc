" I've borrowed and pinched ideas for my (.|_)vimrc file over the years. To those
" that I can remmber, thank you;
"  * Xaos - http://www.darksmile.net/vimindex.html
"  * Alex Reisner - http://github.com/alexreisner/dotfiles/blob/master/.vimrc 
"  * Ryan Kinderman - http://github.com/ryankinderman/dotfiles/blob/master/vimrc 

" Basics
" Use Vim settings. First, because it changes other options as a side effect.
set nocompatible

set nobackup
set number
set nowrap

set shiftwidth=4
set tabstop=4
set shiftwidth=4
set textwidth=80

set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
set laststatus=2
set showcmd
set gcr=a:blinkon0
set errorbells
set visualbell
set nowarn
set ignorecase
set smartcase
set backspace=indent,eol,start
let maplocalleader=","

" Platform specific
if has("win32") 
	let osys="windows"

	behave mswin
	source $VIMRUNTIME/mswin.vim
else
	let osys=system('uname -s')
endif

if &t_Co > 2
	set bg=dark
	syntax on
	highlight Comment term=bold ctermfg=2
	highlight Constant term=underline ctermfg=7
endif

if osys == "windows" && has("gui_running")
	syntax on
	set hlsearch
	set directory=.,$TEMP
endif

if has("autocmd")
	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif 

	filetype plugin indent on
else
	set autoindent
endif

if &term == "xterm"
	" Delete
	map  x
	" End
	map [26~ 100%
	" Home
	map [25~ :1<CR>
else
	if osys != "windows"
		" Convenient saving!
		map <C-s> :w<CR>
		" Delete
		map [3~ x
		imap [3~  
		" End key
		map [4~ 100%
		" Home key
		map [1~ :1<CR>
		" Better Page Up and Down emulators
		map <silent> <PageUp> 1000<C-U>
		map <silent> <PageDown> 1000<C-D>
		imap <silent> <PageUp> <C-O>1000<C-U>
		imap <silent> <PageDown> <C-O>1000<C-D>
	endif
endif

" Use F4 to switch between hex and text editing
function Fxxd()
	let c=getline(".")
	if c =~ '^[0-9a-f]\{7}:'
		:%!xxd -r
	else
		:%!xxd -g4
	endif
endfunction
map <LocalLeader>hex :call Fxxd()<CR>

" Kill trailing whitespace
map <LocalLeader>ks :%s/\s\+$//g<CR>

" Convert 4 spaces to tabs. Yes, I love the tabs. Sorry.
map <LocalLeader>kt :%s/    /\t/g<CR>

