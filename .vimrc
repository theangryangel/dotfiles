" I've borrowed and pinched ideas for my (.|_)vimrc file over the years. To those
" that I can remmber, thank you;
"  * Xaos - http://www.darksmile.net/vimindex.html
"  * Alex Reisner - http://github.com/alexreisner/dotfiles/blob/master/.vimrc 
"  * Ryan Kinderman - http://github.com/ryankinderman/dotfiles/blob/master/vimrc 
"  * Greg Stallings - https://github.com/gregstallings/vimfiles/blob/master/vimrc

" To disable a plugin, add it's bundle name to the following list
" let g:pathogen_disabled = []

let g:pathogen_disabled = []
let g:coc_global_extensions = [ 'coc-pyright', 'coc-eslint', 'coc-snippets', 'coc-git', 'coc-emoji', 'coc-json', 'coc-css', 'coc-html', 'coc-yaml', 'coc-prettier' ]
let g:airline#extensions#coc#enabled = 1

" Add pathogen
call pathogen#infect()

" Basics
set nocompatible " Use Vim settings. First, because it changes other options as a side effect.
set shortmess=atIc " Don't show the Vim intro message

set nobackup
set backupcopy=yes " Fix file watchers
set number
set nowrap

set termguicolors

set title         " Set terminal window
set expandtab     " Tab in insert mode will produce spaces
set tabstop=2     " Width of a tab
set shiftwidth=2  " Width of reindent operations and auto indentation
set softtabstop=2 " Set spaces for tab in insert mode
set autoindent    " Enable auto indentation

set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P " Default status line. Largely here as a fallback if airline is not available
set laststatus=2
set showcmd
set gcr=a:blinkon0
set errorbells
set visualbell
set nowarn
set backspace=indent,eol,start " Backspace over everything in insert mode
set autoindent

set hlsearch   " Highlight searches
set incsearch  " Highlight dynamically as pattern is typed
set ignorecase " Make searches case-insensitive...
set smartcase  " ...unless they contain at least one uppercase character

" Split windows below and right instead of above and left
set splitbelow splitright

set hidden
set signcolumn=auto
set updatetime=300

filetype plugin on
syntax on

" Use UTF-8 without BOM
set encoding=utf-8 nobomb
set fileencoding=utf-8 nobomb

"colorscheme molokai

augroup nord-overrides
  " nord specific override to make comments legible
  autocmd!
  autocmd ColorScheme * highlight Comment ctermfg=14
augroup end

colorscheme nord

hi Search guifg=#1B1D1E guibg=#FEFE56
set cursorline " Highlight current line

let maplocalleader=","

" Platform specific
if has("win32")
  set directory=.,$TEMP
endif

" Better Page Up and Down emulators
map <silent> <PageUp> 1000<C-U>
map <silent> <PageDown> 1000<C-D>
imap <silent> <PageUp> <C-O>1000<C-U>
imap <silent> <PageDown> <C-O>1000<C-D>

function Fxxd()
  let c=getline(".")
  if c =~ '^[0-9a-f]\{7}:'
    :%!xxd -r
  else
    :%!xxd -g4
  endif
endfunction

" NerdTree
let g:NERDTreeHijackNetrw=1
map <LocalLeader>nt :NERDTree<CR>

" Convert to a hex output
map <LocalLeader>hex :call Fxxd()<CR>

" Make Y consistent with C and D. See :help Y.
nnoremap Y y$

" Toggle between number and relativenumber
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

map <LocalLeader>tn :call ToggleNumber()<CR>

" I can type :help on my own, thanks.
noremap <F1> <Esc>

" Load filetype-specific indent files
filetype plugin indent on

" Autocmd group
augroup configgroup
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif 

  " Some file types use real tabs
  autocmd FileType {make,gitconfig} setlocal noexpandtab sw=4

  " Treat JSON files like JavaScript
  autocmd BufNewFile,BufRead *.json setf javascript

  " Make Python follow PEP8
  autocmd FileType python setlocal sts=4 ts=4 sw=4 tw=79

  " Make sure all markdown files have the correct filetype
  autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown

  autocmd BufEnter Makefile setlocal noexpandtab
augroup END

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Disable autofolding of markdown
let g:vim_markdown_folding_disabled=1

" Make NERDTree change dir correctly, so tags file is correctly autoloaded.
let g:NERDTreeChDirMode=2
let NERDTreeShowHidden=1

" vim-go specifics
let g:go_fmt_autosave = 0

" Airline customisation
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" Append the character code to airline_section_z
let g:airline_section_z = airline#section#create(['windowswap', '%3p%%', 'linenr', ':%3v', ' | 0x%2B'])
