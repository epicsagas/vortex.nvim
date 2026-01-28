return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "strudel" },
        },
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "strudel" },
  },
  {
    "tidalcycles/vim-tidal",
    ft = { "strudel" },
    config = function()
      -- Strudel-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "strudel" },
        callback = function(event)
          local bufnr = event.buf

          -- F5: Start Strudel REPL (Node.js)
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal npx @strudel.cycles/repl")
            vim.cmd("startinsert")
          end, { desc = "[Strudel] Start REPL", buffer = bufnr })

          -- F6: Evaluate current line/selection
          vim.keymap.set("n", "<F6>", function()
            local line = vim.api.nvim_get_current_line()
            -- Send to Strudel REPL via terminal channel
            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, line .. "\r")
            else
              vim.notify("No Strudel REPL running. Press F5 to start.", vim.log.levels.WARN)
            end
          end, { desc = "[Strudel] Eval Line", buffer = bufnr })

          vim.keymap.set("v", "<F6>", function()
            local start_pos = vim.fn.getpos("'<")
            local end_pos = vim.fn.getpos("'>")
            local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
            local text = table.concat(lines, "\n")

            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, text .. "\r")
            else
              vim.notify("No Strudel REPL running. Press F5 to start.", vim.log.levels.WARN)
            end
          end, { desc = "[Strudel] Eval Selection", buffer = bufnr })

          -- Strudel-specific commands
          vim.keymap.set("n", "<leader>ss", function()
            vim.cmd("split | terminal npx @strudel.cycles/repl")
            vim.cmd("startinsert")
          end, { desc = "[Strudel] Start REPL", buffer = bufnr })

          vim.keymap.set("n", "<leader>sw", function()
            vim.cmd("split | terminal npx @strudel.cycles/web")
            vim.cmd("startinsert")
          end, { desc = "[Strudel] Start Web REPL", buffer = bufnr })

          vim.keymap.set("n", "<leader>sh", function()
            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, "hush()\r")
            else
              vim.notify("No Strudel REPL running.", vim.log.levels.WARN)
            end
          end, { desc = "[Strudel] Hush (Stop All)", buffer = bufnr })

          vim.keymap.set("n", "<leader>sp", function()
            local line = vim.api.nvim_get_current_line()
            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, line .. "\r")
            else
              vim.notify("No Strudel REPL running.", vim.log.levels.WARN)
            end
          end, { desc = "[Strudel] Play Line", buffer = bufnr })

          vim.keymap.set("v", "<leader>sp", function()
            local start_pos = vim.fn.getpos("'<")
            local end_pos = vim.fn.getpos("'>")
            local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
            local text = table.concat(lines, "\n")

            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, text .. "\r")
            else
              vim.notify("No Strudel REPL running.", vim.log.levels.WARN)
            end
          end, { desc = "[Strudel] Play Selection", buffer = bufnr })

          vim.keymap.set("n", "<leader>sb", function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local text = table.concat(lines, "\n")

            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, text .. "\r")
            else
              vim.notify("No Strudel REPL running.", vim.log.levels.WARN)
            end
          end, { desc = "[Strudel] Play Buffer", buffer = bufnr })

          -- Pattern management
          vim.keymap.set("n", "<leader>sc", function()
            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, "clear()\r")
            end
          end, { desc = "[Strudel] Clear All", buffer = bufnr })

          vim.keymap.set("n", "<leader>sr", function()
            if vim.b.terminal_job_id then
              vim.fn.chansend(vim.b.terminal_job_id, "reset()\r")
            end
          end, { desc = "[Strudel] Reset", buffer = bufnr })

          -- Run as Node.js script
          vim.keymap.set("n", "<leader>sn", function()
            vim.cmd("split | terminal node %")
            vim.cmd("startinsert")
          end, { desc = "[Strudel] Run as Node Script", buffer = bufnr })

          -- Open in browser
          vim.keymap.set("n", "<leader>so", function()
            local filepath = vim.fn.expand("%:p")
            vim.cmd("!open https://strudel.tidalcycles.org/")
          end, { desc = "[Strudel] Open Web REPL", buffer = bufnr })

          -- Documentation
          vim.keymap.set("n", "<leader>sH", function()
            vim.cmd("!open https://strudel.tidalcycles.org/learn/")
          end, { desc = "[Strudel] Open Documentation", buffer = bufnr })

          -- TypeScript import helpers (reuse from typescript.lua)
          vim.keymap.set("n", "<leader>si", "<cmd>TSToolsAddMissingImports<CR>", { desc = "[Strudel] Add Missing Imports", buffer = bufnr })
          vim.keymap.set("n", "<leader>sf", "<cmd>TSToolsFixAll<CR>", { desc = "[Strudel] Fix All", buffer = bufnr })
        end,
      })

      -- Set up file type detection for Strudel
      vim.filetype.add({
        extension = {
          strudel = "strudel",
        },
        pattern = {
          [".*%.strudel%.js"] = "strudel",
          [".*%.strudel%.ts"] = "strudel",
          [".*%.strudel"] = "strudel",
        },
      })

      -- Use JavaScript/TypeScript treesitter for Strudel syntax
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "strudel",
        callback = function()
          vim.treesitter.start(nil, "javascript")
        end,
      })
    end,
  },
}
