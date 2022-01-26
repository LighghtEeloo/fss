local lfs = require("lfs")
local rc = require("rc")
local utils = require("utils")

local noticeable = rc.noticeable
local expandable = rc.expandable
local depth_limit = rc.depth_limit

local starts_with = utils.starts_with
local split = utils.split

HOME = "/home/lighght"
VERBOSE = false

Pattern = {}

function Pattern:new(cons)
    local pat = split(cons, ".")
    setmetatable(pat, self)
    self.__index = self
    return pat
end

function Pattern:match(path)
    local len
    for _, p in ipairs(self) do
        _, len = path:find(p)
        if len then
            path = path:sub(len+1, #path)
        else
            return false
        end
    end
    return true
end


-- pattern search under path
local function search(pat, base, depth)
    depth = depth or 1
    if depth_limit(depth) then return end
    if VERBOSE then io.stdout:write(">>>>>> "..base.."\n") end
    local memo = {}
    for face in lfs.dir(base) do
        if noticeable(base, face) then
            print(face)
            if expandable(base, face) then
                table.insert(memo, base..'/'..face)
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
    local pats = split(arg[1], ",")
    if #arg < 2 then
        arg[2] = "."
    end
    for i=2,#arg do
        local path = arg[i]
        if not starts_with(arg[i], '/') then
            path = lfs.currentdir()..'/'..path
        end
        search(pats, path)
    end
    for _, p in ipairs(pats) do
        io.stdout:write("\""..p.."\"\n")
    end
    -- for i, p in ipairs(pats) do
    --     Pattern:new(p)
    --     local pat = Pattern:new(p)
    --     print(pat:match("Xpace/EECS-390"))
    -- end
end

-- run main
os.exit(main())
