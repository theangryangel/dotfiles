" I've borrowed and pinched ideas for my (.|_)vimrc file over the years. To those
" that I can remmber, thank you;
"  * Xaos - http://www.darksmile.net/vimindex.html
"  * Alex Reisner - http://github.com/alexreisner/dotfiles/blob/master/.vimrc 
"  * Ryan Kinderman - http://github.com/ryankinderman/dotfiles/blob/master/vimrc 
"  * Greg Stallings - https://github.com/gregstallings/vimfiles/blob/master/vimrc

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'

Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" colour schemes & icons

Plug 'arcticicestudio/nord-vim'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'joshdick/onedark.vim'
Plug 'sainnhe/sonokai'
Plug 'ryanoasis/vim-devicons'

" Neovim 0.5+

Plug 'neovim/nvim-lspconfig'
Plug 'alexaandru/nvim-lspupdate'

Plug 'nvim-lua/completion-nvim'
Plug 'windwp/nvim-autopairs'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

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
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=auto
endif

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

colorscheme nord

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

" NerdTree
let g:NERDTreeHijackNetrw=1
let g:NERDTreeChDirMode=2 " Make NERDTree change dir correctly, so tags file is correctly autoloaded.
let NERDTreeShowHidden=1
map <Leader>nt :NERDTree<CR>

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

  autocmd BufEnter Makefile setlocal noexpandtab
augroup END

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" Append the character code to airline_section_z
let g:airline_section_z = airline#section#create(['windowswap', '%3p%%', 'linenr', ':%3v', ' | 0x%2B'])
let g:airline#extensions#coc#enabled = 0

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" -------------------- LSP ---------------------------------
:lua << EOF

  require('nvim-autopairs').setup()

  local nvim_lsp = require('lspconfig')

  local on_attach = function(client, bufnr)
    require('completion').on_attach()

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings

    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    
    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

  end

  -- TODO: Find replacements for coc-prettier, coc-xml, coc-eslint
  local servers = {'pyright', 'gopls', 'dockerls', 'jsonls', 'html', 'yamlls', 'diagnosticls'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

set completeopt=menuone,noinsert,noselect
let g:completion_confirm_key = "\<CR>"

let g:completion_chain_complete_list = {
	    \ 'default' : {
	    \   'default': [
	    \       {'complete_items': ['lsp', 'snippet']},
	    \       {'complete_items': ['path'], 'triggered_only': ['/']},
	    \       {'mode': '<c-p>'},
	    \       {'mode': '<c-n>'}],
	    \   'comment': [],
      \   'string': [{ 'complete_items': ['path']}]
	    \   },
	    \}

" Completion
let g:completion_enable_snippet = 'UltiSnips'
let g:UltiSnipsExpandTrigger="<C-tab>"
"let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" -------------------- LSP ---------------------------------
