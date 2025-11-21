return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          settings = {
            ruby = {
              lint = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "vim-ruby/vim-ruby",
    ft = "ruby",
    config = function()
      -- Ruby-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Run Ruby file
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal ruby %")
            vim.cmd("startinsert")
          end, { desc = "[Ruby] Run", buffer = bufnr })

          -- F6: Run RSpec tests
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("Gemfile") == 1 then
              vim.cmd("split | terminal bundle exec rspec")
            else
              vim.cmd("split | terminal rspec %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Ruby] Run Tests", buffer = bufnr })

          -- Ruby-specific commands
          vim.keymap.set("n", "<leader>Rr", function()
            vim.cmd("split | terminal ruby %")
            vim.cmd("startinsert")
          end, { desc = "[Ruby] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>Rt", function()
            if vim.fn.filereadable("Gemfile") == 1 then
              vim.cmd("split | terminal bundle exec rspec")
            else
              vim.cmd("split | terminal rspec %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Ruby] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>Rb", function()
            vim.cmd("split | terminal bundle install")
            vim.cmd("startinsert")
          end, { desc = "[Ruby] Bundle Install", buffer = bufnr })

          vim.keymap.set("n", "<leader>Rf", function()
            vim.cmd("!rubocop -A %")
          end, { desc = "[Ruby] Format (Rubocop)", buffer = bufnr })

          vim.keymap.set("n", "<leader>Rl", function()
            vim.cmd("!rubocop %")
          end, { desc = "[Ruby] Lint (Rubocop)", buffer = bufnr })

          vim.keymap.set("n", "<leader>Ri", function()
            vim.cmd("split | terminal irb")
            vim.cmd("startinsert")
          end, { desc = "[Ruby] IRB REPL", buffer = bufnr })
        end,
      })
    end,
  },
}
