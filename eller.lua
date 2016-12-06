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
			MazeGrid[y][x] = {visited = false, bottom_wall = true, right_wall = true, set = aux.hashKey(x, y)} -- Wall grid
		end
	end  
	return MazeGrid
end

function aux.shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function mod.createMaze(x1, y1, x2, y2, grid)
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.eller()
	return aux.grid
end

function aux.hashKey(x, y)
	return x * aux.height + (y - 1)
end

function aux.eller()
	local sets = {}

	for y = 1, aux.height do 
		for x = 1, aux.width do
			sets[aux.grid[y][x].set] = {}
			table.insert(sets[aux.grid[y][x].set], {x = x, y = y})
		end

		for x = 1, aux.width-1 do
			if y == aux.height then
				sets[aux.grid[y][x+1].set] = nil
				aux.grid[y][x+1].set = aux.grid[y][x].set
			end

		end
		sets = {}
	end
end

return mod
