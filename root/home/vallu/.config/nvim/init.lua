vim.cmd("source ~/.vimrc")


---------------
--- PLUGINS ---
---------------
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/detachhead/basedpyright" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        build = function()
            vim.cmd("TSUpdate")
        end,
    },
    -- { src = "https://github.com/davidhalter/jedi-vim" },
    { src = "https://github.com/ervandew/supertab" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/rktjmp/lush.nvim" },
    { src = "https://github.com/karb94/neoscroll.nvim" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    -- { src = "https://github.com/preservim/vim-indent-guides" },
})


-- LSP CONFIG
vim.lsp.config("ruff", {
    init_options = {
        settings = {
            configuration = "~/.config/ruff/ruff.toml",
            line_length = 79,
            lint = {
                preview = true,
            }
        }
    }
})

vim.lsp.enable("ruff")
-- vim.lsp.config("basedpyright", {
--     settings = {
--         basedpyright = {
--             analysis = {
--                 typeCheckingMode = "standard",      -- off, basic, standard, strict
--                 diagnosticMode = "openFilesOnly",
--                 useLibraryCodeForTypes = true,
--                 autoSearchPaths = true,
--             },
--         },
--     },
-- })
-- vim.lsp.enable("basedpyright")
-- vim.diagnostic.config({
--     virtual_text = false,
-- })

-- toggle floating window
local diagnostic_float
vim.keymap.set("n", "<leader>e", function()
    if diagnostic_float and vim.api.nvim_win_is_valid(diagnostic_float) then
        vim.api.nvim_win_close(diagnostic_float, true)
        diagnostic_float = nil
    else
        local _, winnr = vim.diagnostic.open_float()
        diagnostic_float = winnr
    end
end, { desc = "Toggle diagnostic window" })
-- open all diagnostics results
vim.keymap.set("n", "<leader>a", vim.diagnostic.setqflist, { desc = "Open diagnostics results" })
-- toggle virtual text (inline messages)
vim.keymap.set("n", "<leader>i", function()
    vim.diagnostic.config({
        virtual_text = not vim.diagnostic.config().virtual_text,
    })
end, { desc = "Toggle diagnostic virtual text" })
-- auto-open floating window on cursor hold ("hover")
-- vim.o.updatetime = 1000
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         vim.diagnostic.open_float(nil, {
--             focus = false,
--         })
--     end,
-- })


----------------
--- OIL.NVIM ---
----------------
require("oil").setup({
    columns = {
        "permissions",
        "size",
        "mtime",
    },
    keymaps = {
        ["g?"]    = { "actions.show_help", mode = "n" },
        ["<CR>"]  = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"]     = { "actions.parent", mode = "n" },
        ["_"]     = { "actions.open_cwd", mode = "n" },
        ["gw"]     = { "actions.cd", mode = "n" },
        ["gt"]    = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"]    = { "actions.change_sort", mode = "n" },
        ["gx"]    = "actions.open_external",
        ["g."]    = { "actions.toggle_hidden", mode = "n" },
        ["g\\"]   = { "actions.toggle_trash", mode = "n" },
    },
    view_options = { show_hidden = true },
})
vim.keymap.set("n", "-", function()
    vim.cmd("tabe")
    require("oil").open()
end)
vim.keymap.set("n", "_", function()
    vim.cmd("vsp")
    require("oil").open()
end)
vim.keymap.set("n", "+", function()
    require("oil").open()
end)

---------------------
--- COLOUR SCHEME ---
---------------------
require('nightfox').setup({
    options = {
        transparent = true,
        styles = {
            comments     = "NONE",     -- `:help attr-list`
            conditionals = "NONE",
            constants    = "NONE",
            functions    = "NONE",
            keywords     = "bold",
            numbers      = "NONE",
            operators    = "NONE",
            strings      = "NONE",
            types        = "NONE",
            variables    = "NONE",
        },
        inverse = {             -- Inverse highlight for different types
            match_paren = true,
        },
    },
    palettes = {},
    specs = {},
    groups = {},
})

-- local lush = require("lush")
-- local hsl = lush.hsl
-- local sea_foam  = hsl(208, 100, 80) -- Vim has a mapping, <n>C-a and <n>C-x to
-- local sea_crest = hsl(208, 90, 30)  -- increment or decrement integers, or
-- local sea_deep  = hsl(208, 90, 10)  -- you can just type them normally.
-- local theme = lush(function()
--     return {
--         Normal { bg = sea_deep, fg = sea_foam },  -- Goodbye gray, hello blue!
--     }
-- end)


----------------
--- JEDI-VIM ---
----------------
-- default scroll direction for completions
vim.g.SuperTabDefaultCompletionType = "<c-n>"


---------------------
--- INDENT GUIDES ---
---------------------
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#703C35" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#75601B" })
    vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#214F8F" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#814A26" })
    vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#387319" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#734886" })
    vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#167682" })
end)
require("ibl").setup({
    indent = {
        highlight = highlight,
        -- char = "┊",
        char = "│",
    },
})
-- For first-level spaces and tabs
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
-----
-- vim.g.indent_guides_enable_on_vim_startup = 1
-- vim.g.indent_guides_start_level = 2
-- vim.g.indent_guides_guide_size = 1


------------
--- MISC ---
------------
vim.cmd.colorscheme("carbonfox")
require("statusline")
require("tabline")
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.termguicolors = true
-- hide '-- INSERT --' because insert mode is already displayed in lualine.nvim, right?
vim.opt.showmode = false
vim.opt.tabstop = 4         -- TAB character looks like 4 spaces
vim.opt.softtabstop = 4     -- Number of spaces instead of TAB char
vim.opt.shiftwidth = 4      -- Number of spaces when indenting
vim.opt.expandtab = true    -- Pressing TAB key will insert spaces instead of TAB character
vim.opt.guicursor = "n-v-i-c:block-Cursor"    -- Block cursor in insert mode and every damn mode
vim.opt.signcolumn = "yes"

-- HIDDEN CUSTOMISATION
vim.opt.hidden = true
local function smart_quit(bang)
    if not bang and vim.bo.modified then
        local bufnr = vim.api.nvim_get_current_buf()
        local wincount = 0
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == bufnr then
                wincount = wincount + 1
            end
        end
        if wincount <= 1 then
            vim.api.nvim_err_writeln("E37: No write since last change (add ! to override)")
            return
        end
    end
    vim.cmd("quit" .. (bang and "!" or ""))
end

vim.api.nvim_create_user_command("Q", function(opts)
    smart_quit(opts.bang)
end, { bang = true })

vim.cmd([[
  cnoreabbrev <expr> q  (getcmdtype() ==# ':' && getcmdline() ==# 'q')  ? 'Q'  : 'q'
  cnoreabbrev <expr> q! (getcmdtype() ==# ':' && getcmdline() ==# 'q!') ? 'Q!' : 'q!'
]])

-- KEYMAPS
-- remap Y to yy because it's y$ by default in nvim
vim.keymap.set("n", "Y", "yy", { desc = "Yank whole line" })
vim.keymap.set("n", "<leader>cv", ":vnew | r !", { desc = "Execute a external command in a vertical split" })
vim.keymap.set("n", "<leader>ch", ":new | r !", { desc = "Execute a external command in a horizontal split" })
vim.keymap.set("n", "<leader>ct", ":tabe | r !", { desc = "Execute a external command in a tab" })

if vim.g.neovide then
    vim.o.guifont = "Iosevka Nerd Font:h18"
    vim.opt.linespace = 3
    vim.g.neovide_text_gamma = 1.0
    vim.g.neovide_text_contrast = 0.5
    vim.g.neovide_padding_top = 4
    vim.g.neovide_padding_bottom = 4
    vim.g.neovide_padding_right = 4
    vim.g.neovide_padding_left = 4
end
