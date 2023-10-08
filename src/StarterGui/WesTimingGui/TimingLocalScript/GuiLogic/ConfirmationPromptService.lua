local service = {}

-- Variables
local gui: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("WesTimingGui")
local prompt: Frame = gui.ConfirmPrompt
local textLabel: TextLabel = prompt.TextLabel
local confirmButton: GuiButton = prompt.Confirm
local cancelButton: GuiButton = prompt.Cancel

-- Events
local onConfirm
local onCancel

--- Opens the confirmation prompt
---@param text string The text that is displayed on the prompt
---@param func any The function that should be called if the confirm button is pressed 
function service:Prompt(text: string, func: () -> any)

    -- Show prompt
    textLabel.Text = text
    prompt.Visible = true

    -- Set confirm button
    onConfirm = confirmButton.MouseButton1Click:Connect(function()
        service:ConfirmAction(func)
        onConfirm:Disconnect()
    end)

    -- Set cancel button
    onCancel = cancelButton.MouseButton1Click:Connect(function()
        service:CancelAction()
        onCancel:Disconnect()
    end)
    
end

--- Hides the prompt and executes the given function
---@param func any Function to be executed on click
function service:ConfirmAction(func: () -> any)
    
    prompt.Visible = false
    func()

end

--- Closes the prompt and does not execute the action
function service:CancelAction()
    
    prompt.Visible = false

end

return service