return {
  'NickvanDyke/opencode.nvim',
  version = '*',
  dependencies = {
    { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    local opencode_cmd = 'opencode --port'

    vim.g.opencode_opts = {
      server = {
        start = function()
          require('snacks.terminal').open(opencode_cmd, {
            win = { position = 'right', enter = false },
          })
        end,
      },
    }

    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
      require('opencode').ask('@this: ')
    end, { desc = 'Ask opencode' })
    vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action' })
    vim.keymap.set({ 'n', 't' }, '<leader>o.', function()
      require('snacks.terminal').toggle(opencode_cmd, {
        win = { position = 'right', enter = false },
      })
    end, { desc = 'Toggle opencode' })

    vim.keymap.set({ 'n', 'x' }, 'go', function()
      return require('opencode').operator('@this ')
    end, { desc = 'Add range to opencode', expr = true })
    vim.keymap.set('n', 'goo', function()
      return require('opencode').operator('@this ') .. '_'
    end, { desc = 'Add line to opencode', expr = true })

    vim.keymap.set('n', '<S-C-u>', function()
      require('opencode').command('session.half.page.up')
    end, { desc = 'Scroll opencode up' })
    vim.keymap.set('n', '<S-C-d>', function()
      require('opencode').command('session.half.page.down')
    end, { desc = 'Scroll opencode down' })
  end,
}
