return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {
          settings = {
            kotlin = {
              compiler = {
                jvm = {
                  target = "1.8",
                },
              },
              linting = {
                debounceTime = 250,
              },
            },
          },
        },
      },
    },
  },
  {
    "udalov/kotlin-vim",
    ft = "kotlin",
    config = function()
      -- Kotlin-specific keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "kotlin",
        callback = function(event)
          local bufnr = event.buf

          -- F5: Compile and run Kotlin file
          vim.keymap.set("n", "<F5>", function()
            local file = vim.fn.expand("%:p")
            local basename = vim.fn.expand("%:t:r")
            vim.cmd("split | terminal kotlinc " .. file .. " -include-runtime -d " .. basename .. ".jar && kotlin " .. basename .. ".jar")
            vim.cmd("startinsert")
          end, { desc = "[Kotlin] Compile & Run", buffer = bufnr })

          -- F6: Run Gradle test
          vim.keymap.set("n", "<F6>", function()
            if vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
              vim.cmd("split | terminal ./gradlew test")
            else
              vim.cmd("split | terminal kotlinc %:p -include-runtime -d %:t:r.jar && kotlin %:t:r.jar")
            end
            vim.cmd("startinsert")
          end, { desc = "[Kotlin] Run Tests", buffer = bufnr })

          -- Kotlin-specific commands
          vim.keymap.set("n", "<leader>kr", function()
            local file = vim.fn.expand("%:p")
            local basename = vim.fn.expand("%:t:r")
            vim.cmd("split | terminal kotlinc " .. file .. " -include-runtime -d " .. basename .. ".jar && kotlin " .. basename .. ".jar")
            vim.cmd("startinsert")
          end, { desc = "[Kotlin] Run", buffer = bufnr })

          vim.keymap.set("n", "<leader>kb", function()
            if vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
              vim.cmd("split | terminal ./gradlew build")
            else
              vim.cmd("!kotlinc %:p -include-runtime -d %:t:r.jar")
            end
          end, { desc = "[Kotlin] Build", buffer = bufnr })

          vim.keymap.set("n", "<leader>kt", function()
            if vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
              vim.cmd("split | terminal ./gradlew test")
            end
          end, { desc = "[Kotlin] Test", buffer = bufnr })

          vim.keymap.set("n", "<leader>kc", function()
            vim.cmd("!ktlint --format %")
          end, { desc = "[Kotlin] Format (ktlint)", buffer = bufnr })
        end,
      })
    end,
  },
}
