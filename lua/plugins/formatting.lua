return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        go = { "goimports", "gofumpt" },
        python = { "isort", "black" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        java = { "google-java-format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        php = { "php_cs_fixer" },
        sql = { "sqlfluff" },
        kotlin = { "ktlint" },
        dart = { "dart_format" },
        ruby = { "rubocop" },
        r = { "styler" },
        cs = { "csharpier" },
        swift = { "swiftformat" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        zig = { "zigfmt" },
        elixir = { "mix" },
        haskell = { "ormolu" },
        scala = { "scalafmt" },
        nim = { "nimpretty" },
      },
    },
  },
}
