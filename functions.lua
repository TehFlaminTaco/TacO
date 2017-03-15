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
	local n = 0
	for k,v in pairs({run(...)}) do
		n = n + v
	end
	return n
end

function l(...)
	return {run(...)}
end

function s(...)
	local t = {}
	for k,v in pairs({run(...)}) do
		if(type(v)=='table')then
			local S = "{"
			for i=1, #v do
				S = S .. s(wrap(v[i]))
				if(i~=#v) then
					S = S .. ", "
				end
			end
			t[#t+1] = S.."}"
		else
			t[#t+1] = tostring(v)
		end
	end
	return table.unpack(t)
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