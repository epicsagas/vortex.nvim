return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hls = {
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
    "mrcjkb/haskell-tools.nvim",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Haskell-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "haskell", "lhaskell", "cabal", "cabalproject" },
        callback = function(event)
          local bufnr = event.buf
          local ht = require("haskell-tools")

          -- F5: Run Haskell project
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("stack.yaml") == 1 then
              vim.cmd("split | terminal stack run")
            elseif vim.fn.filereadable("*.cabal") == 1 then
              vim.cmd("split | terminal cabal run")
            else
              vim.cmd("split | terminal runhaskell %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Haskell] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("stack.yaml") == 1 then
              vim.cmd("split | terminal stack test")
            else
              vim.cmd("split | terminal cabal test")
            end
            vim.cmd("startinsert")
          end, { desc = "[Haskell] Test", buffer = bufnr })

          -- Haskell-specific commands
          vim.keymap.set("n", "<leader>hr", function()
            vim.cmd("split | terminal ghci %")
            vim.cmd("startinsert")
          end, { desc = "[Haskell] GHCi REPL", buffer = bufnr })

          vim.keymap.set("n", "<leader>hb", function()
            if vim.fn.filereadable("stack.yaml") == 1 then
              vim.cmd("split | terminal stack build")
            else
              vim.cmd("split | terminal cabal build")
            end
            vim.cmd("startinsert")
          end, { desc = "[Haskell] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>ht", function()
            if vim.fn.filereadable("stack.yaml") == 1 then
              vim.cmd("split | terminal stack test")
            else
              vim.cmd("split | terminal cabal test")
            end
            vim.cmd("startinsert")
          end, { desc = "[Haskell] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>hf", function()
            vim.cmd("!ormolu -i %")
          end, { desc = "[Haskell] Format (ormolu)", buffer = bufnr })

          vim.keymap.set("n", "<leader>hl", function()
            vim.cmd("!hlint %")
          end, { desc = "[Haskell] Lint (hlint)", buffer = bufnr })

          vim.keymap.set("n", "<leader>hc", function()
            vim.cmd("!ghc % -o %:r")
          end, { desc = "[Haskell] Compile", buffer = bufnr })

          vim.keymap.set("n", "<leader>hh", function()
            ht.hoogle.hoogle_signature()
          end, { desc = "[Haskell] Hoogle Signature", buffer = bufnr })

          vim.keymap.set("n", "<leader>he", function()
            ht.lsp.buf_eval_all()
          end, { desc = "[Haskell] Eval All", buffer = bufnr })
        end,
      })
    end,
  },
}
