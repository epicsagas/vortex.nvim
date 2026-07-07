return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ok = pcall(function()
        -- nvim-treesitter `main` branch: setup only accepts { install_dir }.
        -- Highlighting/folding/indent are NOT enabled here — they are provided
        -- by Neovim itself via the FileType autocmd below (see :h treesitter-highlight).
        require("nvim-treesitter").setup()

        local ensure_installed = {
          "rust", "go", "lua", "vim", "vimdoc", "markdown", "markdown_inline",
          "toml", "yaml", "json",
          "python", "c", "cpp", "java", "cmake", "make",
          "javascript", "typescript", "tsx", "jsdoc",
          "php", "phpdoc", "html", "css", "scss",
          "sql", "kotlin", "dart",
          "ruby", "commonlisp", "scheme", "r",
          "c_sharp", "swift", "bash", "zig", "elixir", "haskell", "scala", "nim",
        }

        -- install() returns an async task; norm_languages() inside it filters
        -- unsupported names, so no manual parser-table check is needed.
        local installed = require("nvim-treesitter").get_installed()
        local missing = vim.tbl_filter(function(lang)
          return not vim.list_contains(installed, lang)
        end, ensure_installed)

        if #missing > 0 then
          require("nvim-treesitter").install(missing)
        end
      end)

      if not ok then
        vim.notify("nvim-treesitter: config error — see :messages", vim.log.levels.ERROR)
      end

      -- Enable Treesitter highlighting & folding for every installed parser.
      -- nvim-treesitter `main` no longer enables these automatically.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("vortex_treesitter", { clear = true }),
        callback = function(args)
          pcall(function()
            vim.treesitter.start(args.buf)
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo[args.buf][0].foldmethod = "expr"
            vim.wo[args.buf][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end)
        end,
      })

      -- Register markdown parser for Avante filetype
      vim.treesitter.language.register("markdown", "Avante")
    end,
  },
}
