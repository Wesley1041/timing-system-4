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
---@param timeAt table The time() of each sector start
---@param sectorIsValid boolean If sector time is valid
---@return table | nil deltaTimeData Contains the delta time between sectors and the status
function service:GetDeltaTime(sector: number, timeAt: table, sectorIsValid: boolean): table | nil
	
	local playerData = data[tostring(localPlayer.UserId)]
	
	local deltaTimeData = {}
	local personalBest = {}
	local overallBest = {}
	
	if playerData ~= nil and playerData.BestLap.LapTime ~= nil then
		
		-- No previous sector to compare to
		if sector == 1 then
			personalBest.PreviousSector = 0
		else
			personalBest.PreviousSector = playerData.BestLap["Sector" .. tostring(sector - 1)].Time
		end
		
		personalBest.CurrentSector = playerData.BestLap["Sector" .. tostring(sector)].Time
		personalBest.Total = personalBest.CurrentSector + personalBest.PreviousSector
	end
	
	if bestTime ~= nil and bestTime.Lap.LapTime ~= nil then

		-- No previous sector to compare to
		if sector == 1 then
			overallBest.PreviousSector = 0
		else
			overallBest.PreviousSector = bestTime.Sectors["Sector" .. tostring(sector - 1)].Time
		end

		overallBest.CurrentSector = bestTime.Sectors["Sector" .. tostring(sector)].Time
		overallBest.Total = overallBest.CurrentSector + overallBest.PreviousSector
	end
	
	-- Store and return delta time data if personal best lap exists
	if personalBest.CurrentSector ~= nil then
		
		-- Determine with timeAt to use
		-- sectorTimeAt - lapStartAt
		local currentLapTotal = timeAt[sector] - timeAt[3]
		
		-- Determine state of current sector time
		local state = DetermineState(
			currentLapTotal, 
			personalBest.Total, 
			overallBest.Total, 
			sectorIsValid
		)
		
		-- Set delta data
		deltaTimeData.delta = currentLapTotal - personalBest.Total
		deltaTimeData.state = state
	else
		
		-- No lap data to compare current time to
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