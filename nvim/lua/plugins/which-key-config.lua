return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "org-mode", icon = { icon = "", hl = "WhichKeyGreen", color = "green" } },
        {
          "<leader>fs",
          "<cmd>w<CR>",
          desc = "Save",
          icon = { icon = "󰆓", hl = "WhichKeyYellow", color = "yellow" },
        },
      },
    },
  },
}
