return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "native",
        },
        decorations = {
          statusline = {
            app_version = false,
            device = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          register_configurations = function(_)
            require("dap").configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
          end,
        },
        flutter_path = nil, -- Auto-detect from PATH
        flutter_lookup_cmd = nil,
        fvm = false, -- Use fvm if true
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        lsp = {
          color = {
            enabled = true,
            background = false,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })

      -- Dart/Flutter-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dart",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Run Dart/Flutter
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("pubspec.yaml") == 1 then
              -- Flutter project
              vim.cmd("FlutterRun")
            else
              -- Pure Dart
              vim.cmd("split | terminal dart run %")
              vim.cmd("startinsert")
            end
          end, { desc = "[Dart] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("pubspec.yaml") == 1 then
              vim.cmd("split | terminal flutter test")
            else
              vim.cmd("split | terminal dart test")
            end
            vim.cmd("startinsert")
          end, { desc = "[Dart] Test", buffer = bufnr })

          -- Flutter-specific commands
          vim.keymap.set("n", "<leader>dr", "<cmd>FlutterRun<CR>", { desc = "[Flutter] Run", buffer = bufnr })
          vim.keymap.set("n", "<leader>dq", "<cmd>FlutterQuit<CR>", { desc = "[Flutter] Quit", buffer = bufnr })
          vim.keymap.set("n", "<leader>dR", "<cmd>FlutterRestart<CR>", { desc = "[Flutter] Restart", buffer = bufnr })
          vim.keymap.set("n", "<leader>dh", "<cmd>FlutterReload<CR>", { desc = "[Flutter] Hot Reload", buffer = bufnr })
          vim.keymap.set("n", "<leader>dd", "<cmd>FlutterDevices<CR>", { desc = "[Flutter] Devices", buffer = bufnr })
          vim.keymap.set("n", "<leader>de", "<cmd>FlutterEmulators<CR>", { desc = "[Flutter] Emulators", buffer = bufnr })
          vim.keymap.set("n", "<leader>do", "<cmd>FlutterOutlineToggle<CR>", { desc = "[Flutter] Outline", buffer = bufnr })
          vim.keymap.set("n", "<leader>dl", "<cmd>FlutterDevLog<CR>", { desc = "[Flutter] DevLog", buffer = bufnr })
          vim.keymap.set("n", "<leader>dt", "<cmd>FlutterDevTools<CR>", { desc = "[Flutter] DevTools", buffer = bufnr })
          vim.keymap.set("n", "<leader>dc", "<cmd>FlutterCopyProfilerUrl<CR>", { desc = "[Flutter] Copy Profiler URL", buffer = bufnr })
          vim.keymap.set("n", "<leader>dL", "<cmd>FlutterLspRestart<CR>", { desc = "[Flutter] LSP Restart", buffer = bufnr })

          -- Dart commands
          vim.keymap.set("n", "<leader>df", function()
            vim.cmd("!dart format %")
          end, { desc = "[Dart] Format", buffer = bufnr })

          vim.keymap.set("n", "<leader>da", function()
            vim.cmd("!dart analyze")
          end, { desc = "[Dart] Analyze", buffer = bufnr })

          vim.keymap.set("n", "<leader>dp", function()
            vim.cmd("!flutter pub get")
          end, { desc = "[Flutter] Pub Get", buffer = bufnr })
        end,
      })
    end,
  },
}
