local Workspace = game:GetService("Workspace")
local _Config = require(Workspace.Wes_Timing_System_4._Config)
local service = {}

--- Updates the lap count of the given player
---@param player Player The player whose lap count should be updated
---@param value number The new lap count
function service:UpdateLap(player: Player, value: number)
    
    local leaderstats = player:WaitForChild("leaderstats")
    if not leaderstats then
        warn("Leaderstats of player " .. player.Name .. "not found!")
        return
    end

    local laps = leaderstats:WaitForChild("Laps")
    if not laps then
        warn("Laps of player " .. player.Name .. "not found!")
        return
    end

    laps.Value = value

end

--- Updates the CC count of the given player
---@param player Player The player whose CC count should be updated
---@param value number The new CC count
function service:UpdateCCs(player: Player, value: number)
    
    local leaderstats = player:WaitForChild("leaderstats")
    if not leaderstats then
        warn("Leaderstats of player " .. player.Name .. "not found!")
        return
    end

    local cornerCuts = leaderstats:WaitForChild("CornerCuts")
    if not cornerCuts then
        warn("CornerCuts of player " .. player.Name .. "not found!")
        return
    end

    cornerCuts.Value = value

end

--- Resets the leaderstats of all players
function service:ResetStats()
    
    local players = game.Players:GetChildren()

    for _, player in pairs(players) do
        service:UpdateCCs(player, 0)
        service:UpdateLap(player, 0)
    end

end

--- Adds leaderstats to a new player
---@param player Player The new player
function service.AddPlayer(player: Player)
    require(script.Parent.TimingCommandsService).AddCommandsToChat(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats == nil then
        leaderstats = Instance.new("IntValue", player)
        leaderstats.Name = "leaderstats"
    end

    local laps = leaderstats:FindFirstChild("Laps")
    if laps == nil then
        laps = Instance.new("IntValue", leaderstats)
        laps.Name = "Laps"
    end

    local cornerCuts = leaderstats:FindFirstChild("CornerCuts")
    if cornerCuts == nil then
        cornerCuts = Instance.new("IntValue", leaderstats)
        cornerCuts.Name = "CornerCuts"
    end

end

function service:Init()
    
    -- Add leaderstats to players who join the server
    game.Players.PlayerAdded:Connect(service.AddPlayer)

end

return service