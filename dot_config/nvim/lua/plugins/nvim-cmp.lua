return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    -- XXX: Signature help has been moved to noice.nvim for now
    -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
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
    vim.api.nvim_create_autocmd('LspAttach',  {
      desc = "LSP Actions",
      callback = function(args)
        local bufnr = args.buf
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
        { name = 'luasnip' },
        { name = 'emoji' },
        { name = 'buffer' },
        { name = 'path' }
      }, {
        name = 'buffer'
      })
    })
  end
}
