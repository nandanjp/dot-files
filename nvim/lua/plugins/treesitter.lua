return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = { "css", "dockerfile", "go", "haskell", "hcl", "html", "javascript", "lua", "proto", "python", "rust", "sql", "terraform", "tsx", "typescript", "vim", "vimdoc", "yaml" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
