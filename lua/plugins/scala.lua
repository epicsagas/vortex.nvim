return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
      }

      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Scala-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function(event)
          local bufnr = event.buf

          require("metals").initialize_or_attach(metals_config)

          -- F5: Run Scala project
          vim.keymap.set("n", "<F5>", function()
            if vim.fn.filereadable("build.sbt") == 1 then
              vim.cmd("split | terminal sbt run")
            else
              vim.cmd("split | terminal scala %")
            end
            vim.cmd("startinsert")
          end, { desc = "[Scala] Run", buffer = bufnr })

          -- F6: Run tests
          vim.keymap.set("n", "<F6>", function()
            vim.cmd("split | terminal sbt test")
            vim.cmd("startinsert")
          end, { desc = "[Scala] Test", buffer = bufnr })

          -- Scala-specific commands
          vim.keymap.set("n", "<leader>mc", function()
            require("metals").compile_cascade()
          end, { desc = "[Scala] Compile Cascade", buffer = bufnr })

          vim.keymap.set("n", "<leader>mr", function()
            vim.cmd("split | terminal sbt run")
            vim.cmd("startinsert")
          end, { desc = "[Scala] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>mt", function()
            vim.cmd("split | terminal sbt test")
            vim.cmd("startinsert")
          end, { desc = "[Scala] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>mb", function()
            vim.cmd("split | terminal sbt compile")
            vim.cmd("startinsert")
          end, { desc = "[Scala] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>mf", function()
            vim.cmd("!scalafmt %")
          end, { desc = "[Scala] Format", buffer = bufnr })

          vim.keymap.set("n", "<leader>mi", function()
            require("metals").organize_imports()
          end, { desc = "[Scala] Organize Imports", buffer = bufnr })

          vim.keymap.set("n", "<leader>mh", function()
            require("metals").hover_worksheet()
          end, { desc = "[Scala] Hover Worksheet", buffer = bufnr })

          vim.keymap.set("n", "<leader>ms", function()
            require("telescope").extensions.metals.commands()
          end, { desc = "[Scala] Metals Commands", buffer = bufnr })

          vim.keymap.set("n", "<leader>mR", function()
            vim.cmd("split | terminal sbt console")
            vim.cmd("startinsert")
          end, { desc = "[Scala] REPL", buffer = bufnr })
        end,
      })
    end,
  },
}
