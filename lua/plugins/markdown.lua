return {
  -- Markdown rendering inside Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "Avante" },
    config = function()
      require("render-markdown").setup({
        -- Heading configuration
        heading = {
          enabled = true,
          sign = true,
          position = "overlay",
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
          backgrounds = {
            "RenderMarkdownH1Bg",
            "RenderMarkdownH2Bg",
            "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg",
            "RenderMarkdownH5Bg",
            "RenderMarkdownH6Bg",
          },
        },

        -- Code block configuration
        code = {
          enabled = true,
          sign = true,
          style = "full",
          position = "left",
          width = "block",
          left_pad = 0,
          right_pad = 0,
          min_width = 0,
          border = "thin",
          above = "▄",
          below = "▀",
          highlight = "RenderMarkdownCode",
          highlight_inline = "RenderMarkdownCodeInline",
        },

        -- Bullet points
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },

        -- Checkboxes
        checkbox = {
          enabled = true,
          unchecked = {
            icon = "󰄱 ",
            highlight = "RenderMarkdownUnchecked",
          },
          checked = {
            icon = "󰱒 ",
            highlight = "RenderMarkdownChecked",
          },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          },
        },

        -- Quote blocks
        quote = {
          enabled = true,
          icon = "▋",
        },

        -- Tables
        pipe_table = {
          enabled = true,
          style = "full",
          cell = "padded",
          border = {
            "┌", "┬", "┐",
            "├", "┼", "┤",
            "└", "┴", "┘",
            "│", "─",
          },
        },

        -- Callouts (GitHub/Obsidian style)
        callout = {
          note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
          tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
          important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
          warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
          caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
          abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
          todo = { raw = "[!TODO]", rendered = "󰥔 Todo", highlight = "RenderMarkdownInfo" },
        },

        -- Links
        link = {
          enabled = true,
          image = "󰥶 ",
          hyperlink = "󰌹 ",
        },

        -- LaTeX support
        latex = {
          enabled = true,
          converter = "latex2text",
        },

        -- Window options
        win_options = {
          conceallevel = {
            default = vim.api.nvim_get_option_value("conceallevel", {}),
            rendered = 3,
          },
          concealcursor = {
            default = vim.api.nvim_get_option_value("concealcursor", {}),
            rendered = "nc",
          },
        },
      })
    end,
  },

  -- Markdown preview in browser (supports Mermaid)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    config = function()
      -- Configuration
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ""
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_port = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_theme = "dark" -- or 'light'

      -- Preview options with PlantUML support
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {
          server = "http://www.plantuml.com/plantuml", -- PlantUML server
          imageFormat = "svg", -- svg or png
        },
        maid = {}, -- Mermaid diagrams
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }

      -- Keybindings
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview" })
      vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown Stop" })
      vim.keymap.set("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Toggle" })
    end,
  },

  -- PlantUML support (simple and reliable)
  {
    "javiorfo/nvim-soil",
    lazy = true,
    ft = { "plantuml" },
    config = function()
      require("soil").setup({
        -- Use system plantuml command
        puml_jar = nil,
        -- Image settings
        image = {
          darkmode = true,
          format = "png",
          execute_to_open = "open", -- macOS open command
        },
      })

      -- Keybinding for nvim-soil
      vim.keymap.set("n", "<leader>pl", "<cmd>Soil<cr>", { desc = "PlantUML Render (Soil)" })
    end,
  },

  -- PlantUML previewer (browser-based with auto-refresh)
  {
    "weirongxu/plantuml-previewer.vim",
    ft = { "plantuml" },
    dependencies = {
      "tyru/open-browser.vim", -- Required for opening browser
    },
    config = function()
      -- PlantUML jar path (if using jar instead of command)
      -- vim.g.plantuml_previewer#plantuml_jar_path = '/path/to/plantuml.jar'

      -- Save and preview option
      vim.g["plantuml_previewer#save_format"] = "png"

      -- Keybindings for PlantUML
      vim.keymap.set("n", "<leader>pu", "<cmd>PlantumlOpen<cr>", { desc = "PlantUML Open Preview" })
      vim.keymap.set("n", "<leader>ps", "<cmd>PlantumlSave<cr>", { desc = "PlantUML Save" })
      vim.keymap.set("n", "<leader>pt", "<cmd>PlantumlToggle<cr>", { desc = "PlantUML Toggle" })
    end,
  },

  -- Markdown table mode
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    config = function()
      -- Table mode settings
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "-"

      -- Keybinding to toggle table mode
      vim.keymap.set("n", "<leader>tm", "<cmd>TableModeToggle<cr>", { desc = "Table Mode Toggle" })
    end,
  },

  -- Markdown TOC generator
  {
    "hedyhli/markdown-toc.nvim",
    ft = { "markdown" },
    cmd = { "Mtoc" },
    config = function()
      require("mtoc").setup({})

      vim.keymap.set("n", "<leader>mT", "<cmd>Mtoc<cr>", { desc = "Generate TOC" })
    end,
  },
}
