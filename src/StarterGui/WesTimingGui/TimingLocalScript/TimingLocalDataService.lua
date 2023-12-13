local service = {}

-- Modules
local State = require(workspace.Wes_Timing_System_4.DataModels.State)
local _dataHelpers = require(workspace.Wes_Timing_System_4.Modules.TimingDataHelpers)

-- Variables
local localPlayer = game.Players.LocalPlayer

local data = {}
local bestTime = {}

--- Updates the local data with data from the server
---@param newData table Timing data of all players
---@param newBestTime table Overall best lap and sector times
function service:UpdateData(newData: table, newBestTime: table)
    
    data = newData
    bestTime = newBestTime

end

--- Returns the time delta between sectors
---@param sector number Sector completed
---@param sectorTime number Time of completed sector
---@param sectorIsValid boolean If sector time is valid
---@return table | nil deltaTimeData Contains the delta time between sectors and the status
function service:GetDeltaTime(sector: number, sectorTime: number, sectorIsValid: boolean): table | nil
	
	local deltaTimeData = {}
	
	local playerData = data[tostring(localPlayer.UserId)]
	local personalBest
	local overallBest
	
	-- Grab personal best and overall best sector data
	if playerData ~= nil then
		personalBest = playerData.BestLap["Sector" .. tostring(sector)].Time
	end

	if bestTime ~= nil then
		overallBest = bestTime.Sectors["Sector" .. tostring(sector)].Time
	end
	
	-- Determine state of current sector time
	local state = DetermineState(
		sectorTime, 
		personalBest, 
		overallBest, 
		sectorIsValid
	)
	
	-- Store and return delta time data
	if personalBest ~= nil then
		--print(sectorTime)
		--print(personalBest)
		deltaTimeData.delta = sectorTime - personalBest
		deltaTimeData.state = state
	else
		deltaTimeData = nil
	end
	
	return deltaTimeData
	
end

--- Gets the status of the lap time of the local player, given the lap time
---@param lapTime number The lap time
---@return number state The state of the lap time
function service:GetLapTimeStatus(lapTime: number)
	
	local playerData = data[tostring(localPlayer.UserId)]
	local personalBest
	local overallBest

	if playerData ~= nil then
		personalBest = playerData.BestLap.LapTime
	end

	if bestTime ~= nil then
		overallBest = bestTime.Lap.LapTime
	end

	return DetermineState(
		lapTime, 
		personalBest, 
		overallBest, 
		true
	)

end

--- Returns sorted lap times of all players
---@return table list Sorted list of times
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

return service