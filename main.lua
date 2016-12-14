--[[
Progress:
1. Recursive Backtracker - Done
2. Recursive Division – Done
3. Binary Tree – Done
4. Sidewinder – Done
5. HuntandKill – Done
6. Growing Tree (or recursive backtracker on loops) - Done
7. Aldous-Broder – Done
8. Wilson – Done
9. Prim – Done
10. Kruskal – Done
11. Eller – WIP
]]

local GRID_TYPE = "walls" --squares --walls
local backtracking = require("backtracking")
local recursivedivision = require("recursiveDivision")
local binarytree = require("binarytree")
local sidewinder = require("sidewinder")
local huntandkill = require("huntandkill")
local backtracking_search = require("backtracker_search")
local aldous_broder = require("aldous_broder")
local wilson = require("wilson")
local prim = require("prim")
local kruskal = require("kruskal")
local eller = require("eller")
local dijkstra = require("dijkstra")

local function vertfromwalls(x, y, t)
	local vert = {}

	if t.bottom_wall == true then vert.bottom_wall = {x, y+h, x+w, y+h} end
	if t.right_wall == true then vert.right_wall = {x+w, y, x+w, y+h} end

	return vert
end

local function createPNG()
	canvas = love.graphics.newCanvas(window_w, window_h)
	love.graphics.setCanvas(canvas)
	for y = 1, rows do
		for x = 1, columns do
			r, g, b = mat[y][x].r, mat[y][x].g, mat[y][x].b
			love.graphics.setColor(r,g,b, 255)
			love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h)
			for k, v in pairs ( vertfromwalls(ox+(w*(x-1)), oy+(h*(y-1)), mGrid[y][x]) ) do
				-- -- r, g, b = 0, 0, 0
				-- love.graphics.setColor(r,g,b)
				-- love.graphics.setLineWidth(1)
				-- love.graphics.line(v)
			end
		end
	end

	data = canvas:newImageData(0, 0, window_w, window_h)
	data:encode( "png", "colored_maze.png" )
	print(success)
	love.graphics.setCanvas()
end

local function colorizeByDistance(maxDist, curDist)
	local version = 1
	local r, g, b = 0, 0, 0
	
	if version == 1 then
		local saturation = (maxDist - curDist)/maxDist
		local dark, bright = 255*saturation, 128 + 127*saturation
		r, g, b = dark, dark, dark
	
	elseif version == 2 then
		local color = (maxDist-curDist)/maxDist*767
		local color1 = 255-color%256
		local color2 = color%256

		if color < 256 then
			r = color1
			g = color2
			b = 0
		elseif color < 512 then
			g = color1
			b = color2
			r = 0
		else
			b = color1
			r = color2
			g = 0
		end
	end
	return r, g, b
end

-- function color_maze(maze)
-- 	local front = {}
-- 		for _, v in pairs(front) do
-- 			if v == "UP" and iy - 1 >= aux.oy then
-- 				aux.matrice[iy - 1][ix].distance = aux.matrice[iy][ix].distance + 1
-- 				if aux.matrice[iy][ix].b > 0 and multicolor then
-- 					aux.matrice[iy - 1][ix].b = aux.matrice[iy][ix].b - 10
-- 					aux.matrice[iy - 1][ix].r = aux.matrice[iy][ix].r + 10
-- 					elseif multicolor then 
-- 					aux.matrice[iy - 1][ix].r = aux.matrice[iy][ix].r - 10
-- 					aux.matrice[iy - 1][ix].g = aux.matrice[iy][ix].g + 10
-- 				else 
-- 					aux.matrice[iy - 1][ix].b = aux.matrice[iy][ix].b - 0.12
-- 				end
-- 			elseif v == "DOWN" and iy + 1 <= aux.height then 
-- 				aux.matrice[iy + 1][ix].distance = aux.matrice[iy][ix].distance + 1
-- 				if aux.matrice[iy][ix].b > 0 and multicolor then
-- 					aux.matrice[iy + 1][ix].b = aux.matrice[iy][ix].b - 10
-- 					aux.matrice[iy + 1][ix].r = aux.matrice[iy][ix].r + 10
-- 				elseif multicolor then
-- 					aux.matrice[iy + 1][ix].r = aux.matrice[iy][ix].r - 10
-- 					aux.matrice[iy + 1][ix].g = aux.matrice[iy][ix].g + 10
-- 				else
-- 					aux.matrice[iy + 1][ix].b = aux.matrice[iy][ix].b - 0.12 
-- 				end
-- 			elseif v == "RIGHT" and ix + 1 <= aux.width then 
-- 				aux.matrice[iy][ix + 1].distance = aux.matrice[iy][ix].distance + 1
-- 				if aux.matrice[iy][ix].b > 0 and multicolor then
-- 					aux.matrice[iy][ix + 1].b = aux.matrice[iy][ix].b - 10
-- 					aux.matrice[iy][ix + 1].r = aux.matrice[iy][ix].r + 10
-- 				elseif multicolor then 
-- 					aux.matrice[iy][ix + 1].r = aux.matrice[iy][ix].r - 10
-- 					aux.matrice[iy][ix + 1].g = aux.matrice[iy][ix].g + 10
-- 				else
-- 					aux.matrice[iy][ix + 1].b = aux.matrice[iy][ix].b - 0.12 
-- 				end
-- 			elseif v == "LEFT" and ix - 1 >= aux.ox then 
-- 				aux.matrice[iy][ix - 1].distance = aux.matrice[iy][ix].distance + 1
-- 				if aux.matrice[iy][ix].b > 0 and multicolor then
-- 					aux.matrice[iy][ix - 1].b = aux.matrice[iy][ix].b - 0.0013
-- 					aux.matrice[iy][ix - 1].r = aux.matrice[iy][ix].r + 0.0013
-- 				elseif multicolor then 
-- 					aux.matrice[iy][ix - 1].r = aux.matrice[iy][ix].r - 0.0013
-- 					aux.matrice[iy][ix - 1].g = aux.matrice[iy][ix].g + 0.0013
-- 				else
-- 					aux.matrice[iy][ix - 1].b = aux.matrice[iy][ix].b - 0.12 
-- 				end
-- 			end
-- 		end
-- end


function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor( 255, 255, 255 )
  
  r,g,b = 1, 1, 1
  CONTROL = 0

  love.window.setMode( 900, 900, windowed, false, 0 )
  window_w, window_h = love.graphics.getDimensions()
  
  columns, rows = 100, 100
  ox, oy = 0, 0 -- Начальные координаты, левый верхний угол
  w, h = window_w / columns, window_h / rows
  -- w, h = 20, 20

  title = tostring(window_w) .. " x " .. tostring(window_h)
  love.window.setTitle(title)
  
  math.randomseed(os.time())
  for i = 1, 20 do  
  	math.random(1, 1000)
  end

  local t1 = os.clock()
 	-- mGrid = recursivedivision.createMaze(1, 1, columns, rows, 5)
 	-- mGrid = binarytree.createMaze(1, 1, columns, rows)
  -- mGrid = sidewinder.createMaze(1, 1, columns, rows)
 	-- mGrid = huntandkill.createMaze(1, 1, columns, rows)
 	mGrid = backtracking.createMaze(1, 1, columns, rows)
 	-- mGrid = aldous_broder.createMaze(1, 1, columns, rows)
 	-- mGrid = wilson.createMaze(1, 1, columns, rows)
 	-- mGrid = prim.createMaze(1, 1, columns, rows)
 	-- mGrid = kruskal.createMaze(1, 1, columns, rows)
 	-- mGrid = eller.createMaze(1, 1, columns, rows)
 	local t2 = os.clock()
  print(t2-t1)

  mat, maxDist = dijkstra.generateMatrice(1, 1, columns, rows, mGrid, 1, 1)
  print(maxDist)

  -- for _, v in pairs(mat) do
  -- 	for _, xv in pairs(v) do
  -- 		io.write(xv.distance, " ")
  -- 	end
  -- 	print()
  -- end

  -- createPNG()
  -- love.event.quit()
  -- end_paths = backtracking_search.findExit(mGrid, 1, 1, 30, 30, columns, rows)
	
	-- recursivedivision.createAliensWritings(mGrid, 0, 0, columns-1, rows-1)
end

function love.update(dt)
	-- love.timer.sleep(0)
	if CONTROL ~= columns*rows+columns then CONTROL = CONTROL + 1 end
end

function love.draw()
	if GRID_TYPE == "squares" then -- Only for Eight Queen Problem
		for y = 0, rows-1 do
			for x = 0, columns-1 do
				if mGrid[y][x] == 1 then love.graphics.setColor(1, 1, 1) else love.graphics.setColor(255, 255, 255) end
				love.graphics.rectangle("fill", ox+(w*x), oy+(h*y), w, h)
			end
		end
	else -- Uses for all mazes
		if GRID_TYPE == "walls" then
			--[[ local SOMEVARY
			if CONTROL <= columns*rows then SOMEVARY = math.floor(CONTROL/rows) else SOMEVARY = columns end 
			if y == 0 then y = 1 end --]]
			for y = 1, rows do
				--[[ local temp = math.floor((CONTROL - y*rows)/rows)
				if temp >= 1 then SOMEVARX = columns else SOMEVARX = CONTROL%rows end --]]
				for x = 1, columns do
					-- r, g, b = 255, 255, 255
					r, g, b = colorizeByDistance(maxDist, mat[y][x].distance)
					love.graphics.setColor(r,g,b, 255)
					love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h)
					for k, v in pairs ( vertfromwalls(ox+(w*(x-1)), oy+(h*(y-1)), mGrid[y][x]) ) do
						r, g, b = 0, 0, 0
						love.graphics.setColor(r,g,b)
						love.graphics.setLineWidth(2)
						love.graphics.line(v)
					end
				end
			end 
		end
	end
end
