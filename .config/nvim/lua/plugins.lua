local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  -- use {
  --  'svrana/neosolarized.nvim',
  --  requires = { 'tjdevries/colorbuddy.nvim' }
  -- }
  use 'bluz71/vim-nightfly-guicolors' -- preferred colorscheme
  use 'christoomey/vim-tmux-navigator'
  use 'szw/vim-maximizer'
  use 'tpope/vim-surround'
  use 'vim-scripts/ReplaceWithRegister'

  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'nvim-lua/plenary.nvim' -- Common utilities
  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  
  -- auto-completion
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  
  -- snippets
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets' 

  use 'neovim/nvim-lspconfig' -- LSP
  use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  use 'jayp0521/mason-null-ls.nvim'
  use 'jose-elias-alvarez/typescript.nvim'
  use 'MunifTanjim/prettier.nvim'
  
  -- managing and installing lsp servers
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
        require('lspsaga').setup({})
    end,
  })

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use 'nvim-tree/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons' -- File icons
  use {'nvim-telescope/telescope.nvim', branch = '0.1.x'}
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

  -- auto closing
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use { 'numToStr/Comment.nvim',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    }
  }
  use 'norcalli/nvim-colorizer.lua'
  use 'folke/zen-mode.nvim'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'akinsho/nvim-bufferline.lua'
  -- use 'github/copilot.vim'

  use 'lewis6991/gitsigns.nvim'

  -- C++ lsp
  use {'neoclide/coc.nvim', branch = 'master', run = 'yarn install --frozen-lockfile'}
end)
