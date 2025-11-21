return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "delve",
          "codelldb",
        },
      })

      -- Debug keymaps (F9-F12 to avoid conflict with F5/F6 run/test)
      vim.keymap.set("n", "<F9>", dap.continue, { desc = "[Debug] Start/Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "[Debug] Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "[Debug] Step Into" })
      vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "[Debug] Step Out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[Debug] Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "[Debug] Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "[Debug] Toggle UI" })
      vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, { desc = "[Debug] Clear Breakpoints" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "[Debug] Terminate" })

      -- DAP UI setup
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Go debugging
      require("dap-go").setup()

      -- Rust/C/C++ debugging (codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Python debugging (debugpy)
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return "/usr/bin/python3"
            end
          end,
        },
      }

      -- JavaScript/TypeScript debugging (node)
      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js" },
      }

      dap.configurations.javascript = {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }

      dap.configurations.typescript = {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          runtimeExecutable = "npx",
          runtimeArgs = { "tsx" },
        },
      }

      -- PHP debugging (xdebug)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
      }

      -- Kotlin debugging (uses Java debug adapter)
      dap.configurations.kotlin = {
        {
          type = "java",
          request = "launch",
          name = "Launch Kotlin file",
          program = "${file}",
          projectName = "",
          javaExec = "java",
          mainClass = "",
          vmArgs = "",
        },
      }

      -- Dart/Flutter debugging (configured via flutter-tools.nvim)
      dap.adapters.dart = {
        type = "executable",
        command = "dart",
        args = { "debug_adapter" },
      }

      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Dart file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }

      -- Ruby debugging
      dap.adapters.ruby = {
        type = "executable",
        command = "bundle",
        args = { "exec", "readapt", "stdio" },
      }

      dap.configurations.ruby = {
        {
          type = "ruby",
          request = "launch",
          name = "Launch Ruby file",
          program = "${file}",
        },
        {
          type = "ruby",
          request = "attach",
          name = "Attach to running process",
          localfs = true,
        },
      }

      -- C# debugging (netcoredbg)
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          request = "launch",
          name = "Launch C# file",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }

      -- Elixir debugging (elixir-ls)
      dap.adapters.mix_task = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/debug_adapter.sh",
        args = {},
      }

      dap.configurations.elixir = {
        {
          type = "mix_task",
          request = "launch",
          name = "Launch Mix Task",
          task = "test",
          taskArgs = { "--trace" },
          startApps = true,
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
      }

      -- Virtual text
      require("nvim-dap-virtual-text").setup({})
    end,
  },
}
