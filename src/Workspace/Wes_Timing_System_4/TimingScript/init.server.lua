--[[
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
Wesley1041's Timing System 4 v0.1

This fourth timing system is designed to be compatible with places that use StreamingEnabled.
It is the most feature-rich and modular timing system yet.

IMPORTANT: Configure the Timing System to your liking in the Config script that is part of this script.

----------------------------------------------------------------------------------------------------------

FOR SCRIPTERS:
The scripts and code in this model have been structured such that they are easy to edit and adapted to your needs!

The structure goes as follows:
- TimingBoardHandler - Contains all remote event/function handlers on the server side
- TimingDataService  - Contains the logic that keeps track of everyone's times
- TimingBoardService - Updates the timing board on the server side

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
--]]

-- Modules
local _remoteHandler = require(script.TimingRemoteHandler)
local _boardService = require(script.TimingBoardService)
local _leaderstatsService = require(script.TimingLeaderstatsService)

function Init()
	
	-- Start listening for remotes
	_remoteHandler:Init()
	-- Initialize board
	_boardService:Init()
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