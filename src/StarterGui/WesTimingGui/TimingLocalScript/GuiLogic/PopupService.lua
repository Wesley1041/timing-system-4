local service = {}

-- Services
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Variables
local player = game.Players.LocalPlayer
local gui: ScreenGui = player.PlayerGui:WaitForChild("WesTimingGui")
local popupFrame: Frame = gui.PopupTemplate


local defaultLength = popupFrame.Size.X.Offset

local popupVisibilityTime = 3
local popupMovementDuration = 0.3
local tweenInfo = TweenInfo.new(popupMovementDuration, Enum.EasingStyle.Linear)

function service:NewPopup(text: string, color: Color3, frameLength: number | nil)

    -- Create new concurrent operation
    task.spawn(function()

        -- Move all popups upwards
        for _,frame in pairs(popupFrame.Parent:GetChildren()) do
            if frame.Name == "Popup" then
                local tween = TweenService:Create(frame, tweenInfo, { Position = UDim2.new(
                    frame.Position.X.Scale,
                    frame.Position.X.Offset,
                    frame.Position.Y.Scale,
                    frame.Position.Y.Offset - frame.Size.Y.Offset)}) -- Moves frame upwards by its own size to make room for another popup
                tween:Play()
            end
        end

        -- Create new popup
        local newFrame = popupFrame:Clone()
        newFrame.Parent = popupFrame.Parent
        newFrame.Name = "Popup"
    
        newFrame.TextLabel.Text = text
        newFrame.TextLabel.BackgroundColor3 = color
        if frameLength ~= nil then
            newFrame.Size = UDim2.new(0, frameLength, newFrame.Size.Y.Scale, newFrame.Size.Y.Offset)
        else
            newFrame.Size = UDim2.new(0, defaultLength, newFrame.Size.Y.Scale, newFrame.Size.Y.Offset)
        end
    
        service:ShowPopup(newFrame)
        task.wait(popupVisibilityTime)
        service:HidePopup(newFrame)

    end)

end

--- Slides the popup frame into view
function service:ShowPopup(newFrame: Frame)
    
    SlideGuiObject(newFrame.TextLabel, 0, popupMovementDuration)

end

--- Fades the frame out
function service:HidePopup(newFrame: Frame)
    
    local tween = TweenService:Create(newFrame.TextLabel, tweenInfo, {Transparency = 1})
    tween:Play()

    repeat
        RunService.RenderStepped:Wait()
    until tween.PlaybackState == Enum.PlaybackState.Completed

    newFrame:Destroy()

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