
local mod = {}
local aux = {}

aux.width = false 
aux.height = false
aux.grid = false
aux.sy = false
aux.sx = false

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

function aux.shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function aux.getUnvisited(x, y)
	local dirs = {}
	if y-1 >= aux.sy and aux.grid[y-1][x].visited == false then  -- UP
		dirs[#dirs + 1] = "up"
	end
	
	if y+1 <= aux.height and aux.grid[y+1][x].visited == false then -- DOWN
		dirs[#dirs + 1] = 
		"down"
	end
	
	if x-1 >= aux.sx and aux.grid[y][x-1].visited == false then -- LEFT
		dirs[#dirs + 1] = "left"
	end
	
	if x+1 <= aux.width and aux.grid[y][x+1].visited == false then -- RIGHT
		dirs[#dirs + 1] = "right"
	end

	aux.shuffleTable(dirs)
	return dirs
end

function mod.createMaze(x1, y1, x2, y2, grid)  
		aux.width, aux.height = x2, y2
		aux.grid = grid or aux.createGrid(y2, x2)
		aux.sx, aux.sy = x1, y1

		-- aux.LoopsMaze()
		aux.backtrackingMaze(aux.sx, aux.sy)
		return aux.grid
end

function aux.backtrackingMaze(x, y)
	aux.grid[y][x].visited = true
	
	local dirs = aux.getUnvisited(x, y)

	for k, v in pairs(dirs) do
		if v == "up" and y-1 >= aux.sy then 
			if aux.grid[y-1][x].visited == false then 
				aux.grid[y-1][x].bottom_wall = false
				aux.backtrackingMaze(x, y - 1)
			end
		end

		if v == "down" and y+1 <= aux.height then 
			if aux.grid[y+1][x].visited == false then 
				aux.grid[y][x].bottom_wall = false
				aux.backtrackingMaze(x, y + 1)
			end
		end

		if v == "left" and x-1 >= aux.sx then 
			if aux.grid[y][x-1].visited == false then 
				aux.grid[y][x-1].right_wall = false
				aux.backtrackingMaze(x - 1, y)
			end
		end

		if v == "right" and x+1 <= aux.width then 
			if aux.grid[y][x+1].visited == false then 
				aux.grid[y][x].right_wall = false
				aux.backtrackingMaze(x + 1, y)
			end
		end
	end
end

function aux.LoopsMaze()
	local dirs = {}
	local stack = {}

	local x, y = aux.sx, aux.sy
	while true do
		print(x, y)
		aux.grid[y][x].visited = true
		
		if #aux.getUnvisited(x, y) ~= 0 then
			dirs = aux.getUnvisited(x, y)
			if #aux.getUnvisited(x, y) > 1 then 
				table.insert(stack, {x = x, y = y})
			end
		else
			if #stack ~= 0 then
				while #stack ~= 0 do 
					local value = table.remove(stack)
					x, y = value.x, value.y
					if #aux.getUnvisited(x, y) ~= 0 then
						dirs = aux.getUnvisited(x, y)
						break
					end
				end
			else
				break
			end
		end

		local dir = table.remove(dirs)

		if dir == "up" and aux.grid[y-1][x].visited == false then
			aux.grid[y-1][x].bottom_wall = false
			y, x = y - 1, x
		elseif dir == "down" and aux.grid[y+1][x].visited == false then
			aux.grid[y][x].bottom_wall = false
			y, x = y + 1, x
		elseif dir == "left" and aux.grid[y][x-1].visited == false then
			aux.grid[y][x-1].right_wall = false
			y, x = y, x - 1
		elseif dir == "right" and aux.grid[y][x+1].visited == false then 
			aux.grid[y][x].right_wall = false
			y, x = y, x + 1
		end
	end
end

return mod
