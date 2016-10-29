local mod = {}
local aux = {}

mod.width = 0
mod.height = 0

function aux.shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function aux.possibleDirs(grid, x, y)
	local dirs = {}
	if y-1 >= 0 and grid[y-1][x].checked == nil and grid[y-1][x].bottom_wall == false then  -- UP
		dirs[#dirs + 1] = "up"
	end

	if y+1 < mod.height and grid[y+1][x].checked == nil and grid[y][x].bottom_wall == false then -- DOWN
			dirs[#dirs + 1] = "down" 
	end
	
	if x-1 >= 0 and grid[y][x-1].checked == nil and grid[y][x-1].right_wall == false then -- LEFT
		dirs[#dirs + 1] = "left"
	end
	
	if x+1 < mod.width and grid[y][x+1].checked == nil and grid[y][x].right_wall == false then -- RIGHT
			dirs[#dirs + 1] = "right" 
	end
	aux.shuffleTable(dirs)
	return dirs
end

function mod.findExit(grid, x, y, tx, ty, width, height) 
	if mod.width == 0 or mod.height == 0 then mod.width = width mod.height = height end
	if tx > width or ty > height then return end
	if tx == x and ty == y then return {x = x, y = y} end

	local dirs = {}
	local path = {}

	while true do
		table.insert(path, {x = x, y = y})
		grid[y][x].checked = true

		if x == tx and y == ty then 
			break
		end

		if #aux.possibleDirs(grid, x, y) ~= 0 then
			dirs = aux.possibleDirs(grid, x, y)
		else 
			if #path ~= 0 then
				while true do
					local value = table.remove(path)
					x, y = value.x, value.y
					if #aux.possibleDirs(grid, x, y) >= 1 then
						table.insert(path, {x = x, y = y})
						dirs = aux.possibleDirs(grid, x, y)
						break
					end
				end
			else
				break
			end
		end

		local dir = table.remove(dirs)

		if dir == "up" and grid[y-1][x].checked == nil then
			y, x = y-1, x
		elseif dir == "down" and grid[y+1][x].checked == nil then
			y, x = y+1, x
		elseif dir == "left" and grid[y][x-1].checked == nil then
			y, x = y, x-1
		elseif dir == "right" and grid[y][x+1].checked == nil then 
			y, x = y, x+1
		end
		-- table.insert(path, {x = x, y = y})
	end
	return path
end

return mod
