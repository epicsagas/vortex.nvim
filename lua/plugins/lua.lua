return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    ft = "lua",
    config = function()
      -- Lua-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Run Lua file
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal lua %")
            vim.cmd("startinsert")
          end, { desc = "[Lua] Run", buffer = bufnr })

          -- F6: Source current Lua file (for Neovim config)
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("source %")
            vim.notify("Sourced " .. vim.fn.expand("%"), vim.log.levels.INFO)
          end, { desc = "[Lua] Source File", buffer = bufnr })

          -- Lua-specific commands
          vim.keymap.set("n", "<leader>Lr", function()
            vim.cmd("split | terminal lua %")
            vim.cmd("startinsert")
          end, { desc = "[Lua] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>Ls", function()
            vim.cmd("source %")
            vim.notify("Sourced " .. vim.fn.expand("%"), vim.log.levels.INFO)
          end, { desc = "[Lua] Source", buffer = bufnr })

          vim.keymap.set("n", "<leader>Lf", function()
            vim.cmd("!stylua %")
          end, { desc = "[Lua] Format (stylua)", buffer = bufnr })

          vim.keymap.set("n", "<leader>Lc", function()
            vim.cmd("!luacheck %")
          end, { desc = "[Lua] Check (luacheck)", buffer = bufnr })
        end,
      })
    end,
  },
}
