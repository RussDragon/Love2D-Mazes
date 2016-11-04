local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
aux.CellsHash = {}

aux.dirs = {"UP", "DOWN", "LEFT", "RIGHT"}

function aux.createGrid (rows, columns)
	local MazeGrid = {}
	
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

function aux.hashValue(x, y)
return x * aux.height + (y-1)
end

function aux.deHashKey(value)
return math.floor(value/aux.height), value%aux.height + 1
end

function aux.shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function aux.hashCells()
	for yk, yv in pairs(aux.grid) do
		for xk, xv in pairs(yv) do
			if xv.visited == false then 
				aux.CellsHash[aux.hashValue(xk, yk)] = true
			end
		end
	end
end

-- function aux.wilson()
-- 	local unvisited_cells = aux.width * aux.height
-- 	local dirsStack = {}
-- 	local dirsHash = {}

-- 	aux.hashCells()

-- 	local key = next(aux.CellsHash, nil)
-- 	local vx, vy = aux.deHashKey(key)
-- 	aux.CellsHash[key] = nil
-- 	aux.grid[vy][vx].visited = true
	
-- 	unvisited_cells = unvisited_cells - 1

-- 	key = next(aux.CellsHash, nil)
-- 	vx, vy = aux.deHashKey(key)
-- 	aux.CellsHash[key] = nil
	
-- 	local stx, sty = vx, vy

-- 	local ix, iy = stx, sty -- sub-vertecies

-- 	while unvisited_cells ~= 0 do
-- 		if aux.grid[iy][ix].visited == true then 
-- 			aux.grid[sty][stx].visited = true
-- 			aux.CellsHash[aux.hashValue(stx, sty)] = nil
-- 			while unvisited_cells ~= 0 do
-- 				if stx == ix and sty == iy then 
-- 					key = next(aux.CellsHash, nil)
-- 					vx, vy = aux.deHashKey(key)
-- 					aux.CellsHash[key] = nil

-- 					stx, sty = vx, vy

-- 					dirsStack = {}
-- 					dirsHash = {}
-- 					break
-- 				end

-- 				for i = 1, #dirsStack do
-- 					unvisited_cells = unvisited_cells - 1
-- 					-- print(stx, sty, i)
-- 					-- print(unvisited_cells)
--           -- local dir = dirsStack[i]
-- 					if dirsStack[i] == "UP" then
-- 					    aux.grid[sty-1][stx].visited = true
-- 							aux.CellsHash[aux.hashValue(stx, sty-1)] = nil
-- 					    aux.grid[sty-1][stx].bottom_wall = false
-- 					    sty = sty - 1
-- 					elseif dirsStack[i] == "DOWN" then
-- 					    aux.grid[sty+1][stx].visited = true
-- 					    aux.CellsHash[aux.hashValue(stx, sty+1)] = nil
-- 					    aux.grid[sty][stx].bottom_wall = false
-- 					    sty = sty + 1
-- 					elseif dirsStack[i] == "LEFT" then
-- 					    aux.grid[sty][stx-1].visited = true
-- 					    aux.CellsHash[aux.hashValue(stx-1, sty)] = nil
-- 					    aux.grid[sty][stx-1].right_wall = false
-- 					    stx = stx - 1
-- 					elseif dirsStack[i] == "RIGHT" then
-- 					    aux.grid[sty][stx+1].visited = true
-- 					    aux.CellsHash[aux.hashValue(stx+1, sty)] = nil
-- 					    aux.grid[sty][stx].right_wall = false
-- 					    stx = stx + 1
-- 					end
-- 				end
-- 			end
-- 			ix, iy = stx, sty
-- 		end

-- 		local dir = aux.dirs[math.random(1, 4)]
-- 		key = aux.hashValue(ix, iy)

-- 		if dir == "UP" then 
-- 			if iy-1 >= aux.sy then
-- 				if not dirsHash[key] then
-- 					dirsStack[#dirsStack+1] = "UP"
-- 					dirsHash[key] = #dirsStack
-- 				else dirsStack[dirsHash[key]] = "UP" 
-- 					for i = #dirsStack, dirsHash[key]+1, -1 do
-- 						dirsStack[i] = nil
-- 					end
-- 				end
-- 				iy = iy - 1
-- 			end
-- 		elseif dir == "DOWN" then 
-- 			if iy+1 <= aux.height then 
-- 				if not dirsHash[key] then 
-- 					dirsStack[#dirsStack+1] = "DOWN"
-- 					dirsHash[key] = #dirsStack
-- 				else dirsStack[dirsHash[key]] = "DOWN" 
-- 					for i = #dirsStack, dirsHash[key]+1, -1 do
-- 						dirsStack[i] = nil
-- 					end
-- 				end
-- 				iy = iy + 1
-- 			end
-- 		elseif dir == "RIGHT" then 
-- 			if ix+1 <= aux.width then
-- 				if not dirsHash[key] then 
-- 					dirsStack[#dirsStack+1] = "RIGHT"
-- 					dirsHash[key] = #dirsStack
-- 				else dirsStack[dirsHash[key]] = "RIGHT" 
-- 					for i = #dirsStack, dirsHash[key]+1, -1 do
-- 						dirsStack[i] = nil
-- 					end
-- 				end
-- 				ix = ix + 1
-- 			end
-- 		elseif dir == "LEFT" then 
-- 			if ix-1 >= aux.sx then
-- 				if not dirsHash[key] then 
-- 					dirsStack[#dirsStack+1] = "LEFT"
-- 					dirsHash[key] = #dirsStack
-- 				else dirsStack[dirsHash[key]] = "LEFT" 
-- 					for i = #dirsStack, dirsHash[key]+1, -1 do
-- 						dirsStack[i] = nil
-- 					end
-- 				end
-- 				ix = ix - 1
-- 			end
-- 		end
-- 	end
-- end

function aux.wilson()
	local unvisited_cells = aux.width * aux.height
	local dirsStack = {}
	local dirsHash = {}

	aux.hashCells()

	local key = next(aux.CellsHash, nil)
	local vx, vy = aux.deHashKey(key)
	aux.CellsHash[key] = nil
	aux.grid[vy][vx].visited = true
	
	unvisited_cells = unvisited_cells - 1

	key = next(aux.CellsHash, nil)
	vx, vy = aux.deHashKey(key)
	aux.CellsHash[key] = nil
	
	local stx, sty = vx, vy

	local ix, iy = stx, sty -- sub-vertecies

	while unvisited_cells ~= 0 do
		if aux.grid[iy][ix].visited == true then 
			aux.grid[sty][stx].visited = true
			aux.CellsHash[aux.hashValue(stx, sty)] = nil
			while unvisited_cells ~= 0 do
				if stx == ix and sty == iy then 
					key = next(aux.CellsHash, nil)
					vx, vy = aux.deHashKey(key)
					aux.CellsHash[key] = nil

					stx, sty = vx, vy

					dirsStack = {}
					dirsHash = {}
					break
				else unvisited_cells = unvisited_cells - 1 end

				local dir = aux.grid[sty][stx].dir
				if dir == "UP" then
				    aux.grid[sty-1][stx].visited = true
						aux.CellsHash[aux.hashValue(stx, sty-1)] = nil
				    aux.grid[sty-1][stx].bottom_wall = false
				    sty = sty - 1
				elseif dir == "DOWN" then
				    aux.grid[sty+1][stx].visited = true
				    aux.CellsHash[aux.hashValue(stx, sty+1)] = nil
				    aux.grid[sty][stx].bottom_wall = false
				    sty = sty + 1
				elseif dir == "LEFT" then
				    aux.grid[sty][stx-1].visited = true
				    aux.CellsHash[aux.hashValue(stx-1, sty)] = nil
				    aux.grid[sty][stx-1].right_wall = false
				    stx = stx - 1
				elseif dir == "RIGHT" then
				    aux.grid[sty][stx+1].visited = true
				    aux.CellsHash[aux.hashValue(stx+1, sty)] = nil
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
