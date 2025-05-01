-- To use this config in VSCode
-- 1. Install the "VSCode Neovim" plugin.
-- 2. Modify VSCode's settings.json file to include these two lines:
--    "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
--    "vscode-neovim.neovimInitVimPaths.darwin": "$HOME/.config/vscode-neovim-config/init.lua",
--
-- To upadte the Neovim Plugins:
-- 1. NVIM_APPNAME=vscode-neovim-config nvim
-- 2. In nvim run :Lazy

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"kylechui/nvim-surround",
			version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- vscode setup
if vim.g.vscode then -- VSCode extension
	vim.g.mapleader = " "

	vim.keymap.set({ "n", "v" }, "gl", "$")
	vim.keymap.set({ "n", "v" }, "gh", "^")
	vim.keymap.set({ "n", "v" }, "<leader>fs", ":w<CR>")

	-- Needed for folding
	vim.api.nvim_set_keymap("n", "j", "gj", { noremap = false, silent = true })
	vim.api.nvim_set_keymap("n", "k", "gk", { noremap = false, silent = true })

	local vscode = require("vscode")

	local function map(mode, lhs, rhs)
		vim.keymap.set(mode, lhs, function()
			vscode.call(rhs)
		end, { silent = true, noremap = true })
	end

	map("n", "zM", "editor.foldAll")
	map("n", "zR", "editor.unfoldAll")
	map("n", "zc", "editor.fold")
	map("n", "zC", "editor.foldRecursively")
	map("n", "zo", "editor.unfold")
	map("n", "zO", "editor.unfoldRecursively")
	map("n", "za", "editor.toggleFold")

	-- Code navigation
	map("n", "gd", "editor.action.peekDefinition")
	map("n", "gD", "editor.action.revealDefinition")
	map("n", "gr", "editor.action.referenceSearch.trigger")
	map("n", "ga", "editor.action.quickFix")
	map("n", "gf", "editor.action.formatDocument")
	map("n", "gR", "editor.action.rename")
end
