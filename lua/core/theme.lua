-- Theme management module for Vortex.nvim
local M = {}

-- Available themes with their plugin configurations
M.THEMES = {
  system = {
    name = "system",
    description = "Adapts to your terminal's background color",
    plugin = nil,
    colorscheme = nil,
  },
  tokyonight = {
    name = "tokyonight",
    description = "Based on the Tokyonight theme",
    plugin = "folke/tokyonight.nvim",
    colorscheme = "tokyonight",
  },
  everforest = {
    name = "everforest",
    description = "Based on the Everforest theme",
    plugin = "sainnhe/everforest",
    colorscheme = "everforest",
  },
  ayu = {
    name = "ayu",
    description = "Based on the Ayu dark theme",
    plugin = "Shatur/neovim-ayu",
    colorscheme = "ayu-dark",
  },
  catppuccin = {
    name = "catppuccin",
    description = "Based on the Catppuccin theme",
    plugin = "catppuccin/nvim",
    colorscheme = "catppuccin",
  },
  ["catppuccin-macchiato"] = {
    name = "catppuccin-macchiato",
    description = "Based on the Catppuccin Macchiato theme",
    plugin = "catppuccin/nvim",
    colorscheme = "catppuccin-macchiato",
  },
  gruvbox = {
    name = "gruvbox",
    description = "Based on the Gruvbox theme",
    plugin = "ellisonleao/gruvbox.nvim",
    colorscheme = "gruvbox",
  },
  kanagawa = {
    name = "kanagawa",
    description = "Based on the Kanagawa theme",
    plugin = "rebelot/kanagawa.nvim",
    colorscheme = "kanagawa",
  },
  nord = {
    name = "nord",
    description = "Based on the Nord theme",
    plugin = "shaunsingh/nord.nvim",
    colorscheme = "nord",
  },
  matrix = {
    name = "matrix",
    description = "Hacker-style green on black theme",
    plugin = nil,
    colorscheme = "matrix",
  },
  ["one-dark"] = {
    name = "one-dark",
    description = "Based on the Atom One Dark theme",
    plugin = "navarasu/onedark.nvim",
    colorscheme = "onedark",
  },
}

-- Default theme
M.DEFAULT_THEME = "tokyonight"

-- Get theme config file path
local function get_theme_file_path()
  return vim.fn.stdpath("data") .. "/vortex_theme.txt"
end

-- Load theme from config file
function M.load_theme()
  local theme_file = get_theme_file_path()
  local file = io.open(theme_file, "r")

  if file then
    local theme_name = file:read("*line")
    file:close()

    -- Trim whitespace
    if theme_name then
      theme_name = theme_name:match("^%s*(.-)%s*$")
      if M.THEMES[theme_name] then
        return theme_name
      end
    end
  end

  return M.DEFAULT_THEME
end

-- Save theme to config file
function M.save_theme(theme_name)
  if not M.THEMES[theme_name] then
    vim.notify(
      "Invalid theme: " .. theme_name .. ". Using default theme.",
      vim.log.levels.WARN
    )
    theme_name = M.DEFAULT_THEME
  end

  local theme_file = get_theme_file_path()
  local dir = vim.fn.fnamemodify(theme_file, ":h")

  -- Create directory if it doesn't exist
  vim.fn.mkdir(dir, "p")

  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name .. "\n")
    file:close()
    return true
  else
    vim.notify(
      "Failed to save theme to " .. theme_file,
      vim.log.levels.ERROR
    )
    return false
  end
end

-- Apply matrix theme (custom configuration)
local function apply_matrix_theme()
  -- Set background to dark
  vim.opt.background = "dark"

  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  -- Set colorscheme name
  vim.g.colors_name = "matrix"

  -- Define matrix colors
  local matrix_green = "#00FF00"
  local dark_green = "#008000"
  local darker_green = "#004000"
  local black = "#000000"
  local dim_green = "#00AA00"

  -- Helper function to set highlight
  local function hi(group, opts)
    local cmd = "highlight " .. group
    if opts.fg then
      cmd = cmd .. " guifg=" .. opts.fg
    end
    if opts.bg then
      cmd = cmd .. " guibg=" .. opts.bg
    end
    if opts.style then
      cmd = cmd .. " gui=" .. opts.style
    end
    vim.cmd(cmd)
  end

  -- Basic UI
  hi("Normal", { fg = matrix_green, bg = black })
  hi("NormalFloat", { fg = matrix_green, bg = darker_green })
  hi("Comment", { fg = dark_green, style = "italic" })
  hi("Cursor", { fg = black, bg = matrix_green })
  hi("CursorLine", { bg = darker_green })
  hi("CursorLineNr", { fg = matrix_green, style = "bold" })
  hi("LineNr", { fg = dark_green })
  hi("Visual", { bg = dark_green })
  hi("Search", { fg = black, bg = matrix_green })
  hi("IncSearch", { fg = black, bg = matrix_green, style = "bold" })

  -- Syntax
  hi("Constant", { fg = dim_green })
  hi("String", { fg = matrix_green })
  hi("Character", { fg = matrix_green })
  hi("Number", { fg = dim_green })
  hi("Boolean", { fg = dim_green })
  hi("Float", { fg = dim_green })
  hi("Identifier", { fg = matrix_green })
  hi("Function", { fg = matrix_green, style = "bold" })
  hi("Statement", { fg = dark_green, style = "bold" })
  hi("Conditional", { fg = dark_green, style = "bold" })
  hi("Repeat", { fg = dark_green, style = "bold" })
  hi("Label", { fg = dark_green })
  hi("Operator", { fg = matrix_green })
  hi("Keyword", { fg = dark_green, style = "bold" })
  hi("Exception", { fg = matrix_green, style = "bold" })
  hi("PreProc", { fg = dim_green })
  hi("Include", { fg = dim_green })
  hi("Define", { fg = dim_green })
  hi("Macro", { fg = dim_green })
  hi("PreCondit", { fg = dim_green })
  hi("Type", { fg = matrix_green, style = "bold" })
  hi("StorageClass", { fg = dark_green })
  hi("Structure", { fg = matrix_green })
  hi("Typedef", { fg = matrix_green })
  hi("Special", { fg = matrix_green, style = "bold" })
  hi("SpecialChar", { fg = matrix_green })
  hi("Tag", { fg = matrix_green })
  hi("Delimiter", { fg = dark_green })
  hi("SpecialComment", { fg = dark_green, style = "italic" })
  hi("Debug", { fg = matrix_green })

  -- UI elements
  hi("Pmenu", { fg = matrix_green, bg = darker_green })
  hi("PmenuSel", { fg = black, bg = matrix_green })
  hi("StatusLine", { fg = matrix_green, bg = darker_green })
  hi("StatusLineNC", { fg = dark_green, bg = darker_green })
  hi("VertSplit", { fg = dark_green })
  hi("TabLine", { fg = dark_green, bg = darker_green })
  hi("TabLineFill", { fg = dark_green, bg = darker_green })
  hi("TabLineSel", { fg = matrix_green, bg = black })

  -- Diagnostic
  hi("DiagnosticError", { fg = matrix_green })
  hi("DiagnosticWarn", { fg = dim_green })
  hi("DiagnosticInfo", { fg = dark_green })
  hi("DiagnosticHint", { fg = dark_green })

  -- Git
  hi("DiffAdd", { fg = matrix_green, bg = darker_green })
  hi("DiffChange", { fg = dim_green, bg = darker_green })
  hi("DiffDelete", { fg = dark_green, bg = darker_green })
  hi("DiffText", { fg = matrix_green, bg = dark_green })
end

-- Apply theme
function M.apply_theme(theme_name)
  if not theme_name or theme_name == "" then
    theme_name = M.load_theme()
  end

  local theme = M.THEMES[theme_name]
  if not theme then
    vim.notify(
      "Unknown theme: " .. theme_name .. ". Using default theme.",
      vim.log.levels.WARN
    )
    theme_name = M.DEFAULT_THEME
    theme = M.THEMES[theme_name]
  end

  -- Special handling for system theme
  if theme_name == "system" then
    vim.opt.background = "dark"
    vim.notify("Using system default colorscheme", vim.log.levels.INFO)
    return
  end

  -- Special handling for matrix theme
  if theme_name == "matrix" then
    apply_matrix_theme()
    vim.notify("Applied Matrix theme", vim.log.levels.INFO)
    return
  end

  -- Apply colorscheme if it exists
  if theme.colorscheme then
    local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
    if ok then
      vim.notify("Applied theme: " .. theme_name, vim.log.levels.INFO)
    else
      vim.notify(
        "Failed to apply theme " .. theme_name .. ": " .. tostring(err),
        vim.log.levels.ERROR
      )
    end
  end
end

-- Get list of available themes
function M.get_available_themes()
  local themes = {}
  for _, theme in pairs(M.THEMES) do
    table.insert(themes, theme)
  end

  -- Sort by name
  table.sort(themes, function(a, b)
    return a.name < b.name
  end)

  return themes
end

-- Get list of theme names (for command completion)
function M.get_theme_names()
  local names = {}
  for name, _ in pairs(M.THEMES) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

return M
