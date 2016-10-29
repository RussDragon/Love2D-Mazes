local mod = {}
local aux = {}

mod.dirs = {"UP", "DOWN", "LEFT", "RIGHT"}

function mod.createGrid (rows, columns)
	local MazeGrid = {}
	local color = 0

	for y = 0, rows-1 do 
		MazeGrid[y] = {}
		for x = 0, columns-1 do
			MazeGrid[y][x] = {dir = "NONE", visited = false, bottom_wall = true, right_wall = true} -- Wall grid
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

function mod.createMaze(grid, x1, y1, x2, y2)
	local unvisited_cells = (x2+1) * (y2+1) 
	local stx, sty = math.random(x1, x2), math.random(y1, y2) -- Start point
	local rx, ry = stx, sty -- sub-vertecies

	local y, x = math.random(y1, y2), math.random(x1, x2)
	grid[y][x].visited = true
	print(x, y)

	while unvisited_cells ~= 0 do
		-- print(rx, ry)
		if grid[ry][rx].visited == true then 
			while true do
				if stx == rx and sty == ry then 
					local stx, sty = math.random(x1, x2), math.random(y1, y2) 
					break
				end
				local dir = grid[sty][stx].dir
				if dir == "UP" then
				    grid[sty-1][stx].visited = true
				    grid[sty-1][stx].bottom_wall = false
				    unvisited_cells = unvisited_cells - 1
				    sty = sty - 1
				elseif dir == "DOWN" then
				    grid[sty+1][stx].visited = true
				    grid[sty][stx].bottom_wall = false
				    unvisited_cells = unvisited_cells - 1
				    sty = sty + 1
				elseif dir == "LEFT" then
				    grid[sty][stx-1].visited = true
				    grid[sty][stx-1].right_wall = false
				    unvisited_cells = unvisited_cells - 1
				    stx = stx - 1
				elseif dir == "RIGHT" then
				    grid[sty][stx+1].visited = true
				    grid[sty][stx].right_wall = false
				    unvisited_cells = unvisited_cells - 1
				    stx = stx + 1
				end
			end
		end

		local dir = mod.dirs[math.random(1, 4)]
		if dir == "UP" then -- UP
			if ry-1 >= y1 then
				grid[ry][rx].dir = "UP"
				ry = ry-1
			end
		elseif dir == "DOWN" then -- DOWN 
			if ry+1 <= y2 then 
				grid[ry][rx].dir = "DOWN"
				ry = ry+1
			end
		elseif dir == "RIGHT" then -- RIGHT
			if rx+1 <= x2 then
				grid[ry][rx].dir = "RIGHT"
				rx = rx+1
			end
		elseif dir == "LEFT" then -- LEFT
			if rx-1 >= x1 then
				grid[ry][rx].dir = "LEFT"
				rx = rx-1
			end
		end
	end
end

return mod
