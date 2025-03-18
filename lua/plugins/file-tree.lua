return {
  {
    'nvim-tree/nvim-web-devicons',
    lazy = false, -- Load immediately, not lazily
    priority = 1000, -- High priority so it loads first
    opts = {},
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        '<leader>fe',
        function()
          require('nvim-tree.api').tree.toggle()
        end,
        desc = '[F]ile [E]xplorer current directory',
      },
    },
    config = function()
      require('nvim-web-devicons').setup {}
      require('nvim-tree').setup {
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
      }
    end,
  },
}
