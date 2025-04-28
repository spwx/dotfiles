-- adjust the terminal bg color to match the current neovim colorscheme
-- https://old.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

return {
  -- Configure ef-themes
  { "oonamo/ef-themes.nvim", lazy = false, priority = 1000, opts = { modules = { orgmode = true } } },

  -- Set the theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ef-maris-dark",
    },
  },
}
