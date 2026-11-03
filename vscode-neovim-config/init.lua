-- Plugins are installed by Nix (vscodeNeovim in nix/home.nix) and pinned by
-- flake.lock; update them with `nix flake update`.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("nvim-surround").setup({})

-- vscode setup
if vim.g.vscode then -- VSCode extension
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
	map("n", "gD", "editor.action.peekDefinition")
	map("n", "gd", "editor.action.revealDefinition")
	map("n", "gr", "editor.action.referenceSearch.trigger")
	map("n", "ga", "editor.action.quickFix")
	map("n", "gf", "editor.action.formatDocument")
	map("n", "gR", "editor.action.rename")

	-- Tabs
	map("n", "H", "workbench.action.previousEditor")
	map("n", "L", "workbench.action.nextEditor")
end
