return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        r_language_server = {
          settings = {
            r = {
              lsp = {
                diagnostics = true,
                rich_documentation = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "R-nvim/R.nvim",
    ft = { "r", "rmd", "quarto" },
    config = function()
      require("r").setup({
        R_args = { "--quiet", "--no-save" },
        hook = {
          on_filetype = function()
            -- R-specific keybindings
            vim.api.nvim_buf_set_keymap(0, "n", "<F5>", "<Plug>RStart", { desc = "[R] Start R Console" })
            vim.api.nvim_buf_set_keymap(0, "n", "<F6>", "<Plug>RDSendFile", { desc = "[R] Send File to R" })
            vim.api.nvim_buf_set_keymap(0, "v", "<F6>", "<Plug>RDSendSelection", { desc = "[R] Send Selection to R" })
          end,
        },
        min_editor_width = 72,
        rconsole_width = 78,
        objbr_mappings = {
          c = "class",
          ["<localleader>gg"] = "head({object}, n = 15)",
          v = "vim.inspect({object})",
        },
        disable_cmds = {
          "RClearConsole",
          "RCustomStart",
          "RSPlot",
          "RSaveClose",
        },
      })

      -- Additional R keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "r", "rmd", "quarto" },
        callback = function(event)
          local bufnr = event.buf

          -- R-specific commands
          vim.keymap.set("n", "<leader>rr", "<Plug>RStart", { desc = "[R] Start Console", buffer = bufnr })
          vim.keymap.set("n", "<leader>rq", "<Plug>RClose", { desc = "[R] Close Console", buffer = bufnr })
          vim.keymap.set("n", "<leader>rf", "<Plug>RDSendFile", { desc = "[R] Send File", buffer = bufnr })
          vim.keymap.set("n", "<leader>rl", "<Plug>RDSendLine", { desc = "[R] Send Line", buffer = bufnr })
          vim.keymap.set("v", "<leader>rs", "<Plug>RDSendSelection", { desc = "[R] Send Selection", buffer = bufnr })
          vim.keymap.set("n", "<leader>rh", "<Plug>RHelp", { desc = "[R] Help", buffer = bufnr })
          vim.keymap.set("n", "<leader>ro", "<Plug>RObjectBrowser", { desc = "[R] Object Browser", buffer = bufnr })
          vim.keymap.set("n", "<leader>rv", "<Plug>RViewDF", { desc = "[R] View DataFrame", buffer = bufnr })

          -- Additional utility commands
          vim.keymap.set("n", "<leader>rc", function()
            vim.cmd("RClearAll")
          end, { desc = "[R] Clear All", buffer = bufnr })

          vim.keymap.set("n", "<leader>rp", function()
            vim.cmd("!Rscript %")
          end, { desc = "[R] Run Script", buffer = bufnr })

          vim.keymap.set("n", "<leader>ri", function()
            vim.cmd("split | terminal R")
            vim.cmd("startinsert")
          end, { desc = "[R] R Interactive", buffer = bufnr })
        end,
      })
    end,
  },
}
