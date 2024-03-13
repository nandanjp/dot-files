return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "emmet_language_server", "gopls", "html", "htmx", "hls", "jsonls", "tsserver", "prismals", "rust_analyzer", "svelte", "tailwindcss", "vuels", "zls" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.emmet_language_server.setup({})
      lspconfig.gopls.setup({})
      lspconfig.html.setup({})
      lspconfig.htmx.setup({})
      lspconfig.hls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.prismals.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.svelte.setup({})
      lspconfig.tailwindcss.setup({})
      lspconfig.vuels.setup({})
      lspconfig.zls.setup({})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
