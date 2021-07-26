" I've borrowed and pinched ideas for my (.|_)vimrc file over the years. To those
" that I can remmber, thank you;
"  * Xaos - http://www.darksmile.net/vimindex.html
"  * Alex Reisner - http://github.com/alexreisner/dotfiles/blob/master/.vimrc 
"  * Ryan Kinderman - http://github.com/ryankinderman/dotfiles/blob/master/vimrc 
"  * Greg Stallings - https://github.com/gregstallings/vimfiles/blob/master/vimrc

" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'editorconfig/editorconfig-vim'

" vim native snippets
Plug 'sheerun/vim-polyglot'
Plug 'honza/vim-snippets'

" vscode snippets
Plug 'rafamadriz/friendly-snippets'

" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" colour schemes & icons
Plug 'patstockwell/vim-monokai-tasty'
Plug 'sainnhe/sonokai'
Plug 'arcticicestudio/nord-vim'
Plug 'projekt0n/github-nvim-theme'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'romgrk/barbar.nvim'

Plug 'windwp/nvim-autopairs'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'hoob3rt/lualine.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': ':TSUpdate'}

Plug 'folke/which-key.nvim'
Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

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
set cmdheight=2 " Give more space for displaying messages.
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
set signcolumn=number

set updatetime=300

filetype plugin on
syntax on

" Use UTF-8 without BOM
set encoding=utf-8 nobomb
set fileencoding=utf-8 nobomb

augroup nord-overrides
  " nord specific override to make comments legible
  autocmd!
  autocmd ColorScheme * highlight Comment ctermfg=14
augroup end

"colorscheme nord

hi Search guifg=#1B1D1E guibg=#FEFE56
set cursorline " Highlight current line

let mapleader = ","

" Platform specific
if has("win32")
  set directory=.,$TEMP
endif

" Better Page Up and Down emulators
map <silent> <PageUp> 1000<C-U>
map <silent> <PageDown> 1000<C-D>
imap <silent> <PageUp> <C-O>1000<C-U>
imap <silent> <PageDown> <C-O>1000<C-D>

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

map <Leader>tn :call ToggleNumber()<CR>

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
augroup END

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" coc.nvim
let g:coc_global_extensions = [
  \'coc-pyright',
  \'coc-eslint',
  \'coc-snippets',
  \'coc-emoji',
  \'coc-json',
  \'coc-css',
  \'coc-html',
  \'coc-yaml',
  \'coc-prettier',
  \'coc-xml',
  \'coc-docker',
  \'coc-go',
  \'coc-tsserver',
  \ 'https://github.com/rodrigore/coc-tailwind-intellisense'
  \]

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

map <Leader>nt :NvimTreeToggle<CR>

lua << EOF
require("github-theme").setup({
  themeStyle = "dimmed",
})

require("which-key").setup {}

require('lualine').setup {
  options = {
    -- ... your lualine config
    theme = 'github'
    -- ... your lualine config
  }
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,     -- false will disable the whole extension
    disable = {},      -- list of language that will be disabled
  },
}
EOF
