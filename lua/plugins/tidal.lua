return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hls = {
          filetypes = { "haskell", "lhaskell", "cabal", "cabalproject", "tidal" },
          settings = {
            haskell = {
              formattingProvider = "ormolu",
              checkProject = true,
            },
          },
        },
      },
    },
  },
  {
    "tidalcycles/vim-tidal",
    ft = { "tidal" },
    config = function()
      -- TidalCycles configuration
      vim.g.tidal_target = "terminal"
      vim.g.tidal_default_config = {
        socket = "default",
        boot = "BootTidal.hs",
      }

      -- TidalCycles-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tidal" },
        callback = function(event)
          local bufnr = event.buf

          -- F5: Start TidalCycles REPL
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("split | terminal ghci -XOverloadedStrings")
            vim.cmd("startinsert")
            -- Auto-import Tidal
            vim.fn.chansend(vim.b.terminal_job_id, ":script BootTidal.hs\r")
          end, { desc = "[Tidal] Start REPL", buffer = bufnr })

          -- F6: Evaluate current line/selection
          vim.keymap.set("n", "<F6>", function()
            local line = vim.api.nvim_get_current_line()
            vim.cmd("TidalSend " .. line)
          end, { desc = "[Tidal] Eval Line", buffer = bufnr })

          vim.keymap.set("v", "<F6>", function()
            vim.cmd("'<,'>TidalSend")
          end, { desc = "[Tidal] Eval Selection", buffer = bufnr })

          -- Tidal-specific commands
          vim.keymap.set("n", "<leader>ts", function()
            vim.cmd("split | terminal ghci -XOverloadedStrings")
            vim.cmd("startinsert")
            vim.fn.chansend(vim.b.terminal_job_id, ":script BootTidal.hs\r")
          end, { desc = "[Tidal] Start REPL", buffer = bufnr })

          vim.keymap.set("n", "<leader>th", function()
            vim.cmd("TidalSend hush")
          end, { desc = "[Tidal] Hush (Stop All)", buffer = bufnr })

          vim.keymap.set("n", "<leader>tp", function()
            local line = vim.api.nvim_get_current_line()
            vim.cmd("TidalSend " .. line)
          end, { desc = "[Tidal] Play Line", buffer = bufnr })

          vim.keymap.set("v", "<leader>tp", function()
            vim.cmd("'<,'>TidalSend")
          end, { desc = "[Tidal] Play Selection", buffer = bufnr })

          vim.keymap.set("n", "<leader>tb", function()
            vim.cmd("%TidalSend")
          end, { desc = "[Tidal] Play Buffer", buffer = bufnr })

          vim.keymap.set("n", "<leader>t1", function()
            vim.cmd("TidalSend d1 silence")
          end, { desc = "[Tidal] Silence d1", buffer = bufnr })

          vim.keymap.set("n", "<leader>t2", function()
            vim.cmd("TidalSend d2 silence")
          end, { desc = "[Tidal] Silence d2", buffer = bufnr })

          vim.keymap.set("n", "<leader>t3", function()
            vim.cmd("TidalSend d3 silence")
          end, { desc = "[Tidal] Silence d3", buffer = bufnr })

          vim.keymap.set("n", "<leader>t4", function()
            vim.cmd("TidalSend d4 silence")
          end, { desc = "[Tidal] Silence d4", buffer = bufnr })

          vim.keymap.set("n", "<leader>tH", function()
            vim.cmd("TidalHelp")
          end, { desc = "[Tidal] Show Help", buffer = bufnr })

          vim.keymap.set("n", "<leader>tc", function()
            vim.cmd("TidalConfig")
          end, { desc = "[Tidal] Show Config", buffer = bufnr })

          -- Quick pattern shortcuts
          vim.keymap.set("n", "<leader>td1", function()
            vim.cmd("TidalSend d1")
          end, { desc = "[Tidal] d1 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td2", function()
            vim.cmd("TidalSend d2")
          end, { desc = "[Tidal] d2 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td3", function()
            vim.cmd("TidalSend d3")
          end, { desc = "[Tidal] d3 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td4", function()
            vim.cmd("TidalSend d4")
          end, { desc = "[Tidal] d4 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td5", function()
            vim.cmd("TidalSend d5")
          end, { desc = "[Tidal] d5 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td6", function()
            vim.cmd("TidalSend d6")
          end, { desc = "[Tidal] d6 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td7", function()
            vim.cmd("TidalSend d7")
          end, { desc = "[Tidal] d7 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td8", function()
            vim.cmd("TidalSend d8")
          end, { desc = "[Tidal] d8 Pattern", buffer = bufnr })

          vim.keymap.set("n", "<leader>td9", function()
            vim.cmd("TidalSend d9")
          end, { desc = "[Tidal] d9 Pattern", buffer = bufnr })

          -- SuperCollider control
          vim.keymap.set("n", "<leader>tS", function()
            vim.cmd("split | terminal sclang")
            vim.cmd("startinsert")
          end, { desc = "[Tidal] Start SuperCollider", buffer = bufnr })

          vim.keymap.set("n", "<leader>tB", function()
            vim.cmd("split | terminal sclang -c 'SuperDirt.start'")
            vim.cmd("startinsert")
          end, { desc = "[Tidal] Boot SuperDirt", buffer = bufnr })
        end,
      })

      -- Set up file type detection
      vim.filetype.add({
        extension = {
          tidal = "tidal",
        },
        pattern = {
          [".*%.tidal"] = "tidal",
        },
      })
    end,
  },
}
