return {
  {
    "nvim-orgmode/orgmode",
    -- Next two line work around folding issues.
    -- See: https://github.com/nvim-orgmode/orgmode/issues/975#issuecomment-2851182006
    lazy = false,
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      {
        "akinsho/org-bullets.nvim",
        opts = {
          symbols = {
            list = "-",
            checkboxes = {
              half = { "-", "@org.checkbox.halfchecked" },
              done = { "✓", "@org.keyword.done" },
              todo = { " ", "@org.keyword.todo" },
            },
          },
        },
      },
      {
        "hamidi-dev/org-list.nvim",
        dependencies = {
          "tpope/vim-repeat", -- for repeatable actions with '.'
        },
        config = function()
          require("org-list").setup({
            mapping = {
              key = "<leader>olt", -- nvim-orgmode users: you might want to change this to <leader>olt
              desc = "Toggle: Cycle through list types",
            },
          })
        end,
      },
    },
    opts = {
      org_agenda_files = "~/org/**/*",
      org_default_notes_file = "~/org/refile.org",
      calendar_week_start_day = 0,
      org_startup_indented = true,
      mappings = {
        org = {
          org_open_at_point = "<CR>",
        },
      },
      org_todo_keywords = { "TODO(t)", "PROG(p)", "WAIT(w)", "|", "DONE(d)", "STOP(s)" },
      org_todo_keyword_faces = {
        WAIT = ":foreground orange",
        PROG = ":foreground yellow",
        STOP = ":foreground grey",
      },
    },
    init = function()
      -- Set linebreak and textwidth for Markdown files
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("OrgmodeSettings", { clear = true }),
        pattern = "org",
        callback = function()
          vim.opt_local.linebreak = true
          vim.opt_local.textwidth = 80
          vim.opt_local.conceallevel = 2
          vim.opt.concealcursor = "nc"
          vim.opt_local.wrap = false
          vim.opt_local.spell = true
        end,
      })

      -- Remove the background color from Org Headlines
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
        end,
      })

      -- Map <leader>om in visual mode to convert selected text from Org-mode to
      -- GitHub Flavored Markdown.
      -- The keymap is buffer-local (only works in Org files).
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          vim.keymap.set(
            "v",
            "<leader>om",
            ":'<,'>w !/opt/homebrew/bin/pandoc -f org -t gfm --wrap=none | pbcopy<CR>:lua vim.notify('Converted selection to Markdown and copied to clipboard', vim.log.levels.INFO)<CR>",
            { noremap = true, silent = true, desc = "Convert org to gfm and copy to clipboard", buffer = true }
          )
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "org", "orgagenda" }, -- or whatever filetype
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        filter = function(buf)
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and vim.bo[buf].filetype ~= "org"
        end,
      },
    },
  },
}
