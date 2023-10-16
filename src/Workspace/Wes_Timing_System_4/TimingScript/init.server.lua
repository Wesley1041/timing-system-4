-- Modules
local _remoteHandler = require(script.TimingRemoteHandler)
local _leaderstatsService = require(script.TimingLeaderstatsService)

function Init()
	
	-- Start listening for remotes
	_remoteHandler:Init()
	-- Initialize leaderstats
	_leaderstatsService:Init()

	-- Move Timing GUI to StarterGui
    MoveTimingGui()
	
end

function MoveTimingGui()
    
    local gui = script.Parent:FindFirstChild("WesTimingGui")
    if gui ~= nil then
        gui.Parent = game.StarterGui
    end

end

Init()