local mod = {}
local aux = {}

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

function mod.createMaze(grid, x1, y1, x2, y2)
	local unvisited_cells = (x2+1) * (y2+1)
	local rx = math.random(x1, x2)
	local ry = math.random(y1, y2)

	while unvisited_cells ~= 0 do 
		local dir = math.random(0, 3)

		if dir == 0 then -- UP
			if ry-1 >= y1 then
				if grid[ry-1][rx].visited == false then 
					grid[ry-1][rx].bottom_wall = false
					grid[ry-1][rx].visited = true 
					unvisited_cells = unvisited_cells - 1 
				end
				ry = ry-1
			end
		elseif dir == 1 then -- DOWN 
			if ry+1 <= y2 then 
				if grid[ry+1][rx].visited == false then 
					grid[ry][rx].bottom_wall = false 
					grid[ry+1][rx].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				ry = ry+1
			end
		elseif dir == 2 then -- RIGHT
			if rx+1 <= x2 then
				if grid[ry][rx+1].visited == false then 
					grid[ry][rx].right_wall = false
					grid[ry][rx+1].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				rx = rx+1
			end
		elseif dir == 3 then -- LEFT
			if rx-1 >= x1 then
				if grid[ry][rx-1].visited == false then
					unvisited_cells = unvisited_cells - 1 
				end
				rx = rx-1
			end
		end
	end
end

return mod
