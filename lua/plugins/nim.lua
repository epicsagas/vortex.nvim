return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nim_langserver = {
          settings = {
            nim = {
              nimsuggestPath = "nimsuggest",
            },
          },
        },
      },
    },
  },
  {
    "alaviss/nim.nvim",
    ft = "nim",
    config = function()
      -- Nim-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nim",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Compile and run Nim file
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("*.nimble") == 1 then
              vim.cmd("split | terminal nimble run")
            else
              vim.cmd("split | terminal nim compile --run %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Nim] Compile & Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("*.nimble") == 1 then
              vim.cmd("split | terminal nimble test")
            else
              vim.cmd("split | terminal nim test %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Nim] Test", buffer = bufnr })

          -- Nim-specific commands
          vim.keymap.set("n", "<leader>nr", function()
            vim.cmd("split | terminal nim compile --run %")
            vim.cmd("startinsert")
          end, { desc = "[Nim] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>nb", function()
            vim.cmd("!nim compile %")
          end, { desc = "[Nim] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>nc", function()
            vim.cmd("!nim check %")
          end, { desc = "[Nim] Check", buffer = bufnr })

          vim.keymap.set("n", "<leader>nt", function()
            vim.cmd("split | terminal nimble test")
            vim.cmd("startinsert")
          end, { desc = "[Nim] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>nf", function()
            vim.cmd("!nimpretty %")
          end, { desc = "[Nim] Format (nimpretty)", buffer = bufnr })

          vim.keymap.set("n", "<leader>nd", function()
            vim.cmd("!nim doc %")
          end, { desc = "[Nim] Generate Docs", buffer = bufnr })

          vim.keymap.set("n", "<leader>nR", function()
            vim.cmd("split | terminal nim compile -r -d:release %")
            vim.cmd("startinsert")
          end, { desc = "[Nim] Release Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>nD", function()
            vim.cmd("split | terminal nim compile -r -d:debug %")
            vim.cmd("startinsert")
          end, { desc = "[Nim] Debug Build", buffer = bufnr })
        end,
      })
    end,
  },
}
