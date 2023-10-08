local SectorTime = require(script.Parent.SectorTime)

local LapTime = {}
LapTime.__index = LapTime

function LapTime.new(sector1: table, sector2: table, sector3: table, lap: number, state: number, player: Player | nil): table
	
	local lapTime = {}
	setmetatable(lapTime, LapTime)
	
	lapTime.Sector1 = if sector1 then sector1 else SectorTime.new()
	lapTime.Sector2 = if sector2 then sector2 else SectorTime.new()
	lapTime.Sector3 = if sector3 then sector3 else SectorTime.new()
	lapTime.LapTime = lap
	lapTime.State = state
	
	if player then
		lapTime.DisplayName = player.DisplayName
		lapTime.UserId = player.UserId
	end
	
	return lapTime
	
end

function LapTime:GetSector(sector: number): table

	if sector == 1 then
		return self.Sector1
	elseif sector == 2 then
		return self.Sector2
	elseif sector == 3 then
		return self.Sector3
	end
	
	return nil
	
end

function LapTime:SetSector(sector: number, sectorTime: number, state: number)
	
	if sector == 1 then
		self.Sector1 = SectorTime.new(sectorTime, state)
		self.Sector2 = SectorTime.new()
		self.Sector3 = SectorTime.new()
	elseif sector == 2 then
		self.Sector2 = SectorTime.new(sectorTime, state)
	elseif sector == 3 then
		self.Sector3 = SectorTime.new(sectorTime, state)
	end
	
end

return LapTime
