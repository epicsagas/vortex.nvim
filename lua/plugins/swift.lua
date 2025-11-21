return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift", "objective-c", "objective-cpp" },
          root_dir = require("lspconfig.util").root_pattern("Package.swift", ".git"),
        },
      },
    },
  },
  {
    "wojciech-kulik/xcodebuild.nvim",
    ft = { "swift", "objc", "objcpp" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("xcodebuild").setup({
        restore_on_start = true,
        auto_save = true,
        logs = {
          auto_open_on_success_tests = false,
          auto_open_on_failed_tests = true,
          auto_focus = true,
        },
      })

      -- Swift-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "swift", "objc", "objcpp" },
        callback = function(event)
          local bufnr = event.buf
          local ft = vim.bo.filetype

          -- F5: Run Swift/Xcode project
          vim.keymap.set("n", "<F5>", function()
            if ft == "swift" then
              if vim.fn.filereadable("Package.swift") == 1 then
                vim.cmd("split | terminal swift run")
              else
                vim.cmd("XcodebuildBuild")
              end
            end
            vim.cmd("startinsert")
          end, { desc = "[Swift] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("Package.swift") == 1 then
              vim.cmd("split | terminal swift test")
            else
              vim.cmd("XcodebuildTest")
            end
            vim.cmd("startinsert")
          end, { desc = "[Swift] Test", buffer = bufnr })

          -- Swift-specific commands
          vim.keymap.set("n", "<leader>Sr", function()
            vim.cmd("split | terminal swift run")
            vim.cmd("startinsert")
          end, { desc = "[Swift] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>Sb", function()
            vim.cmd("split | terminal swift build")
            vim.cmd("startinsert")
          end, { desc = "[Swift] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>St", function()
            vim.cmd("split | terminal swift test")
            vim.cmd("startinsert")
          end, { desc = "[Swift] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>Sf", function()
            vim.cmd("!swift-format format -i %")
          end, { desc = "[Swift] Format", buffer = bufnr })

          vim.keymap.set("n", "<leader>Sl", function()
            vim.cmd("!swiftlint")
          end, { desc = "[Swift] Lint", buffer = bufnr })

          -- Xcode-specific commands
          vim.keymap.set("n", "<leader>SX", "<cmd>XcodebuildPicker<CR>", { desc = "[Xcode] Picker", buffer = bufnr })
          vim.keymap.set("n", "<leader>SB", "<cmd>XcodebuildBuild<CR>", { desc = "[Xcode] Build", buffer = bufnr })
          vim.keymap.set("n", "<leader>ST", "<cmd>XcodebuildTest<CR>", { desc = "[Xcode] Test", buffer = bufnr })
          vim.keymap.set("n", "<leader>SD", "<cmd>XcodebuildSelectDevice<CR>", { desc = "[Xcode] Select Device", buffer = bufnr })
          vim.keymap.set("n", "<leader>SS", "<cmd>XcodebuildSelectScheme<CR>", { desc = "[Xcode] Select Scheme", buffer = bufnr })
        end,
      })
    end,
  },
}
