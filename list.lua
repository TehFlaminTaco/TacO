
local __list = {__index = __list, __type = 'list'}

function list(t)
	if(type(t)=='string')then
		local T = {}
		for s in t:gmatch"."do 
			T[#T+1] = string.byte(s)
		end
		t=T
	end
	local l = setmetatable(t or {}, __list)
	return l
end


function __list.__tostring(l)
	local S = ""
	for i=1, #l do
		S = S .. string.char(l[i])
	end
	return S
end

function __list.__add(a, b)
	local o = list()
	if(type(a)~='list')then a = {a} end
	if(type(b)~='list')then b = {b} end
	for i=1, #a do
		o[#o+1] = a[i]
	end
	for i=1, #b do
		o[#o+1] = b[i]
	end
	return o
end

function __list.__call(t)
	t.__i = (t.__i or 0)+1
	if(t.__i > #t)then
		t.__i = 0
		return nil
	end
	return t.__i, t[t.__i]
end