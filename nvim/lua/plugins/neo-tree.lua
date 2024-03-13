return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", {})
            vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
            require("neo-tree").setup({
                close_if_last_window = true,
                popup_border_style = "rounded",
                filesystem = {
                    filtered_items = {
                        visible = true,
                        show_hidden_count = true,
                        hide_hidden = false,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        never_show = {},
                    },
                }
            })
        end,
    },
    {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
            require 'window-picker'.setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { 'terminal', "quickfix" },
                    },
                },
            })
        end,
    },
}
