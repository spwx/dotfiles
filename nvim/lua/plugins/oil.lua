return {
  "stevearc/oil.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    win_options = {
      -- Display the path in the winbar
      winbar = "%{v:lua.require('oil').get_current_dir()}",
    },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Oil", mode = "n" },
  },
}
