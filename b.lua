local lfs = require("lfs")

HOME = "/home/lighght"
VERBOSE = false

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function split(inputstr, sep)
    sep = sep or ","
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]*)") do
        table.insert(t, str)
    end
    return t
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

local function is_white(face)
    return face:find("Lib")
end

local function is_black(face)
    return face:find("DualEeloo")
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

-- local function is_file(base, face)
--     local mode = face_mode(base, face)
--     return mode and mode == "file"
-- end


-- pattern search under path
local function search(pat, path, depth)
    depth = depth or 1
    if depth > 4 then return end
    if VERBOSE then io.stdout:write(">>>>>> "..path.."\n") end
    local memo = {}
    for face in lfs.dir(path) do
        if is_dir(path, face)
        and is_important(face)
        and (is_concise(face) or is_white(face))
        and not is_black(face) then
            print(face)
            if is_capitalized(face) then
                table.insert(memo, path..'/'..face)
            end
        end
    end
    if VERBOSE then io.stdout:write("<<<<<<\n") end
    for _, path in ipairs(memo) do
        search(pat, path, depth + 1)
    end
end


-- main
local function main()
    if #arg < 1 then
        io.stderr:write("usage:\t", arg[0], " <PATTERN> <PATH>{ <PATH>}\n")
        io.stderr:write("where:\t<PATTERN> ::= <cstr>{,<cstr>}\n")
        io.stderr:write("      \t<PATH>    ::= / | /<name>{/<name>} | <name>{/<name>}\n")
        io.stderr:write("      \t<cstr>    ::= <consecutive str>\n")
        io.stderr:write("      \t<name>    ::= <file name>\n")
        return 1
    end
    local pat = split(arg[1])
    if #arg < 2 then
        arg[2] = "."
    end
    for i=2,#arg do
        local path = arg[i]
        if not starts_with(arg[i], '/') then
            path = lfs.currentdir()..'/'..path
        end
        search(pat, path)
    end
    for _, p in ipairs(pat) do
        io.stdout:write("\""..p.."\"\n")
    end
end

-- run main
os.exit(main())
