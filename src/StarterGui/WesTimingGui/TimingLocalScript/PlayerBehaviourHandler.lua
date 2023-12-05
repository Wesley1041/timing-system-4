local handler = {}

-- Modules
local _keeperService = require(script.Parent.TimingKeeperService)
local _config = require(workspace.Wes_Timing_System_4._Config)

-- Variables
local player = game.Players.LocalPlayer

--- Handle the touch between the player and the part that it touched
--- @param part BasePart The part that the player touched
function handler.HandlePlayerTouch(part: BasePart)

    -- Check if player is seated and if this is required
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or (not humanoid.Sit and _config.PlayerMustBeSeated) then
        return
    end

    if part.Name == "_Start" then
        _keeperService:HandleLap()
    elseif part.Name == "_S1" then
        _keeperService:HandleSector(1)
    elseif part.Name == "_S2" then
        _keeperService:HandleSector(2)
    elseif part.Name == "_CC" then

        -- Checks if CC invalidates next lap
        local nextLapInvalid = part:GetAttribute("InvalidsNextLap")
        -- Gets amount of cuts from CC
        local cutsFromBlock = part:GetAttribute("CutsFromBlock")
        if cutsFromBlock == nil then cutsFromBlock = 1 end
        -- Gets minimum speed from CC
        local minimumSpeed = part:GetAttribute("MinimumSpeed")
        if minimumSpeed == nil then minimumSpeed = 0 end
        local characterSpeed = humanoid.Parent.HumanoidRootPart.AssemblyLinearVelocity.Magnitude
        if characterSpeed > minimumSpeed then
            _keeperService:AddCornerCut(nextLapInvalid, cutsFromBlock)
        end
        
    end

end

--- Start watching the player's character for touches
---@param character Model The player's character
function handler.WatchForTriggers(character: Model)

    local head = character.PrimaryPart
    head.Touched:Connect(handler.HandlePlayerTouch)

end

function handler:Init()
    
    player.CharacterAdded:Connect(handler.WatchForTriggers)

    task.wait()
    handler.WatchForTriggers(player.Character)

end

return handler