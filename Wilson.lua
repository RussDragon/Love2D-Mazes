
local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false

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

-- function aux.shuffleTable(t)
--     for i = #t, 2, -1 do
--         local j = math.random(i)
--         t[i], t[j] = t[j], t[i]
--     end
-- end

-- function aux.createCellStack(grid)
-- 	local stack = {}
-- 	for yk, yv in pairs(grid) do
-- 		for xk, xv in pairs(yv) do
-- 			if xv.visited == false then 
-- 				print(yk, xk)
-- 				stack[#stack+1] = {x = xk, y = yk}
-- 			end
-- 		end
-- 	end
-- 	return stack
-- end

-- function mod.createMaze(grid, x1, y1, x2, y2)
-- 	local unvisited_cells = (x2+1) * (y2+1) 
-- 	local stack = aux.createCellStack(grid)
-- 	aux.shuffleTable(stack)

-- 	local value = table.remove(stack)
-- 	grid[value.y][value.x].visited = true
-- 	unvisited_cells = unvisited_cells - 1

-- 	value = table.remove(stack)
-- 	local stx, sty = value.x, value.y

-- 	local ix, iy = stx, sty -- sub-vertecies
-- 	print("-----")
-- 	while unvisited_cells ~= 0 do
-- 		if grid[iy][ix].visited == true then 
-- 			grid[sty][stx].visited = true
-- 			while unvisited_cells ~= 0 do
-- 				if stx == ix and sty == iy then 
-- 					value = table.remove(stack)
-- 					stx, sty = value.x, value.y
-- 					print(stx, sty)
-- 					break
-- 				else unvisited_cells = unvisited_cells - 1 end

-- 				local dir = grid[sty][stx].dir
-- 				if dir == "UP" then
-- 				    grid[sty-1][stx].visited = true
-- 				    grid[sty-1][stx].bottom_wall = false
-- 				    sty = sty - 1
-- 				elseif dir == "DOWN" then
-- 				    grid[sty+1][stx].visited = true
-- 				    grid[sty][stx].bottom_wall = false
-- 				    sty = sty + 1
-- 				elseif dir == "LEFT" then
-- 				    grid[sty][stx-1].visited = true
-- 				    grid[sty][stx-1].right_wall = false
-- 				    stx = stx - 1
-- 				elseif dir == "RIGHT" then
-- 				    grid[sty][stx+1].visited = true
-- 				    grid[sty][stx].right_wall = false
-- 				    stx = stx + 1
-- 				end
-- 			end
-- 			ix, iy = stx, sty
-- 		end

-- 		local dir = aux.dirs[math.random(1, 4)]
-- 		if dir == "UP" then -- UP
-- 			if iy-1 >= y1 then
-- 				grid[iy][ix].dir = "UP"
-- 				iy = iy - 1
-- 			end
-- 		elseif dir == "DOWN" then -- DOWN 
-- 			if iy+1 <= y2 then 
-- 				grid[iy][ix].dir = "DOWN"
-- 				iy = iy + 1
-- 			end
-- 		elseif dir == "RIGHT" then -- RIGHT
-- 			if ix+1 <= x2 then
-- 				grid[iy][ix].dir = "RIGHT"
-- 				ix = ix + 1
-- 			end
-- 		elseif dir == "LEFT" then -- LEFT
-- 			if ix-1 >= x1 then
-- 				grid[iy][ix].dir = "LEFT"
-- 				ix = ix - 1
-- 			end
-- 		end
-- 	end
-- end

return mod
