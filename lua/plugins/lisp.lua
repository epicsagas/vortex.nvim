return {
  {
    "vlime/vlime",
    ft = { "lisp", "scheme" },
    config = function()
      -- Lisp/Scheme-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lisp", "scheme" },
        callback = function(event)
          local bufnr = event.buf
          local ft = vim.bo.filetype

          -- F5: Run Lisp/Scheme file
          vim.keymap.set("n", "<F5>", function()
            if ft == "lisp" then
              vim.cmd("split | terminal sbcl --script %")
            elseif ft == "scheme" then
              vim.cmd("split | terminal racket %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Lisp/Scheme] Run", buffer = bufnr })

          -- F6: Load file in REPL
          vim.keymap.set("n", "<F6>", function()
            if ft == "lisp" then
              vim.cmd("split | terminal sbcl --load %")
            elseif ft == "scheme" then
              vim.cmd("split | terminal racket -i %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Lisp/Scheme] Load in REPL", buffer = bufnr })

          -- Lisp-specific commands
          vim.keymap.set("n", "<leader>lr", function()
            if ft == "lisp" then
              vim.cmd("split | terminal sbcl")
            elseif ft == "scheme" then
              vim.cmd("split | terminal racket")
            end
            vim.cmd("startinsert")
          end, { desc = "[Lisp/Scheme] REPL", buffer = bufnr })

          vim.keymap.set("n", "<leader>ll", function()
            if ft == "lisp" then
              vim.cmd("split | terminal sbcl --load %")
            elseif ft == "scheme" then
              vim.cmd("split | terminal racket -i %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Lisp/Scheme] Load File", buffer = bufnr })

          vim.keymap.set("n", "<leader>le", function()
            if ft == "lisp" then
              vim.cmd("split | terminal sbcl --script %")
            elseif ft == "scheme" then
              vim.cmd("split | terminal racket %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Lisp/Scheme] Execute", buffer = bufnr })
        end,
      })
    end,
  },
}
