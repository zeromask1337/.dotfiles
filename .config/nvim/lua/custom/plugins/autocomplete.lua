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
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if ctx.item.source_name == 'LSP' then
                                        local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                                        if color_item and color_item.abbr ~= '' then
                                            icon = color_item.abbr
                                        end
                                    end
                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local highlight = 'BlinkCmpKind' .. ctx.kind
                                    if ctx.item.source_name == 'LSP' then
                                        local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                                        if color_item and color_item.abbr_hl_group then
                                            highlight = color_item.abbr_hl_group
                                        end
                                    end
                                    return highlight
                                end,
                            },
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
