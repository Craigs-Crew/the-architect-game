-- swap nodes
function ccore.swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

-- int to time string
function ccore.get_time(int)
	if not tonumber(int) then
		return nil
	end
	if int > 59 then
		if int > 3600 then
			local ihr = math.floor(int / 3600)
			local imin = math.floor((int % 3600) / 60)
			local isec = int % 60
			if isec > 0 then
				return ihr.." hr "..imin.." min "..isec.." sec"
			else
				if imin > 0 then
					return ihr.." hr "..imin.." min"
				else
					return ihr.. "hr"
				end
			end
		else -- minutes and seconds
			local imin = math.floor(int / 60)
			local isec = int % 60
			if isec > 0 then
				return imin.." min "..isec.." sec"
			else
				return imin.." min"
			end
		end
	else -- seconds only
		return int.." sec"
	end
end