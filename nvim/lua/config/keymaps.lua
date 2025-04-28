-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("n", "<bs>", ":edit #<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "gh", "^", { silent = true })
vim.keymap.set({ "n", "v" }, "gl", "$", { silent = true })

vim.keymap.set("n", "<leader>bC", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to clipboard!')
end, { desc = "Copy buffer path to clipboard" })
