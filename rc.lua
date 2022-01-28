local fs = require("pl.path")
local strx = require("pl.stringx")

local function depth_limit(depth)
    return depth > 5
end

local function is_unimportant(face)
    return strx.startswith(face, '.')
        or strx.startswith(face, '_')
end

local function is_important(face)
    return not is_unimportant(face)
end

local function is_capitalized(face)
    local c = face:sub(1, 1)
    return c >= 'A' and c <= 'Z'
end


local function noticeable(base, face)
    return  fs.isdir(fs.join(base, face))
        and is_important(face)
end

local function expandable(base, face)
    return is_capitalized(face)
end


return {
    noticeable = noticeable,
    expandable = expandable,
    depth_limit = depth_limit,
}