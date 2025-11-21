return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqlls = {
          settings = {
            sql = {
              database = "mysql", -- or "postgresql", "sqlite"
              linter = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "vim-scripts/dbext.vim",
    ft = { "sql", "mysql", "plsql" },
    config = function()
      -- SQL-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function(event)
          local bufnr = event.buf

          -- F5: Execute SQL file or selection
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal cat %")
            vim.cmd("startinsert")
          end, { desc = "[SQL] View SQL File", buffer = bufnr })

          -- F6: Format SQL
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("!sqlfluff format %")
          end, { desc = "[SQL] Format SQL File", buffer = bufnr })

          -- SQL-specific commands
          vim.keymap.set("n", "<leader>sf", function()
            vim.cmd("!sqlfluff format %")
          end, { desc = "[SQL] Format", buffer = bufnr })

          vim.keymap.set("n", "<leader>sl", function()
            vim.cmd("!sqlfluff lint %")
          end, { desc = "[SQL] Lint", buffer = bufnr })

          vim.keymap.set("n", "<leader>sc", function()
            vim.cmd("split | terminal cat %")
            vim.cmd("startinsert")
          end, { desc = "[SQL] View Content", buffer = bufnr })
        end,
      })
    end,
  },
}
