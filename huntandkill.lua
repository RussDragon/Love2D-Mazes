local mod = {}
local aux = {}

aux.width = false 
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false

function aux.createGrid (rows, columns)
	local MazeGrid = {}
	local color = 0

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

function aux.getUnvisitedNeighbour(x, y)
	if y-1 >= aux.sy and aux.grid[y-1][x].visited == true and aux.grid[y][x].visited == false then  -- UP
		return "up"
	end
	
	if y+1 <= aux.height and aux.grid[y+1][x].visited == true and aux.grid[y][x].visited == false then -- DOWN
		return "down"
	end
	
	if x-1 >= aux.sx and aux.grid[y][x-1].visited == true and aux.grid[y][x].visited == false then -- LEFT
		return "left"
	end
	
	if x+1 <= aux.width and aux.grid[y][x+1].visited == true and aux.grid[y][x].visited == false then -- RIGHT
		return "right"
	end
	return false
end

function aux.getUnvisited(x, y)
	local dirs = {}
	if y-1 >= aux.sy and aux.grid[y-1][x].visited == false then  -- UP
		dirs[#dirs + 1] = "up"
	end
	
	if y+1 <= aux.height and aux.grid[y+1][x].visited == false then -- DOWN
		dirs[#dirs + 1] = "down"
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
	aux.width, aux.height, aux.sx, aux.sy = x2, y2, x1, y1
	aux.grid = grid or aux.createGrid(y2, x2)
	aux.huntandkill()
	return aux.grid
end

function aux.huntandkill()
	local dirs = {}

	local x, y = aux.sx, aux.sy
	while true do
		aux.grid[y][x].visited = true
		
		if #aux.getUnvisited(x, y) ~= 0 then
			dirs = aux.getUnvisited(x, y)
		else
			local isFound = false
			for ky, vy in pairs(aux.grid) do
				local f = 0
				for kx, vx in pairs(vy) do
					if aux.getUnvisitedNeighbour(kx, ky) then
						local dir_ = aux.getUnvisitedNeighbour(kx, ky)
						
						aux.grid[ky][kx].visited = true
						x, y = kx, ky
							
						if dir_ == "up" then aux.grid[ky-1][kx].bottom_wall = false
						elseif dir_ == "down" then aux.grid[ky][kx].bottom_wall = false
						elseif dir_ == "right" then aux.grid[ky][kx].right_wall = false
						elseif dir_ == "left" then aux.grid[ky][kx-1].right_wall = false end

						dirs = aux.getUnvisited(kx, ky) 
						
						f = 1
						isFound = true
						break
					end
				end
				if f == 1 then break end
			end
			if not isFound then break end
		end

		local dir = table.remove(dirs)
		if dir then
			if dir == "up" and aux.grid[y-1][x].visited == false then
				aux.grid[y-1][x].bottom_wall = false
				y, x = y-1, x
			elseif dir == "down" and aux.grid[y+1][x].visited == false then
				aux.grid[y][x].bottom_wall = false
				y, x = y+1, x
			elseif dir == "left" and aux.grid[y][x-1].visited == false then
				aux.grid[y][x-1].right_wall = false
				y, x = y, x-1
			elseif dir == "right" and aux.grid[y][x+1].visited == false then 
				aux.grid[y][x].right_wall = false
				y, x = y, x+1
			end
		end
	end
end

return mod
