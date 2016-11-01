local mod = {}
local aux = {}

mod.width = 0x1
mod.height = 0x1
mod.room_size = 0x1
aux.grid = 0x1

--[[
TODO: 
Rewrite Recursive divison and figure out with weird constants
]]

function mod.createGrid (rows, columns)
  local MazeGrid = {}
  local color = 0

  for y = 0, rows-1 do 
    MazeGrid[y] = {}
    for x = 0, columns-1 do
        MazeGrid[y][x] = {bottom_wall = false, right_wall = false} -- Wall grid
    end
  end  
  return MazeGrid
end

function mod.createMaze(grid, x1, y1, x2, y2, room_size)
  if mod.room_size == 0x1 then if room_size >= 1 then mod.room_size = room_size-2 else mod.room_size = 0 end end
  if y2 - y1 > mod.room_size and x2 - x1 > mod.room_size then
      if mod.width == 0x1 or mod.height == 0x1 then 
        mod.width = x2 mod.height = y2 
      end
  end

  local ox, oy = math.random(x1 + 1, x2 - 1), math.random(y1 + 1, y2 - 1)

  if x2 - x1 > y2 - y1 then 
    mod.aux.add_vertical_wall()
  elseif x2 - x1 == y2 - y1 then
  
  else

  end
end

-- function aux.add_horizontal_wall(grid, x1, x2, ox, oy)
--   for x = x1, x2 do
--         grid[oy][x].bottom_wall = true
--   end
--   if x2+1 < mod.width then 
--   grid[oy][x2+1].bottom_wall = true
--   grid[oy][math.random(x1, x2+1)].bottom_wall = false
--     else 
--       grid[oy][math.random(x1, x2)].bottom_wall = false end
-- end

-- function aux.add_vertical_wall(grid, y1, y2, ox, oy)
--   for y = y1, y2 do
--       grid[y][ox].right_wall = true
--   end
--   if y2+1 < mod.height then 
--   grid[y2+1][ox].right_wall = true 
--   grid[math.random(y1, y2+1)][ox].right_wall = false 
--     else 
--       grid[math.random(y1, y2)][ox].right_wall = false end
-- end

-- function mod.createMaze(grid, x1, y1, x2, y2, room_size)
--   if mod.room_size == -2 then if room_size >= 1 then mod.room_size = room_size-2 else mod.room_size = 0 end end
--     if y2 - y1 > mod.room_size and x2 - x1 > mod.room_size then
--       if mod.width == 0 or mod.height == 0 then mod.width = x2 mod.height = y2 end

--       local ox = math.random(x1, x2)
--       local oy = math.random(y1, y2)

--       if x2 - x1 > y2 - y1 then 
--         aux.add_vertical_wall(grid, y1, y2, ox, oy)
--         mod.createMaze(grid, x1, y1, ox - 1, y2)
--         mod.createMaze(grid, ox + 1, y1, x2, y2)
--         else 
--           if x2 - x1 == y2 - y1 then
--             if math.random(0,1) == 0 then
--               aux.add_horizontal_wall(grid, x1, x2, ox, oy) 
--               mod.createMaze(grid, x1, y1, x2, oy - 1)
--               mod.createMaze(grid, x1, oy + 1, x2, y2)
--             else 
--               aux.add_vertical_wall(grid, y1, y2, ox, oy)
--               mod.createMaze(grid, x1, y1, ox - 1, y2)
--               mod.createMaze(grid, ox + 1, y1, x2, y2) 
--             end
--           else 
--             aux.add_horizontal_wall(grid, x1, x2, ox, oy) 
--             mod.createMaze(grid, x1, y1, x2, oy - 1)
--             mod.createMaze(grid, x1, oy + 1, x2, y2)
--           end
--       end
--     end
-- end

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
