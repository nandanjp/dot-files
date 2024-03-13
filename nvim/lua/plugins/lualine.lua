return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require('lualine').setup({
      options = {
        them = 'dracula'
      }
    })
  end
}
