return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        go = "go",
        goimports = "gopls",
        gofmt = "gofumpt",
        fillstruct = "gopls",
        tag_transform = false,
        test_template = "",
        test_template_dir = "",
        comment_placeholder = "",
        lsp_cfg = false, -- Using lspconfig from lsp.lua
        lsp_gofumpt = true,
        lsp_on_attach = false,
        dap_debug = true,
      })

      -- Go-specific keymaps
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          -- Quick run/test keymaps
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal go run .")
            vim.cmd("startinsert")
          end, { desc = "[Go] Run Main", buffer = true })
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal go test -v ./...")
            vim.cmd("startinsert")
          end, { desc = "[Go] Test Package", buffer = true })

          -- Go-specific keymaps
          vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", { desc = "[Go] Run", buffer = true })
          vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "[Go] Test All", buffer = true })
          vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFunc<CR>", { desc = "[Go] Test Function", buffer = true })
          vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", { desc = "[Go] Coverage", buffer = true })
          vim.keymap.set("n", "<leader>gC", "<cmd>GoCoverageClear<CR>", { desc = "[Go] Clear Coverage", buffer = true })
          vim.keymap.set("n", "<leader>gi", "<cmd>GoIfErr<CR>", { desc = "[Go] If Err", buffer = true })
          vim.keymap.set("n", "<leader>gf", "<cmd>GoFillStruct<CR>", { desc = "[Go] Fill Struct", buffer = true })
          vim.keymap.set("n", "<leader>ga", "<cmd>GoAlt<CR>", { desc = "[Go] Alternate File", buffer = true })
          vim.keymap.set("n", "<leader>gm", "<cmd>GoModTidy<CR>", { desc = "[Go] Mod Tidy", buffer = true })
          vim.keymap.set("n", "<leader>ge", "<cmd>GoGenerate<CR>", { desc = "[Go] Generate", buffer = true })
        end,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
