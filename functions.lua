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
	if(type(n)=='list')then
		return #n>0
	end
end

function p(...)
	print(run(...))
end

function w(...)
	local t = {}
	for k,v in pairs({run(...)}) do
		t[#t+1] = tostring(v)
	end
	io.write(table.unpack(t))
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
		return b and b()
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

_G['%'] = function(A,b)
	local a = run(A)
	local b = b
	if not b then
		b = function()
			return ({A()})[2]
		end
	end
	if not a then return b() end
	if(type(a)=='number' or type(a)=='string')then
		a = tonumber(a)
		local l = list()
		for i=1, a do
			l[#l+1] = i
		end
		a = l
	end
	if(type(a)=='list')then
		local t = {}
		for i=1,#a do
			table.insert(inputs,1,a[i])
			for k,v in pairs({b()}) do
				t[#t+1] = v
			end
			table.remove(inputs,1)
		end
		return table.unpack(t)
	end
end

--[[
_G['$'] = function(condition, run, finally)
	local v = condition()
	while truthy(v) do
		if run then run() end
		v = condition and condition()
	end
	if finally then finally() end
end
--]]
function i(n)
	local i = 1
	if(n)then
		local v = n()
		if v then
			i = tonumber(v)
		end
	end
	return inputs[i]
end

_G['-'] = function(...)
	local t = {run(...)}
	local n = table.remove(t,1)
	if n then
		while(#t>0)do
			n = n - table.remove(t,1)
		end
	end
	return n
end

function n(n)
	local v = n()
	if(type(v)=='number')then
		return v
	else
		return #v
	end
end

function s(...)
	local t = {}
	for k,v in pairs({run(...)}) do
		t[#t+1] = list(tostring(v))
	end
	return table.unpack(t)
end

function g(...)
	local t = {run(...)}
	local val = t[1] or {}
	local i = t[2] or 1
	if(type(val)=='list')then
	if(#val > 0)then i = i % #val end
	if(i==0)then i = #val end
	return val[i]
	end
end

function e(l)
	local l = l()
	return table.unpack(l)
end