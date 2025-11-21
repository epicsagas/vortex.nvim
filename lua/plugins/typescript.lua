return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = {},
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })

      -- TypeScript/JavaScript keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function()
          -- Quick run/test keymaps
          vim.keymap.set("n", "<F5>", function()
            local ft = vim.bo.filetype
            if ft == "typescript" or ft == "typescriptreact" then
              vim.cmd("split | terminal npx tsx %")
            else
              vim.cmd("split | terminal node %")
            end
            vim.cmd("startinsert")
          end, { desc = "[TS/JS] Run Script", buffer = true })

          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal npm test")
            vim.cmd("startinsert")
          end, { desc = "[TS/JS] Run Tests", buffer = true })

          -- TypeScript-specific commands
          vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<CR>", { desc = "[TS] Organize Imports", buffer = true })
          vim.keymap.set("n", "<leader>ts", "<cmd>TSToolsSortImports<CR>", { desc = "[TS] Sort Imports", buffer = true })
          vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<CR>", { desc = "[TS] Remove Unused", buffer = true })
          vim.keymap.set("n", "<leader>ti", "<cmd>TSToolsAddMissingImports<CR>", { desc = "[TS] Add Missing Imports", buffer = true })
          vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<CR>", { desc = "[TS] Fix All", buffer = true })
          vim.keymap.set("n", "<leader>td", "<cmd>TSToolsGoToSourceDefinition<CR>", { desc = "[TS] Go to Source Definition", buffer = true })
          vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRenameFile<CR>", { desc = "[TS] Rename File", buffer = true })
        end,
      })
    end,
  },
}
