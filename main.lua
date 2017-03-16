local r = require
local path = ""
function require(s)
	if not arg[0] then
		return r(s)
	end
	local p = arg[0]:match("(.*[\\/])") or ""
	path = p
	local b, e = loadfile(p..s:gsub("%.","\\")..".lua")
	if(not b) then
		error(e)
	end
	return b()
end
require "otherhacks"
require "stringhacks"
require "list"
local loadstring = load

inputs = {}
for i=2, #arg do
	if(tonumber(arg[i]))then
		inputs[#inputs+1] = tonumber(arg[i])
	else
		inputs[#inputs+1] = list(arg[i])
	end
end

-- Load the script.
function load()
	local fn = arg[1] or (path.."code.tac")
	local f = assert(io.open(fn,"r"), string.format("Could not open file %s!", fn))
	local s = f:read("*a"):gsub("[^\n]+",function(s)
			local o = ""
			local x = 1
			for i=1, #s do
				if s:sub(i,i)=="\t" then
					local n = math.ceil(x/5)*5
					o = o .. (" "):rep(n-x)
					x = n + 1
				else
					o = o .. s:sub(i,i)
					x = x + 1
				end
			end
			return o
		end)
	return s
end

-- Load the functions table.
functions = setmetatable({},{__index = _G}) do
	local f,r = loadfile(path.."functions.lua")
	if(not f) then error(r) end
	debug.setupvalue(f,1,functions) -- 1 is the default for _ENV for loadfile
	f()
end

local function escape(s)
	local b, e = loadstring('return "'..s..'"')
	if b then
		return b()
	else
		return s
	end
end


function compile(s,p,d)
	assert(({s:gsub("@","")})[2]==1, "Incorrect amount of @ detected.")

	local x, y = s:get"@"
	local a = {}
	local adj = {{-1,0},{0,-1},{1,0},{0,1}}
	local adj_b = {['<']={-1,0},['^']={0,-1},['>']={1,0},v={0,1}}
	if p and adj_b[p] then
		adj = {adj_b[p]}
	end

	if p == "\"" then
		local pth = s
		local str = ""
		while true do
			pth = pth:set(x,y," ")
			x = x + d[1]
			y = y + d[2]
			local S = s:get(x,y)
			if S == "\\" then
				pth = pth:set(x,y," ")
				x = x + d[1]
				y = y + d[2]
				str = str .. '\\' .. s:get(x,y)
			elseif S == "\"" then
				pth = pth:set(x,y," ")
				x = x + d[1]
				y = y + d[2]
				pth = pth:set(x,y,"@")
				local f
				if(s:get(x,y):match("%S"))then
					f = compile(pth, s:get(x,y), d)
				else
					f = function() end
				end
				str = escape(str)
				return function(...)
					local t = {list(str)}
					for k,v in pairs({f(...)}) do
						t[#t+1] = v
					end
					return table.unpack(t)
				end
			else
				str = str .. S
			end
		end
	end

	for k,v in pairs(adj) do
		local S = s:get(v[1]+x,v[2]+y)
		if(S:match("%S"))then
			--print(s:set(x,y," "):set(x+v[1],y+v[2],"@"))
			--print(s:set(x,y," "):set(x+v[1],y+v[2],"@"), S)
			for k,v in pairs({compile(s:set(x,y," "):set(x+v[1],y+v[2],"@"), S, v)}) do
				a[#a+1] = v
			end
		end
	end
	return function()
		if(p and functions[p])then
			return functions[p](table.unpack(a))
		else
			local t = {}
			for k,v in pairs(a) do
				for k2, v2 in pairs({v()}) do
					t[#t+1] = v2
				end
			end
			return table.unpack(t)
		end
	end
end

print(compile(load())())