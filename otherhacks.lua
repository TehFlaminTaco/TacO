local num = {}
debug.setmetatable(0, num)

local t = type
function type(a)
	local Type = t(a)
	if(Type=='table' and getmetatable(a) and getmetatable(a).__type) then
		return getmetatable(a).__type
	end
	return Type
end