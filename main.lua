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

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor( 255, 255, 255 )
  
  r,g,b = 1, 1, 1
  CONTROL = 0

  love.window.setMode( 1920, 1080, windowed, false, 0 )
  window_w, window_h = love.graphics.getDimensions()
  
  columns, rows = 1920, 1080
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
 	-- mGrid = recursivedivision.createMaze(1, 1, columns, rows, 1)
 	-- mGrid = binarytree.createMaze(1, 1, columns, rows)
  -- mGrid = sidewinder.createMaze(1, 1, columns, rows)
 	-- mGrid = huntandkill.createMaze(1, 1, columns, rows)
 	-- mGrid = backtracking.createMaze(1, 1, columns, rows)
 	-- mGrid = aldous_broder.createMaze(1, 1, columns, rows)
 	-- mGrid = wilson.createMaze(1, 1, columns, rows)
 	-- mGrid = prim.createMaze(1, 1, columns, rows)
 	mGrid = kruskal.createMaze(1, 1, columns, rows)
 	-- mGrid = eller.createMaze(1, 1, columns, rows)
 	local t2 = os.clock()
  print(t2-t1)

  mat = dijkstra.generateMatrice(1, 1, columns, rows, mGrid, 960, 540)

  -- for _, v in pairs(mat) do
  -- 	for _, xv in pairs(v) do
  -- 		io.write(xv.distance, " ")
  -- 	end
  -- 	print()
  -- end

  tt = {}
  local adds = 100
  for i = 1, rows*columns do 
  		tt[i] = adds
  		adds = adds + 0.1
  		if adds == 255 then adds = 0 end
  end



	canvas = love.graphics.newCanvas(window_w, window_h)
	love.graphics.setCanvas(canvas)
	for y = 1, rows do
		--[[ local temp = math.floor((CONTROL - y*rows)/rows)
		if temp >= 1 then SOMEVARX = columns else SOMEVARX = CONTROL%rows end --]]
		for x = 1, columns do
			-- love.graphics.setColor(0,255,0) love.graphics.rectangle("fill", ox+w*3/8+w*x, oy+h*3/8+h*y, w*2/8, h*2/8)
			-- r, g, b = 255, 255, 255
			r, g, b = mat[y][x].r, mat[y][x].g, mat[y][x].b
			love.graphics.setColor(r,g,b, 255)
			love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h)
			for k, v in pairs ( vertfromwalls(ox+(w*(x-1)), oy+(h*(y-1)), mGrid[y][x]) ) do
				r, g, b = 0, 0, 0
				-- r, g, b = tt[(y-1)*rows+x], 0, 0
				-- love.graphics.setColor(r,g,b)
				-- love.graphics.setLineWidth(1)
				-- love.graphics.line(v)
			end
			-- for k, v in pairs(end_paths) do love.graphics.setColor(0,255,0) love.graphics.rectangle("fill", ox+w*3/8+w*v.x, oy+h*3/8+h*v.y, w*2/8, h*2/8) end
		end
	end
	data = canvas:newImageData(0, 0, window_w, window_h)
	filedata = data:encode( "png", "imagezzzzzzzz.png" )
	print(success)
	love.graphics.setCanvas()


  love.event.quit()
  -- end_paths = backtracking_search.findExit(mGrid, 1, 1, 30, 30, columns, rows)
	
	-- recursivedivision.createAliensWritings(mGrid, 0, 0, columns-1, rows-1)
end

function love.update(dt)
	-- love.timer.sleep(0)
	if CONTROL ~= columns*rows+columns then CONTROL = CONTROL + 1 end
end

function love.draw()
	-- if GRID_TYPE == "squares" then -- Only for Eight Queen Problem
	-- 	for y = 0, rows-1 do
	-- 		for x = 0, columns-1 do
	-- 			if mGrid[y][x] == 1 then love.graphics.setColor(1, 1, 1) else love.graphics.setColor(255, 255, 255) end
	-- 			love.graphics.rectangle("fill", ox+(w*x), oy+(h*y), w, h)
	-- 		end
	-- 	end
	-- else -- Uses for all mazes
	-- 	if GRID_TYPE == "walls" then
	-- 		-- love.graphics.line({0, 0, 0, height})
	-- 		--[[ local SOMEVARY
	-- 		if CONTROL <= columns*rows then SOMEVARY = math.floor(CONTROL/rows) else SOMEVARY = columns end 
	-- 		if y == 0 then y = 1 end --]]
	-- 		for y = 1, rows do
	-- 			--[[ local temp = math.floor((CONTROL - y*rows)/rows)
	-- 			if temp >= 1 then SOMEVARX = columns else SOMEVARX = CONTROL%rows end --]]
	-- 			for x = 1, columns do
	-- 				-- love.graphics.setColor(0,255,0) love.graphics.rectangle("fill", ox+w*3/8+w*x, oy+h*3/8+h*y, w*2/8, h*2/8)
	-- 				-- r, g, b = 255, 255, 255
	-- 				r, g, b = mat[y][x].r, mat[y][x].g, mat[y][x].b
	-- 				love.graphics.setColor(r,g,b, 255)
	-- 				love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h)
	-- 				for k, v in pairs ( vertfromwalls(ox+(w*(x-1)), oy+(h*(y-1)), mGrid[y][x]) ) do
	-- 					r, g, b = 60, 60, 60
	-- 					-- r, g, b = tt[(y-1)*rows+x], 0, 0
	-- 					love.graphics.setColor(r,g,b)
	-- 					-- love.graphics.setLineWidth(1)
	-- 					-- love.graphics.line(v)
	-- 				end
	-- 				-- for k, v in pairs(end_paths) do love.graphics.setColor(0,255,0) love.graphics.rectangle("fill", ox+w*3/8+w*v.x, oy+h*3/8+h*v.y, w*2/8, h*2/8) end
	-- 			end
	-- 		end 
	-- 	end
	-- end
end
