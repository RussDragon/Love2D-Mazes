local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
aux.stack = {}
aux.stackHash = {}

aux.dirs = {"UP", "DOWN", "LEFT", "RIGHT"}

function aux.createGrid (rows, columns)
	local MazeGrid = {}
	local color = 0

	for y = 1, rows do 
		MazeGrid[y] = {}
		for x = 1, columns do
			MazeGrid[y][x] = {dir = "NONE", visited = false, bottom_wall = true, right_wall = true} -- Wall grid
		end
	end  
	return MazeGrid
end

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.wilson()
	return aux.grid
end

function aux.hashValue(x, y)
return x * 10 + y
end

function aux.deHashKey(value)
return math.floor(value/10), value%10
end

-- function aux.wilson()
-- 	local unvisited_cells = aux.width * aux.height 

-- 	local y, x = math.random(aux.sy, aux.height), math.random(aux.sx, aux.width)
-- 	aux.grid[y][x].visited = true
-- 	unvisited_cells = unvisited_cells - 1

-- 	local stx, sty
-- 	while true do
-- 		stx, sty = math.random(aux.sx, aux.width), math.random(aux.sy, aux.height) -- Start point
-- 		if aux.grid[sty][stx].visited == false then break end
-- 	end

-- 	local ix, iy = stx, sty -- sub-vertecies

-- 	while unvisited_cells ~= 0 do
-- 		if aux.grid[iy][ix].visited == true then 
-- 			aux.grid[sty][stx].visited = true
-- 			while unvisited_cells ~= 0 do
-- 				if stx == ix and sty == iy then 
-- 					while true do
-- 						stx, sty = math.random(aux.sx, aux.width), math.random(aux.sy, aux.height) 
-- 						if aux.grid[sty][stx].visited == false then break end
-- 					end
-- 					break
-- 				else unvisited_cells = unvisited_cells - 1 end

-- 				local dir = aux.grid[sty][stx].dir
-- 				if dir == "UP" then
-- 				    aux.grid[sty-1][stx].visited = true
-- 				    aux.grid[sty-1][stx].bottom_wall = false
-- 				    sty = sty - 1
-- 				elseif dir == "DOWN" then
-- 				    aux.grid[sty+1][stx].visited = true
-- 				    aux.grid[sty][stx].bottom_wall = false
-- 				    sty = sty + 1
-- 				elseif dir == "LEFT" then
-- 				    aux.grid[sty][stx-1].visited = true
-- 				    aux.grid[sty][stx-1].right_wall = false
-- 				    stx = stx - 1
-- 				elseif dir == "RIGHT" then
-- 				    aux.grid[sty][stx+1].visited = true
-- 				    aux.grid[sty][stx].right_wall = false
-- 				    stx = stx + 1
-- 				end
-- 			end
-- 			ix, iy = stx, sty
-- 		end

-- 		local dir = aux.dirs[math.random(1, 4)]
-- 		if dir == "UP" then -- UP
-- 			if iy-1 >= aux.sy then
-- 				aux.grid[iy][ix].dir = "UP"
-- 				iy = iy - 1
-- 			end
-- 		elseif dir == "DOWN" then -- DOWN 
-- 			if iy+1 <= aux.height then 
-- 				aux.grid[iy][ix].dir = "DOWN"
-- 				iy = iy + 1
-- 			end
-- 		elseif dir == "RIGHT" then -- RIGHT
-- 			if ix+1 <= aux.width then
-- 				aux.grid[iy][ix].dir = "RIGHT"
-- 				ix = ix + 1
-- 			end
-- 		elseif dir == "LEFT" then -- LEFT
-- 			if ix-1 >= aux.sx then
-- 				aux.grid[iy][ix].dir = "LEFT"
-- 				ix = ix - 1
-- 			end
-- 		end
-- 	end
-- end

function aux.wilson()
	local unvisited_cells = aux.width * aux.height 

	local y, x = math.random(aux.sy, aux.height), math.random(aux.sx, aux.width)
	aux.grid[y][x].visited = true
	unvisited_cells = unvisited_cells - 1

	local stx, sty
	while true do
		stx, sty = math.random(aux.sx, aux.width), math.random(aux.sy, aux.height) -- Start point
		if aux.grid[sty][stx].visited == false then break end
	end

	local ix, iy = stx, sty -- sub-vertecies

	while unvisited_cells ~= 0 do
		if aux.grid[iy][ix].visited == true then 
			aux.grid[sty][stx].visited = true
			while unvisited_cells ~= 0 do
				if stx == ix and sty == iy then 
					while true do
						stx, sty = math.random(aux.sx, aux.width), math.random(aux.sy, aux.height) 
						if aux.grid[sty][stx].visited == false then break end
					end
					break
				else unvisited_cells = unvisited_cells - 1 end

				local dir = aux.grid[sty][stx].dir
				if dir == "UP" then
				    aux.grid[sty-1][stx].visited = true
				    aux.grid[sty-1][stx].bottom_wall = false
				    sty = sty - 1
				elseif dir == "DOWN" then
				    aux.grid[sty+1][stx].visited = true
				    aux.grid[sty][stx].bottom_wall = false
				    sty = sty + 1
				elseif dir == "LEFT" then
				    aux.grid[sty][stx-1].visited = true
				    aux.grid[sty][stx-1].right_wall = false
				    stx = stx - 1
				elseif dir == "RIGHT" then
				    aux.grid[sty][stx+1].visited = true
				    aux.grid[sty][stx].right_wall = false
				    stx = stx + 1
				end
			end
			ix, iy = stx, sty
		end

		local dir = aux.dirs[math.random(1, 4)]
		if dir == "UP" then -- UP
			if iy-1 >= aux.sy then
				aux.grid[iy][ix].dir = "UP"
				iy = iy - 1
			end
		elseif dir == "DOWN" then -- DOWN 
			if iy+1 <= aux.height then 
				aux.grid[iy][ix].dir = "DOWN"
				iy = iy + 1
			end
		elseif dir == "RIGHT" then -- RIGHT
			if ix+1 <= aux.width then
				aux.grid[iy][ix].dir = "RIGHT"
				ix = ix + 1
			end
		elseif dir == "LEFT" then -- LEFT
			if ix-1 >= aux.sx then
				aux.grid[iy][ix].dir = "LEFT"
				ix = ix - 1
			end
		end
	end
end

return mod
