-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local ns = vim.lsp.diagnostic.get_namespace(client.id)
    vim.diagnostic.config({ update_in_insert = false }, ns)

    -- Remove LSP's TextChangedI autocmd so the server is not notified while
    -- typing. TextChanged fires automatically after InsertLeave, which still
    -- delivers didChange to the server at the right time.
    vim.schedule(function()
      for _, ac in ipairs(vim.api.nvim_get_autocmds({ event = "TextChangedI", buffer = args.buf })) do
        if (ac.group_name or ""):find("lsp", 1, true) then
          pcall(vim.api.nvim_del_autocmd, ac.id)
        end
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "py" },
  callback = function()
    vim.wo.spell = false
    vim.wo.concealleave = 0
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp" },
  callback = function()
    vim.b.autoformat = false
  end,
})
