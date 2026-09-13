-- Source Vim's config
vim.cmd('source ~/.vimrc')


-------------------------------------------------------------------------------
-------------------------------- PLUGINS --------------------------------------
-------------------------------------------------------------------------------
vim.pack.add({
    -- { src = "https://github.com/neovim/nvim-lspconfig" },
    -- { src = "https://github.com/detachhead/basedpyright" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        build = function()
            vim.cmd("TSUpdate")
        end,
    },
    { src = "https://github.com/davidhalter/jedi-vim" },
    { src = "https://github.com/ervandew/supertab" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nanozuki/tabby.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/X3eRo0/dired.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
})


-- LSP CONFIG
-- local lspconfig = require("lspconfig")
-- lspconfig.basedpyright.setup{}
-- vim.lsp.config("basedpyright", {
--     settings = {
--         basedpyright = {
--             analysis = {
--                 typeCheckingMode = "standard", -- Options: "off", "basic", "standard", "strict"
--                 diagnosticMode = "openFilesOnly",
--                 useLibraryCodeForTypes = true,
--                 autoSearchPaths = true,
--             },
--         },
--     },
-- })
-- vim.lsp.enable("basedpyright")


-------------------------------------------------------------------------------
--------------------------------- oil.nvim ------------------------------------
-------------------------------------------------------------------------------
require("oil").setup({
  columns = {
    "permissions",
    "size",
    "mtime",
  },
})


-------------------------------------------------------------------------------
----------------------------- COLOUR SCHEME -----------------------------------
-------------------------------------------------------------------------------
require('nightfox').setup({
    options = {
        transparent = true,
        styles = {
            comments = "NONE",     -- `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "bold",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
        },
        inverse = {             -- Inverse highlight for different types
            match_paren = true,
        },
    },
    palettes = {},
    specs = {},
    groups = {},
})


-------------------------------------------------------------------------------
------------------------------ tabby.nvim -------------------------------------
-------------------------------------------------------------------------------
local function get_git_branch()
    local handle = io.popen("git branch --show-current 2>/dev/null")
    if not handle then return "" end
    local result = handle:read("*a")
    handle:close()
    local branch = result:gsub("%s+", "")
    if branch ~= "" then
        return "  " .. branch .. " "
    else
        return ""
    end
end

local theme = {
    fill = 'TabLineFill',
    -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
    head = 'TabLine',
    current_tab = { fg = '#000000', bg = '#A0A0A0' , style = 'bold' },
    tab = 'TabLine',
    win = 'TabLine',
    tail = 'TabLine',
}
require('tabby').setup({
    line = function(line)
        local git_branch = get_git_branch()
        local right_section = {}
        if git_branch ~= "" then
            right_section = {
                line.sep('', { bg = '#FFFFFF' }, theme.fill ),
                {
                    git_branch,
                    hl = { fg = '#303030', bg = '#FFFFFF' },
                },
            }
        end

        return {
            {
                { '  neovim', hl = theme.fill },
                line.sep('', theme.fill, theme.fill),
            },
            line.tabs().foreach(function(tab)
                local hl = tab.is_current() and theme.current_tab or theme.tab
                return {
                    line.sep('', hl, theme.fill),
                    -- tab.is_current() and '' or '󰆣',           -- Current tab indicator
                    tab.number(),
                    tab.name(),
                    -- tab.close_btn(''),
                    line.sep('', hl, theme.fill),
                    hl = hl,
                    margin = ' ',
                }
            end),
            line.spacer(),
            right_section,
            hl = theme.fill,
        }
    end,
})


-------------------------------------------------------------------------------
------------------------------ lualine.nvim -----------------------------------
-------------------------------------------------------------------------------
-- DON'T APPLY *ANY* THEME TO lualine.nvim
local lualine_theme = {
    normal = { a = 'Normal', b = 'Normal', c = 'Normal' },
    insert = { a = 'Normal', b = 'Normal', c = 'Normal' },
    visual = { a = 'Normal', b = 'Normal', c = 'Normal' },
    replace = { a = 'Normal', b = 'Normal', c = 'Normal' },
    command = { a = 'Normal', b = 'Normal', c = 'Normal' },
    inactive = { a = 'Normal', b = 'Normal', c = 'Normal' },
}

-- SPINNERS AND BOUNCERS
-- Seven-char reverse spinner
local spinner_7ch_full = { '⣾', '⣷', '⣯', '⣟', '⡿', '⢿', '⣻', '⣽' }
-- Wave bouncer
local spinner_wave = { '▁', '▃', '▅', '▆', '▇', '█', '▇', '▆', '▅', '▃', '▁', ' ' }
-- Left-aligned dot bouncer
local spinner_ltdot = { '⡀', '⠄', '⠂', '⠁', '⠂', '⠄', '⡀' }
-- Right-aligned dot bouncer
local spinner_rtdot = { '⢀', '⠠', '⠐', '⠈', '⠐', '⠠', '⢀' }
-- Four-char lower-half-cell spinner
local spinner_4ch_lower = { '⠖', '⠲', '⢲', '⢰', '⣰', '⣠', '⣄', '⣆', '⡆', '⡖' }
-- Four-char upper-half-cell spinner
local spinner_4ch_upper = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
-- Four-char full cell spinner
local spinner_4ch_full = { '⠋', '⠙', '⠸', '⢰', '⣠', '⣄', '⡆', '⠇' }
-- Four-char alternating lower- and upper-half-cell spinner
local spinner_4ch_altern = { '⠋', '⠙', '⠸', '⠴', '⠦', '⠇', '⠋', '⠙', '⠸', '⢰', '⣠', '⣄', '⡆', '⠖', '⠲', '⢰', '⣠', '⣄', '⡆', '⠇' }
-- Centred double dots
local spinner_2dot = { '⠉', '⠒', '⠤', '⣀', '⠤', '⠒', '⠉' }
local spinner_index = 1
local function get_spinner_char()
    return spinner_7ch_full[spinner_index]
end
vim.fn.timer_start(
  150,
  function()
    spinner_index = spinner_index % #spinner_7ch_full + 1
    require("lualine").refresh()
  end,
  { ["repeat"] = -1 }
)

-- MODE MAP
local mode_map = {
  ['NORMAL']   = 'NOR',
  ['INSERT']   = 'INS',
  ['VISUAL']   = 'VIS',
  ['V-BLOCK']  = 'VBL',
  ['V-LINE']   = 'VLN',
  ['TERMINAL'] = 'TER',
  ['COMMAND']  = 'CMD',
}

local function get_time()
  return os.date("%I:%M%p")
end

require("lualine").setup({
    options = {
        -- ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷
        -- ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
        section_separators = { left = ' ', right = ' ' },
        component_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = "", right = "" },
        -- component_separators = { left = "", right = "" },
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        icons_enabled = false,
        theme = lualine_theme,
    },

    sections = {
        lualine_a = {
            {
                'mode',
                fmt = function(str)
                    return mode_map[str] or str
                end,
            },
            {
                'custom_spinner',
                fmt = function(str)
                    return get_spinner_char()
                end,
            },
        },
        lualine_b = {
            {
                'filename',
                path = 3,
                symbols = { unnamed = '[buf]' },
            },
        },
        lualine_c = {},
        lualine_x = {
            'searchcount',
            'selectioncount',
            'fileformat',
            'filesize',
            -- get_time,
        },
        lualine_y = {
            {
                'progress',
                fmt = function(str)
                    return str:lower()
                end,
            },
        },
    },
})


-------------------------------------------------------------------------------
------------------------------- JEDI-VIM --------------------------------------
-------------------------------------------------------------------------------
-- Default scroll direction for completions
vim.g.SuperTabDefaultCompletionType = "<c-n>"


-------------------------------------------------------------------------------
------------------------------ MISCELLANEOUS ----------------------------------
-------------------------------------------------------------------------------
vim.opt.termguicolors = true
-- Hide '-- INSERT --' because insert mode is already displayed in lualine.nvim, right?
vim.opt.showmode = false
-- Remap Y to yy because it's y$ by default in nvim
vim.keymap.set('n', 'Y', 'yy', { desc = 'Yank whole line' })
vim.opt.tabstop = 4         -- TAB character looks like 4 spaces
vim.opt.softtabstop = 4     -- Number of spaces instead of TAB char
vim.opt.shiftwidth = 4      -- Number of spaces when indenting
vim.opt.expandtab = true    -- Pressing TAB key will insert spaces instead of TAB character
vim.opt.guicursor = "n-v-i-c:block-Cursor"    -- Block cursor in insert mode and every damn mode
-- vim.cmd.colorscheme("oxocarbon")
vim.cmd.colorscheme("carbonfox")
