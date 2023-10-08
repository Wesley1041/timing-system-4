local service = {}

-- Modules
local _remoteHandler = require(script.Parent.Parent.TimingLocalRemoteHandler)
local _confirmPromptService = require(script.Parent.ConfirmationPromptService)
local _helpers = require(workspace.Wes_Timing_System_4.Modules.Helpers)

-- Variables
local player = game.Players.LocalPlayer
local gui = player.PlayerGui:WaitForChild("WesTimingGui")
local resetTimesButton: GuiButton = gui.TimeTable.ResetTimesButton

--- Reset the server's timing board
function service:ResetBoard()
    
    -- Call prompt
    _confirmPromptService:Prompt("Are you sure that you want to reset all times?", function()
        _remoteHandler:RequestResetBoard()
    end)

end

--- On init call by the client script
function service:Init()

    -- Determine visibility
    if not _helpers:CheckPlayerIsAdmin(player) then
        resetTimesButton.Visible = false
    end

    -- Button inputs
    resetTimesButton.MouseButton1Click:Connect(service.ResetBoard)

end

return service