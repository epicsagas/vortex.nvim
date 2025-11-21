return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    ft = "python",
    opts = {
      name = { "venv", ".venv", "env", ".env" },
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "[Python] Select VirtualEnv" },
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)

      -- Python keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Quick run/test keymaps
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal python3 %")
            vim.cmd("startinsert")
          end, { desc = "[Python] Run Script", buffer = true })

          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal python3 -m pytest")
            vim.cmd("startinsert")
          end, { desc = "[Python] Run Tests", buffer = true })

          -- Python-specific commands
          vim.keymap.set("n", "<leader>pc", function()
            vim.cmd("split | terminal python3 -m compileall %")
            vim.cmd("startinsert")
          end, { desc = "[Python] Check Syntax", buffer = true })

          vim.keymap.set("n", "<leader>pi", function()
            vim.cmd("split | terminal pip install -r requirements.txt")
            vim.cmd("startinsert")
          end, { desc = "[Python] Install Requirements", buffer = true })
        end,
      })
    end,
  },
}
