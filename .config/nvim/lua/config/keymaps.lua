local map = vim.keymap.set

-- Clear highlights
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Better enter behavior
map('n', '<CR>', 'o<Esc>')
map('n', '<M-CR>', 'O<Esc>')

-- Diagnostic mappings
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mappings
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Quickfix list navigation
map('n', '<C-M-j>', '<cmd>cnext<CR>')
map('n', '<C-M-k>', '<cmd>cprev<CR>')

-- Debugging nvim config
map('n', '<space><space>x', '<cmd>source %<CR>', { desc = 'Reload current file' })
map('n', '<space>x', ':.lua<CR>', { desc = 'Execute current line' })
map('v', '<space>x', ':lua<CR>', { desc = 'Exectute selected code in lua' })

return {} -- Return empty table for consistency
