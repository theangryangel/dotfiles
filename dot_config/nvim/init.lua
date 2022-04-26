-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

require('packer').startup(function(use) 

use 'editorconfig/editorconfig-vim'

-- snippets
use 'L3MON4D3/LuaSnip'
use 'honza/vim-snippets'
use 'rafamadriz/friendly-snippets'

use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

use {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup{}
  end
}

-- lsp
use 'neovim/nvim-lspconfig'
use 'williamboman/nvim-lsp-installer'
use 'ray-x/lsp_signature.nvim'
use 'kosayoda/nvim-lightbulb'
use 'onsails/lspkind-nvim'
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-emoji'
use 'hrsh7th/nvim-cmp'
use 'saadparwaiz1/cmp_luasnip'
use 'j-hui/fidget.nvim'

use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

-- colour schemes & icons
use 'kyazdani42/nvim-web-devicons'

use {
  'projekt0n/github-nvim-theme',
  commit = "715c554",
  config = function()
    require("github-theme").setup({
      theme_style = "dimmed",
      hide_inactive_statusline = false,
      dark_sidebar = true,
      dark_float = true,
    })
  end
}

-- Telescope
use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}

-- UI
use {
  "hoob3rt/lualine.nvim",
  after = "github-nvim-theme",
  config = function()
    require("lualine").setup {
      options = {
        theme = "auto",
        extensions = {'nvim-tree'},
        globalstatus = true,
      },
    }
  end
}

use 'romgrk/barbar.nvim'

use {
  'folke/which-key.nvim',
  config = function()
  end
}

use {
  'kyazdani42/nvim-tree.lua',
  config = function()
    vim.api.nvim_set_keymap("", "<Leader>nt", "<cmd>NvimTreeToggle<CR>", { })

    require'nvim-tree'.setup {
      view = {
        auto_resize = False,
      },
      git = {
        enable = true,
        ignore = false,
      },
      update_focused_file = {
        enable = true,
      },
    }
  end
}

use {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end
}

use "lukas-reineke/indent-blankline.nvim"

-- Temporary workaround for netrw bug
use 'felipec/vim-sanegx'

-- Copilot
use 'github/copilot.vim'

end)

--Basics
vim.opt.shortmess = "atIc" -- Don't show the Vim intro message
vim.opt.backup = false -- no file system spam pls
vim.opt.backupcopy = "yes" -- fix file watchers

vim.opt.title = true
vim.opt.expandtab = true
vim.opt.tw = 80
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'

vim.opt.backspace = "indent,eol,start"

--Remap leader
vim.g.mapleader = ','
vim.g.maplocalleader = ','

--Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true


--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.o.completeopt = 'menu,menuone,noselect'

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
  },
}

-- lspconfig

-- XXX: experimental effort to change from virtual_text to hover.
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
})
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- nvim-lightbulb
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
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
  -- Code Actions via Telescope
  buf_set_keymap('n', '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)
  
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
end

-- Setup luasnip
require("luasnip.loaders.from_vscode").load()
require("luasnip.loaders.from_snipmate").lazy_load()

-- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require'lspkind'

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    })
  },
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'emoji' },
  }, {
    name = 'buffer'
  })
})

-- LSP
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local opts = {}
    opts.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    opts.on_attach = on_attach
    server:setup(opts)
end)

require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.

    -- The following makes lsp_signature look like the default floating windows.
    hint_enable = false,
    handler_opts = {
      border = "none"
    }
})

require"fidget".setup{}
require("which-key").setup {}
