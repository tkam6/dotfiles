-- the greatest, most powerful, OG
vim.cmd("source ~/.vimrc")


-- =============
-- ===== PLUGINS
-- =============
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        build = function()
            vim.cmd("TSUpdate")
        end,
    },
    { src = "https://github.com/ervandew/supertab" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    {
        src = "https://github.com/junegunn/fzf",
        build = function()
            vim.cmd("fzf#install")
        end
    },
})


-- =====================
-- ===== NVIM-TREESITTER
-- =====================
require('nvim-treesitter').install({ 'python', 'c', 'rust' })


-- ================
-- ===== LSP CONFIG
-- ================
vim.lsp.config("ruff", {
    init_options = {
        settings = {
            configuration = "~/.config/ruff/ruff.toml",
            lineLength = 79,
            lint = { preview = true },
        },
    },
})
vim.lsp.enable("ruff")

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
--vim.o.updatetime = 1000
--vim.api.nvim_create_autocmd("CursorHold", {
--    callback = function()
--        vim.diagnostic.open_float(nil, {
--            focus = false,
--        })
--    end,
--})


-- ==============
-- ===== OIL.NVIM
-- ==============
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
        ["gw"]    = { "actions.cd", mode = "n" },
        ["gt"]    = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"]    = { "actions.change_sort", mode = "n" },
        ["gx"]    = "actions.open_external",
        ["g."]    = { "actions.toggle_hidden", mode = "n" },
        ["g\\"]   = { "actions.toggle_trash", mode = "n" },
    },
    view_options = { show_hidden = true },
})

vim.keymap.set("n", "+", function()
    vim.cmd("tabe")
    require("oil").open()
end)
vim.keymap.set("n", "_", function()
    vim.cmd("vsp")
    require("oil").open()
end)
vim.keymap.set("n", "-", function()
    require("oil").open()
end)


-- ===================
-- ===== INDENT GUIDES
-- ===================
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
        char = "│",
        --char = "•",
    },
    -- whitespace = {
    --     highlight = highlight,
    --     remove_blankline_trail = false,
    -- },
    scope = { enabled = false },
})
-- for first-level spaces and tabs
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)


-- ---------------------------------
-- ----- SMART TAB COMPLETION PLUGIN
-- ---------------------------------
-- default scroll direction for completions
vim.g.SuperTabDefaultCompletionType = "<c-n>"



-- ===================
-- ===== MISCELLANEOUS
-- ===================
--vim.cmd.colorscheme("carbonfox")
require("statusline")
require("tabline")
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.termguicolors = true
-- hide '-- INSERT --'
vim.opt.showmode = false
-- TAB char looks like 4 spaces
vim.opt.tabstop = 4
-- number of spaces instead of TAB char
vim.opt.softtabstop = 4
-- number of spaces when indenting
vim.opt.shiftwidth = 4
-- pressing TAB key inserts spaces instead of TAB char
vim.opt.expandtab = true
-- block cursor in insert and every damn mode
vim.opt.guicursor = "n-v-i-c:block-Cursor"
vim.opt.signcolumn = "yes"

-- SMARTER QUIT
-- does not allow hiding a buffer when there are unsaved changes;
-- hids a buffer when it is abandoned if there are NO unsaved changes;
-- has one observed bug: when an alternate buffer is open (say with `+1 or
-- something), it still hides the current buffer even when there are unsaved
-- changes
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


-- =============
-- ===== KEYMAPS
-- =============
-- remap Y to yy because it is y$ by default in nvim
vim.keymap.set("n", "Y", "yy", { desc = "Yank whole line" })
vim.keymap.set("n", "<leader>cv", ":vnew | r !", { desc = "Execute a external command in a vertical split" })
vim.keymap.set("n", "<leader>ch", ":new | r !", { desc = "Execute a external command in a horizontal split" })
vim.keymap.set("n", "<leader>ct", ":tabe | r !", { desc = "Execute a external command in a tab" })
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Come back to Neovim from terminal" })


-- =======================
-- ===== NEOVIDE SPECIFICS
-- =======================
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


-- =========
-- ===== FZF
-- =========
vim.keymap.set("n", "<leader><Space>", ":FZF<CR>", { desc = "Open fzf" })
vim.g.fzf_action = {
    [ 'alt-enter' ] = 'tab split',
    [ 'ctrl-h' ] = 'split',
    [ 'ctrl-v' ] = 'vsplit'
}

-- ==============
-- ===== AUTOCMDS
-- ==============
-- from https://github.com/nvim-treesitter/nvim-treesitter/issues/8031
vim.api.nvim_create_autocmd('FileType', {
    callback = function(opts)
        local lang = vim.treesitter.language.get_lang(vim.bo[opts.buf].filetype)
        if vim.treesitter.language.add(lang) then
            vim.treesitter.start()
        end
    end,
})
