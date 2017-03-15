local function run(...)
	local t={}
	for k,v in pairs({...}) do
		for k2, v2 in pairs({v()}) do
			t[#t+1] = v2
		end
	end
	return table.unpack(t)
end

local function wrap(...)
	local t = {...}
	return function() return table.unpack(t) end
end

local function truthy(n)
	if(type(n)=='number')then
		return n~=0
	end
	if(type(n)=='string')then
		return #n>0
	end
	if(type(n)=='table')then
		return #n>0
	end
end

function p(...)
	print(s(...))
end

for i=0, 9 do
	_G[i..''] = function(...)
		local s = i
		for k, v in pairs({run(...)}) do
			s = s .. v
		end
		return s
	end
end

_G['+'] = function(...)
	local n = nil
	for k,v in pairs({run(...)}) do
		if n then
			n = n + v
		else
			n = v
		end
	end
	return n
end

function l(...)
	return list({run(...)})
end

_G["*"] = function(A,b)
	local a = run(A)
	local b = b
	if not b then
		b = function()
			return ({A()})[2]
		end
	end
	if not a then return b() end
	local t = {}
	for i=1, a do
		for k,v in pairs({b()}) do
			t[#t+1] = v
		end
	end
	return table.unpack(t)
end

_G["?"] = function(a,b,c)
	local A = run(a)
	if(truthy(A)) then
		return b()
	else
		return c and c()
	end
end


function j(...)
	local vals = {run(...)}
	if(vals[1]) then
		local c = table.remove(vals, 1)
		local t
		for i=1, #vals do
			if t then
				t = t + c + vals[i]
			else
				t = vals[i]
			end
		end
		return list(t)
	end
end