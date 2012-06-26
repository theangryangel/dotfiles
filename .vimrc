" I've borrowed and pinched ideas for my (.|_)vimrc file over the years. To those
" that I can remmber, thank you;
"  * Xaos - http://www.darksmile.net/vimindex.html
"  * Alex Reisner - http://github.com/alexreisner/dotfiles/blob/master/.vimrc 
"  * Ryan Kinderman - http://github.com/ryankinderman/dotfiles/blob/master/vimrc 

" Add pathogen
call pathogen#infect()

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
set hlsearch
let maplocalleader=","

set gfn=Bitstream\ Vera\ Sans\ Mono:h11

syntax on

set encoding=utf-8
set fileencoding=utf-8

" Platform specific
if has("win32")
	behave mswin
	source $VIMRUNTIME/mswin.vim

	set directory=.,$TEMP
else
	" Better Page Up and Down emulators
	map <silent> <PageUp> 1000<C-U>
	map <silent> <PageDown> 1000<C-D>
	imap <silent> <PageUp> <C-O>1000<C-U>
	imap <silent> <PageDown> <C-O>1000<C-D>

	" My poor eyes :(
	if has("gui_macvim")
		set gfn=Bitstream\ Vera\ Sans\ Mono:h12
	endif

	if has("gui")
		" Only for the gui, because
		" 1. I'm trained not to use ctrl+X in a terminal
		" 2. I seem to be trained to use ctrl+x everywhere else. Gordamnit
		" Windows-style Ctrl+X keys because I suck
		" First, remap <C-Q> to what <C-V> used to do (inserting special
		" characters)
		noremap <C-Q> <C-V> 
		" Now remap our keys
		" Copy
		vnoremap <C-C> "+y
		vnoremap <C-Insert> "+y
		" Paste
		map <S-Insert> "+gP
		map <C-V> "+gP
		" Probably not the best way to do it, but the most reliable I can
		" see
		imap <C-V> <ESC>"+gP<ESC>a
		vmap <C-V> "+gP<ESC>a
		vmap <S-Insert> <C-V>
		" Saving
		noremap <C-S> :update<CR>
		vnoremap <C-S> <C-C>:update<CR>
		inoremap <C-S> <C-O>:update<CR>
	endif
endif

" colour schemes
if &t_Co > 2 || has("gui_running")
	colorscheme Tomorrow-Night
endif

" terminal specifics
if &t_Co > 2
	highlight Comment term=bold ctermfg=2
	highlight Constant term=underline ctermfg=7
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

function Fxxd()
	let c=getline(".")
	if c =~ '^[0-9a-f]\{7}:'
		:%!xxd -r
	else
		:%!xxd -g4
	endif
endfunction

" Convert to a hex output
map <LocalLeader>hex :call Fxxd()<CR>

" Kill trailing whitespace
map <LocalLeader>ks :%s/\s\+$//g<CR>

" Convert 4 spaces to tabs. Yes, I love the tabs. Sorry.
map <LocalLeader>kt :%s/    /\t/g<CR>

" PHP doc
source ~/.vim/php-doc.vim 
let g:pdv_cfg_Type = "mixed"
let g:pdv_cfg_Package = ""
let g:pdv_cfg_Version = "$id$"
let g:pdv_cfg_Author = "Karl Southern"
let g:pdv_cfg_Copyright = ""
let g:pdv_cfg_License = ""

" Add our docblocks
map <LocalLeader>d :call PhpDocSingle()<CR>i 

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
				\ &tabstop, &shiftwidth, &textwidth)
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

nnoremap <silent> <LocalLeader>ml :call AppendModeline()<CR>
