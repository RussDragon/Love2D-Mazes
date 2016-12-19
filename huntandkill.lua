local mod = {}
local aux = {}

aux.width = false 
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
-- aux.changes = {}

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
	return aux.grid--, aux.changes
end

local function saveGridState()
  local temp = {}
  for yk, yv in pairs(aux.grid) do
    temp[yk] = {}
    for xk, xv in pairs(yv) do 
      temp[yk][xk] = {bottom_wall = aux.grid[yk][xk].bottom_wall, right_wall = aux.grid[yk][xk].right_wall}
    end
  end
  return temp
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
				for kx, vx in pairs(vy) do
					if aux.getUnvisitedNeighbour(kx, ky) then
						local dir_ = aux.getUnvisitedNeighbour(kx, ky)
						
						x, y = kx, ky
						aux.grid[y][x].visited = true
							
						if dir_ == "up" then aux.grid[y-1][x].bottom_wall = false 
						elseif dir_ == "down" then aux.grid[y][x].bottom_wall = false 
						elseif dir_ == "right" then aux.grid[y][x].right_wall = false 
						elseif dir_ == "left" then aux.grid[y][x-1].right_wall = false end
						-- table.insert(aux.changes, saveGridState())

						dirs = aux.getUnvisited(x, y) 
						
						isFound = true
						break
					end
				end
				if isFound then break end
			end
			if not isFound then break end
		end

		local dir = table.remove(dirs)
		if dir then
			if dir == "up" and not aux.grid[y-1][x].visited then
				aux.grid[y-1][x].bottom_wall = false
				y, x = y-1, x
			elseif dir == "down" and not aux.grid[y+1][x].visited then
				aux.grid[y][x].bottom_wall = false
				y, x = y+1, x
			elseif dir == "left" and not aux.grid[y][x-1].visited then
				aux.grid[y][x-1].right_wall = false
				y, x = y, x-1
			elseif dir == "right" and not aux.grid[y][x+1].visited then 
				aux.grid[y][x].right_wall = false
				y, x = y, x+1
			end
			-- table.insert(aux.changes, saveGridState())
		end
	end
end

return mod
