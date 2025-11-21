-- nvim-ai CLI Integration
-- Connects Neovim to multiple AI providers via CLI wrapper

local M = {}

-- Configuration
M.config = {
  nvai_path = vim.fn.stdpath("config") .. "/scripts/nvai",
  default_provider = "auto", -- auto|claude|gemini|cursor
  default_temperature = 0.7,
  default_max_tokens = 4096,
  window = {
    position = "right", -- right|bottom|float
    width = 0.4, -- percentage or absolute
    height = 0.8,
  },
  keymaps = {
    send = "<C-s>",
    cancel = "<C-c>",
    new_chat = "<C-n>",
    select_provider = "<leader>ap",
  },
}

-- State
local state = {
  current_provider = nil,
  chat_buffer = nil,
  chat_window = nil,
  input_buffer = nil,
  context = {
    file = nil,
    selection = nil,
    project = nil,
  },
}

-- Utility functions
local function log(message, level)
  level = level or vim.log.levels.INFO
  vim.notify("[nvim-ai] " .. message, level)
end

local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if #lines == 0 then
    return nil
  end

  -- Handle partial line selection
  local start_col = start_pos[3]
  local end_col = end_pos[3]

  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  return table.concat(lines, "\n")
end

local function get_current_file()
  local bufnr = vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_name(bufnr)
end

local function get_project_root()
  -- Try to find project root using various markers
  local markers = { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml" }
  local current_file = get_current_file()

  if current_file == "" then
    return vim.fn.getcwd()
  end

  local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

  while current_dir ~= "/" do
    for _, marker in ipairs(markers) do
      if vim.fn.filereadable(current_dir .. "/" .. marker) == 1 or vim.fn.isdirectory(current_dir .. "/" .. marker) == 1 then
        return current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return vim.fn.getcwd()
end

-- AI Provider selection
function M.select_provider(callback)
  local providers = { "auto", "claude", "gemini", "cursor" }

  vim.ui.select(providers, {
    prompt = "Select AI Provider:",
    format_item = function(item)
      local icons = {
        auto = "🔄 Auto-detect",
        claude = "🤖 Claude (Anthropic)",
        gemini = "✨ Gemini (Google)",
        cursor = "⚡ Cursor AI",
      }
      return icons[item] or item
    end,
  }, function(choice)
    if choice then
      state.current_provider = choice
      log("Provider changed to: " .. choice)
      if callback then
        callback(choice)
      end
    end
  end)
end

-- Execute nvai command
function M.call_ai(prompt, opts)
  opts = opts or {}

  local provider = opts.provider or state.current_provider or M.config.default_provider
  local temperature = opts.temperature or M.config.default_temperature
  local max_tokens = opts.max_tokens or M.config.default_max_tokens

  -- Build command
  local cmd = { M.config.nvai_path }

  table.insert(cmd, "--provider")
  table.insert(cmd, provider)

  table.insert(cmd, "--temperature")
  table.insert(cmd, tostring(temperature))

  table.insert(cmd, "--max-tokens")
  table.insert(cmd, tostring(max_tokens))

  -- Add context
  if opts.file then
    table.insert(cmd, "--file")
    table.insert(cmd, opts.file)
  end

  if opts.project then
    table.insert(cmd, "--project")
    table.insert(cmd, opts.project)
  end

  if opts.selection then
    table.insert(cmd, "--selection")
    table.insert(cmd, opts.selection)
  end

  -- Add prompt
  table.insert(cmd, prompt)

  -- Execute command
  log("Calling AI: " .. provider)

  local output = {}
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(output, line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" and not line:match("^ℹ") and not line:match("^✓") then
            log("Error: " .. line, vim.log.levels.ERROR)
          end
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        if opts.callback then
          opts.callback(table.concat(output, "\n"))
        end
      else
        log("AI call failed with exit code: " .. exit_code, vim.log.levels.ERROR)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  if job_id <= 0 then
    log("Failed to start nvai command", vim.log.levels.ERROR)
    return nil
  end

  return job_id
end

-- Create chat window
function M.open_chat()
  -- Check if chat window already exists
  if state.chat_window and vim.api.nvim_win_is_valid(state.chat_window) then
    vim.api.nvim_set_current_win(state.chat_window)
    return
  end

  -- Create chat buffer
  if not state.chat_buffer or not vim.api.nvim_buf_is_valid(state.chat_buffer) then
    state.chat_buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(state.chat_buffer, "buftype", "nofile")
    vim.api.nvim_buf_set_option(state.chat_buffer, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(state.chat_buffer, "swapfile", false)
    vim.api.nvim_buf_set_name(state.chat_buffer, "nvim-ai://chat")
  end

  -- Create window
  local width = math.floor(vim.o.columns * M.config.window.width)
  local height = math.floor(vim.o.lines * M.config.window.height)

  if M.config.window.position == "right" then
    vim.cmd("vsplit")
    state.chat_window = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.chat_window, state.chat_buffer)
    vim.api.nvim_win_set_width(state.chat_window, width)
  elseif M.config.window.position == "bottom" then
    vim.cmd("split")
    state.chat_window = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.chat_window, state.chat_buffer)
    vim.api.nvim_win_set_height(state.chat_window, height)
  elseif M.config.window.position == "float" then
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    state.chat_window = vim.api.nvim_open_win(state.chat_buffer, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })
  end

  -- Set buffer options
  vim.api.nvim_buf_set_option(state.chat_buffer, "filetype", "markdown")
  vim.api.nvim_buf_set_option(state.chat_buffer, "modifiable", true)

  -- Add welcome message
  local welcome = {
    "# nvim-ai Chat",
    "",
    "Provider: " .. (state.current_provider or "auto"),
    "",
    "---",
    "",
  }
  vim.api.nvim_buf_set_lines(state.chat_buffer, 0, -1, false, welcome)

  log("Chat window opened")
end

-- Close chat window
function M.close_chat()
  if state.chat_window and vim.api.nvim_win_is_valid(state.chat_window) then
    vim.api.nvim_win_close(state.chat_window, true)
    state.chat_window = nil
    log("Chat window closed")
  end
end

-- Toggle chat window
function M.toggle_chat()
  if state.chat_window and vim.api.nvim_win_is_valid(state.chat_window) then
    M.close_chat()
  else
    M.open_chat()
  end
end

-- Send message to AI
function M.send_message(prompt, opts)
  opts = opts or {}

  if not prompt or prompt == "" then
    vim.ui.input({ prompt = "AI Prompt: " }, function(input)
      if input and input ~= "" then
        M.send_message(input, opts)
      end
    end)
    return
  end

  -- Collect context
  local context_opts = {
    provider = opts.provider,
    temperature = opts.temperature,
    max_tokens = opts.max_tokens,
  }

  if opts.include_file then
    context_opts.file = get_current_file()
  end

  if opts.include_project then
    context_opts.project = get_project_root()
  end

  if opts.include_selection then
    context_opts.selection = get_visual_selection()
  end

  -- Open chat window if not open
  if not state.chat_window or not vim.api.nvim_win_is_valid(state.chat_window) then
    M.open_chat()
  end

  -- Add user message to chat
  local chat_lines = vim.api.nvim_buf_get_lines(state.chat_buffer, 0, -1, false)
  table.insert(chat_lines, "")
  table.insert(chat_lines, "## You:")
  table.insert(chat_lines, prompt)
  table.insert(chat_lines, "")
  table.insert(chat_lines, "## AI:")
  table.insert(chat_lines, "_Thinking..._")
  vim.api.nvim_buf_set_lines(state.chat_buffer, 0, -1, false, chat_lines)

  -- Scroll to bottom
  vim.api.nvim_win_set_cursor(state.chat_window, { #chat_lines, 0 })

  -- Call AI
  context_opts.callback = function(response)
    -- Replace "Thinking..." with response
    local current_lines = vim.api.nvim_buf_get_lines(state.chat_buffer, 0, -1, false)
    for i = #current_lines, 1, -1 do
      if current_lines[i] == "_Thinking..._" then
        current_lines[i] = response
        break
      end
    end
    vim.api.nvim_buf_set_lines(state.chat_buffer, 0, -1, false, current_lines)

    -- Scroll to bottom
    local line_count = vim.api.nvim_buf_line_count(state.chat_buffer)
    vim.api.nvim_win_set_cursor(state.chat_window, { line_count, 0 })

    log("Response received")
  end

  M.call_ai(prompt, context_opts)
end

-- Quick actions
function M.explain_selection()
  local selection = get_visual_selection()
  if not selection then
    log("No selection", vim.log.levels.WARN)
    return
  end

  M.send_message("Explain this code:", {
    include_selection = true,
  })
end

function M.fix_selection()
  local selection = get_visual_selection()
  if not selection then
    log("No selection", vim.log.levels.WARN)
    return
  end

  M.send_message("Find and fix bugs in this code:", {
    include_selection = true,
  })
end

function M.refactor_selection()
  local selection = get_visual_selection()
  if not selection then
    log("No selection", vim.log.levels.WARN)
    return
  end

  M.send_message("Refactor this code for better maintainability:", {
    include_selection = true,
  })
end

function M.optimize_selection()
  local selection = get_visual_selection()
  if not selection then
    log("No selection", vim.log.levels.WARN)
    return
  end

  M.send_message("Optimize this code for performance:", {
    include_selection = true,
  })
end

function M.generate_tests()
  local file = get_current_file()
  if not file or file == "" then
    log("No file open", vim.log.levels.WARN)
    return
  end

  M.send_message("Generate comprehensive tests for this code:", {
    include_file = true,
  })
end

function M.analyze_project()
  M.send_message("Analyze the architecture and suggest improvements:", {
    include_project = true,
  })
end

-- Setup function
function M.setup(user_config)
  -- Merge user config
  if user_config then
    M.config = vim.tbl_deep_extend("force", M.config, user_config)
  end

  -- Check if nvai exists
  if vim.fn.executable(M.config.nvai_path) ~= 1 then
    log("nvai script not found or not executable: " .. M.config.nvai_path, vim.log.levels.WARN)
    log("Run: chmod +x " .. M.config.nvai_path)
  end

  -- Create user commands
  vim.api.nvim_create_user_command("AIChat", function(opts)
    if opts.args and opts.args ~= "" then
      M.send_message(opts.args)
    else
      M.toggle_chat()
    end
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("AIProvider", function()
    M.select_provider()
  end, {})

  vim.api.nvim_create_user_command("AIExplain", function()
    M.explain_selection()
  end, { range = true })

  vim.api.nvim_create_user_command("AIFix", function()
    M.fix_selection()
  end, { range = true })

  vim.api.nvim_create_user_command("AIRefactor", function()
    M.refactor_selection()
  end, { range = true })

  vim.api.nvim_create_user_command("AIOptimize", function()
    M.optimize_selection()
  end, { range = true })

  vim.api.nvim_create_user_command("AITest", function()
    M.generate_tests()
  end, {})

  vim.api.nvim_create_user_command("AIAnalyze", function()
    M.analyze_project()
  end, {})

  log("nvim-ai CLI integration loaded")
end

return M
