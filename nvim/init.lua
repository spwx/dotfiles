local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    'tpope/vim-commentary',
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
    	    require("nvim-surround").setup({
	        -- Configuration here, or leave empty to use defaults
	    })
            end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { { "nvim-treesitter/nvim-treesitter" } },
    }
}

require("lazy").setup(plugins, opts)

vim.keymap.set('i', 'jk', [[<C-\><C-n>]]) -- no need to escape the '\'
vim.keymap.set('n', 'gh', '^')
vim.keymap.set('n', 'gl', '$')

