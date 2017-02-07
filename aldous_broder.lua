local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
-- aux.changes = {}

aux.dirs = {"UP", "DOWN", "LEFT", "RIGHT"}

function aux.createGrid (rows, columns)
	local MazeGrid = {}

	for y = 1, rows do 
		MazeGrid[y] = {}
		for x = 1, columns do
			MazeGrid[y][x] = {visited = false, bottom_wall = true, right_wall = true} --, point = false} -- Wall grid
		end
	end  
	return MazeGrid
end

-- local function saveGridState()
-- 	local temp = {}
-- 	for yk, yv in pairs(aux.grid) do
-- 		temp[yk] = {}
-- 		for xk, xv in pairs(yv) do 
-- 			temp[yk][xk] = {bottom_wall = aux.grid[yk][xk].bottom_wall, right_wall = aux.grid[yk][xk].right_wall} -- , point = aux.grid[yk][xk].point}
-- 		end
-- 	end
-- 	return temp
-- end

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.aldous_broder()
	return aux.grid--, aux.changes
end

function aux.aldous_broder()
	local unvisited_cells = aux.width * aux.height
	local ix = math.random(aux.sx, aux.width)
	local iy = math.random(aux.sy, aux.height)

	aux.grid[iy][ix].visited = true
	unvisited_cells = unvisited_cells - 1

	while unvisited_cells ~= 0 do
		local dir = aux.dirs[math.random(1, 4)]

		if dir == "UP" then
			if iy-1 >= aux.sy then
				if aux.grid[iy-1][ix].visited == false then
					aux.grid[iy-1][ix].bottom_wall = false
					aux.grid[iy-1][ix].visited = true 
					unvisited_cells = unvisited_cells - 1 
				end
				iy = iy-1
			end
		elseif dir == "DOWN" then
			if iy+1 <= aux.height then 
				if aux.grid[iy+1][ix].visited == false then 
					aux.grid[iy][ix].bottom_wall = false 
					aux.grid[iy+1][ix].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				iy = iy+1
			end
		elseif dir == "RIGHT" then
			if ix+1 <= aux.width then
				if aux.grid[iy][ix+1].visited == false then 
					aux.grid[iy][ix].right_wall = false
					aux.grid[iy][ix+1].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				ix = ix+1
			end
		elseif dir == "LEFT" then
			if ix-1 >= aux.sx then
				if aux.grid[iy][ix-1].visited == false then
					aux.grid[iy][ix-1].right_wall = false
					aux.grid[iy][ix-1].visited = true
					unvisited_cells = unvisited_cells - 1 
				end
				ix = ix-1
			end
		end
	end
end

return mod
