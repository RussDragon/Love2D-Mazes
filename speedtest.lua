local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
aux.changes = {}

aux.dirs = {"UP", "DOWN", "LEFT", "RIGHT"}

function aux.createGrid (rows, columns)
	local MazeGrid = {}
	
	for y = 1, rows do 
		MazeGrid[y] = {}
		for x = 1, columns do
			MazeGrid[y][x] = {dir = "NONE", visited = false, bottom_wall = true, right_wall = true, point = 0} -- Wall grid
		end
	end  
	return MazeGrid
end

local function saveGridState()
	local temp = {}
	for yk, yv in pairs(aux.grid) do
		temp[yk] = {}
		for xk, xv in pairs(yv) do 
			temp[yk][xk] = {bottom_wall = aux.grid[yk][xk].bottom_wall, right_wall = aux.grid[yk][xk].right_wall, point = aux.grid[yk][xk].point}
		end
	end
	return temp
end

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.wilson()
	return aux.grid, aux.changes
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

function aux.hashKey(x, y)
	return x * aux.height + (y - 1)
end

function aux.deHashKey(value)
	return math.floor(value/aux.height), value%aux.height + 1
end

function aux.hashCells(grid)
	local vtable = {}
	for yk, yv in pairs(grid) do
		for xk, xv in pairs(yv) do
			if xv.visited == false then
				vtable[aux.hashKey(xk, yk)] = xv -- Добавляем только ссылки, не занимаем память, профит (?)
			end
		end
	end
	return vtable
end

-- Dirs optimized

function aux.wilson()
	local unvisited_cells = aux.width * aux.height
	local dirsStack = {}
	local dirsHash = {}
	local CellsHash = aux.hashCells(aux.grid)

	local key = next(CellsHash, nil)
	local vx, vy = aux.deHashKey(key)
	CellsHash[key] = nil
	aux.grid[vy][vx].visited = true
	
	unvisited_cells = unvisited_cells - 1

	key = next(CellsHash, nil)
	vx, vy = aux.deHashKey(key)
	CellsHash[key] = nil
	
	local stx, sty = vx, vy

	local ix, iy = stx, sty -- sub-vertecies

	while unvisited_cells ~= 0 do
		if aux.grid[iy][ix].visited == true then 
			aux.grid[sty][stx].visited = true
			CellsHash[aux.hashKey(stx, sty)] = nil
			while unvisited_cells ~= 0 do
				if stx == ix and sty == iy then 
					key = next(CellsHash, nil)
					vx, vy = aux.deHashKey(key)
					CellsHash[key] = nil

					stx, sty = vx, vy

					dirsStack = {}
					dirsHash = {}
					break
				end

				for i = 1, #dirsStack do
					unvisited_cells = unvisited_cells - 1
					if dirsStack[i].dir == "UP" then
					    aux.grid[sty-1][stx].visited = true
							CellsHash[aux.hashKey(stx, sty-1)] = nil
					    aux.grid[sty-1][stx].bottom_wall = false
					    sty = sty - 1
					elseif dirsStack[i].dir == "DOWN" then
					    aux.grid[sty+1][stx].visited = true
					    CellsHash[aux.hashKey(stx, sty+1)] = nil
					    aux.grid[sty][stx].bottom_wall = false
					    sty = sty + 1
					elseif dirsStack[i].dir == "LEFT" then
					    aux.grid[sty][stx-1].visited = true
					    CellsHash[aux.hashKey(stx-1, sty)] = nil
					    aux.grid[sty][stx-1].right_wall = false
					    stx = stx - 1
					elseif dirsStack[i].dir == "RIGHT" then
					    aux.grid[sty][stx+1].visited = true
					    CellsHash[aux.hashKey(stx+1, sty)] = nil
					    aux.grid[sty][stx].right_wall = false
					    stx = stx + 1
					end
				end
			end
			ix, iy = stx, sty
		end

		local dir = aux.dirs[math.random(1, 4)]
		key = aux.hashKey(ix, iy)

		if dir == "UP" then 
			if iy-1 >= aux.sy then
				if not dirsHash[key] then
					dirsStack[#dirsStack+1] = {dir = "UP", ref = key}
					dirsHash[key] = #dirsStack
				else dirsStack[dirsHash[key]].dir = "UP"
					for i = dirsHash[key]+1, #dirsStack do
						dirsHash[dirsStack[i].ref] = nil
						dirsStack[i] = nil
					end
				end
				iy = iy - 1
			end
		elseif dir == "DOWN" then 
			if iy+1 <= aux.height then 
				if not dirsHash[key] then 
					dirsStack[#dirsStack+1] = {dir = "DOWN", ref = key}
					dirsHash[key] = #dirsStack
				else dirsStack[dirsHash[key]].dir = "DOWN" 
					for i = dirsHash[key]+1, #dirsStack do
						dirsHash[dirsStack[i].ref] = nil
						dirsStack[i] = nil
					end
				end
				iy = iy + 1
			end
		elseif dir == "RIGHT" then 
			if ix+1 <= aux.width then
				if not dirsHash[key] then 
					dirsStack[#dirsStack+1] = {dir = "RIGHT", ref = key}
					dirsHash[key] = #dirsStack
				else dirsStack[dirsHash[key]].dir = "RIGHT" 
					for i = dirsHash[key]+1, #dirsStack do
						dirsHash[dirsStack[i].ref] = nil
						dirsStack[i] = nil
					end
				end
				ix = ix + 1
			end
		elseif dir == "LEFT" then 
			if ix-1 >= aux.sx then
				if not dirsHash[key] then
					dirsStack[#dirsStack+1] = {dir = "LEFT", ref = key}
					dirsHash[key] = #dirsStack
				else dirsStack[dirsHash[key]].dir = "LEFT" 
					for i = dirsHash[key]+1, #dirsStack do
						dirsHash[dirsStack[i].ref] = nil
						dirsStack[i] = nil
					end
				end
				ix = ix - 1
			end
		end
	end
end

-- Optimized Wilson algorithm with hash-table

-- function aux.wilson()
-- 	local unvisited_cells = aux.width * aux.height

-- 	-- Выбираем случайную вершину, которая будет начальной в UST
-- 	local CellsHash = aux.hashCells(aux.grid)
-- 	local key = next(CellsHash, key)
-- 	local vx, vy = aux.deHashKey(key)

-- 	CellsHash[key] = nil
-- 	aux.grid[vy][vx].visited = true
-- 	unvisited_cells = unvisited_cells - 1

-- 	-- Выбираем следующую случайную вершину, которая должна будет соединиться с начальной
-- 	key = next(CellsHash, key)
-- 	CellsHash[key] = nil
-- 	vx, vy = aux.deHashKey(key)
	
-- 	-- startx, starty – начальные координаты вершины случайного прохода
-- 	local stx, sty = vx, vy
-- 	local ix, iy = stx, sty -- sub-vertecies

-- 	while unvisited_cells ~= 0 do
-- 		if aux.grid[iy][ix].visited then 
-- 			aux.grid[sty][stx].visited = true
-- 			CellsHash[aux.hashKey(stx, sty)] = nil

-- 			while unvisited_cells ~= 0 do
-- 				if stx == ix and sty == iy then 
-- 					key = next(CellsHash, key)
-- 					vx, vy = aux.deHashKey(key)
-- 					CellsHash[key] = nil

-- 					stx, sty = vx, vy
-- 					break
-- 				else 
-- 					unvisited_cells = unvisited_cells - 1

-- 					local dir = aux.grid[sty][stx].dir
-- 					if dir == "UP" then
-- 					    aux.grid[sty-1][stx].visited = true
-- 							CellsHash[aux.hashKey(stx, sty-1)] = nil
-- 					    aux.grid[sty-1][stx].bottom_wall = false
-- 					    sty = sty - 1
-- 					elseif dir == "DOWN" then
-- 					    aux.grid[sty+1][stx].visited = true
-- 					    CellsHash[aux.hashKey(stx, sty+1)] = nil
-- 					    aux.grid[sty][stx].bottom_wall = false
-- 					    sty = sty + 1
-- 					elseif dir == "LEFT" then
-- 					    aux.grid[sty][stx-1].visited = true
-- 					    CellsHash[aux.hashKey(stx-1, sty)] = nil
-- 					    aux.grid[sty][stx-1].right_wall = false
-- 					    stx = stx - 1
-- 					elseif dir == "RIGHT" then
-- 					    aux.grid[sty][stx+1].visited = true
-- 					    CellsHash[aux.hashKey(stx+1, sty)] = nil
-- 					    aux.grid[sty][stx].right_wall = false
-- 					    stx = stx + 1
-- 					end
-- 					table.insert(aux.changes, saveGridState())
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

mGrid = mod.createMaze(1, 1, 100, 100)

return mod
