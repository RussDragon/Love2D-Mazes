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
			MazeGrid[y][x] = {bottom_wall = true, right_wall = true, set = aux.hashKey(x, y)} -- Wall grid
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
			if sets[aux.grid[y][x].set] and #sets[aux.grid[y][x].set] >= 1 then
				table.insert(sets[aux.grid[y][x].set], {x = x, y = y})
				aux.grid[y][x].setalloc = #sets[aux.grid[y][x].set]
			else
				sets[aux.grid[y][x].set] = {}
				table.insert(sets[aux.grid[y][x].set], {x = x, y = y})
				aux.grid[y][x].setalloc = #sets[aux.grid[y][x].set]
			end
		end

		for x = 1, aux.width-1 do
			if y == aux.height then
				if aux.grid[y][x].set ~= aux.grid[y][x+1].set then
					aux.grid[y][x].right_wall = false
				end
			elseif math.random(0, 1) == 1 and aux.grid[y][x].set ~= aux.grid[y][x+1].set then 
				aux.grid[y][x].right_wall = false
				
				table.insert(sets[aux.grid[y][x].set], {x = x + 1, y = y})
				-- print(#sets[aux.grid[y][x+1].set])
				if #sets[aux.grid[y][x+1].set] > 1 then 
					sets[aux.grid[y][x+1].set][aux.grid[y][x+1].setalloc] = sets[aux.grid[y][x+1].set][#sets[aux.grid[y][x+1].set]]
					sets[aux.grid[y][x+1].set][#sets[aux.grid[y][x+1].set]] = nil
				else 
					sets[aux.grid[y][x+1].set] = nil
				end

				aux.grid[y][x+1].set = aux.grid[y][x].set
			end
		end

		if y+1 <= aux.height then
			for k, v in pairs(sets) do
				local value = v[math.random(1, #v)]
				aux.grid[value.y][value.x].bottom_wall = false
				aux.grid[value.y+1][value.x].set = aux.grid[value.y][value.x].set

				for _, vi in pairs(v) do
					if math.random(0, 1) == 1 and aux.grid[vi.y][vi.x].bottom_wall then
						aux.grid[vi.y][vi.x].bottom_wall = false
						aux.grid[vi.y+1][vi.x].set = aux.grid[vi.y][vi.x].set
					end
				end
			end
		end
		sets = {}
	end
end

return mod
