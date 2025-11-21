return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          cmd = { "omnisharp" },
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
              AnalyzeOpenDocumentsOnly = false,
            },
          },
        },
      },
    },
  },
  {
    "iabdelkareem/csharp.nvim",
    ft = "cs",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim",
    },
    config = function()
      require("csharp").setup()

      -- C#-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "cs",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Run C# project
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("*.csproj") == 1 or vim.fn.isdirectory(".") == 1 then
              vim.cmd("split | terminal dotnet run")
            else
              vim.cmd("split | terminal dotnet run %")
            end
            vim.cmd("startinsert")
          end, { desc = "[C#] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal dotnet test")
            vim.cmd("startinsert")
          end, { desc = "[C#] Run Tests", buffer = bufnr })

          -- C#-specific commands
          vim.keymap.set("n", "<leader>Cr", function()
            vim.cmd("split | terminal dotnet run")
            vim.cmd("startinsert")
          end, { desc = "[C#] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>Cb", function()
            vim.cmd("split | terminal dotnet build")
            vim.cmd("startinsert")
          end, { desc = "[C#] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>Ct", function()
            vim.cmd("split | terminal dotnet test")
            vim.cmd("startinsert")
          end, { desc = "[C#] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>Cc", function()
            vim.cmd("split | terminal dotnet clean")
            vim.cmd("startinsert")
          end, { desc = "[C#] Clean", buffer = bufnr })

          vim.keymap.set("n", "<leader>Cf", function()
            vim.cmd("!dotnet format")
          end, { desc = "[C#] Format (dotnet format)", buffer = bufnr })

          vim.keymap.set("n", "<leader>Cn", function()
            vim.cmd("split | terminal dotnet new")
            vim.cmd("startinsert")
          end, { desc = "[C#] New Project", buffer = bufnr })

          vim.keymap.set("n", "<leader>Ca", function()
            vim.cmd("split | terminal dotnet add package")
            vim.cmd("startinsert")
          end, { desc = "[C#] Add Package", buffer = bufnr })
        end,
      })
    end,
  },
}
