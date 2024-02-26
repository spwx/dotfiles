-- init.lua

-- must go first
vim.g.mapleader = " "

-- universal mappings
vim.keymap.set({ 'n' }, "<Esc>", "<Esc><cmd>:noh<CR>")

-- setup lazy.nvim package manager
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

-- install plugins
require("lazy").setup({
    "xiyaowong/fast-cursor-move.nvim",
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
})

-- load vscode-neovim config
if vim.g.vscode then
    require "vsconfig"
end
