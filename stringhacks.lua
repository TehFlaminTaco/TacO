local str = getmetatable("")

function str.__index(a,k)
	return string[k] or str[k]
end

function str.get(s,x,y)
	if(type(x)=="string")then
		return str._find(s,x)
	end
	if y> (({s:gsub("\n","")})[2]+1) then
		return " "
	end
	if y <= 0 then
		return " "
	end
	if x <= 0 then
		return " "
	end
	return s:match(("[^\n]-\n"):rep(y-1).."([^\n]*)"):sub(x,x) or " "
end

function str.set(s, x, y, S)
	local t = {}
	for S in s:gmatch("[^\n]*") do
		t[#t+1] = S
	end
	if y < 1 then
	elseif y > #t then
		t[y] = (" "):rep(x-1)..S
	elseif x>#t[y] then
		t[y] = t[y] .. (" "):rep((x-1) - #t[y]) .. S
	else
		t[y] = t[y]:sub(0,x-1)..S..t[y]:sub(x+1)
	end
	return table.concat(t,"\n")
end

function str._find(s,S)
	local i = s:find(S:gsub("%A",function(s)return "%"..s end))
	local y = ({s:sub(0,i):gsub("\n","")})[2]+1
	local x = i-#s:match(("[^\n]-\n"):rep(y-1))
	return x, y
end