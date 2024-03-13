return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {"bash", "c", "cpp", "css", "dockerfile", "gitignore", "go", "gomod", "haskell", "html", "javascript", "latex", "lua", "markdown_inline", "ocaml", "prisma", "python", "rust", "scala", "svelte", "tsx", "typescript", "vim", "vimdoc", "vue", "yaml"},
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
