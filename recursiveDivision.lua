
local mod = {}
local aux = {}

aux.width = false
aux.height = false
aux.sx = false
aux.sy = false
aux.grid = false
aux.room_size = false

function aux.createGrid (rows, columns)
  local MazeGrid = {}

  for y = 1, rows do 
    MazeGrid[y] = {}
    for x = 1, columns do
        MazeGrid[y][x] = {bottom_wall = false, right_wall = false} -- Wall grid
    end
  end  
  return MazeGrid
end

function aux.add_horizontal_wall(x1, x2, oy)
  for x = x1, x2 do
        aux.grid[oy][x].bottom_wall = true
  end 
  aux.grid[oy][math.random(x1, x2)].bottom_wall = false 
end

function aux.add_vertical_wall(y1, y2, ox)
  for y = y1, y2 do
      aux.grid[y][ox].right_wall = true
  end
  aux.grid[math.random(y1, y2)][ox].right_wall = false
end

function aux.divide(x1, y1, x2, y2) 
  local ratio = math.random(1, 3)
  if x2 - x1 >= math.ceil(aux.room_size/ratio) and y2 - y1 >= math.ceil(aux.room_size/ratio) then
    local ox, oy = math.random(x1, x2 - 1), math.random(y1, y2 - 1)
    if x2 - x1 > y2 - y1 then 
      aux.add_vertical_wall(y1, y2, ox)
      aux.divide(x1, y1, ox, y2)
      aux.divide(ox + 1, y1, x2, y2)
    elseif x2 - x1 < y2 - y1 then
      aux.add_horizontal_wall(x1, x2, oy)
      aux.divide(x1, y1, x2, oy)
      aux.divide(x1, oy + 1, x2, y2)
    elseif x2 - x1 == y2 - y1 then
      if math.random(0, 1) == 0 then
        aux.add_vertical_wall(y1, y2, ox)
        aux.divide(x1, y1, ox, y2)
        aux.divide(ox + 1, y1, x2, y2)
      else 
        aux.add_horizontal_wall(x1, x2, oy)
        aux.divide(x1, y1, x2, oy)
        aux.divide(x1, oy + 1, x2, y2)
      end
    end
  end
end

function mod.createMaze(x1, y1, x2, y2, room_size, grid)
  aux.grid = grid or aux.createGrid(y2, x2)
  aux.width = x2 aux.height = y2 
  aux.sx, aux.sy = x1, y1

  if room_size > 0 then 
    aux.room_size = room_size
  else
    aux.room_size = 1
  end

  aux.divide(x1, y1, x2, y2)
  return aux.grid
end

-- Mystic Writing Generator, for real
-- function mod.createGrid (rows, columns)
--   local MazeGrid = {}
--   local color = 0

--   for y = 0, rows-1 do 
--     MazeGrid[y] = {}
--     for x = 0, columns-1 do
--         MazeGrid[y][x] = 0 -- Wall grid
--     end
--   end  
--   return MazeGrid
-- end

-- function aux.add_horizontal_wall(grid, x1, x2, oy)
--   for x = x1, x2 do
--         grid[oy][x] = 1
--   end
-- end

-- function aux.add_vertical_wall(grid, y1, y2, ox)
--   for y = y1, y2 do
--       grid[y][ox] = 1
--   end
-- end

-- function mod.createAliensWritings(grid, x1, y1, x2, y2)
--   if y2 - y1 > 2 and x2 - x1 > 2 then

--     local ox = math.random(x1 + 1, x2 - 1)
--     local oy = math.random(y1 + 1, y2 - 1)

--     if x2-x1 > y2-y1 then 
--       aux.add_vertical_wall(grid, y1, y2, ox)
--       mod.createAliensWritings(grid, x1 + 1, y1 + 1, ox - 1, y2 - 1)
--       mod.createAliensWritings(grid, ox + 1, y1 + 1, x2 - 1, y2 - 1)

--       else if x2-x1 == y2-y1 then
--         if math.random(0,1) == 0 then
--           aux.add_horizontal_wall(grid, x1, x2, oy) 
--           mod.createAliensWritings(grid, x1 + 1, y1 + 1, x2 - 1, oy - 1)
--           mod.createAliensWritings(grid, x1 + 1, oy + 1, x2 - 1, y2 - 1)
--         else 
--           aux.add_vertical_wall(grid, y1, y2, ox)
--           mod.createAliensWritings(grid, x1 + 1, y1 + 1, ox - 1, y2 - 1)
--           mod.createAliensWritings(grid, ox + 1, y1 + 1, x2 - 1, y2 - 1) 
--         end
--       else 
--         aux.add_horizontal_wall(grid, x1, x2, oy) 
--         mod.createAliensWritings(grid, x1 + 1, y1 + 1, x2 - 1, oy - 1)
--         mod.createAliensWritings(grid, x1 + 1, oy + 1, x2 - 1, y2 - 1)
--       end
--     end
--   end
-- end

return mod
