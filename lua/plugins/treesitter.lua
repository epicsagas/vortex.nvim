return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "rust", "go", "lua", "vim", "vimdoc", "markdown", "toml", "yaml", "json",
          "python", "c", "cpp", "java", "cmake", "make",
          "javascript", "typescript", "tsx", "jsdoc",
          "php", "phpdoc", "html", "css", "scss",
          "sql", "kotlin", "dart",
          "ruby", "commonlisp", "scheme", "r",
          "c_sharp", "swift", "bash", "zig", "elixir", "haskell", "scala", "nim"
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
}
