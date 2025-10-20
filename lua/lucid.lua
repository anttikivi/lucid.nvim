local M = {}

---@class lucid.Config
M.defaults = {
    ---@type boolean
    transparent = false,
}

M.config = M.defaults

---@class lucid.Colors
---@field bg string
---@field fg string
---@field gray string
---@field red string
---@field green string
---@field yellow string
---@field blue string

M.colors = {
    ---@type lucid.Colors
    dark = {
        -- H: 252.8; S: 17.3; L: 7.4
        bg = "#14161b",
        -- H: 261.6; S: 54.5; L: 94.6
        fg = "#eeeff8",
        -- H: 192.2; S: 4.2; L: 68.6
        gray = "#a4a8a8",
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
    light = {},
}

---@param opts? lucid.Config
---@return lucid.Config
function M.extend(opts)
    return opts and vim.tbl_deep_extend("force", {}, M.config, opts) or M.config
end

---@param opts? lucid.Config
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

---@param opts? lucid.Config
function M.load(opts)
    opts = M.extend(opts)
    local bg = vim.o.background
end

return M
