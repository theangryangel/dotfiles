-- Remapping leader, etc. to ensure that any plugins use the correct
-- configuration
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Basics
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

-- Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.o.completeopt = 'menu,menuone,noselect'

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h11"
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
end

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

-- Plugins.
require("lazy").setup({
  -- editorconfig is supported out of the box under neovim 0.9+
  -- 🥳
  --{'editorconfig/editorconfig-vim'},

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        ignore_install = {},
        highlight = {
          enable = true,
          disable = {},
        },
      }
    end
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup{}
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- UI status updates from LSP
      'j-hui/fidget.nvim',
    },
    config = function()
      -- LSP setup
      require("fidget").setup()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          "dockerls", "pyright", "rust_analyzer", "eslint", "yamlls"
        },
      })
      require('mason-lspconfig').setup_handlers {
        -- fallback handler.
        function (server_name)
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require('lspconfig')[server_name].setup{
            capabilities = capabilities
          }
        end,
      }
    end
  },

  -- Debugging
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { automatic_setup = true },
      },
      { 
        "rcarriga/nvim-dap-ui",
        config = function()
          require('dapui').setup()
        end
      }
    },
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { 'hrsh7th/cmp-emoji' },
      { 'kosayoda/nvim-lightbulb' },
      { 'onsails/lspkind-nvim' },
      { "saadparwaiz1/cmp_luasnip" },
      -- snippets
      {
        'L3MON4D3/LuaSnip', 
        version = "v1.2.1", 
      },
      {'honza/vim-snippets'},
      {'rafamadriz/friendly-snippets'},
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,
      })

      -- XXX: experimental effort to change from virtual_text to hover.
      -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

      vim.api.nvim_create_autocmd('LspAttach',  {
        desc = "LSP Actions",
        callback = function()
          -- Mappings
          local opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
          -- Code Actions via Telescope
          vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        end
      })

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
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'emoji' },
          { name = 'buffer' },
          { name = 'path' }
        }, {
          name = 'buffer'
        })
      })
    end
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-dap.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').load_extension('dap')
      require('telescope').load_extension('ui-select')
    end
  },

  -- UI
  {
    'projekt0n/github-nvim-theme',
    lazy = false,
    branch = '0.0.x',
    config = function()
      require("github-theme").setup({
        hide_inactive_statusline = false,
        dark_float = true,
        dark_sidebar = true,
      })

      vim.cmd('colorscheme github_dimmed')
      vim.cmd('highlight FoldColumn guibg=#22272e guifg=#909dab')
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {'projekt0n/github-nvim-theme'},
      {'nvim-tree/nvim-tree.lua'}
    },
    config = function()
      require("lualine").setup {
        options = {
          theme = "auto",
          extensions = {'nvim-tree'},
          globalstatus = true,
        },
      }
    end
  },

  { 
    'romgrk/barbar.nvim',
    config = function()
      require('barbar').setup {
        animation = false,
        auto_hide = false,

        hide = {
          extensions = true
        },
        icons = {
          button = '',
          -- Enables / disables diagnostic symbols
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
            [vim.diagnostic.severity.WARN] = {enabled = false},
            [vim.diagnostic.severity.INFO] = {enabled = false},
            [vim.diagnostic.severity.HINT] = {enabled = false},
          },
          filetype = {
            -- Sets the icon's highlight group.
            -- If false, will use nvim-web-devicons colors
            custom_colors = false,

            -- Requires `nvim-web-devicons` if `true`
            enabled = true,
          },

          -- custom separator icons/characters

          separator = {left = '', right = '│'},

          -- Configure the icons on the bufferline when modified or pinned.
          -- Supports all the base icon options.
          modified = {button = '●'},
          pinned = {
            buffer_index = true, filename = true, button = '', separator = { right = '│', left = ''} 
          },

          -- Configure the icons on the bufferline based on the visibility of a buffer.
          -- Supports all the base icon options, plus `modified` and `pinned`.
          alternate = {filetype = {enabled = false}},
          inactive = {button = '', separator = {left = '', right = '│'}},
        },
        sidebar_filetypes = {
          NvimTree = true
        },
        -- icon_pinned = '󰐃',
        exclude_ft = {'netrw'},
        -- closable = false,
        highlight_visible = false,
      }
    end
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  {
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup {}
    end
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require'nvim-tree'.setup {
        git = {
          enable = true,
          ignore = false,
        },
        update_focused_file = {
          enable = true,
        },
        actions = {
          open_file = {
            resize_window = false
          }
        }
      }

      vim.api.nvim_set_keymap("", "<Leader>nt", "<cmd>NvimTreeToggle<CR>", { })
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    config = true
  },

  {
    "luukvbaal/statuscol.nvim",
    event = "VimEnter",
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        relculright = true,
        setopt = true,
        segments = {
          {
            sign = {
              name = {
                "Diagnostic"
              },
              maxwidth = 1,
              colwidth = 2,
              auto = false,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            sign = {
              name = { "GitSigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              fillchar = "│",
              fillcharhl = "StatusColumnSeparator",
            },
            click = "v:lua.ScSa",
          },
          { 
            text = { builtin.foldfunc }, 
            click = "v:lua.ScFa",
          },
          { 
            text = { " " }, 
          },

        },
        ft_ignore = {
          "help",
          "vim",
          "NvimTree",
          "lazy",
          "toggleterm",
        },
        bt_ignore = {"terminal", "nofile"},
      }
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "VimEnter",
    dependencies = {
      "kevinhwang91/promise-async"
    },
    config = function() 
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      -- ufo
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    end
  },

  { "lukas-reineke/indent-blankline.nvim" },

  -- Temporary workaround for netrw bug
  { 'felipec/vim-sanegx' },
})
