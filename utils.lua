local lfs = require("lfs")

local function match(tbl, expr)
    return tbl[expr]
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function split(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]*)") do
        table.insert(t, str)
    end
    return t
end


local function face_mode(base, face)
    local path = base..'/'..face
    if lfs.attributes(path) then
        return lfs.attributes(path).mode
    end
    return nil
end

local function is_dir(base, face)
    local mode = face_mode(base, face)
    return mode and mode == "directory"
end

local function is_file(base, face)
    local mode = face_mode(base, face)
    return mode and mode == "file"
end


return {
    starts_with = starts_with,
    match = match,
    split = split,
    is_dir = is_dir,
    is_file = is_file,
}
