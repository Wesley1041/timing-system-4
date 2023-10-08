local module = {}

-- Modules
local _dataService = require(script.Parent.TimingLocalDataService)
local _boardService = require(script.Parent.GuiLogic.TimingLocalBoardService)
local _remotes = require(workspace.Wes_Timing_System_4.Modules.RemotesLocal)

-- Remotes
local getCurrentTimesEvent = _remotes:GetRemoteEvent("GetCurrentTimesEvent")
local resetTimesEvent = _remotes:GetRemoteEvent("ResetTimesEvent")
local updateCcEvent = _remotes:GetRemoteEvent("UpdateCcEvent")

--- Calls the server to get the current timing board
function module:RequestGetTimingBoard()
    
    getCurrentTimesEvent:FireServer()

end

--- Calls the server to reset the timing board
function module:RequestResetBoard()
    
    resetTimesEvent:FireServer()

end

--- Calls the server to add a corner cut
function module:RequestAddCornerCut()
    
    updateCcEvent:FireServer()

end

--- Updates the local timing board
---@param data table New data for the timing board
function module.UpdateBoardEvent(data: table, bestTime: table)
    
    _dataService:UpdateData(data, bestTime)
    
    local times = _dataService:GetSortedTimes()
    _boardService:UpdateBoard(times)

end

function module:Init()
    
    getCurrentTimesEvent.OnClientEvent:Connect(module.UpdateBoardEvent)
    module:RequestGetTimingBoard()

end

return module