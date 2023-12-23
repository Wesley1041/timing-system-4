local Workspace = game:GetService("Workspace")
local _config = require(Workspace.Wes_Timing_System_4._Config)
local _timingDataService = require(script.Parent.TimingDataService)
local _timingRemoteHandler = require(script.Parent.TimingRemoteHandler)

local service = {}
local prefix = _config.CommandPrefix
local commands = {
    "setlaps",
    "setcuts"
}

--- Attaches itself to admin player's chats to catch called commands
---@param callingPlayer Player player calling the command
function service.AddCommandsToChat(callingPlayer: Player)
    for _,v in pairs(_config.AdminUsers) do
        if callingPlayer.Name == v then
            callingPlayer.Chatted:Connect(function(msg)
                local loweredString = string.lower(msg)
                local args = string.split(loweredString," ")
                for _,command in pairs(commands) do
                    if args[1] ~= nil and args[1] == prefix .. command then
                        service[command](args, callingPlayer)
                    end
                end
            end)
        end
    end
end

--- Returns null if no player is found, else return Player instance
---@param input string the name of the player typed into the command
---@return Player player the player found from the string name
---@return nil nil if the player was not found
function SearchPlayer(input: string, callingPlayer: Player): Player | nil
    
    for _,player in pairs(game:GetService("Players"):GetPlayers()) do
        if (string.sub(string.lower(player.Name), 1, string.len(input)) == string.lower(input)) 
        or (string.sub(string.lower(player.DisplayName), 1, string.len(input)) == string.lower(input)) then
            return player
        end
    end
    -- If no player found then
    _timingRemoteHandler.fireClientPopup(callingPlayer, string.format("\"%s\" is not a valid username or display name",input), _config.Styles.InvalidStatePopup, 400)
    return nil
 end

function service.setlaps(args: {string}, callingPlayer: Player)

    local player = SearchPlayer(args[2], callingPlayer)
    if player ~= nil and args[3] ~= nil then
        _timingDataService:ManualChangeLap(player, args[3])
        _timingRemoteHandler.fireClientPopup(nil,string.format("Laps changed to %d for %s",args[3],player.Name), _config.Styles.PersonalBestStatePopup)
    elseif args[3] == nil then 
        _timingRemoteHandler.fireClientPopup(callingPlayer, "No value provided", _config.Styles.InvalidStatePopup)
    elseif tonumber(args[3]) == nil then
        _timingRemoteHandler.fireClientPopup(callingPlayer, string.format("$s is not a valid input",args[3]), _config.Styles.InvalidStatePopup)
    end
    
end

function service.setcuts(args: {string}, callingPlayer: Player)

    local player = SearchPlayer(args[2], callingPlayer)
    if player ~= nil and args[3] ~= nil then
        _timingDataService:UpdateCC(player, args[3])
        _timingRemoteHandler.fireClientPopup(nil,string.format("Cuts changed to %d for %s",args[3],player.Name), _config.Styles.PersonalBestStatePopup)
    elseif args[3] == nil then 
        _timingRemoteHandler.fireClientPopup(callingPlayer, "No value provided", _config.Styles.InvalidStatePopup)
    elseif tonumber(args[3]) == nil then
        _timingRemoteHandler.fireClientPopup(callingPlayer, string.format("$s is not a valid input",args[3]), _config.Styles.InvalidStatePopup)
    end

end

return service