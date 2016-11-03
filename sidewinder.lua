local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false

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

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.height, aux.width, aux.sx, aux.sy = y2, x2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.sidewinder()
	return aux.grid
end

function aux.sidewinder()
	if aux.width > 0 and aux.height > 0 and aux.sx < aux.width and aux.sy < aux.height then
		local cx = aux.sx
		for y = aux.sy, aux.height do
			for x = aux.sx, aux.width do 
				if y ~= aux.sy then
					if math.random(0, 1) == 0 and x ~= aux.width then
						if x ~= aux.width then
							aux.grid[y][x].right_wall = false
						end
					else 
						aux.grid[y-1][math.random(cx, x)].bottom_wall = false
						if x ~= aux.width then
							cx = x+1
						else 
							cx = aux.sx
						end
					end
				else 
					if x ~= aux.width then aux.grid[y][x].right_wall = false end
				end
			end
		end
	end
end

return mod
