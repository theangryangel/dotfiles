" I've borrowed and pinched ideas for my (.|_)vimrc file over the years. To those
" that I can remmber, thank you;
"  * Xaos - http://www.darksmile.net/vimindex.html
"  * Alex Reisner - http://github.com/alexreisner/dotfiles/blob/master/.vimrc 
"  * Ryan Kinderman - http://github.com/ryankinderman/dotfiles/blob/master/vimrc 

" To disable a plugin, add it's bundle name to the following list
" let g:pathogen_disabled = ["snipmate", "snippets"]

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
set autoindent
let maplocalleader=","

syntax on

set encoding=utf-8
set fileencoding=utf-8

" font fun
if has("gui_running")
	if has("gui_gtk2")
		set gfn=Bitstream\ Vera\ Sans\ Mono\ 12
	elseif has("gui_macvim") 
		set gfn=Bitstream\ Vera\ Sans\ Mono:h12
	else
		set gfn=Bitstream\ Vera\ Sans\ Mono:h11
	endif
endif

snor <bs> <bs>

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

	if has("gui")
		" Bad habits I can't get out of

		" CTRL-A is Select all
		noremap <C-A> gggH<C-O>G
		inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
		cnoremap <C-A> <C-C>gggH<C-O>G
		onoremap <C-A> <C-C>gggH<C-O>G
		snoremap <C-A> <C-C>gggH<C-O>G
		xnoremap <C-A> <C-C>ggVG

		" Ctrl+c, Ctrl+x
		vmap <C-C> "+yi
		vmap <C-X> "+c

		" Ctrl+v paste - only works in visual and insert mode in order to
		" prevent default ctrl+v
		vmap <C-V> c<ESC>"+p
		imap <C-v> <C-r><C-o>+

		" Saving
		noremap <C-s> :update<CR>
		vnoremap <C-s> <C-C>:update<CR>
		inoremap <C-s> <C-O>:update<CR>

		" CTRL-Z is Undo; not in cmdline though
		noremap <C-Z> u
		inoremap <C-Z> <C-O>u
	endif
endif

" colour schemes
if &t_Co > 2 || has("gui_running")
	colorscheme molokai
	hi Search guifg=#1B1D1E guibg=#FEFE56
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

" xmllint format
map <LocalLeader>xml-format :%!xmllint --format -<CR>

" Make Y consistent with C and D. See :help Y.
nnoremap Y y$

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

" I can type :help on my own, thanks.
noremap <F1> <Esc>

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

let g:vim_markdown_folding_disabled=1

" Filetype specifics
autocmd Filetype ruby,eruby,yaml setlocal ts=2 sts=2 sw=2 expandtab
