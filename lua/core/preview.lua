-- Custom file preview handlers
-- Provides: PDF (pdftotext), Excel (xlsx2csv/python3), Mermaid standalone (.mmd)
local M = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- PDF preview via pdftotext (poppler-utils)
-- macOS: brew install poppler
-- Linux: apt install poppler-utils
-- ─────────────────────────────────────────────────────────────────────────────
local function setup_pdf_handler()
  vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern  = "*.pdf",
    callback = function(args)
      if vim.fn.executable("pdftotext") == 0 then
        vim.notify(
          "[Preview] pdftotext not found. Install: brew install poppler",
          vim.log.levels.WARN
        )
        return
      end

      local tmpfile = vim.fn.tempname() .. ".txt"
      vim.fn.system(string.format(
        "pdftotext -layout %s %s 2>/dev/null",
        vim.fn.shellescape(args.file), tmpfile
      ))

      if vim.v.shell_error ~= 0 then
        vim.notify("[Preview] Failed to read PDF: " .. args.file, vim.log.levels.ERROR)
        return
      end

      local lines = vim.fn.readfile(tmpfile)
      vim.fn.delete(tmpfile)

      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].filetype   = "text"
      vim.bo[buf].readonly   = true
      vim.bo[buf].modifiable = false
      vim.bo[buf].buftype    = "nofile"
      vim.bo[buf].swapfile   = false
    end,
  })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Excel / spreadsheet preview
-- Priority: xlsx2csv → python3+openpyxl → ssconvert
--   brew install xlsx2csv   OR   pip3 install openpyxl   OR   brew install ssconvert
-- ─────────────────────────────────────────────────────────────────────────────
local function build_excel_cmd(filepath)
  local q = vim.fn.shellescape(filepath)
  if vim.fn.executable("xlsx2csv") == 1 then
    return "xlsx2csv " .. q

  elseif vim.fn.executable("python3") == 1 then
    -- Inline python; works if openpyxl is installed
    local py = table.concat({
      "import sys, openpyxl",
      "wb = openpyxl.load_workbook(sys.argv[1], read_only=True, data_only=True)",
      "ws = wb.active",
      "import csv, io",
      "buf = io.StringIO()",
      "w = csv.writer(buf)",
      "[w.writerow([str(c.value) if c.value is not None else '' for c in r]) for r in ws.iter_rows()]",
      "print(buf.getvalue(), end='')",
    }, "; ")
    return string.format("python3 -c %s %s", vim.fn.shellescape(py), q)

  elseif vim.fn.executable("ssconvert") == 1 then
    return string.format("ssconvert --export-type=Gnumeric_stf:stf_csv %s fd://1", q)
  end

  return nil
end

local function setup_excel_handler()
  vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern  = { "*.xlsx", "*.xls", "*.ods" },
    callback = function(args)
      local cmd = build_excel_cmd(args.file)
      if not cmd then
        vim.notify(
          "[Preview] No Excel converter found.\n" ..
          "Install:  brew install xlsx2csv  OR  pip3 install openpyxl",
          vim.log.levels.WARN
        )
        return
      end

      local output = vim.fn.systemlist(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("[Preview] Failed to read Excel file: " .. args.file, vim.log.levels.ERROR)
        return
      end

      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
      vim.bo[buf].filetype   = "csv"
      vim.bo[buf].readonly   = true
      vim.bo[buf].modifiable = false
      vim.bo[buf].buftype    = "nofile"
      vim.bo[buf].swapfile   = false

      -- Trigger csvview column alignment if available
      vim.schedule(function()
        if pcall(require, "csvview") then
          vim.cmd("CsvViewEnable")
        end
      end)
    end,
  })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Standalone Mermaid file preview (.mmd / .mermaid)
-- Wraps content in a markdown fence → opens markdown-preview.nvim in browser
-- Requires: markdown-preview.nvim (already in markdown.lua)
-- ─────────────────────────────────────────────────────────────────────────────
local function setup_mermaid_handler()
  -- :MermaidPreview — wrap current buffer in ```mermaid and open in browser
  vim.api.nvim_create_user_command("MermaidPreview", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local tmpfile = vim.fn.tempname() .. ".md"

    local content = { "```mermaid" }
    for _, line in ipairs(lines) do
      table.insert(content, line)
    end
    table.insert(content, "```")

    vim.fn.writefile(content, tmpfile)

    -- Open temp markdown in a split, preview it, then close on preview open
    local orig_win = vim.api.nvim_get_current_win()
    vim.cmd("split " .. tmpfile)
    vim.bo.filetype   = "markdown"
    vim.bo.bufhidden  = "wipe"
    vim.cmd("MarkdownPreview")
    -- Return focus to original window
    vim.api.nvim_set_current_win(orig_win)
  end, { desc = "Preview Mermaid diagram in browser" })

  vim.keymap.set("n", "<leader>Pm", "<cmd>MermaidPreview<cr>", { desc = "Mermaid Preview" })

  -- Also allow <leader>Pm to fall back gracefully if not a mermaid file
  vim.api.nvim_create_autocmd("FileType", {
    pattern  = { "mermaid" },
    callback = function(args)
      vim.keymap.set("n", "<leader>Pm", "<cmd>MermaidPreview<cr>",
        { buffer = args.buf, desc = "Mermaid Preview" })
    end,
  })
end

-- ─────────────────────────────────────────────────────────────────────────────

function M.setup()
  setup_pdf_handler()
  setup_excel_handler()
  setup_mermaid_handler()
end

return M
