return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      -- Ensure parsers are installed
      local ensure_installed = {
        "rust", "go", "lua", "vim", "vimdoc", "markdown", "toml", "yaml", "json",
        "python", "c", "cpp", "java", "cmake", "make",
        "javascript", "typescript", "tsx", "jsdoc",
        "php", "phpdoc", "html", "css", "scss",
        "sql", "kotlin", "dart",
        "ruby", "commonlisp", "scheme", "r",
        "c_sharp", "swift", "bash", "zig", "elixir", "haskell", "scala", "nim",
      }

      local parsers = require("nvim-treesitter.parsers")
      local config = require("nvim-treesitter.config")
      local install = require("nvim-treesitter.install")
      local installed = config.get_installed()

      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang) and parsers[lang] ~= nil
      end, ensure_installed)

      if #missing > 0 then
        install.install(missing)
      end

      -- Register markdown parser for Avante filetype
      vim.treesitter.language.register("markdown", "Avante")
    end,
  },
}
