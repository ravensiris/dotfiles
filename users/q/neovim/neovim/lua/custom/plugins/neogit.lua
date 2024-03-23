return {
  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      local neogit = require 'neogit'

      neogit.setup {
        use_magit_keybindings = true,
      }
    end,
    keys = { { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Open Neogit' } },
  },
}
