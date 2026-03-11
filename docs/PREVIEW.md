# File Preview System

Vortex.nvim supports rich file previews for images, animated GIFs, CSV/Excel spreadsheets, PDFs, and Mermaid diagrams — similar to the yazi file manager.

---

## Dependencies

### Required

| Tool | Purpose | Install |
|---|---|---|
| **ImageMagick** | Image decoding backend for `image.nvim` | `brew install imagemagick` |
| **Kitty** terminal | Inline image rendering (kitty graphics protocol) | [sw.kovidgoyal.net/kitty](https://sw.kovidgoyal.net/kitty/) |

> **Alternative to Kitty**: Install `ueberzugpp` (`brew install ueberzugpp`). The backend is auto-detected at startup.

### Optional (per feature)

| Tool | Purpose | Install |
|---|---|---|
| **chafa** | Animated GIF playback in any terminal | `brew install chafa` |
| **poppler** | PDF text extraction (`pdftotext`) | `brew install poppler` |
| **xlsx2csv** | Excel file preview | `brew install xlsx2csv` |
| **openpyxl** | Excel fallback via Python | `pip3 install openpyxl` |

### Quick install (all at once)

```bash
# macOS
brew install imagemagick chafa poppler xlsx2csv

# Excel fallback (if xlsx2csv is unavailable)
pip3 install openpyxl
```

```bash
# Linux (Ubuntu/Debian)
sudo apt install imagemagick chafa poppler-utils python3-openpyxl
pip3 install xlsx2csv
```

---

## Keymaps

| Key | Command | Description |
|---|---|---|
| `<leader>Pi` | `:lua require("image").from_file(...)` | Inline image render (static) |
| `<leader>Pg` | `:GifPlay` | Animated GIF in floating window |
| `<leader>Pv` | `:CsvViewToggle` | CSV/TSV column view toggle |
| `<leader>Pm` | `:MermaidPreview` | Mermaid diagram in browser |

---

## Feature Details

### Images (PNG / JPG / WebP / BMP / TIFF)

Supported via `image.nvim`. Open any image file directly in Neovim:

```bash
nvim photo.png
```

The image renders inline in the buffer. Also renders images embedded in Markdown files automatically.

**Backend detection order:**
1. Kitty terminal (`$TERM=xterm-kitty` or `$KITTY_PID` set)
2. ueberzugpp (if installed)

---

### Animated GIF

GIF animation requires **chafa** and works in any terminal.

```bash
nvim animation.gif     # opens file, then press <leader>Pg
# or
:GifPlay animation.gif # open any GIF by path
```

- Plays in a centered floating terminal window
- Press `q` to close the player
- Window size is auto-calculated from current Neovim dimensions

**Kitty terminal bonus**: Static GIF frames also render inline via `image.nvim` without chafa.

---

### CSV / TSV

Automatically activates column-aligned view when opening `.csv` or `.tsv` files.

```bash
nvim data.csv
```

- Columns align with virtual text overlay
- Toggle with `<leader>Pv`
- Delimiter auto-detected (`","` for CSV, `"\t"` for TSV)

---

### Excel (XLSX / XLS / ODS)

Excel files are converted to CSV on open (read-only).

```bash
nvim spreadsheet.xlsx
```

Conversion priority: `xlsx2csv` → `python3+openpyxl` → `ssconvert`

After conversion, `csvview.nvim` activates automatically for column alignment.

---

### PDF

PDF files are converted to text on open via `pdftotext` (read-only).

```bash
nvim document.pdf
```

- Layout is preserved with `-layout` flag
- Buffer is read-only and non-modifiable

---

### Mermaid Diagrams (.mmd / .mermaid)

Standalone Mermaid files get syntax highlighting and browser preview.

```bash
nvim diagram.mmd
```

Press `<leader>Pm` to:
1. Wrap the content in a markdown code fence
2. Open `markdown-preview.nvim` in the browser with live Mermaid rendering

Mermaid diagrams inside `.md` files are already supported by `markdown-preview.nvim` (`:MarkdownPreview`).

---

## Troubleshooting

### Images not rendering

```
[Preview] ImageMagick not found
```
→ `brew install imagemagick`

```
image.nvim: backend error
```
→ Ensure you are using Kitty or WezTerm terminal, or install `ueberzugpp`

### GIF not animating

```
[Preview] chafa not found
```
→ `brew install chafa`

### PDF shows garbled text

Encoding issues may occur with scanned PDFs. For OCR-based PDFs, `pdftotext` works best with native text layers.

### Excel conversion failed

```
[Preview] No Excel converter found
```
→ `brew install xlsx2csv` or `pip3 install openpyxl`

---

## Plugin Reference

| Plugin | Role |
|---|---|
| `3rd/image.nvim` | Image rendering backend |
| `hat0uma/csvview.nvim` | CSV/TSV column viewer |
| `iamcco/markdown-preview.nvim` | Markdown + Mermaid browser preview |
| `core.preview` (local) | PDF, Excel, Mermaid standalone handlers |
