local hsluv = require("hsluv")
local palette = require("lua.lucid").palette

local indent = 4

local function main()
    local output = {
        "-- This file is generated using generate-colors.lua. Do not edit manually.",
        "",
        "local M = {}",
        "",
        "M.colors = {",
        "    ---@type lucid.Colors",
        "    dark = {",
    }

    for k, v in pairs(palette.dark) do
        table.insert(output, ('%s%s = "%s",'):format((" "):rep(indent * 2), k, hsluv.hsluv_to_hex({ v.h, v.s, v.l })))
    end

    table.insert(output, "    },")
    table.insert(output, "    ---@type lucid.Colors")
    table.insert(output, "    light = {")

    for k, v in pairs(palette.light) do
        table.insert(output, ('%s%s = "%s",'):format((" "):rep(indent * 2), k, hsluv.hsluv_to_hex({ v.h, v.s, v.l })))
    end

    table.insert(output, "    },")
    table.insert(output, "}")
    table.insert(output, "")
    table.insert(output, "return M")

    local file_path = "lua/lucid/generated.lua"
    local check_file = io.open(file_path, "r")
    if check_file ~= nil then
        check_file:close()
        os.remove(file_path)
    end

    local file = io.open(file_path, "w")
    if file == nil then
        error("Failed to open the color output file")
    end

    file:write(table.concat(output, "\n"))
    file:close()
end

main()
