local utils = require("utils")

local starts_with = utils.starts_with
local is_dir = utils.is_dir

local function is_white(face)
    return face:find("Lib")
end

local function is_black(face)
    return face:find("DualEeloo")
end


local function depth_limit(depth)
    return depth > 5
end

local function is_unimportant(face)
    return starts_with(face, '.')
        or starts_with(face, '_')
end

local function is_important(face)
    return not is_unimportant(face)
end

local function is_capitalized(face)
    local c = face:sub(1, 1)
    return c >= 'A' and c <= 'Z'
end

local function is_concise(face)
    return #face < 16
end


local function noticeable(base, face)
    return  is_dir(base, face)
        and is_important(face)
        and (is_concise(face) or is_white(face))
        and not is_black(face)
end

local function expandable(base, face)
    return is_capitalized(face)
end


return {
    noticeable = noticeable,
    expandable = expandable,
    depth_limit = depth_limit,
}