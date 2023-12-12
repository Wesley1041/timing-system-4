local _handler = require(workspace.Wes_Timing_System_4.TimingScript.TimingRemoteHandler)

-- Services
local Players = game:GetService("Players")

function DoLap(player: Player)

	local sector1 = RandomTime()
	local sector2 = RandomTime()
	local sector3 = RandomTime()
	local lapTime = sector1 + sector2 + sector3

	-- Sector 1
	_handler.UpdateSectorEvent(player, 1, sector1, true)
	-- Sector 2
	_handler.UpdateSectorEvent(player, 2, sector2, true)
	-- Sector 3
	_handler.UpdateSectorEvent(player, 3, sector3, true)
	-- Lap
	_handler.UpdateLapEvent(player, lapTime, true)

end

function RandomTime()

	return math.random(20000, 40000) / 1000

end

function AddPlayer(player: Player)
	
	-- Negative UserID indicates a test player on a test server (Clients and Servers tab)
	-- i.e. "Player1", "Player2", etc.
	if player.UserId < 0 then
		
		local leaderstats = Instance.new("IntValue", player)
		leaderstats.Name = "leaderstats"

		local laps = Instance.new("IntValue", leaderstats)
		laps.Name = "Laps"

		local cornerCuts = Instance.new("IntValue", leaderstats)
		cornerCuts.Name = "CornerCuts"
		
		DoLap(player)
		
	end

end

function Init()

	Players.PlayerAdded:Connect(AddPlayer)

end

Init()