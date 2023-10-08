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