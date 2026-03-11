return {
  -- ─────────────────────────────────────────────────────────────────────
  -- Inline image rendering (kitty protocol or ueberzugpp)
  -- Requirements:
  --   ImageMagick : brew install imagemagick   (required by image.nvim)
  --   Terminal    : Kitty  https://sw.kovidgoyal.net/kitty/
  --              OR ueberzugpp: brew install ueberzugpp
  --   GIF animate : brew install chafa          (all terminals)
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

      if vim.fn.executable("magick") == 0 and vim.fn.executable("convert") == 0 then
        vim.notify(
          "[Preview] ImageMagick not found. Install: brew install imagemagick",
          vim.log.levels.WARN
        )
        return
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

      -- <leader>Pi : render static image in current buffer
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

      -- ── GIF animated playback via chafa ──────────────────────────────
      -- :GifPlay [file]  →  opens a floating terminal running chafa
      -- <leader>Pg       →  shortcut for current buffer's GIF
      -- Press q inside the window to close
      -- ─────────────────────────────────────────────────────────────────
      vim.api.nvim_create_user_command("GifPlay", function(opts)
        local file = (opts.args ~= "") and opts.args or vim.fn.expand("%:p")

        if vim.fn.executable("chafa") == 0 then
          vim.notify(
            "[Preview] chafa not found. Install: brew install chafa",
            vim.log.levels.WARN
          )
          return
        end

        local ext = vim.fn.fnamemodify(file, ":e"):lower()
        if ext ~= "gif" then
          vim.notify("[Preview] GifPlay expects a .gif file", vim.log.levels.WARN)
          return
        end

        local width  = math.floor(vim.o.columns * 0.82)
        local height = math.floor(vim.o.lines   * 0.82)
        local row    = math.floor((vim.o.lines   - height) / 2)
        local col    = math.floor((vim.o.columns - width)  / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(buf, true, {
          relative  = "editor",
          width     = width,
          height    = height,
          row       = row,
          col       = col,
          style     = "minimal",
          border    = "rounded",
          title     = " GIF: " .. vim.fn.fnamemodify(file, ":t") .. " ",
          title_pos = "center",
        })
        -- chafa renders animation; --size matches the window dimensions
        vim.fn.termopen(string.format(
          "chafa --size=%dx%d --animate=on %s",
          width, height - 1, vim.fn.shellescape(file)
        ))
        vim.cmd("startinsert")

        -- q closes the floating window
        vim.keymap.set("t", "q", function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf, desc = "Close GIF player" })
      end, {
        nargs = "?",
        complete = "file",
        desc = "Play GIF animation in floating terminal (chafa)",
      })

      vim.keymap.set("n", "<leader>Pg", function()
        local file = vim.fn.expand("%:p")
        local ext  = vim.fn.fnamemodify(file, ":e"):lower()
        if ext == "gif" then
          vim.cmd("GifPlay " .. vim.fn.fnameescape(file))
        else
          vim.notify("Current file is not a GIF", vim.log.levels.WARN)
        end
      end, { desc = "GIF Play (animated)" })
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
