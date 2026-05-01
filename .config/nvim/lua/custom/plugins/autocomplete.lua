return {
    'xzbdmw/colorful-menu.nvim',
    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        opts = {
            keymap = {
                preset = 'default',
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            completion = {
                ghost_text = { enabled = true },
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
                menu = {
                    border = 'rounded',
                    draw = {
                        -- We don't need label_description now because label and label_description are already
                        -- combined together in label by colorful-menu.nvim.
                        padding = { 1, 10 },
                        columns = { { 'kind_icon' }, { 'label', gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require('colorful-menu').blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require('colorful-menu').blink_components_highlight(ctx)
                                end,
                            },
                        },
                        treesitter = { 'lsp' },
                    },
                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
                providers = {
                    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },
            snippets = { preset = 'default' },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
            signature = { enabled = true },
        },
    },
    {
        'windwp/nvim-ts-autotag',
        opts = {},
    },
    {
        'supermaven-inc/supermaven-nvim',
        config = function()
            require('supermaven-nvim').setup {
                keymaps = {
                    accept_suggestion = '<C-l>',
                },
            }
        end,
    },
}
