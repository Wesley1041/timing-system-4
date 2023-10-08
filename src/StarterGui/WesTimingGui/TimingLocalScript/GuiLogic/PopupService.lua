local service = {}

-- Services
local RunService = game:GetService("RunService")

-- Variables
local player = game.Players.LocalPlayer
local gui: ScreenGui = player.PlayerGui:WaitForChild("WesTimingGui")
local popupFrame: Frame = gui.Popup

local defaultLength = popupFrame.Size.X.Offset
local popupVisible = false

local popupVisibilityTime = 3
local popupMovementDuration = 0.3

function service:NewPopup(text: string, color: Color3, frameLength: number | nil)

    -- Create new concurrent operation
    task.spawn(function()

        -- Wait until the previous prompt is done
        repeat
            RunService.RenderStepped:Wait()
        until not popupVisible

        popupFrame.TextLabel.Text = text
        popupFrame.TextLabel.BackgroundColor3 = color
        if frameLength ~= nil then
            popupFrame.Size = UDim2.new(0, frameLength, popupFrame.Size.Y.Scale, popupFrame.Size.Y.Offset)
        else
            popupFrame.Size = UDim2.new(0, defaultLength, popupFrame.Size.Y.Scale, popupFrame.Size.Y.Offset)
        end
    
        service:ShowPopup()
        task.wait(popupVisibilityTime)
        service:HidePopup()

    end)

end

--- Slides the popup frame into view
function service:ShowPopup()
    
    popupVisible = true
    SlideGuiObject(popupFrame.TextLabel, 0, popupMovementDuration)

end

--- Slides the popup frame out of view
function service:HidePopup()
    
    SlideGuiObject(popupFrame.TextLabel, -1, popupMovementDuration)
    popupVisible = false

end

--- Slides the given GUI object in a certain direction
---@param object GuiObject The object that should be moved
---@param targetScale number The target position of the object
---@param movementDuration number How long the movement should take
function SlideGuiObject(object: GuiObject, targetScale: number, movementDuration: number)
    
    local initScale = object.Position.Y.Scale
    local deltaScale = targetScale - initScale
    local progress = 0

    while progress < 1 do
        local deltaTime = RunService.RenderStepped:Wait()
        progress += deltaTime / movementDuration
        progress = math.min(1, progress)

        local currentScale = initScale + deltaScale * progress
        object.Position = UDim2.new(0, 0, currentScale, 0) 
    end

end

return service