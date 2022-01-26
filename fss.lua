local lfs = require("lfs")
local rc = require("rc")
local utils = require("utils")

local noticeable = rc.noticeable
local expandable = rc.expandable
local depth_limit = rc.depth_limit

local starts_with = utils.starts_with
local split = utils.split

HOME = "/home/lighght"

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

function Pattern:match_memo(memo)
    local res = {}
    for _, path in ipairs(memo) do
        if self:match(path) then
            table.insert(res, path)
        end
    end
    return res
end


-- pattern search under path
local function search(pat, base, depth)
    depth = depth or 1
    local memo = {}
    local res = {}
    if depth_limit(depth) then return res end
    for face in lfs.dir(base) do
        if noticeable(base, face) then
            local path = base..'/'..face
            if pat:match(path) then
                table.insert(res, path)
            elseif expandable(base, face) then
                table.insert(memo, path)
            end
        end
    end
    for _, path in ipairs(memo) do
        local memo_ = search(pat, path, depth + 1)
        for _, path_ in ipairs(memo_) do
            table.insert(res, path_)
        end
    end
    return res
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
    local pats = {}
    for _, p in ipairs(split(arg[1], ",")) do
        local pat = Pattern:new(p)
        table.insert(pats, pat)
    end
    if #arg < 2 then
        arg[2] = "."
    end
    local res = {}
    for _, pat in ipairs(pats) do
        for i=2,#arg do
            local path = arg[i]
            if not starts_with(arg[i], '/') then
                path = lfs.currentdir()..'/'..path
            end
            local res_ = search(pat, path)
            for _, path_ in ipairs(res_) do
                table.insert(res, path_)
            end
        end
    end
    for _, r in ipairs(res) do
        print(r)
    end
end

-- run main
os.exit(main())
