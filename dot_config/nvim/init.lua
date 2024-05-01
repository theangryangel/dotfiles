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

-- TODO: shrink this list to what I'm actually using. I've borrowed this from
-- LunarVim.
local icons = {
  ui = {
    ArrowCircleDown = "",
    ArrowCircleLeft = "",
    ArrowCircleRight = "",
    ArrowCircleUp = "",
    BoldArrowDown = "",
    BoldArrowLeft = "",
    BoldArrowRight = "",
    BoldArrowUp = "",
    BoldClose = "",
    BoldDividerLeft = "",
    BoldDividerRight = "",
    BoldLineLeft = "▎",
    BookMark = "",
    BoxChecked = "",
    Bug = "",
    Stacks = "",
    Scopes = "",
    Watches = "󰂥",
    DebugConsole = "",
    Calendar = "",
    Check = "",
    ChevronRight = "",
    ChevronShortDown = "",
    ChevronShortLeft = "",
    ChevronShortRight = "",
    ChevronShortUp = "",
    Circle = " ",
    Close = "󰅖",
    CloudDownload = "",
    Code = "",
    Comment = "",
    Dashboard = "",
    DividerLeft = "",
    DividerRight = "",
    DoubleChevronRight = "»",
    Ellipsis = "",
    EmptyFolder = "",
    EmptyFolderOpen = "",
    File = "",
    FileSymlink = "",
    Files = "",
    FindFile = "󰈞",
    FindText = "󰊄",
    Fire = "",
    Folder = "󰉋",
    FolderOpen = "",
    FolderSymlink = "",
    Forward = "",
    Gear = "",
    History = "",
    Lightbulb = "",
    LineLeft = "▏",
    LineMiddle = "│",
    List = "",
    Lock = "",
    NewFile = "",
    Note = "",
    Package = "",
    Pencil = "󰏫",
    Plus = "",
    Project = "",
    Search = "",
    SignIn = "",
    SignOut = "",
    Tab = "󰌒",
    Table = "",
    Target = "󰀘",
    Telescope = "",
    Text = "",
    Tree = "",
    Triangle = "󰐊",
    TriangleShortArrowDown = "",
    TriangleShortArrowLeft = "",
    TriangleShortArrowRight = "",
    TriangleShortArrowUp = "",
  },
}

-- Plugins.
require("lazy").setup({
  -- editorconfig is supported out of the box under neovim 0.9+
  -- 🥳
  --{'editorconfig/editorconfig-vim'},

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
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
      {
        'j-hui/fidget.nvim',
        tag = 'v1.4.1'
      },
    },
    config = function()
      -- LSP setup
      require("fidget").setup()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          "dockerls", "pyright", "rust_analyzer", "eslint", "yamlls", "lua_ls"
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
        dependencies = { 'nvim-neotest/nvim-nio' },
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
          })
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
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
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          darken = {
            sidebars = {
              enabled = true,
            }
          },
        }
      })

      vim.cmd('colorscheme github_dark')
      --vim.cmd('highlight FoldColumn guibg=#22272e guifg=#909dab')
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
          theme = "auto",
          extensions = {
            'nvim-tree',
          },

          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "lazy", "alpha" },
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 100,
          },
        },
        tabline = {},
        extensions = {},
      }
  },

  {
    "akinsho/bufferline.nvim",
    config = function()
      local bufferline = require('bufferline')

      bufferline.setup({
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          indicator = {
            icon = icons.ui.BoldLineLeft,
            style = 'icon',
          },

          style_preset = bufferline.style_preset.no_italic,

          separator = {left = icons.ui.DividerLeft, right = icons.ui.DividerRight},
          buffer_close_icon = icons.ui.Close,
          modified_icon = icons.ui.Circle,
          close_icon = icons.ui.BoldClose,
          left_trunc_marker = icons.ui.ArrowCircleLeft,
          right_trunc_marker = icons.ui.ArrowCircleRight,

          offsets = {
            {
              filetype = "neo-tree",
              text_align = "center",
              text = "Explorer",
              padding = 0,
              separator = true,
            },
          },
        },
      })
    end,
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
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('neo-tree').setup({
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
          winbar = true,
          statusline = false
        },

        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        }
      })
      vim.api.nvim_set_keymap("", "<Leader>nt", "<cmd>Neotree toggle<CR>", { })
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  {
    "luukvbaal/statuscol.nvim",
    config = function()
      require("statuscol").setup {}
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = icons.ui.LineLeft },
      scope = { show_start = false, show_end = false },
      exclude = {
        buftypes = {
          "nofile",
          "prompt",
          "quickfix",
          "terminal",
        },
        filetypes = {
          "help",
          "lazy",
          "mason",
          "neo-tree",
        },
      },
    },
  },

  -- Temporary workaround for netrw bug
  { 'felipec/vim-sanegx' },
})
