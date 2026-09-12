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
