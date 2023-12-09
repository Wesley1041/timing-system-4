local Workspace = game:GetService("Workspace")
local _Config = require(Workspace.Wes_Timing_System_4._Config)
local TimingDataService = require(script.Parent.TimingDataService)

local service = {}

function service.AddCommandsToChat(plr: Player)
    for _,v in pairs(_Config.AdminUsers) do
        if plr.Name == v then
            plr.Chatted:Connect(function(msg)
                local loweredString = string.lower(msg)
                local args = string.split(loweredString," ")

                if args[1] == ":setlaps" then
                    print("Setting Laps!")
                    for _,player in pairs(game:GetService("Players"):GetPlayers()) do
                        if (string.sub(string.lower(player.Name), 1, string.len(args[2])) == string.lower(args[2])) 
                        or (string.sub(string.lower(player.DisplayName), 1, string.len(args[2])) == string.lower(args[2])) then
                            if args[3] ~= nil then
                                TimingDataService:ManualChangeLap(player, args[3])
                            else
                                warn("INVALID INPUT FOR ADDING LAPS")
                            end
                        end
                    end

                elseif args[1] == ":setcuts" then
                    for _,player in pairs(game:GetService("Players"):GetPlayers()) do
                        if (string.sub(string.lower(player.Name), 1, string.len(args[2])) == string.lower(args[2])) 
                        or (string.sub(string.lower(player.DisplayName), 1, string.len(args[2])) == string.lower(args[2])) then
                            if args[3] ~= nil then
                                TimingDataService:UpdateCC(player, args[3])
                            else
                                warn("INVALID INPUT FOR ADDING CUTS")
                            end
                        end
                    end
                end
            end)
        end
    end
end

return service