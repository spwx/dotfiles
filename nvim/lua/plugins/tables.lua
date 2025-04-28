return {
  "dhruvasagar/vim-table-mode",
  -- | Key/Command                  | Function                           |
  -- |------------------------------+------------------------------------|
  -- | :Tableize                    | convert CSV to table               |
  -- | :Tableize/{delimeter}        | tableize and specify the delimeter |
  -- | :TableModeRealign            | realign a table                    |
  -- | :TableModeEnable/<leader>bte | turn on table mode                 |
  -- | <leader>btdc                 | delete a column                    |
  -- | <leader>btdr                 | realign a table                    |
  -- | <leader>btic                 | insert a column before             |
  -- |------------------------------+------------------------------------|
  init = function()
    -- remap some keys
    -- legacy key remaps need to go in the init section, not config
    vim.g.table_mode_map_prefix = "<leader>bt"
    vim.g.table_mode_tableize_map = "<leader>btt"
    -- don't override the functionality of `{` or `}`
    vim.g.table_mode_motion_up_map = ""
    vim.g.table_mode_motion_down_map = ""
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable TableMode for Markdown files",
      group = vim.api.nvim_create_augroup("MarkdownAutoCommands", { clear = true }),
      callback = function()
        vim.cmd("silent! TableModeEnable")
      end,
    })
  end,
}
