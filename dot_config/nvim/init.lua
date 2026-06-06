vim.g.mapleader = ','
vim.g.maplocalleader = ','

local options = {
  shortmess = "atIc",
  backup = false,
  backupcopy = "yes",
  title = true,
  expandtab = true,
  tw = 88,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  autoindent = true,
  cursorline = true,
  wrap = false,
  splitbelow = true,
  splitright = true,
  termguicolors = true,
  clipboard = 'unnamedplus',
  backspace = "indent,eol,start",
  hlsearch = true,
  incsearch = true,
  ignorecase = true,
  smartcase = true,
  number = true,
  mouse = 'a',
  breakindent = true,
  undofile = true,
  updatetime = 250,
  signcolumn = 'yes',
  completeopt = 'menu,menuone,noselect',
  diffopt = "internal,filler,closeoff,linematch:60",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.g.neovide then
  require('neovide')
end

require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
})

-- Colourscheme loaded first so everything else inherits the right highlight groups
vim.pack.add({ 'https://github.com/projekt0n/github-nvim-theme' })
require("github-theme").setup({
  options = {
    darken = {
      sidebars = {
        enable = true,
      }
    },
  }
})
vim.cmd('colorscheme github_dark_dimmed')

for _, file in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '/lua/plugins/*.lua', false, true)) do
  dofile(file)
end

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})
