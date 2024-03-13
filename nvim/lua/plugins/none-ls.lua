return {
"nvimtools/none-ls.nvim",
config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.diagnostics.cppcheck,
      null_ls.builtins.diagnostics.staticcheck,
      null_ls.builtins.formatting.gofmt,
      null_ls.builtins.formatting.rustywind,
      null_ls.builtins.formatting.scalafmt,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.black,
    })

    vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
  end
}
