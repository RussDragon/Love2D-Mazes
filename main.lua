--[[
TODO:
1. Recursive Backtracker - Done
2. Recursive Division – Done
3. Binary Tree – Done
4. Sidewinder – Done
5. HuntandKill – Done
6. Growing Tree (or recursive backtracker on loops) - Done
7. Aldous-Broder – Done
8. Wilson – Done
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

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    love.graphics.setBackgroundColor( 255, 255, 255 )
    
    -- flag = true
    r,g,b = 1, 1, 1

    love.window.setMode( 900, 900, windowed, false, 0 )
    window_w, window_h = love.graphics.getDimensions()
    
    columns, rows = 30, 30
    ox, oy = 0, 0 -- Начальные координаты, левый верхний угол
    w, h = window_w / columns, window_h / rows
    -- w, h = 20, 20

    title = tostring(window_w) .. " x " .. tostring(window_h)
    love.window.setTitle(title)
    
    math.randomseed(os.time())
    for i = 1, 20 do  
    	math.random(1, 1000)
    end

    -- mGrid = recursivedivision.createGrid(rows, columns)
    mGrid = recursivedivision.createGrid(rows, columns)

    local t1 = os.clock()
    -- backtracking.createMaze(mGrid, 0, 0, columns, rows)
   	recursivedivision.createMaze(mGrid, 0, 0, columns-1, rows-1, 1)
   	-- binarytree.createMaze(mGrid, 0, 0, columns-1, rows-1)
    -- sidewinder.createMaze(mGrid, 0, 0, columns-1, rows-1)
   	-- huntandkill.createMaze(mGrid, 0, 0, columns, rows)
   	-- backtracking.createMazeLoops(mGrid, 0, 0, columns, rows)
   	-- aldous_broder.createMaze(mGrid, 0, 0, columns-1, rows-1)
   	-- wilson.createMaze(mGrid, 0, 0, columns-1, rows-1)
   	local t2 = os.clock()
    print(t2-t1)
   	-- end_paths = backtracking_search.findExit(mGrid, 0, 0, 30, 30, columns, rows)
	
	-- recursivedivision.createAliensWritings(mGrid, 0, 0, columns-1, rows-1)
end

function love.update(dt)
end

local function vertfromwalls(x, y, t)
	local vert = {}

	if t.bottom_wall == true then vert.bottom_wall = {x, y+h, x+w, y+h} end
	if t.right_wall == true then vert.right_wall = {x+w, y, x+w, y+h} end

	return vert
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
			-- love.graphics.line({0, 0, 0, height})
			for y = 0, rows-1 do
				for x = 0, columns-1 do
					for k, v in pairs ( vertfromwalls(ox+(w*x), oy+(h*y), mGrid[y][x]) ) do   
						love.graphics.setColor(r,g,b)
						love.graphics.line(v)
					end
					-- for k, v in pairs(end_paths) do love.graphics.setColor(0,255,0) love.graphics.rectangle("fill", ox+w*3/8+w*v.x, oy+h*3/8+h*v.y, w*2/8, h*2/8) end
				end
			end 
		end
	end
end
