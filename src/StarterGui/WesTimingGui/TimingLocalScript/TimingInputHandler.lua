local handler = {}

-- Services
local InputService = game:GetService("UserInputService")

-- Modules
local _boardService = require(script.Parent.GuiLogic.TimingLocalBoardService)
local _remoteHandler = require(script.Parent.TimingLocalRemoteHandler)
local _config = require(workspace.Wes_Timing_System_4._Config)

-- Keys
local toggleBoardKeyCode = _config.ToggleBoardGuiKey

--- Handles input by the player
---@param input InputObject The input that was detected
---@param gameProcessedEvent boolean Whether the input is already being processed for something else, like typing or character movement
function handler.HandleDeviceInput(input: InputObject, gameProcessedEvent: boolean)
    
    if gameProcessedEvent then
        return
    end

    if input.UserInputState == Enum.UserInputState.Begin then

        -- Show timing board
        if input.KeyCode == toggleBoardKeyCode then
            _boardService:ToggleBoardVisibility(true)
        end

    elseif input.UserInputState == Enum.UserInputState.End then

        -- Hide timing board
        if input.KeyCode == toggleBoardKeyCode then
            _boardService:ToggleBoardVisibility(false)
        end

    end

end

--- Requests the server to reset the timing board for everyone
function handler.ResetBoard()
    
    _remoteHandler:RequestResetBoard()

end

function handler:Init()
    
    -- Device inputs
    InputService.InputBegan:Connect(handler.HandleDeviceInput)
    InputService.InputEnded:Connect(handler.HandleDeviceInput)

end

return handler