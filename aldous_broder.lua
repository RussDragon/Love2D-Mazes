local mod = {}
local aux = {}

aux.dirs = {"UP", "DOWN", "LEFT", "RIGHT"}

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
	local ix = math.random(x1, x2)
	local iy = math.random(y1, y2)

	while unvisited_cells ~= 0 do
		local dir = aux.dirs[math.random(1, 4)]

		if dir == "UP" then -- UP
			if iy-1 >= y1 then
				if grid[iy-1][ix].visited == false then 
					grid[iy-1][ix].bottom_wall = false
					grid[iy-1][ix].visited = true 
					unvisited_cells = unvisited_cells - 1 
				end
				iy = iy-1
			end
		elseif dir == "DOWN" then -- DOWN 
			if iy+1 <= y2 then 
				if grid[iy+1][ix].visited == false then 
					grid[iy][ix].bottom_wall = false 
					grid[iy+1][ix].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				iy = iy+1
			end
		elseif dir == "RIGHT" then -- RIGHT
			if ix+1 <= x2 then
				if grid[iy][ix+1].visited == false then 
					grid[iy][ix].right_wall = false
					grid[iy][ix+1].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				ix = ix+1
			end
		elseif dir == "LEFT" then -- LEFT
			if ix-1 >= x1 then
				if grid[iy][ix-1].visited == false then
					grid[iy][ix-1].right_wall = false
					grid[iy][ix-1].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				ix = ix-1
			end
		end
	end
end

return mod
