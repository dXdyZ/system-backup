-- Установка Lazy.nvim (уже имеющийся код)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.title = true
vim.opt.titlestring = "NVIM: %t"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Инициализация Lazy.nvim и подключение плагинов
require('lazy').setup('plugins.init')

-- Базовые настройки Neovim
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.mouse = 'a'

-- Клавиатурные сокращения
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>p', '<cmd>MarkdownPreview<cr>')
-- Клавиатурные сокращения
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>') -- <leader>e для открытия/закрытия

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { silent = true })
