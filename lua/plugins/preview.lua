return {
  -- ─────────────────────────────────────────────────────────────────────
  -- Inline image rendering (kitty protocol or ueberzugpp)
  -- Requirements (choose one):
  --   Kitty terminal: https://sw.kovidgoyal.net/kitty/
  --   ueberzugpp:     brew install ueberzugpp
  -- ─────────────────────────────────────────────────────────────────────
  {
    "3rd/image.nvim",
    build = false,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- Auto-detect backend
      local backend = "kitty"
      if vim.env.TERM == "xterm-kitty" or vim.env.KITTY_PID ~= nil then
        backend = "kitty"
      elseif vim.fn.executable("ueberzugpp") == 1 then
        backend = "ueberzugpp"
      end

      local ok, image = pcall(require, "image")
      if not ok then return end

      image.setup({
        backend = backend,
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown" },
          },
          neorg   = { enabled = false },
          typst   = { enabled = false },
          html    = { enabled = false },
          css     = { enabled = false },
        },
        max_height_window_percentage    = 50,
        window_overlap_clear_enabled    = true,
        window_overlap_clear_ft_ignore  = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = true,
        tmux_show_only_in_active_window = true,
        -- Open image files directly in Neovim → renders inline
        hijack_file_patterns = {
          "*.png", "*.jpg", "*.jpeg", "*.gif",
          "*.webp", "*.avif", "*.bmp", "*.tiff",
        },
      })

      -- <leader>Pi : render image file in current buffer
      vim.keymap.set("n", "<leader>Pi", function()
        local file = vim.fn.expand("%:p")
        local ext  = vim.fn.fnamemodify(file, ":e"):lower()
        local img_exts = { png=1, jpg=1, jpeg=1, gif=1, webp=1, avif=1, bmp=1, tiff=1 }
        if img_exts[ext] then
          require("image").from_file(file, {
            window = vim.api.nvim_get_current_win(),
          })
        else
          vim.notify("Not an image file", vim.log.levels.WARN)
        end
      end, { desc = "Image Preview (inline)" })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────
  -- CSV / TSV column-aligned viewer
  -- Renders each column as a virtual-text aligned table in the buffer
  -- ─────────────────────────────────────────────────────────────────────
  {
    "hat0uma/csvview.nvim",
    ft  = { "csv", "tsv" },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    config = function()
      require("csvview").setup({
        parser = {
          async_chunksize = 100,
          delimiter = {
            default = ",",
            ft      = { tsv = "\t" },
          },
        },
        view = {
          min_column_width = 5,
          spacing          = 2,
          display_mode     = "highlight",
        },
      })

      -- Auto-enable column view when a CSV/TSV file is opened
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = { "csv", "tsv" },
        callback = function()
          vim.cmd("CsvViewEnable")
        end,
      })

      vim.keymap.set("n", "<leader>Pv", "<cmd>CsvViewToggle<cr>", { desc = "CSV View Toggle" })
    end,
  },
}
