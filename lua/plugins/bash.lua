return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command)",
            },
          },
        },
      },
    },
  },
  {
    "bash-lsp/bash-language-server",
    ft = { "sh", "bash", "zsh" },
    config = function()
      -- Bash-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash", "zsh" },
        callback = function(event)
          local bufnr = event.buf

          -- F5: Run shell script
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal bash %")
            vim.cmd("startinsert")
          end, { desc = "[Bash] Run Script", buffer = bufnr })

          -- F6: Check syntax
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("!shellcheck %")
          end, { desc = "[Bash] Shellcheck", buffer = bufnr })

          -- Bash-specific commands
          vim.keymap.set("n", "<leader>br", function()
            vim.cmd("split | terminal bash %")
            vim.cmd("startinsert")
          end, { desc = "[Bash] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>bx", function()
            vim.cmd("!chmod +x %")
            vim.notify("Made executable: " .. vim.fn.expand("%"), vim.log.levels.INFO)
          end, { desc = "[Bash] Make Executable", buffer = bufnr })

          vim.keymap.set("n", "<leader>bc", function()
            vim.cmd("!shellcheck %")
          end, { desc = "[Bash] Shellcheck", buffer = bufnr })

          vim.keymap.set("n", "<leader>bf", function()
            vim.cmd("!shfmt -w %")
          end, { desc = "[Bash] Format (shfmt)", buffer = bufnr })

          vim.keymap.set("n", "<leader>bd", function()
            vim.cmd("!bash -x %")
          end, { desc = "[Bash] Debug Mode", buffer = bufnr })

          vim.keymap.set("n", "<leader>bs", function()
            vim.cmd("!bash -n %")
          end, { desc = "[Bash] Syntax Check", buffer = bufnr })
        end,
      })
    end,
  },
}
