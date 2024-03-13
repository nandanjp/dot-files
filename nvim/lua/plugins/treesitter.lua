return {
  "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"c", "cpp", "css", "go", "haskell", "html", "javascript", "lua", "ocaml", "proto", "python", "rust", "scala", "sql", "svelte", "tsx", "typescript", "vim", "vimdoc", "vue"},
      highlight = { enable = true },
      indent = { enable = true },  
    })
  end
}
