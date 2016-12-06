local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
aux.front = {}
aux.frontHash	= {}

function aux.createGrid (rows, columns)
	local MazeGrid = {}

	for y = 1, rows do 
		MazeGrid[y] = {}
		for x = 1, columns do
			MazeGrid[y][x] = {visited = false, bottom_wall = true, right_wall = true} -- Wall grid
		end
	end  
	return MazeGrid
end

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.prim()
	return aux.grid
end

function aux.shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function aux.hashValue(x, y)
	return x * aux.height + (y - 1)
end

function aux.deHashKey(value)
	return math.floor(value/aux.height), value%aux.height + 1
end

function aux.getVisited(x, y)
	local dirs = {}

	if y - 1 >= aux.sy and aux.grid[y-1][x].visited == true then 
		dirs[#dirs+1] = "UP" 
	end

	if y + 1 <= aux.height and aux.grid[y+1][x].visited == true then
		dirs[#dirs+1] = "DOWN"
	end

	if x + 1 <= aux.width and aux.grid[y][x+1].visited == true then
		dirs[#dirs+1] = "RIGHT"
	end

	if x - 1 >= aux.sx and aux.grid[y][x-1].visited == true then
		dirs[#dirs+1] = "LEFT"
	end

	return dirs[math.random(1, #dirs)]
end

function aux.updateFront(x, y)
	local dirs = {}

	if y - 1 >= aux.sy and aux.grid[y-1][x].visited == false and not aux.frontHash[aux.hashValue(x, y - 1)] then 
		aux.frontHash[aux.hashValue(x, y-1)] = #aux.front+1
		aux.front[#aux.front+1] = {x = x, y = y - 1}
	end

	if y + 1 <= aux.height and aux.grid[y+1][x].visited == false and not aux.frontHash[aux.hashValue(x, y + 1)] then
		aux.frontHash[aux.hashValue(x, y + 1)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x, y = y + 1}
	end

	if x + 1 <= aux.width and aux.grid[y][x+1].visited == false and not aux.frontHash[aux.hashValue(x + 1, y)] then
		aux.frontHash[aux.hashValue(x + 1, y)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x + 1, y = y}
	end

	if x - 1 >= aux.sx and aux.grid[y][x-1].visited == false and not aux.frontHash[aux.hashValue(x - 1, y)] then
		aux.frontHash[aux.hashValue(x - 1, y)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x - 1, y = y}
	end

	-- aux.shuffleTable(aux.front)
end

function aux.prim()
	local ix, iy = math.random(aux.sx, aux.width), math.random(aux.sy, aux.height)

	aux.grid[iy][ix].visited = true
	aux.updateFront(ix, iy)

	while #aux.front ~= 0 do
		local value = table.remove(aux.front, math.random(1, #aux.front))
		ix, iy = value.x, value.y
		aux.grid[iy][ix].visited = true
		aux.frontHash[aux.hashValue(ix, iy)] = nil
		aux.updateFront(ix, iy)

		local dir = aux.getVisited(ix, iy)
		if dir == "UP" then
			aux.grid[iy-1][ix].bottom_wall = false
		elseif dir == "DOWN" then
			aux.grid[iy][ix].bottom_wall = false
		elseif dir == "LEFT" then
			aux.grid[iy][ix-1].right_wall = false
		elseif dir == "RIGHT" then
			aux.grid[iy][ix].right_wall = false
		end
	end
end

return mod
