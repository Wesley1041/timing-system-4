local service = {}

-- Modules
local PlayerData = require(script.Parent.Parent.DataModels.PlayerData)
local LapTime = require(script.Parent.Parent.DataModels.LapTime)
local State = require(script.Parent.Parent.DataModels.State)

local _config = require(script.Parent.Parent._Config)
local _leaderstatsService = require(script.Parent.TimingLeaderstatsService)
local _dataHelpers = require(script.Parent.Parent.Modules.TimingDataHelpers)

-- Variables
local data = {}
local bestTime = {
	DisplayName = nil,
	Sectors = LapTime.new(),
	Lap = LapTime.new()
}

--- Updates the sector time of a player
---@param player Player The player whose time should be updated
---@param sector number The sector that should be updated
---@param sectorTime number The sector time
---@param isValid boolean Whether the sector time is valid
function service:UpdateSector(player: Player, sector: number, sectorTime: number, isValid: boolean)
	
	local playerData = data[player.UserId]
	
	-- If the player data does not exist, return
	if playerData == nil then
		playerData = service:AddPlayer(player)
	end
	
	-- Determine state
	local state = DetermineState(
		sectorTime, 
		playerData.BestLap:GetSector(sector).Time, 
		bestTime.Sectors:GetSector(sector).Time, 
		isValid
	)
	
	-- Update sector time
	if sector == 1 then
		local previousLap = playerData.CurrentLap
		playerData.CurrentLap = LapTime.new()
		playerData.CurrentLap.LapTime = previousLap.LapTime
		playerData.CurrentLap.State = previousLap.State
	end
	playerData.CurrentLap:SetSector(sector, sectorTime, state)
	
	-- Update overall best
	if state == State.OverallBest then
		UpdateBestSector(sector, playerData)
	end
	
end

--- Updates and adds a lap of the player
---@param player Player The player whose lap should be updated
---@param lapTime number The lap time of the player
---@param isValid boolean Whether the lap time is valid
function service:UpdateLap(player: Player, lapTime: number, isValid: boolean)
	
	local playerData = data[player.UserId]
	
	-- If the player data does not exist, return
	if playerData == nil then
		warn("Could not find player in Timing Data: " .. player.UserId)
		return
	end
	
	-- Determine state
	local state = DetermineState(
		lapTime, 
		playerData.BestLap.LapTime, 
		bestTime.Lap.LapTime, 
		isValid
	)
	
	-- Update Lap time
	playerData.CurrentLap.LapTime = lapTime
	playerData.CurrentLap.State = state
	-- Add lap to list of laps
	table.insert(playerData.LapTimes, playerData.CurrentLap)
	-- Update personal best
	if state == State.OverallBest or state == State.PersonalBest then
		playerData.BestLap = playerData.CurrentLap
	end
	
	-- Update overall best
	if state == State.OverallBest then
		UpdateBestLap(playerData)
	end
	
	-- Add lap
	playerData.Laps += 1
	playerData.LastUpdatedAt = time()
	_leaderstatsService:UpdateLap(player, playerData.Laps)
	
end

--- Adds a CC could to the player
---@param player Player The player to be given a CC count
function service:UpdateCC(player: Player)
	
	local playerData = data[player.UserId]

	-- If the player data does not exist, add the player
	if playerData == nil then
		playerData = service:AddPlayer(player)
	end

	-- Check CC cooldown
	if time() - playerData.LastCornerCutAt < _config.CornerCutCooldownSeconds then
		return
	end
	
	-- Update CC count
	playerData.LastCornerCutAt = time()
	playerData.CornerCuts += 1
	_leaderstatsService:UpdateCCs(player, playerData.CornerCuts)
	
end

--- Adds a new player to the timing board
---@param player Player The player to be added
---@return table playerData Instance of the player data
function service:AddPlayer(player: Player): table
	
	local playerData = data[player.UserId]

	-- If the player already exists, return
	if playerData ~= nil then
		return
	end
	
	-- Add new player data
	playerData = PlayerData.new(player)
	playerData.LastCornerCutAt = 0
	data[player.UserId] = playerData

	return playerData
	
end

--- Removes the player data from the game
---@param player Player The player who left
function service:RemovePlayer(player: Player)
	
	data[player.UserId] = nil
	
end

--- Resets the timing table
function service:ResetData()
	
	-- Clear data
	data = {}
	bestTime = {
		DisplayName = nil,
		Sectors = LapTime.new(),
		Lap = LapTime.new()
	}

	-- Reset leaderstats
	_leaderstatsService:ResetStats()
	
end

--- Get raw service data
---@return any data Raw service data
function service:GetCurrentData(): (table, table)
	
	return data, bestTime

end

--- Return sorted players data list
---@return table list List of players data
function service:GetSortedTimes(): table
	
	return _dataHelpers:GetSortedData(data)

end

--- Determine whether the lap is a new PB or overall best time
---@param thisTime number The time to be checked
---@param personalBest number The personal best time
---@param overallBest number The overall best time
---@param isValid boolean Whether the set time is valid
---@return number state State of the time
function DetermineState(thisTime: number, personalBest: number, overallBest: number, isValid: boolean): number

	if not isValid then
		return State.Invalid
	elseif overallBest == nil or thisTime < overallBest then
		return State.OverallBest
	elseif personalBest == nil or thisTime < personalBest then
		return State.PersonalBest
	end
	
	return State.Default
	
end

--- Override the overall best sector with a new sector time
---@param sector number The sector that should be overridden
---@param playerData table The new data with the new best sector time
function UpdateBestSector(sector: number, playerData: table)
	
	local sectorTime = playerData.CurrentLap:GetSector(sector)
	sectorTime.UserId = playerData.UserId
	sectorTime.DisplayName = playerData.DisplayName

	if sector == 1 then
		bestTime.Sectors.Sector1.State = State.PersonalBest
		bestTime.Sectors.Sector1 = sectorTime
	elseif sector == 2 then
		bestTime.Sectors.Sector2.State = State.PersonalBest
		bestTime.Sectors.Sector2 = sectorTime
	elseif sector == 3 then
		bestTime.Sectors.Sector3.State = State.PersonalBest
		bestTime.Sectors.Sector3 = sectorTime
	end

end

--- Override the overall best lap with a new lap time
---@param playerData table Player data with the new best lap time
function UpdateBestLap(playerData: table)
	
	local lapTime = playerData.CurrentLap
	lapTime.UserId = playerData.UserId
	lapTime.DisplayName = playerData.DisplayName

	bestTime.Lap.State = State.PersonalBest
	bestTime.Lap = lapTime

end

return service