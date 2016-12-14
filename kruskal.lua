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
			MazeGrid[y][x] = {bottom_wall = true, right_wall = true, set = -1} -- Wall grid
		end
	end  
	return MazeGrid
end

function mod.createEdgeStack()
	local stack = {}
	for yk, yv in pairs(aux.grid) do
		for xk, xv in pairs(yv) do
			table.insert(stack, {dir = "right", y = yk, x = xk})
			table.insert(stack, {dir = "down", y = yk, x = xk})
		end
	end
	aux.shuffleTable(stack)
	return stack
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
	aux.kruskal()
	return aux.grid
end

function aux.hashKey(x, y)
	return x * aux.height + (y - 1)
end

function aux.kruskal()
	local edgeStack = mod.createEdgeStack()
	local sets = {}
	local counter = 1
	while #edgeStack ~= 0 do
		local value = table.remove(edgeStack)
		local x, y, dir = value.x, value.y, value.dir
		local hv = aux.hashKey(x, y)
		
		if aux.grid[y][x].set == -1 then 
			sets[hv] = {}
			table.insert(sets[hv], aux.grid[y][x]) 
			aux.grid[y][x].set = hv
		end
		
		if dir == "right" then
			if x + 1 <= aux.width then 
				if aux.grid[y][x+1].set == -1 then
					table.insert(sets[aux.grid[y][x].set], aux.grid[y][x+1])
					aux.grid[y][x+1].set = aux.grid[y][x].set
					aux.grid[y][x].right_wall = false
				elseif aux.grid[y][x].set ~= aux.grid[y][x+1].set then
					aux.grid[y][x].right_wall = false 
					for _, v in pairs(sets[aux.grid[y][x+1].set]) do 
						table.insert(sets[aux.grid[y][x].set], v)
						v.set = aux.grid[y][x].set
					end
					sets[aux.hashKey(x + 1, y)] = nil
				end
			end
		elseif dir == "down" then 
			if y + 1 <= aux.height then 
				if aux.grid[y+1][x].set == -1 then
					aux.grid[y][x].bottom_wall = false
					table.insert(sets[aux.grid[y][x].set], aux.grid[y+1][x] )
					aux.grid[y+1][x].set = aux.grid[y][x].set
				elseif aux.grid[y][x].set ~= aux.grid[y+1][x].set then 
					aux.grid[y][x].bottom_wall = false
					for _, v in pairs(sets[aux.grid[y+1][x].set]) do 
						table.insert(sets[aux.grid[y][x].set], v)
						v.set = aux.grid[y][x].set
					end
					sets[aux.hashKey(x, y + 1)] = nil
				end
			end
		end
	end

	sets = nil
	edgeStack = nil
end
return mod
