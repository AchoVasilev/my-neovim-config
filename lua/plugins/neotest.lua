return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest',
  },
  keys = {
    {
      '<leader>tt',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run File',
    },
    {
      '<leader>tA',
      function()
        require('neotest').run.run(vim.uv.cwd())
      end,
      desc = 'Run All',
    },
    {
      '<leader>tr',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run Nearest',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Run Last',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle Summary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open { enter = true, auto_close = true }
      end,
      desc = 'Show Output',
    },
    {
      '<leader>tO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle Output Panel',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop',
    },
    {
      '<leader>tw',
      function()
        require('neotest').watch.toggle(vim.fn.expand '%')
      end,
      desc = 'Toggle Watch',
    },
  },
  config = function()
    local function find_nearest_node_modules()
      local dir = vim.fn.expand '%:p:h' -- start from the current file's directory
      while dir and dir ~= '/' do
        local node_modules_path = dir .. '/node_modules/jest/bin/jest.js'
        if vim.fn.filereadable(node_modules_path) == 1 then
          return node_modules_path
        end
        dir = vim.fn.fnamemodify(dir, ':h') -- go up one level
      end
      return nil -- return nil if not found
    end

    require('neotest').setup {
      adapters = {
        require 'neotest-jest' {
          jestCommand = function()
            local file_path = vim.fn.expand '%:p'
            local jest_path = find_nearest_node_modules() or 'jest' -- fallback to "jest" if not found
            local node_path = '/usr/bin/node' -- adjust this if necessary

            local cmd = string.format('%s %s --colors --verbose --runTestsByPath %s', node_path, jest_path, file_path)
            return cmd
          end,
          cwd = function()
            return vim.fn.getcwd()
          end,
          env = { NODE_ENV = 'test' },
          jestConfigFile = function()
            local file_path = vim.fn.expand '%:p'
            local project_name = file_path:match 'apps/(.-)/' or file_path:match 'libs/(.-)/'
            if project_name and project_name ~= '' then
              return 'apps/' .. project_name .. '/jest.config.js'
            end
            return vim.fn.getcwd() .. '/jest.config.js'
          end,
        },
      },
    }
  end,
}
