return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional for slash commands
    },
    config = function()
      -- Read provider configuration from yaml
      local config_path = vim.fn.stdpath("config") .. "/config/nvim-ai-config.yaml"
      local default_provider = "anthropic" -- Fallback default

      -- Parse yaml config to get provider settings
      local function parse_provider_config()
        if vim.fn.filereadable(config_path) ~= 1 then
          return nil
        end

        local config_content = vim.fn.readfile(config_path)
        local providers = {}
        local current_provider = nil
        local in_providers_section = false

        for _, line in ipairs(config_content) do
          -- Get default provider
          local default_match = line:match("^%s*default_provider:%s*([%w_]+)")
          if default_match then
            default_provider = default_match
          end

          -- Track providers section
          if line:match("^providers:") then
            in_providers_section = true
          elseif in_providers_section then
            -- Parse provider name (e.g., "  claude:")
            local provider_name = line:match("^%s%s([%w_]+):")
            if provider_name then
              current_provider = provider_name
              providers[current_provider] = { mode = "api" } -- default
            elseif current_provider then
              -- Parse mode (e.g., "    mode: cli")
              local mode = line:match("^%s+mode:%s*(%w+)")
              if mode then
                providers[current_provider].mode = mode
              end

              -- Parse CLI command
              local command = line:match("^%s+command:%s*(.+)")
              if command then
                if not providers[current_provider].cli then
                  providers[current_provider].cli = {}
                end
                providers[current_provider].cli.command = command
              end
            end
          end
        end

        return providers
      end

      local provider_configs = parse_provider_config() or {}

      -- Determine adapter based on provider config
      local function get_adapter(provider)
        local config = provider_configs[provider]

        -- Map providers to their adapters based on mode
        if provider == "claude" and config and config.mode == "cli" then
          return "claude_code" -- ACP adapter (API key based)
        elseif provider == "gemini" and config and config.mode == "cli" then
          return "gemini_cli" -- ACP adapter (native)
        end

        -- HTTP adapters for API mode
        local provider_to_adapter = {
          claude = "anthropic",
          anthropic = "anthropic",
          gemini = "gemini",
          gemini_cli = "gemini",
          openai = "openai",
          xai = "xai",
          cursor = "cursor",
          codex = "codex",
        }
        return provider_to_adapter[provider] or "anthropic"
      end

      local adapter = get_adapter(default_provider)
      
      require("codecompanion").setup({
        strategies = {
          -- Chat strategy (primary AI interaction)
          chat = {
            adapter = adapter, -- Dynamically read from config
            keymaps = {
              send = {
                modes = {
                  n = "<CR>",
                  i = "<C-s>",
                },
              },
            },
          },
          -- Inline strategy (code suggestions)
          inline = {
            adapter = adapter, -- Dynamically read from config
          },
          -- Agent strategy (using CLI agents) - Disabled for now
          -- agent = {
          --   adapter = "claude_code", -- Agent adapters under acp
          -- },
        },

        -- Configure adapters for multiple AI providers
        adapters = {
          -- ACP adapters (Agent Client Protocol) for CLI mode
          acp = {
            -- Claude Code ACP adapter (API key based, no OAuth)
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {
                  ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY",
                },
              })
            end,

            -- Gemini CLI ACP adapter (native ACP support)
            gemini_cli = function()
              return require("codecompanion.adapters").extend("gemini_cli", {
                defaults = {
                  auth_method = "gemini-api-key", -- or "vertex-ai"
                },
                env = {
                  GEMINI_API_KEY = "GEMINI_API_KEY",
                },
              })
            end,
          },

          http = {
            -- Anthropic Claude
            anthropic = function()
              return require("codecompanion.adapters.http").extend("anthropic", {
                env = {
                  api_key = "ANTHROPIC_API_KEY",
                },
                schema = {
                  model = {
                    default = "claude-sonnet-4-20250514",
                    choices = {
                      "claude-opus-4-20250514",
                      "claude-sonnet-4-20250514",
                      "claude-3-7-sonnet-20250219",
                      "claude-3-5-sonnet-20241022",
                    },
                  },
                },
              })
            end,

            -- Google Gemini
            gemini = function()
              return require("codecompanion.adapters.http").extend("gemini", {
                env = {
                  api_key = "GEMINI_API_KEY",
                },
                schema = {
                  model = {
                    default = "gemini-2.0-flash-exp",
                    choices = {
                      "gemini-2.0-flash-exp",
                      "gemini-2.0-flash-thinking-exp",
                      "gemini-exp-1206",
                      "gemini-1.5-pro",
                      "gemini-1.5-flash",
                    },
                  },
                },
              })
            end,

            -- xAI (Grok)
            xai = function()
              return require("codecompanion.adapters.http").extend("xai", {
                env = {
                  api_key = "XAI_API_KEY",
                },
                schema = {
                  model = {
                    default = "grok-2-1212",
                    choices = {
                      "grok-2-1212",
                      "grok-2-vision-1212",
                      "grok-beta",
                    },
                  },
                },
              })
            end,

            -- OpenAI
            openai = function()
              return require("codecompanion.adapters.http").extend("openai", {
                env = {
                  api_key = "OPENAI_API_KEY",
                },
                schema = {
                  model = {
                    default = "gpt-4o",
                    choices = {
                      "gpt-4o",
                      "gpt-4o-mini",
                      "gpt-4-turbo",
                      "gpt-4",
                      "gpt-3.5-turbo",
                    },
                  },
                },
              })
            end,
          },
        },

        -- Display configuration
        display = {
          chat = {
            window = {
              layout = "vertical", -- vertical|horizontal|float
              width = 0.45,
              height = 0.85,
              relative = "editor",
              border = "rounded",
            },
          },
          diff = {
            provider = "mini_diff",
          },
        },

        -- Prompt library configuration
        prompt_library = {
          ["Explain"] = {
            strategy = "chat",
            description = "Explain how the selected code works",
            opts = {
              index = 1,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = "user",
                content = "Please explain how this code works:\n\n```{{filetype}}\n{{selection}}\n```",
              },
            },
          },
          ["Fix"] = {
            strategy = "chat",
            description = "Fix bugs in the selected code",
            opts = {
              index = 2,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = "user",
                content = "Please fix any bugs in this code:\n\n```{{filetype}}\n{{selection}}\n```",
              },
            },
          },
          ["Optimize"] = {
            strategy = "chat",
            description = "Optimize the selected code",
            opts = {
              index = 3,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = "user",
                content = "Please optimize this code for performance and readability:\n\n```{{filetype}}\n{{selection}}\n```",
              },
            },
          },
          ["Tests"] = {
            strategy = "chat",
            description = "Generate tests for the selected code",
            opts = {
              index = 4,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = "user",
                content = "Please write comprehensive tests for this code:\n\n```{{filetype}}\n{{selection}}\n```",
              },
            },
          },
          ["Refactor"] = {
            strategy = "chat",
            description = "Refactor the selected code",
            opts = {
              index = 5,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = "user",
                content = "Please refactor this code to improve maintainability:\n\n```{{filetype}}\n{{selection}}\n```",
              },
            },
          },
        },
      })

      -- Keybindings
      local keymap = vim.keymap.set

      -- AI prefix: <leader>a
      keymap("n", "<leader>a", "", { desc = "AI Assistant" })

      -- Chat
      keymap("n", "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat" })
      keymap("v", "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat (selection)" })
      keymap("n", "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat" })

      -- Actions
      keymap("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
      keymap("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions (selection)" })

      -- Quick commands
      keymap("n", "<leader>ae", "<cmd>CodeCompanion /explain<cr>", { desc = "Explain code" })
      keymap("v", "<leader>ae", "<cmd>CodeCompanion /explain<cr>", { desc = "Explain selection" })

      keymap("n", "<leader>af", "<cmd>CodeCompanion /fix<cr>", { desc = "Fix bugs" })
      keymap("v", "<leader>af", "<cmd>CodeCompanion /fix<cr>", { desc = "Fix selection" })

      keymap("n", "<leader>ao", "<cmd>CodeCompanion /optimize<cr>", { desc = "Optimize code" })
      keymap("v", "<leader>ao", "<cmd>CodeCompanion /optimize<cr>", { desc = "Optimize selection" })

      keymap("n", "<leader>aT", "<cmd>CodeCompanion /tests<cr>", { desc = "Generate tests" })
      keymap("v", "<leader>aT", "<cmd>CodeCompanion /tests<cr>", { desc = "Generate tests" })

      keymap("n", "<leader>ar", "<cmd>CodeCompanion /refactor<cr>", { desc = "Refactor code" })
      keymap("v", "<leader>ar", "<cmd>CodeCompanion /refactor<cr>", { desc = "Refactor selection" })

      -- Inline completion (like GitHub Copilot)
      keymap("n", "<leader>ai", "<cmd>CodeCompanionInline<cr>", { desc = "Inline AI" })
      keymap("v", "<leader>ai", "<cmd>CodeCompanionInline<cr>", { desc = "Inline AI (selection)" })

      -- Model selection
      keymap("n", "<leader>am", function()
        local models = {
          "claude_code (Claude CLI - API Key)",
          "anthropic (Claude API)",
          "gemini_cli (Gemini CLI)",
          "gemini (Gemini API)",
          "openai (GPT)",
          "xai (Grok)",
        }

        -- Get current adapter from codecompanion state
        local cc = require("codecompanion")
        local current_adapter = nil
        local current_default = nil

        -- Try to get current adapter from strategies
        local ok, state = pcall(function()
          return cc.state
        end)

        -- Function to read default_provider from config
        local function get_default_provider_from_config()
          local config_path = vim.fn.stdpath("config") .. "/config/nvim-ai-config.yaml"
          if vim.fn.filereadable(config_path) == 1 then
            local config_content = vim.fn.readfile(config_path)
            for _, line in ipairs(config_content) do
              local match = line:match("^%s*default_provider:%s*([%w_]+)")
              if match then
                return match
              end
            end
          end
          return "anthropic" -- Fallback default
        end
        
        if ok and state and state.strategies and state.strategies.chat and state.strategies.chat.adapter then
          current_adapter = state.strategies.chat.adapter
        else
          -- Fallback: read from config and map directly
          local provider = get_default_provider_from_config()
          local provider_to_adapter = {
            anthropic = "anthropic",
            claude_code = "claude_code",
            gemini = "gemini",
            gemini_cli = "gemini_cli",
            openai = "openai",
            xai = "xai",
            cursor = "cursor",
            codex = "codex",
          }
          current_adapter = provider_to_adapter[provider] or "anthropic"
        end

        -- Map adapter name to display string
        local adapter_to_display = {
          claude_code = "claude_code (Claude CLI - API Key)",
          anthropic = "anthropic (Claude API)",
          gemini_cli = "gemini_cli (Gemini CLI)",
          gemini = "gemini (Gemini API)",
          openai = "openai (GPT)",
          xai = "xai (Grok)",
        }

        -- Function to get default from config if adapter not found
        local function get_fallback_default()
          local config_path = vim.fn.stdpath("config") .. "/config/nvim-ai-config.yaml"
          if vim.fn.filereadable(config_path) == 1 then
            local config_content = vim.fn.readfile(config_path)
            for _, line in ipairs(config_content) do
              local match = line:match("^%s*default_provider:%s*([%w_]+)")
              if match then
                local provider_to_display = {
                  claude = "claude_code (Claude CLI - API Key)",
                  claude_code = "claude_code (Claude CLI - API Key)",
                  anthropic = "anthropic (Claude API)",
                  gemini = "gemini (Gemini API)",
                  gemini_cli = "gemini_cli (Gemini CLI)",
                  openai = "openai (GPT)",
                  xai = "xai (Grok)",
                  cursor = "cursor (Cursor AI)",
                  codex = "codex (OpenAI CLI)",
                }
                return provider_to_display[match] or "anthropic (Claude API)"
              end
            end
          end
          return "anthropic (Claude API)"
        end
        
        current_default = adapter_to_display[current_adapter] or get_fallback_default()

        vim.ui.select(models, {
          prompt = "Select AI Model:",
          default = current_default,
          format_item = function(item)
            if item == current_default then
              return item .. " ← (current)"
            end
            return item
          end,
        }, function(choice)
          if not choice then
            return
          end

          local adapter
          if choice:match("^claude_code") then
            adapter = "claude_code"
          elseif choice:match("^anthropic") then
            adapter = "anthropic"
          elseif choice:match("^gemini_cli") then
            adapter = "gemini_cli"
          elseif choice:match("^gemini") then
            adapter = "gemini"
          elseif choice:match("^openai") then
            adapter = "openai"
          elseif choice:match("^xai") then
            adapter = "xai"
          end

          -- Update default adapter
          require("codecompanion").setup({
            strategies = {
              chat = { adapter = adapter },
              inline = { adapter = adapter },
            },
          })

          vim.notify("AI Model switched to: " .. adapter, vim.log.levels.INFO)
        end)
      end, { desc = "Select AI Model" })

      -- Add current buffer to chat context
      keymap("n", "<leader>ab", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        vim.notify("Added to AI context: " .. vim.fn.fnamemodify(filename, ":t"), vim.log.levels.INFO)
      end, { desc = "Add buffer to AI context" })
    end,
  },
}
