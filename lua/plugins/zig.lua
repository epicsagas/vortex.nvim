return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
          settings = {
            zls = {
              enable_snippets = true,
              enable_ast_check_diagnostics = true,
              enable_autofix = true,
              enable_import_embedfile_argument_completions = true,
              warn_style = true,
              enable_semantic_tokens = true,
              enable_inlay_hints = true,
            },
          },
        },
      },
    },
  },
  {
    "ziglang/zig.vim",
    ft = "zig",
    config = function()
      -- Zig-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "zig",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Build and run Zig project
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("build.zig") == 1 then
              vim.cmd("split | terminal zig build run")
            else
              vim.cmd("split | terminal zig run %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Zig] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("build.zig") == 1 then
              vim.cmd("split | terminal zig build test")
            else
              vim.cmd("split | terminal zig test %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Zig] Test", buffer = bufnr })

          -- Zig-specific commands
          vim.keymap.set("n", "<leader>zr", function()
            vim.cmd("split | terminal zig run %")
            vim.cmd("startinsert")
          end, { desc = "[Zig] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>zb", function()
            vim.cmd("split | terminal zig build")
            vim.cmd("startinsert")
          end, { desc = "[Zig] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>zt", function()
            vim.cmd("split | terminal zig test %")
            vim.cmd("startinsert")
          end, { desc = "[Zig] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>zf", function()
            vim.cmd("!zig fmt %")
          end, { desc = "[Zig] Format", buffer = bufnr })

          vim.keymap.set("n", "<leader>zc", function()
            vim.cmd("!zig ast-check %")
          end, { desc = "[Zig] AST Check", buffer = bufnr })

          vim.keymap.set("n", "<leader>zd", function()
            vim.cmd("split | terminal zig build -Doptimize=Debug")
            vim.cmd("startinsert")
          end, { desc = "[Zig] Debug Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>zR", function()
            vim.cmd("split | terminal zig build -Doptimize=ReleaseFast")
            vim.cmd("startinsert")
          end, { desc = "[Zig] Release Build", buffer = bufnr })
        end,
      })

      -- Zig formatting on save
      vim.g.zig_fmt_autosave = 1
    end,
  },
}
