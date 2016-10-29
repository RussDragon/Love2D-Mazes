local mod = {}
local aux = {}

function mod.createGrid (rows, columns)
	local MazeGrid = {}
	local color = 0

	for y = 0, rows-1 do 
		MazeGrid[y] = {}
		for x = 0, columns-1 do
			MazeGrid[y][x] = {bottom_wall = true, right_wall = true} -- Wall grid
		end
	end  
	return MazeGrid
end

-- Binary Tree North-East variant 
function mod.createMaze(grid, x1, y1, x2, y2)
	if x2 > 0 and y2 > 0 and x1 < x2 and y1 < y2 then
		for y = y1, y2 do 
			for x = x1, x2 do
				if y ~= y1 then 
					if math.random(0, 1) == 0 then 
						if x ~= x2 then 
							grid[y][x].right_wall = false
						else
							grid[y-1][x].bottom_wall = false
						end
					else
						grid[y-1][x].bottom_wall = false
					end
				else
					if x ~= x2 then
						grid[y][x].right_wall = false
					end
				end
			end
		end
	end
end

return mod
