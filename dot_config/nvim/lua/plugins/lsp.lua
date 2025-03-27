return {
  'neovim/nvim-lspconfig',
  event = "VeryLazy",
  dependencies = {
    -- 'williamboman/mason.nvim',
    -- 'williamboman/mason-lspconfig.nvim',
    "folke/neodev.nvim",
    { 'j-hui/fidget.nvim', tag = 'v1.4.5' },
    'kosayoda/nvim-lightbulb',
  },
  config = function()
    -- LSP setup
    require("fidget").setup {}
    -- require("mason").setup({
    --   ui = {
    --     border = "rounded",
    --     icons = {
    --       package_installed = "✓",
    --       package_pending = "➜",
    --       package_uninstalled = "✗",
    --     },
    --   },
    -- })
    -- require('mason-lspconfig').setup({
    --   ensure_installed = {
    --     -- "dockerls", 
    --     -- "pyright", 
    --     -- XXX: trying out ~/.config/nvim/lsp/
    --     --"rust_analyzer", 
    --     -- "eslint", 
    --     -- "yamlls", 
    --     "lua_ls"
    --   },
    -- })

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- require('mason-lspconfig').setup_handlers {
    --   -- fallback handler.
    --   function (server_name)
    --     require('lspconfig')[server_name].setup{
    --       capabilities = capabilities
    --     }
    --   end,
    -- }

    require("lspconfig.ui.windows").default_options.border = "single"

    require("neodev").setup()

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- XXX: Assumes that we've manually installed all of these
    vim.lsp.enable({
      "css", -- npm install -g vscode-langservers-extracted
      "dockerls",  -- npm install -g
      "eslint", -- npm install -g vscode-langservers-extracted
      "markdown", -- npm install -g vscode-langservers-extracted
      "pyright",   -- pipx install pyright debugpy
      "ruff", -- uv tool install ruff
      "rust-analyzer", -- rustup
      "typescript", -- npm install -g
      "yamlls", -- npm install -g
    })

    vim.diagnostic.config({
      virtual_lines = false,
      signs = true,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
    })

    -- -- Show diagnostics on hover instead of virtual_text
    -- vim.api.nvim_create_autocmd("CursorHold", {
    --   buffer = bufnr,
    --   callback = function()
    --     local opts = {
    --       focusable = false,
    --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --       border = 'rounded',
    --       source = 'always',
    --       prefix = '',
    --       scope = 'cursor',
    --       style = 'minimal',
    --     }
    --     vim.diagnostic.open_float(nil, opts)
    --   end
    -- })


      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('dot-config_lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        end
      })

  end
}
