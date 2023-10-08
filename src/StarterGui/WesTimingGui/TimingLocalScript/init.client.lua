-- Modules
local _remoteHandler = require(script.TimingLocalRemoteHandler)
local _behaviourHandler = require(script.PlayerBehaviourHandler)
local _inputHandler = require(script.TimingInputHandler)

local _adminService = require(script.GuiLogic.TimingAdminService)

--- Initialize all modules that have initialization
function Init()

    -- Handlers
    _remoteHandler:Init()
    _behaviourHandler:Init()
    _inputHandler:Init()

    -- Gui services
    _adminService:Init()

end

Init()