local mod = {}
local aux = {}

mod.width = 0 
mod.height = 0

function mod.createGrid (rows, columns)
	local MazeGrid = {}
	local color = 0

	for y = 0, rows-1 do 
		MazeGrid[y] = {}
		for x = 0, columns-1 do
			MazeGrid[y][x] = {visited = false, bottom_wall = true, right_wall = true} -- Wall grid
		end
	end  
	return MazeGrid
end

function aux.shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function aux.getUnvisitedNeighbour(grid, x, y)
	if y-1 >= 0 and grid[y-1][x].visited == true and grid[y][x].visited == false then  -- UP
		return "up"
	end
	
	if y+1 < mod.height and grid[y+1][x].visited == true and grid[y][x].visited == false then -- DOWN
		return "down"
	end
	
	if x-1 >= 0 and grid[y][x-1].visited == true and grid[y][x].visited == false then -- LEFT
		return "left"
	end
	
	if x+1 < mod.width and grid[y][x+1].visited == true and grid[y][x].visited == false then -- RIGHT
		return "right"
	end
	return false
end

function aux.getUnvisited(grid, x, y)
	local dirs = {}
	if y-1 >= 0 and grid[y-1][x].visited == false then  -- UP
		dirs[#dirs + 1] = "up"
	end
	
	if y+1 < mod.height and grid[y+1][x].visited == false then -- DOWN
		dirs[#dirs + 1] = "down"
	end
	
	if x-1 >= 0 and grid[y][x-1].visited == false then -- LEFT
		dirs[#dirs + 1] = "left"
	end
	
	if x+1 < mod.width and grid[y][x+1].visited == false then -- RIGHT
		dirs[#dirs + 1] = "right"
	end

	aux.shuffleTable(dirs)
	return dirs
end

function mod.createMaze(grid, x, y, x2, y2)
	if mod.width == 0 or mod.height == 0 then mod.width = x2 mod.height = y2 end

	local dirs = {}

	while true do
		grid[y][x].visited = true
		
		if #aux.getUnvisited(grid, x, y) ~= 0 then
			dirs = aux.getUnvisited(grid, x, y)
		else
			local isFound = false
			for ky, vy in pairs(grid) do
				local f = 0
				for kx, vx in pairs(vy) do
					if aux.getUnvisitedNeighbour(grid, kx, ky) then
						local dir_ = aux.getUnvisitedNeighbour(grid, kx, ky)
						
						grid[ky][kx].visited = true
						x, y = kx, ky
							
							if dir_ == "up" then grid[ky-1][kx].bottom_wall = false
							elseif dir_ == "down" then grid[ky][kx].bottom_wall = false
							elseif dir_ == "right" then grid[ky][kx].right_wall = false
							elseif dir_ == "left" then grid[ky][kx-1].right_wall = false end

						dirs = aux.getUnvisited(grid, kx, ky) 
						
						f = 1
						isFound = true
						break
					end
				end
				if f == 1 then break end
			end
			if not isFound then break end
		end

		local dir = table.remove(dirs)
		-- print (dir)
		if dir then
			if dir == "up" and grid[y-1][x].visited == false then
				grid[y-1][x].bottom_wall = false
				y, x = y-1, x
			elseif dir == "down" and grid[y+1][x].visited == false then
				grid[y][x].bottom_wall = false
				y, x = y+1, x
			elseif dir == "left" and grid[y][x-1].visited == false then
				grid[y][x-1].right_wall = false
				y, x = y, x-1
			elseif dir == "right" and grid[y][x+1].visited == false then 
				grid[y][x].right_wall = false
				y, x = y, x+1
			end
		end
	end
end

return mod
