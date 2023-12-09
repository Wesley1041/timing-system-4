local helper = {}

--- Get the current players data in the form of a list
---@param data table Raw timing data
---@return table list Data as list
function helper:GetSortedData(data: table)

	local list = {}

	for _, userData in pairs(data) do
		table.insert(list, userData)
	end

	-- Sort list
	table.sort(list, ComparePlayerData)

	return list

end

--- Compares two player data instances to determine which one is higher than the other
---@param player1 table Player data
---@param player2 table Player data
---@return boolean result True if player 1 should be above player 2
function ComparePlayerData(player1: table, player2: table): boolean
	if player1.BestLap.LapTime == nil and player2.BestLap.LapTime == nil then 
		return player1.UserId > player2.UserId
	end
	if player1.BestLap.LapTime == nil and player2.BestLap.LapTime ~= nil then return false end
	if player1.BestLap.LapTime ~= nil and player2.BestLap.LapTime == nil then return true end
	if player2.BestLap.LapTime >= player1.BestLap.LapTime then return true end
	return false

end

return helper