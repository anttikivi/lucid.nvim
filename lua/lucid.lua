local M = {}

---@class lucid.Config
M.defaults = {
    ---@type boolean
    transparent = false,
}

M.config = M.defaults

---@class lucid.Colors
---@field bg string
---@field bg_light string
---@field bg_hint string
---@field fg string
---@field fg_light string
---@field gray string
---@field light_gray string
---@field red string
---@field green string
---@field yellow string
---@field blue string

M.colors = {
    ---@type lucid.Colors
    dark = {
        -- H: 252.8; S: 17.3; L: 7.2
        bg = "#14161b",
        -- H: 252.8; S: 17.3; L: 14.6
        bg_light = "#22252c",
        -- H: 254.8; S: 16.1; L: 20.4
        bg_hint = "#2e313a",
        -- H: 261.6; S: 54.5; L: 94.6
        fg = "#eeeff8",
        -- H: 261.6; S: 54.5; L: 81.2
        fg_light = "#c4c8e7",
        -- H: 192.2; S: 4.2; L: 68.6
        gray = "#a4a8a8",
        -- H: 192.2; S: 5.1; L: 42.1
        light_gray = "#616464",
        -- H: 11.4; S: 58.4; L: 67
        red = "#e08c8e",
        -- H: 134.9; S: 50.5; L: 67
        green = "#72b180",
        -- H: 55.0; S: 58.9; L: 70.1
        yellow = "#cca56d",
        -- H: 237.6; S: 59.2; L: 69.9
        blue = "#77b1dd",
    },
    ---@type lucid.Colors
    light = {
        -- H: 0; S: 0; L: 98.6
        bg = "#fbfbfb",
        -- H: 0; S: 0; L: 94
        bg_light = "#eeeeee",
        -- H: 0; S: 0; L: 83.6
        bg_hint = "#d8d8d8",
        -- H: 252.8; S: 17.3; L: 7.2
        fg = "#14161b",
        -- H: 252.8; S: 17.3; L: 15.0
        fg_light = "#23262d",
        -- H: 192.2; S: 3.2; L: 45.1
        gray = "#6b6b6b",
        -- H: 0.0; S: 0.0; L: 71.1
        light_gray = "#aeaeae",
        -- H: 11.4; S: 58.4; L: 40
        red = "#a33b3f",
        -- H: 134.9; S: 50.5; L: 40
        green = "#406749",
        -- H: 56.0; S: 58.8; L: 46.6
        yellow = "#846b45",
        -- H: 237.8; S: 59.2; L: 40
        blue = "#40627c",
    },
}

local did_setup = false

---@param opts? lucid.Config
---@return lucid.Config
function M.extend(opts)
    return opts and vim.tbl_deep_extend("force", {}, M.config, opts) or M.config
end

---@param opts? lucid.Config
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
    did_setup = true
end

---@param opts? lucid.Config
function M.load(opts)
    if not did_setup then
        M.setup()
        did_setup = true
    end

    opts = M.extend(opts)
    local colors = M.colors[vim.o.background]
    local groups = M.groups(colors, opts)

    -- Clear highlights when using another color scheme.
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end

    vim.g.colors_name = "lucid"

    for group, hl in pairs(groups) do
        hl = type(hl) == "string" and { link = hl } or hl --[[@as vim.api.keyset.highlight]]
        vim.api.nvim_set_hl(0, group, hl)
    end
end

---@param c lucid.Colors
---@param opts lucid.Config
---@return table<string, vim.api.keyset.highlight | string>
function M.groups(c, opts)
    local none = "NONE"

    -- Default highlight groups:
    -- https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c

    ---@type table<string, vim.api.keyset.highlight | string>
    return {
        Normal = { fg = c.fg, bg = opts.transparent and none or c.bg },

        -- UI
        Cursor = { fg = c.bg, bg = c.fg },
        CursorLineNr = { bold = true },
        PmenuMatch = { bold = true },
        PmenuMatchSel = { bold = true },
        PmenuSel = { reverse = true },
        RedrawDebugNormal = { reverse = true },
        TabLineSel = { bold = true },
        TermCursor = { reverse = true },
        Underlined = { underline = true },
        lCursor = { fg = c.bg, bg = c.fg },

        Added = { fg = c.green },
        Changed = { fg = c.blue },
        ColorColumn = { bg = c.bg_light },
        Conceal = { fg = c.bg_light },
        CurSearch = { fg = c.bg, bg = c.yellow },
        CursorColumn = { bg = c.bg_light },
        CursorLine = { bg = c.bg_light },
        DiffAdd = { fg = c.fg_light, bg = c.green },
        DiffChange = { fg = c.fg_light, bg = c.blue },
        DiffDelete = { fg = c.red },
        DiffText = { fg = c.fg_light, bg = c.blue },
        Directory = { fg = c.fg },
        ErrorMsg = { fg = c.red },
        FloatShadow = { bg = c.bg_light, blend = 80 },
        FloatShadowThrough = { bg = c.bg_light, blend = 100 },
        Folded = { fg = c.fg_light, bg = c.bg_light },
        LineNr = { fg = c.gray },
        MatchParen = { bg = c.bg_light, bold = true },
        ModeMsg = { fg = c.green },
        MoreMsg = { fg = c.blue },
        NonText = { fg = c.fg_light },
        NormalFloat = { bg = c.bg_light },
        OkMsg = { fg = c.green },
        Pmenu = { bg = c.bg_light },
        PmenuThumb = { bg = c.gray },
        Question = { bg = c.blue },
        QuickFixLine = { bg = c.blue },
        RedrawDebugClear = { bg = c.yellow },
        RedrawDebugComposed = { bg = c.green },
        RedrawDebugRecompose = { bg = c.red },
        Removed = { fg = c.red },
        Search = { fg = c.bg, bg = c.yellow },
        SignColumn = { fg = c.gray, bg = opts.transparent and none or c.bg },
        SpecialKey = { fg = c.gray },
        SpellBad = { sp = c.red, undercurl = true },
        SpellCap = { sp = c.yellow, undercurl = true },
        SpellLocal = { sp = c.green, undercurl = true },
        SpellRare = { sp = c.blue, undercurl = true },
        StatusLine = { bg = c.bg_light },
        StatusLineNC = { bg = c.bg, italic = true },
        Title = { fg = c.gray, bold = true },
        Visual = { bg = c.bg_light },
        WarningMsg = { fg = c.yellow },
        WinBar = { bold = true },
        WinBarNC = { italic = true },

        CursorIM = "Cursor",
        CursorLineFold = "FoldColumn",
        CursorLineSign = "SignColumn",
        DiffTextAdd = "DiffText",
        EndOfBuffer = "NonText",
        FloatBorder = "NormalFloat",
        FloatFooter = "FloatTitle",
        FloatTitle = "Title",
        FoldColumn = "SignColumn",
        IncSearch = "CurSearch",
        LineNrAbove = "LineNr",
        LineNrBelow = "LineNr",
        MsgSeparator = "StatusLine",
        MsgArea = none,
        NormalNC = none,
        PmenuExtra = "Pmenu",
        PmenuExtraSel = "PmenuSel",
        PmenuKind = "Pmenu",
        PmenuKindSel = "PmenuSel",
        PmenuSbar = "Pmenu",
        PmenuBorder = "Pmenu",
        PmenuShadow = "FloatShadow",
        PmenuShadowThrough = "FloatShadowThrough",
        PreInsert = "Added",
        ComplMatchIns = none,
        ComplHint = "NonText",
        ComplHintMore = "MoreMsg",
        Substitute = "Search",
        StatusLineTerm = "StatusLine",
        StatusLineTermNC = "StatusLineNC",
        StderrMsg = "ErrorMsg",
        StdoutMsg = none,
        TabLine = "StatusLineNC",
        TabLineFill = "TabLine",
        VertSplit = "WinSeparator",
        VisualNOS = "Visual",
        Whitespace = "NonText",
        WildMenu = "PmenuSel",
        WinSeparator = "Normal",

        -- Syntax
        Constant = { fg = c.blue },
        Operator = { fg = c.fg_light },
        PreProc = { fg = c.fg_light },
        Type = { fg = c.blue },
        Delimiter = { fg = c.gray },

        Comment = { fg = c.gray, italic = true },
        String = { fg = c.green },
        Identifier = { fg = c.fg },
        Function = { fg = c.fg },
        Statement = { fg = c.fg },
        Special = { fg = c.gray },
        Error = { fg = c.gray, bg = c.red },
        Todo = { fg = c.gray, bold = true },

        -- Diagnostic
        DiagnosticError = { fg = c.red },
        DiagnosticWarn = { fg = c.yellow },
        DiagnosticInfo = { fg = c.blue },
        DiagnosticHint = { fg = c.blue },
        DiagnosticOk = { fg = c.green },
        DiagnosticUnderlineError = { sp = c.red, undercurl = true },
        DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
        DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
        DiagnosticUnderlineHint = { sp = c.blue, undercurl = true },
        DiagnosticUnderlineOk = { sp = c.green, undercurl = true },
        DiagnosticDeprecated = { fg = c.gray, strikethrough = true },

        -- Treesitter standard groups
        ["@variable"] = { fg = c.fg },
    }
end

return M
