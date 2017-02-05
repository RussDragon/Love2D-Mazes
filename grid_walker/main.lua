local cursor = {
	posx = 1,
	posy = 1
}

point = true
function createGrid (rows, columns)
	local MazeGrid = {}
	
	for y = 1, rows do 
		MazeGrid[y] = {}
		for x = 1, columns do
			MazeGrid[y][x] = {bottom_wall = true, right_wall = true, isFront = false} -- Wall grid
		end
	end  
	return MazeGrid
end


local function vertfromwalls(x, y, t)
	local vert = {}

	if t.bottom_wall == true then vert.bottom_wall = {x, y+h, x+w, y+h} end
	if  t.right_wall == true then vert.right_wall = {x-1+w, y, x-1+w, y+h} end -- -1 is for fixing weird pixels out of the walls

	return vert
end

NameC = 0
local function createPNG()
	local canvas = love.graphics.newCanvas(window_w, window_h)
	love.graphics.setCanvas(canvas)

	for y = 1, rows do
		for x = 1, columns do
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h) 

			if grid[y][x].isFront == true then 
				love.graphics.setColor(255, 0, 0, 70)
				love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h) 
			end
			-- if point then
			-- 	love.graphics.setColor(0, 255, 0, 10) 
			-- 	-- love.graphics.rectangle("fill", ox+(1/4*w+w*(x-1)), oy+(1/4*h+h*(y-1)), w/2, h/2) 
			-- 	love.graphics.rectangle("fill", ox+(w*(cursor.posx-1)), oy+(h*(cursor.posy-1)), w, h)
			-- end

			for k, v in pairs ( vertfromwalls(ox+(w*(x-1)), oy+(h*(y-1)), grid[y][x]) ) do
				local r, g, b = 0, 0, 0
				love.graphics.setColor(r, g, b)
				love.graphics.setLineWidth(1)
				love.graphics.line(v)
			end
		end
	end 

	love.graphics.line(ox, oy+1, window_w, oy+1) -- Borders on the top and left
	love.graphics.line(ox+1, oy, ox+1, window_h)
	love.graphics.line(window_w-1, oy, window_w-1, window_h)
	love.graphics.line(ox, window_h-2, window_w, window_h-2)

	local data = canvas:newImageData(0, 0, window_w, window_h)
	data:encode( "png", "colored_maze" .. NameC .. ".png" )
	NameC = NameC + 1
	love.graphics.setCanvas()
end

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255, 255)

	-- love.window.setMode( 386, 390, windowed, false, 0 )
  love.window.setMode( 386, 390, windowed, false, 0 )
  window_w, window_h = love.graphics.getDimensions()
  
  columns, rows = 4, 4
  ox, oy = 0, 0 -- Начальные координаты, левый верхний угол
  w, h = window_w / columns, window_h / rows
  -- w, h = 10, 10

  grid = createGrid(rows, columns)
end

local function updateFront(bool)
	grid[cursor.posy][cursor.posx].isFront = bool
	-- if cursor.posx-1 >= 1 and grid[cursor.posy][cursor.posx-1].right_wall then grid[cursor.posy][cursor.posx-1].isFront = bool end
	-- if cursor.posx+1 <= columns and grid[cursor.posy][cursor.posx].right_wall then grid[cursor.posy][cursor.posx+1].isFront = bool end
	-- if cursor.posy-1 >= 1 and grid[cursor.posy-1][cursor.posx].bottom_wall then grid[cursor.posy-1][cursor.posx].isFront = bool end
	-- if cursor.posy+1 <= rows and grid[cursor.posy][cursor.posx].bottom_wall then grid[cursor.posy+1][cursor.posx].isFront = bool end
end

function love.update(dt)
	if love.keyboard.isDown("space") then updateFront((not grid[cursor.posy][cursor.posx].isFront)) end
	if love.keyboard.isDown("o") then point = not point end

	if love.keyboard.isDown("down") and cursor.posy+1 <= rows then
		-- updateFront(false)
		grid[cursor.posy][cursor.posx].bottom_wall = false 
		-- cursor.posy = cursor.posy + 1

	elseif love.keyboard.isDown("up") and cursor.posy-1 >= 1 then
		-- updateFront(false)
		grid[cursor.posy-1][cursor.posx].bottom_wall = false 
		-- cursor.posy = cursor.posy - 1

	elseif love.keyboard.isDown("right") and cursor.posx+1 <= columns then 
		-- updateFront(false)
		grid[cursor.posy][cursor.posx].right_wall = false 
		-- cursor.posx = cursor.posx + 1

	elseif love.keyboard.isDown("left") and cursor.posx-1 >= 1 then 	
		-- updateFront(false)
		grid[cursor.posy][cursor.posx-1].right_wall = false 
		-- cursor.posx = cursor.posx - 1

	elseif love.keyboard.isDown("s") and cursor.posy+1 <= rows then
		-- updateFront(false)
		-- cursor.posx = 1
		cursor.posy = cursor.posy + 1
	
	elseif love.keyboard.isDown("w") and cursor.posy-1 >= 1 then
		-- updateFront(false)
		-- cursor.posx = 1
		cursor.posy = cursor.posy - 1
	
	elseif love.keyboard.isDown("a") and cursor.posx-1 >= 1 then
		-- updateFront(false)
		cursor.posx = cursor.posx - 1
	
	elseif love.keyboard.isDown("d") and cursor.posx+1 <= columns then
		-- updateFront(false)
		cursor.posx = cursor.posx + 1
	end

	if love.keyboard.isDown("p") then
		createPNG()
	end

	-- updateFront(true)
	love.timer.sleep(0.1)
end

function love.draw()
	for y = 1, rows do
		for x = 1, columns do
			if grid[y][x].isFront == true then 
				love.graphics.setColor(255, 0, 0, 70)
				love.graphics.rectangle("fill", ox+(w*(x-1)), oy+(h*(y-1)), w, h) 
			end

			if point then
				love.graphics.setColor(0, 255, 0, 10) 
				-- love.graphics.rectangle("fill", ox+(1/4*w+w*(x-1)), oy+(1/4*h+h*(y-1)), w/2, h/2) 
				love.graphics.rectangle("fill", ox+(w*(cursor.posx-1)), oy+(h*(cursor.posy-1)), w, h)
				-- love.graphics.rectangle("fill", ox+(1/10*w+w*(cursor.posx-1)), oy+(1/10*h+h*(cursor.posy-1)), w*8/10, h*8/10)
			end

			for k, v in pairs ( vertfromwalls(ox+(w*(x-1)), oy+(h*(y-1)), grid[y][x]) ) do
				local r, g, b = 0, 0, 0
				love.graphics.setColor(r, g, b)
				love.graphics.setLineWidth(1)
				love.graphics.line(v)
			end
		end
	end 

	love.graphics.line(ox, oy+1, window_w, oy+1) -- Borders on the top and left
	love.graphics.line(ox+1, oy, ox+1, window_h)
	love.graphics.line(window_w-1, oy, window_w-1, window_h)
	love.graphics.line(ox, window_h-2, window_w, window_h-2)
end
