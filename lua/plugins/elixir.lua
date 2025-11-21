return {
  {
    "elixir-tools/elixir-tools.nvim",
    ft = { "elixir", "eex", "heex", "surface" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        nextls = { enable = true },
        credo = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = true,
            enableTestLenses = true,
          }),
        },
      })

      -- Elixir-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "elixir", "eex", "heex", "surface" },
        callback = function(event)
          local bufnr = event.buf

          -- F5: Run Elixir project
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("mix.exs") == 1 then
              vim.cmd("split | terminal mix run")
            else
              vim.cmd("split | terminal elixir %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Elixir] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal mix test")
            vim.cmd("startinsert")
          end, { desc = "[Elixir] Test", buffer = bufnr })

          -- Elixir-specific commands
          vim.keymap.set("n", "<leader>er", function()
            vim.cmd("split | terminal iex -S mix")
            vim.cmd("startinsert")
          end, { desc = "[Elixir] IEx REPL", buffer = bufnr })

          vim.keymap.set("n", "<leader>et", function()
            vim.cmd("split | terminal mix test")
            vim.cmd("startinsert")
          end, { desc = "[Elixir] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>eT", function()
            vim.cmd("split | terminal mix test %")
            vim.cmd("startinsert")
          end, { desc = "[Elixir] Test Current File", buffer = bufnr })

          vim.keymap.set("n", "<leader>ef", function()
            vim.cmd("!mix format %")
          end, { desc = "[Elixir] Format", buffer = bufnr })

          vim.keymap.set("n", "<leader>ec", function()
            vim.cmd("!mix compile")
          end, { desc = "[Elixir] Compile", buffer = bufnr })

          vim.keymap.set("n", "<leader>ed", function()
            vim.cmd("!mix deps.get")
          end, { desc = "[Elixir] Get Dependencies", buffer = bufnr })

          vim.keymap.set("n", "<leader>eD", function()
            vim.cmd("!mix dialyzer")
          end, { desc = "[Elixir] Dialyzer", buffer = bufnr })

          vim.keymap.set("n", "<leader>eC", function()
            vim.cmd("!mix credo")
          end, { desc = "[Elixir] Credo", buffer = bufnr })

          vim.keymap.set("n", "<leader>ep", function()
            vim.cmd("split | terminal mix phx.server")
            vim.cmd("startinsert")
          end, { desc = "[Elixir] Phoenix Server", buffer = bufnr })
        end,
      })
    end,
  },
}
