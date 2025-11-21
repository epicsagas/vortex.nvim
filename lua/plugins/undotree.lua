return {
  {
    "mbbill/undotree",
    config = function()
      -- Enable persistent undo (undo history survives file close)
      vim.opt.undofile = true
      vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

      -- Undotree settings
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SetFocusWhenToggle = 1

      -- Keybinding to toggle undotree
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undo Tree" })
    end,
  },
}
