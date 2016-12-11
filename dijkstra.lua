local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
aux.matrice = false

aux.front = {}
aux.hashVisited = {}
aux.frontHash	= {}

function aux.createMatrice(x2, y2)
	for y = 1, y2 do
		aux.matrice[y] = {}
		for x = 1, x2 do
			aux.matrice[y][x] = 0
		end
	end
end

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid
	aux.matrice = aux.createMatrice(x2, y2)
	aux.dijkstra()
	return aux.matrice
end

function aux.hashKey(x, y)
	return x * aux.height + (y - 1)
end

function aux.deHashKey(value)
	return math.floor(value/aux.height), value%aux.height + 1
end

function aux.updateFront(x, y)
	local dirs = {}

	if y - 1 >= aux.sy and not aux.hashVisited[aux.hashKey(x, y - 1)] and not aux.frontHash[aux.hashKey(x, y - 1)] and not aux.grid[y-1][x].bottom_wall then 
		aux.frontHash[aux.hashKey(x, y-1)] = #aux.front+1
		aux.front[#aux.front+1] = {x = x, y = y - 1}
	end

	if y + 1 <= aux.height and not aux.hashVisited[aux.hashKey(x, y + 1)] and not aux.frontHash[aux.hashKey(x, y + 1)] and not aux.grid[y][x].bottom_wall then
		aux.frontHash[aux.hashKey(x, y + 1)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x, y = y + 1}
	end

	if x + 1 <= aux.width and not aux.hashVisited[aux.hashKey(x + 1, y)] and not aux.frontHash[aux.hashKey(x + 1, y)] and not aux.grid[y][x].right_wall then
		aux.frontHash[aux.hashKey(x + 1, y)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x + 1, y = y}
	end

	if x - 1 >= aux.sx and not aux.hashVisited[aux.hashKey(x - 1, y)] and not aux.frontHash[aux.hashKey(x - 1, y)] and not aux.grid[y][x-1].right_wall then
		aux.frontHash[aux.hashKey(x - 1, y)] = #aux.front + 1
		aux.front[#aux.front+1] = {x = x - 1, y = y}
	end

	-- aux.shuffleTable(aux.front)
end


function aux.dijkstra()
	local ix, iy = aux.sx, aux.sy

	aux.hashVisited[aux.hashKey(ix, iy)] = true
	aux.updateFront(ix, iy)

	while #aux.front ~= 0 do
		local value = table.remove(aux.front, math.random(1, #aux.front))
		ix, iy = value.x, value.y
		aux.hashVisited[aux.hashKey(ix, iy)] = true
		aux.frontHash[aux.hashKey(ix, iy)] = nil
		aux.updateFront(ix, iy)
	end
end
return mod
