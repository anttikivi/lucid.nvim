local M = {}

---@class lucid.Config
M.defaults = {
    ---@type boolean
    transparent = false,
}

M.config = M.defaults
M.colors = require("lucid.colors")

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
        ModeMsg = { fg = c.gray },
        MoreMsg = { fg = c.blue },
        NonText = { fg = c.bg_hint }, -- { fg = c.gray, bg = c.bg_light },
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
        Visual = { bg = c.light_gray },
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

        Character = "String",
        Number = "Constant",
        Boolean = "Constant",
        Float = "Number",
        Conditional = "Statement",
        Repeat = "Statement",
        Label = "Statement",
        Keyword = { fg = c.blue },
        Exception = "Statement",
        Include = "PreProc",
        Define = "PreProc",
        Macro = "PreProc",
        PreCondit = "PreProc",
        StorageClass = "Type",
        Structure = "Type",
        Typedef = "Type",
        Tag = "Special",
        SpecialChar = "Special",
        SpecialComment = "Special",
        Debug = "Special",
        Ignore = "Normal",

        -- Built-in LSP
        LspCodeLens = "NonText",
        LspCodeLensSeparator = "LspCodeLens",
        LspInlayHint = { fg = c.gray, bg = c.bg_light }, -- "NonText",
        LspReferenceRead = "LspReferenceText",
        LspReferenceText = "Visual",
        LspReferenceWrite = "LspReferenceText",
        LspReferenceTarget = "LspReferenceText",
        LspSignatureActiveParameter = "Visual",
        SnippetTabstop = "Visual",
        SnippetTabstopActive = "SnippetTabstop",

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

        DiagnosticFloatingError = "DiagnosticError",
        DiagnosticFloatingWarn = "DiagnosticWarn",
        DiagnosticFloatingInfo = "DiagnosticInfo",
        DiagnosticFloatingHint = "DiagnosticHint",
        DiagnosticFloatingOk = "DiagnosticOk",
        DiagnosticVirtualTextError = "DiagnosticError",
        DiagnosticVirtualTextWarn = "DiagnosticWarn",
        DiagnosticVirtualTextInfo = "DiagnosticInfo",
        DiagnosticVirtualTextHint = "DiagnosticHint",
        DiagnosticVirtualTextOk = "DiagnosticOk",
        DiagnosticVirtualLinesError = "DiagnosticError",
        DiagnosticVirtualLinesWarn = "DiagnosticWarn",
        DiagnosticVirtualLinesInfo = "DiagnosticInfo",
        DiagnosticVirtualLinesHint = "DiagnosticHint",
        DiagnosticVirtualLinesOk = "DiagnosticOk",
        DiagnosticSignError = "DiagnosticError",
        DiagnosticSignWarn = "DiagnosticWarn",
        DiagnosticSignInfo = "DiagnosticInfo",
        DiagnosticSignHint = "DiagnosticHint",
        DiagnosticSignOk = "DiagnosticOk",
        DiagnosticUnnecessary = "Comment",

        -- Treesitter standard groups
        ["@variable"] = { fg = c.fg },

        ["@variable.builtin"] = "Special",
        ["@variable.parameter.builtin"] = "Special",

        ["@constant"] = "Constant",
        ["@constant.builtin"] = "Special",

        ["@module"] = "Structure",
        ["@module.builtin"] = "Special",
        ["@label"] = "Label",

        ["@string"] = "String",
        ["@string.regexp"] = "@string.special",
        ["@string.escape"] = "@string.special",
        ["@string.special"] = "SpecialChar",
        ["@string.special.url"] = "Underlined",

        ["@character"] = "Character",
        ["@character.special"] = "SpecialChar",

        ["@boolean"] = "Boolean",
        ["@number"] = "Number",
        ["@number.float"] = "Float",

        ["@type"] = "Type",
        ["@type.builtin"] = "Special",

        ["@attribute"] = "Macro",
        ["@attribute.builtin"] = "Special",
        ["@property"] = "Identifier",

        ["@function"] = "Function",
        ["@function.builtin"] = "Special",

        ["@constructor"] = "Special",
        ["@operator"] = "Operator",

        ["@keyword"] = "Keyword",

        ["@punctuation"] = "Delimiter",
        ["@punctuation.special"] = "Special",

        ["@comment"] = "Comment",

        ["@comment.error"] = "DiagnosticError",
        ["@comment.warning"] = "DiagnosticWarn",
        ["@comment.note"] = "DiagnosticInfo",
        ["@comment.todo"] = "Todo",

        ["@markup.strong"] = { bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.underline"] = { underline = true },

        ["@markup"] = "Special",
        ["@markup.heading"] = "Title",
        ["@markup.link"] = "Underlined",

        ["@diff.plus"] = "Added",
        ["@diff.minus"] = "Removed",
        ["@diff.delta"] = "Changed",

        ["@tag"] = "Tag",
        ["@tag.builtin"] = "Special",

        -- "default @markup.heading.1.delimiter.vimdoc guibg=bg guifg=bg guisp=fg gui=underdouble,nocombine ctermbg=NONE ctermfg=NONE cterm=underdouble,nocombine",
        -- "default @markup.heading.2.delimiter.vimdoc guibg=bg guifg=bg guisp=fg gui=underline,nocombine ctermbg=NONE ctermfg=NONE cterm=underline,nocombine",

        -- LSP semantic tokens
        ["@lsp.type.class"] = "@type",
        ["@lsp.type.comment"] = "@comment",
        ["@lsp.type.decorator"] = "@attribute",
        ["@lsp.type.enum"] = "@type",
        ["@lsp.type.enumMember"] = "@constant",
        ["@lsp.type.event"] = "@type",
        ["@lsp.type.function"] = "@function",
        ["@lsp.type.interface"] = "@type",
        ["@lsp.type.keyword"] = "@keyword",
        ["@lsp.type.macro"] = "@constant.macro",
        ["@lsp.type.method"] = "@function.method",
        ["@lsp.type.modifier"] = "@type.qualifier",
        ["@lsp.type.namespace"] = "@module",
        ["@lsp.type.number"] = "@number",
        ["@lsp.type.operator"] = "@operator",
        ["@lsp.type.parameter"] = "@variable.parameter",
        ["@lsp.type.property"] = "@property",
        ["@lsp.type.regexp"] = "@string.regexp",
        ["@lsp.type.string"] = "@string",
        ["@lsp.type.struct"] = "@type",
        ["@lsp.type.type"] = "@type",
        ["@lsp.type.typeParameter"] = "@type.definition",
        ["@lsp.type.variable"] = "@variable",

        ["@lsp.mod.deprecated"] = "DiagnosticDeprecated",
    }
end

return M
