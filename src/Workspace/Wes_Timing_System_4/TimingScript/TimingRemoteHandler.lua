local handler = {}

-- Modules
local _dataService = require(script.Parent.TimingDataService)
local _boardService = require(script.Parent.TimingBoardService)
local _config = require(script.Parent.Parent._Config)
local _remotes = require(script.Parent.Parent.Modules.Remotes)
local _helpers = require(script.Parent.Parent.Modules.Helpers)

-- Remotes
local updateSectorEvent = _remotes:CreateRemoteEvent("UpdateSectorEvent")
local updateLapEvent = _remotes:CreateRemoteEvent("UpdateLapEvent")
local updateCcEvent = _remotes:CreateRemoteEvent("UpdateCcEvent")
local resetTimesEvent = _remotes:CreateRemoteEvent("ResetTimesEvent")
local getCurrentTimesEvent = _remotes:CreateRemoteEvent("GetCurrentTimesEvent")

--- Updates the sector of the given player
---@param player Player The player whose sector should be updated
---@param sector number The sector that should be updated
---@param sectorTime number The sector time to be added
---@param isValid boolean Whether the sector time is valid
function handler.UpdateSectorEvent(player: Player, sector: number, sectorTime: number, isValid: boolean)

	-- Check for cheating
	if _config.CheckForAntiCheat and sectorTime < _config.MinimumSectorTime then
		KickPlayer(player)
		return
	end

	-- Update the sector
	_dataService:UpdateSector(player, sector, sectorTime, isValid)

	-- Update all players' data
	UpdatePlayerBoards()

end

--- Updates the lap time of the given player
---@param player Player The player whose lap time should be added
---@param lapTime number The lap time of the player
---@param isValid boolean Whether the lap is valid
function handler.UpdateLapEvent(player: Player, lapTime: number, isValid: boolean)

	-- Check for cheating
	if _config.CheckForAntiCheat and lapTime < _config.MinimumLapTime then
		KickPlayer(player)
		return
	end

	-- Update the lap
	_dataService:UpdateLap(player, lapTime, isValid)

	-- Update all players' data
	UpdatePlayerBoards()

end

function handler.UpdateCcEvent(player: Player, cutsFromBlock: number): boolean

	_dataService:UpdateCC(player, cutsFromBlock)

end

-- Reset all lap times and board
function handler.ResetTimesEvent(player: Player)

	-- Check if player is authorized
	if not _helpers:CheckPlayerIsAdmin(player) then
		return
	end

	-- Reset the timing table
	_dataService:ResetData()

	-- Update all players' data
	UpdatePlayerBoards()

end

-- Get the current lap times for the board display
function handler.GetCurrentTimesEvent(player: Player)

	local data = _dataService:GetSortedTimes()
	getCurrentTimesEvent:FireClient(player, data)

end

function handler:Init()
	
	updateSectorEvent.OnServerEvent:Connect(handler.UpdateSectorEvent)
	updateLapEvent.OnServerEvent:Connect(handler.UpdateLapEvent)
	updateCcEvent.OnServerEvent:Connect(handler.UpdateCcEvent)
	resetTimesEvent.OnServerEvent:Connect(handler.ResetTimesEvent)
	getCurrentTimesEvent.OnServerEvent:Connect(handler.GetCurrentTimesEvent)
	
end

--- Kicks the player whenever they are caught cheating
---@param player Player The player to be kicked
function KickPlayer(player: Player)
	
	if _config.KickWhenCheat then
		player:Kick("Cheating detected!")
	end
end

--- Updates the server board as well as all players' local boards
function UpdatePlayerBoards()
	
	local sortedData = _dataService:GetSortedTimes()
	_boardService:UpdateBoard(sortedData)

	local data, bestTime = _dataService:GetCurrentData()
	getCurrentTimesEvent:FireAllClients(data, bestTime)

end

return handler