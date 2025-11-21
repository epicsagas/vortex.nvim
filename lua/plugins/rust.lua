return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Quick run/test keymaps
            vim.keymap.set("n", "<F5>", function()
              vim.cmd("split | terminal cargo run")
              vim.cmd("startinsert")
            end, { desc = "[Rust] Run Project", buffer = bufnr })
            vim.keymap.set("n", "<F6>", function()
              vim.cmd("split | terminal cargo test")
              vim.cmd("startinsert")
            end, { desc = "[Rust] Test All", buffer = bufnr })

            -- Rust-specific keymaps
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, { desc = "[Rust] Runnables Menu", buffer = bufnr })
            vim.keymap.set("n", "<leader>rt", function()
              vim.cmd.RustLsp("testables")
            end, { desc = "[Rust] Testables Menu", buffer = bufnr })
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, { desc = "[Rust] Debuggables", buffer = bufnr })
            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp("expandMacro")
            end, { desc = "[Rust] Expand Macro", buffer = bufnr })
            vim.keymap.set("n", "<leader>rc", function()
              vim.cmd.RustLsp("openCargo")
            end, { desc = "[Rust] Open Cargo.toml", buffer = bufnr })
            vim.keymap.set("n", "<leader>rp", function()
              vim.cmd.RustLsp("parentModule")
            end, { desc = "[Rust] Parent Module", buffer = bufnr })
            vim.keymap.set("n", "<leader>rh", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, { desc = "[Rust] Hover Actions", buffer = bufnr })
          end,
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        popup = {
          autofocus = true,
        },
      })

      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({ sources = { { name = "crates" } } })
        end,
      })
    end,
  },
}
