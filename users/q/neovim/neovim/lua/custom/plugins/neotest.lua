return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- additonal langs
      'jfpedroza/neotest-elixir',
    },
    config = function()
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          require 'neotest-elixir',
        },
      }

      -- Add key bindings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'elixir',
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filename = vim.fn.expand '%:t'
          if filename:match '_test%.exs$' then
            vim.keymap.set('n', '<LEADER>cc', function()
              neotest.run.run()
            end, { buffer = bufnr, desc = 'Run Elixir test using neotest' })

            vim.keymap.set('n', '<LEADER>co', function()
              neotest.output.open { enter = true }
            end, { buffer = bufnr, desc = 'Open neotest output window' })
          end
        end,
      })
    end,
  },
}
