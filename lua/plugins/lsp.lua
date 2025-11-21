return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
          map("gr", require("telescope.builtin").lsp_references, "Goto References")
          map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--all", "--", "-W", "clippy::all" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
        },
        jdtls = {}, -- Java LSP configured via nvim-java plugin
        -- tsserver is configured via typescript-tools.nvim plugin, not lspconfig
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 1000000,
              },
            },
          },
        },
        sqlls = {
          settings = {
            sql = {
              database = "mysql",
              linter = {
                enable = true,
              },
            },
          },
        },
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
        -- dartls is configured via flutter-tools.nvim for Flutter projects
        dartls = {
          settings = {
            dart = {
              completeFunctionCalls = true,
              showTodos = true,
            },
          },
        },
        ruby_lsp = {
          settings = {
            ruby = {
              lint = {
                enabled = true,
              },
            },
          },
        },
        r_language_server = {
          settings = {
            r = {
              lsp = {
                diagnostics = true,
                rich_documentation = true,
              },
            },
          },
        },
        omnisharp = {
          cmd = { "omnisharp" },
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true,
            },
          },
        },
        sourcekit = {
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift", "objective-c", "objective-cpp" },
        },
        bashls = {
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command)",
            },
          },
        },
        zls = {
          settings = {
            zls = {
              enable_snippets = true,
              enable_ast_check_diagnostics = true,
              warn_style = true,
            },
          },
        },
        -- elixirls is configured via elixir-tools.nvim
        hls = {
          settings = {
            haskell = {
              formattingProvider = "ormolu",
              checkProject = true,
            },
          },
        },
        -- metals is configured via nvim-metals for Scala
        nim_langserver = {
          settings = {
            nim = {
              nimsuggestPath = "nimsuggest",
            },
          },
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "rust-analyzer",
        "gopls",
        "gofumpt",
        "goimports",
        "gomodifytags",
        "impl",
        "delve",
        "pyright",
        "black",
        "isort",
        "debugpy",
        "clangd",
        "clang-format",
        "codelldb",
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "typescript-language-server",
        "prettier",
        "eslint_d",
        "js-debug-adapter",
        "intelephense",
        "php-cs-fixer",
        "phpstan",
        "sqlls",
        "sqlfluff",
        "sql-formatter",
        "kotlin-language-server",
        "ktlint",
        "dart-debug-adapter",
        "ruby-lsp",
        "rubocop",
        "r-languageserver",
        "stylua",
        "luacheck",
        "omnisharp",
        "netcoredbg",
        "sourcekit-lsp",
        "swiftformat",
        "bash-language-server",
        "shellcheck",
        "shfmt",
        "zls",
        "elixir-ls",
        "haskell-language-server",
        "ormolu",
        "hlint",
        "nimpretty",
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
