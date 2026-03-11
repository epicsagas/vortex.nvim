return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })

      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("which-key").setup({
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
      })

      require("which-key").add({
        { "<leader>P", group = "Preview" },
        { "<leader>a", group = "AI Assistant" },
        { "<leader>b", group = "Bash" },
        { "<leader>c", group = "Code/C++" },
        { "<leader>C", group = "C#" },
        { "<leader>d", group = "Debug/Dart" },
        { "<leader>e", group = "Elixir" },
        { "<leader>f", group = "Find/Format" },
        { "<leader>g", group = "Git/Go" },
        { "<leader>h", group = "Git Hunk/Haskell" },
        { "<leader>j", group = "Java" },
        { "<leader>k", group = "Kotlin" },
        { "<leader>l", group = "Lisp" },
        { "<leader>L", group = "Lua" },
        { "<leader>m", group = "Markdown/Scala" },
        { "<leader>n", group = "Nim" },
        { "<leader>p", group = "Python/PHP/PlantUML" },
        { "<leader>r", group = "Rust/R" },
        { "<leader>R", group = "Ruby" },
        { "<leader>s", group = "SQL" },
        { "<leader>S", group = "Swift" },
        { "<leader>t", group = "Terminal/TypeScript/Table" },
        { "<leader>u", group = "Undo Tree" },
        { "<leader>v", group = "VirtualEnv" },
        { "<leader>w", group = "Workspace" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>z", group = "Zig" },
      })
    end,
  },
}
