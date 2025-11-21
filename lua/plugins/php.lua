return {
  {
    "gbprod/phpactor.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = "php",
    build = function()
      require("phpactor.handler.update")()
    end,
    config = function()
      require("phpactor").setup({
        install = {
          bin = vim.fn.stdpath("data") .. "/phpactor/bin/phpactor",
        },
        lspconfig = {
          enabled = true,
          init_options = {
            ["language_server_phpstan.enabled"] = true,
            ["language_server_psalm.enabled"] = false,
          },
        },
      })

      -- PHP keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "php",
        callback = function()
          -- Quick run/test keymaps
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal php %")
            vim.cmd("startinsert")
          end, { desc = "[PHP] Run Script", buffer = true })

          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal ./vendor/bin/phpunit")
            vim.cmd("startinsert")
          end, { desc = "[PHP] Run Tests", buffer = true })

          -- PHP-specific commands
          vim.keymap.set("n", "<leader>pm", "<cmd>PhpactorContextMenu<CR>", { desc = "[PHP] Context Menu", buffer = true })
          vim.keymap.set("n", "<leader>pn", "<cmd>PhpactorClassNew<CR>", { desc = "[PHP] New Class", buffer = true })
          vim.keymap.set("n", "<leader>pe", "<cmd>PhpactorClassExpand<CR>", { desc = "[PHP] Expand Class", buffer = true })
          vim.keymap.set("n", "<leader>pu", "<cmd>PhpactorImportClass<CR>", { desc = "[PHP] Import Class", buffer = true })
          vim.keymap.set("n", "<leader>pa", "<cmd>PhpactorImportMissingClasses<CR>", { desc = "[PHP] Import Missing Classes", buffer = true })
          vim.keymap.set("n", "<leader>pt", "<cmd>PhpactorTransform<CR>", { desc = "[PHP] Transform", buffer = true })
          vim.keymap.set("n", "<leader>pg", "<cmd>PhpactorGenerateMethod<CR>", { desc = "[PHP] Generate Method", buffer = true })
        end,
      })
    end,
  },
}
