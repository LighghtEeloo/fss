local fs = require("pl.path")

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


local function is_dir(base, face)
    return fs.isdir(fs.join(base, face))
end


return {
    starts_with = starts_with,
    match = match,
    split = split,
    is_dir = is_dir,
}
