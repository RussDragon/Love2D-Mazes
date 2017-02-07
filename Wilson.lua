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
			MazeGrid[y][x] = {visited = false, bottom_wall = true, right_wall = true, point = false} --, dir = "NONE"} -- Wall grid
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
	return aux.grid--, aux.changes
end

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

function aux.wilson()
	local cellsHash = aux.hashCells(aux.grid) -- Вершины, не находящиеся в дереве

	local dirsStack = {} -- Стак направлений
	local dsHash = {}
	local dsSize = 0

	-- Создаем дерево
	local key, v = next(cellsHash, nil)
	v.visited = true
	cellsHash[key] = nil

	while next(cellsHash) do -- Пока есть необработанные вершины, работает
		key = next(cellsHash, nil) -- Получаем ключ и по нему координаты клетки
		local start_x, start_y = aux.deHashKey(key)
		local ix, iy = start_x, start_y

		while not aux.grid[iy][ix].visited do  -- Ходим, пока не найдем относящуюся к дереву клетку
			local dir = aux.dirs[math.random(1, 4)]
			local isMoved = false

			key = aux.hashKey(ix, iy)

			if dir == "UP" and iy-1 >= aux.sy then iy = iy - 1 isMoved = true
			elseif dir == "DOWN" and iy+1 <= aux.height then iy = iy + 1 isMoved = true
			elseif dir == "LEFT" and ix-1 >= aux.sx then ix = ix - 1 isMoved = true
			elseif dir == "RIGHT" and ix+1 <= aux.width then ix = ix + 1 isMoved = true end

			if isMoved then -- Если мы можем двигаться, тогда проверяем на циклы
				if dsHash[key] then -- Удаление циклов
					dirsStack[dsHash[key]].dir = dir

					for i = dsHash[key]+1, dsSize do
						local x, y = aux.deHashKey(dirsStack[i].hashref)
						dsHash[dirsStack[i].hashref] = nil
						dirsStack[i] = nil
						dsSize = dsSize - 1
					end
				else
					local x, y = aux.deHashKey(key) -- Добавление в стак направлений
					dsSize = dsSize + 1
					dsHash[key] = dsSize
					dirsStack[dsSize] = {dir = dir, hashref = key}
				end
			end
			
		end

		for i = 1, dsSize do -- Проквапывание пути
			aux.grid[start_y][start_x].visited = true
			cellsHash[aux.hashKey(start_x, start_y)] = nil
			aux.grid[start_y][start_x].point = false
			local dir = dirsStack[i].dir

			if dir == "UP" then
				aux.grid[start_y-1][start_x].bottom_wall = false
				start_y = start_y - 1
			
			elseif dir == "DOWN" then
				aux.grid[start_y][start_x].bottom_wall = false
				start_y = start_y + 1
			
			elseif dir == "LEFT" then
				aux.grid[start_y][start_x-1].right_wall = false
				start_x = start_x - 1

			elseif dir == "RIGHT" then 
				aux.grid[start_y][start_x].right_wall = false
				start_x = start_x + 1
			end
		end

		dsHash, dirsStack, dsSize = {}, {}, 0 -- Обнуление стака направлений
	end
end


return mod
