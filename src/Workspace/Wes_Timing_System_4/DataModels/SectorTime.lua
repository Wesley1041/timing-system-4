local SectorTime = {}
SectorTime.__index = SectorTime

function SectorTime.new(sectorTime: number, state: number, player: Player | nil)
	
	local sector = {}
	setmetatable(sector, SectorTime)
	
	sector.Time = sectorTime
	sector.State = state

	if player then
		sector.DisplayName = player.DisplayName
		sector.UserId = player.UserId
	end
	
	return sector
	
end

return SectorTime