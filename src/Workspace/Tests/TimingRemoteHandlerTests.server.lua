local _handler = require(workspace.Wes_Timing_System_4.TimingScript.TimingRemoteHandler)

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

function AddPlayer(name: string)
    
    local player = {
        DisplayName = name,
        UserId = math.random(1, 100000),
        leaderstats = nil
    }

    local leaderstats = Instance.new("IntValue", player)
    leaderstats.Name = "leaderstats"

    local laps = Instance.new("IntValue", leaderstats)
    laps.Name = "Laps"

    local cornerCuts = Instance.new("IntValue", leaderstats)
    cornerCuts.Name = "CornerCuts"

    return player

end

function Init()

    task.wait(1)
    local player1 = {
        DisplayName = "Wesley1041",
        UserId = 0  
    }
    local player2 = {
        DisplayName = "NitrousOxide",
        UserId = 1
    }
    local player3 = {
        DisplayName = "Supersonic999",
        UserId = 2
    }
    local player4 = {
        DisplayName = "xXGameMasterXx",
        UserId = 3
    }
    local player5 = {
        DisplayName = "MV33goat1",
        UserId = 4
    }

    DoLap(player1)
    task.wait(0.5)
    DoLap(player2)
    task.wait(0.5)
    DoLap(player3)
    task.wait(0.5)
    DoLap(player4)
    task.wait(0.5)
    DoLap(player5)

    task.wait(5)

    DoLap(player1)
    task.wait(0.5)
    DoLap(player2)
    task.wait(0.5)
    DoLap(player3)
    task.wait(0.5)
    DoLap(player4)
    task.wait(0.5)
    DoLap(player5)

end

--Init()