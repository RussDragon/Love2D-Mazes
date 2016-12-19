local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
-- aux.changes = {}

function aux.createGrid (rows, columns)
	local MazeGrid = {}
	
	for y = 1, rows do 
		MazeGrid[y] = {}
		for x = 1, columns do
			MazeGrid[y][x] = {bottom_wall = true, right_wall = true} -- Wall grid
		end
	end  
	return MazeGrid
end

-- Binary Tree North-East variant 
function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(aux.height, aux.width)
	aux.binarytree()
	return aux.grid--, aux.changes
end

local function saveGridState()
	local temp = {}
	for yk, yv in pairs(aux.grid) do
		temp[yk] = {}
		for xk, xv in pairs(yv) do 
			temp[yk][xk] = {bottom_wall = aux.grid[yk][xk].bottom_wall, right_wall = aux.grid[yk][xk].right_wall}
		end
	end
	return temp
end

function aux.binarytree() 
	if aux.width > 0 and aux.height > 0 and aux.sx < aux.width and aux.sy < aux.height then
		-- table.insert(aux.changes, saveGridState())
		for y = aux.sy, aux.height do 
			for x = aux.sx, aux.width do
				if y ~= aux.sy then 
					if math.random(0, 1) == 0 then 
						if x ~= aux.width then 
							aux.grid[y][x].right_wall = false
						else
							aux.grid[y-1][x].bottom_wall = false
						end
					else
						aux.grid[y-1][x].bottom_wall = false
					end
				else
					if x ~= aux.width then 
						aux.grid[y][x].right_wall = false 
					end
				end
				-- table.insert(aux.changes, saveGridState())
			end
		end
	end
end

return mod
