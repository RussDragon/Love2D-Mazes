local mod = {}
local aux = {}

-- Only for understanding backtrack

function aux.isSafe(table, row, col)
	for i = 0, col-1 do 
		if table[row][i] == 2 then return false end
	end -- Слева направо

	local r, c = row, col
	while (r >= 0 and c >= 0) do 
		if table[r][c] == 2 then 
			return false end 
			r = r - 1 c = c - 1 
	end -- Диагональ налево вверх

	r, c = row, col
	while (c >= 0 and r <= 7) do 
		if table[r][c] == 2 then 
			return false end 
			r = r + 1 c = c - 1 
		end

		return true
end -- Диагональ налево вниз

local function mod.solveEQ(table_s, col)
	if col >= 8 then return true end

	for i = 0, 7 do 
		if aux.isSafe(table_s, i, col) then 
			table_s[i][col] = 2 
			if mod.solveEQ(table_s, col + 1) then return true end
			table_s[i][col] = 0
		end
	end 
	return false 
end

return mod
