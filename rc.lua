local function is_white(face)
    return face:find("Lib")
end

local function is_black(face)
    return face:find("DualEeloo")
end

return {
    is_white = is_white,
    is_black = is_black,
}