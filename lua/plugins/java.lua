return {
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    ft = "java",
    config = function()
      require("java").setup()

      -- Java keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Quick run/test keymaps
          vim.keymap.set("n", "<F5>", function()
            -- Find the main class and run
            local file = vim.fn.expand("%:t:r")
            vim.cmd("split | terminal javac % && java " .. file)
            vim.cmd("startinsert")
          end, { desc = "[Java] Compile & Run", buffer = true })

          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal mvn test")
            vim.cmd("startinsert")
          end, { desc = "[Java] Run Tests", buffer = true })

          -- Java-specific commands
          vim.keymap.set("n", "<leader>jc", "<cmd>JavaRunnerRunMain<CR>", { desc = "[Java] Run Main Class", buffer = true })
          vim.keymap.set("n", "<leader>jt", "<cmd>JavaTestRunCurrentClass<CR>", { desc = "[Java] Test Current Class", buffer = true })
          vim.keymap.set("n", "<leader>jT", "<cmd>JavaTestRunCurrentMethod<CR>", { desc = "[Java] Test Current Method", buffer = true })
          vim.keymap.set("n", "<leader>jd", "<cmd>JavaTestDebugCurrentClass<CR>", { desc = "[Java] Debug Test Class", buffer = true })
        end,
      })
    end,
  },
}
