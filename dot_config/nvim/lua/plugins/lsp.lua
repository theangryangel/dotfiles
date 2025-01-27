return {
  'neovim/nvim-lspconfig',
  event = "VeryLazy",
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    "folke/neodev.nvim",
    { 'j-hui/fidget.nvim', tag = 'v1.4.5' },
  },
  config = function()
    -- LSP setup
    require("fidget").setup {}
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    require('mason-lspconfig').setup({
      ensure_installed = {
        "dockerls", "pyright", "rust_analyzer", "eslint", "yamlls", "lua_ls"
      },
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    require('mason-lspconfig').setup_handlers {
      -- fallback handler.
      function (server_name)
        require('lspconfig')[server_name].setup{
          capabilities = capabilities
        }
      end,
    }

    require("lspconfig.ui.windows").default_options.border = "single"

    require("neodev").setup()

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
    })

    -- Show diagnostics on hover instead of virtual_text
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = '',
          scope = 'cursor',
          style = 'minimal',
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })

  end
}
