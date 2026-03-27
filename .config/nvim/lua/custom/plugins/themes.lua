return {
    { -- You can easily change to a different colorscheme.
        -- Change the name of the colorscheme plugin below, and then
        -- change the command in the config to whatever the name of that colorscheme is.
        --
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
        'folke/tokyonight.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('tokyonight').setup {
                styles = {
                    comments = { italic = false }, -- Disable italics in comments
                },
            }
        end,
    },
    {
        'kaiuri/nvim-juliana',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        lazy = false,
        config = true,
    },
    {
        'rebelot/kanagawa.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        lazy = false,
        config = true,
    },
    {
        'kepano/flexoki-neovim',
        name = 'flexoki',
        init = function()
            vim.cmd.colorscheme 'flexoki-light'
        end,

    }
}
