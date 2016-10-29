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
	grid[y][x].visited = true
	
	local dirs = aux.getUnvisited(grid, x, y)

	for k, v in pairs(dirs) do
		if v == "up" and y-1 >= 0 then 
			if grid[y-1][x].visited == false then 
				grid[y-1][x].bottom_wall = false
				mod.createMaze(grid, y-1, x)
			end
		end

		if v == "down" and y+1 < rows then 
			if grid[y+1][x].visited == false then 
				grid[y][x].bottom_wall = false
				mod.createMaze(grid, y+1, x)
			end
		end

		if v == "left" and x-1 >= 0 then 
			if grid[y][x-1].visited == false then 
				grid[y][x-1].right_wall = false
				mod.createMaze(grid, y, x-1)
			end
		end

		if v == "right" and x+1 < columns then 
			if grid[y][x+1].visited == false then 
				grid[y][x].right_wall = false
				mod.createMaze(grid, y, x+1)
			end
		end
	end
end

function mod.createMazeLoops(grid, x, y, x2, y2)
	if mod.width == 0 or mod.height == 0 then mod.width = x2 mod.height = y2 end

	local dirs = {}
	local stack = {}

	while true do
		grid[y][x].visited = true
		
		if #aux.getUnvisited(grid, x, y) ~= 0 then
			dirs = aux.getUnvisited(grid, x, y)
			if #aux.getUnvisited(grid, x, y) > 1 then 
				table.insert(stack, {x = x, y = y})
			end
		else
			if #stack ~= 0 then
				while #stack ~= 0 do 
					local value = table.remove(stack)
					x, y = value.x, value.y
					if #aux.getUnvisited(grid, x, y) ~= 0 then
						dirs = aux.getUnvisited(grid, x, y)
						break
					end
				end
			else
				break
			end
		end

		local dir = table.remove(dirs)

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

return mod
