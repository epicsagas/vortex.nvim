return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    config = function()
      -- Keymaps for C/C++
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          -- Quick run/test keymaps
          vim.keymap.set("n", "<F5>", function()
            local ft = vim.bo.filetype
            if ft == "cpp" then
              vim.cmd("split | terminal g++ % -o %:r && ./%:r")
            else
              vim.cmd("split | terminal gcc % -o %:r && ./%:r")
            end
            vim.cmd("startinsert")
          end, { desc = "[C/C++] Compile & Run", buffer = true })

          vim.keymap.set("n", "<F6>", function()
            local ft = vim.bo.filetype
            if ft == "cpp" then
              vim.cmd("split | terminal g++ % -o %:r -g")
            else
              vim.cmd("split | terminal gcc % -o %:r -g")
            end
            vim.cmd("startinsert")
          end, { desc = "[C/C++] Compile with Debug", buffer = true })

          -- Switch between header/source
          vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "[C/C++] Switch Header/Source", buffer = true })
        end,
      })
    end,
  },
}
