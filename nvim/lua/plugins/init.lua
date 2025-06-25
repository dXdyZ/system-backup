return {
  -- Улучшенная работа с Markdown
  {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    config = function()
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
    end
  },

  -- Автодополнение
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local cmp = require'cmp'
      cmp.setup({
        sources = {
          { name = 'buffer' },
          { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        })
      })
    end
  },


  {
  'iamcco/markdown-preview.nvim',
  ft = 'markdown', -- Загружать только для Markdown-файлов
  build = 'cd app && npm install', -- Установка зависимостей
  config = function()
    vim.g.mkdp_auto_start = 1 -- Автоматически открывать предпросмотр
    vim.g.mkdp_browser = ''  -- Оставьте пустым для использования браузера по умолчанию
  end
  },

-- Файловый менеджер
{
  'nvim-tree/nvim-tree.lua',
  dependencies = {'nvim-tree/nvim-web-devicons'},
  config = function()
    require('nvim-tree').setup({
      view = {
        width = 30,
        side = 'left',
      },
      filters = {
        dotfiles = true,   -- Показывать dotfiles
        custom = {}         -- Без дополнительных фильтров
      },
      git = {
        enable = true,
        ignore = true     -- Показывать gitignored файлы
      }
    })
  end
},
 -- Тема оформления
  {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup({ style = 'moon' })
      vim.cmd('colorscheme tokyonight')
    end
  },

  -- Поиск файлов
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
      require('telescope').setup()
    end
  },

  -- Форматирование
  {
    'prettier/vim-prettier',
    ft = 'markdown',
    build = 'npm install',
    config = function()
      vim.g['prettier#autoformat'] = 1
      vim.cmd('autocmd BufWritePre *.md PrettierAsync')
    end
  }
}
