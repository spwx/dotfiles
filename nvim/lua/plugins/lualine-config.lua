return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },

    sections = {
      lualine_a = { { "mode", separator = { left = "" }, icon = "" } },
      lualine_c = {
        {
          "filename",
          color = function()
            return { fg = vim.bo.modified and "#fabd2f" or nil, gui = "bold" }
          end,
        },
      },
      lualine_z = {
        { "location", separator = { right = "" } },
      },
    },
  },
}
