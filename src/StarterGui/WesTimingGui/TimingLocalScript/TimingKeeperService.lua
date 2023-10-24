local service = {}

-- Modules
local _remoteHandler = require(script.Parent.TimingLocalRemoteHandler)
local _dataService = require(script.Parent.TimingLocalDataService)
local _popupService = require(script.Parent.GuiLogic.PopupService)
local _helpers = require(workspace.Wes_Timing_System_4.Modules.Helpers)
local _remotes = require(workspace.Wes_Timing_System_4.Modules.RemotesLocal)
local _config = require(workspace.Wes_Timing_System_4._Config)

-- Remotes
local updateSectorEvent = _remotes:GetRemoteEvent("UpdateSectorEvent")
local updateLapEvent = _remotes:GetRemoteEvent("UpdateLapEvent")

-- States
local currentSector = 0
local sectorIsValid = true
local lapIsValid = true
local nextLapIsValid = true

-- Timestamps
local lapStartAt = 0
local sector1At = 0
local sector2At = 0

--- Handles completing a sector
---@param sector number The sector number that was completed
function service:HandleSector(sector: number)

    if sector ~= currentSector then
        return
    end

    -- Get the sector time
    local sectorTime
    if sector == 1 then
        sectorTime = time() - lapStartAt
        sector1At = time()
    elseif sector == 2 then
        sectorTime = time() - sector1At
        sector2At = time()
    end

    -- Update states
    SubmitSectorTime(sector, sectorTime, sectorIsValid)
    currentSector += 1
    sectorIsValid = true

end

--- Handles completing a lap
function service:HandleLap()
    
    -- If in sector 3, complete the lap
    if currentSector == 3 then
        local lapTime = time() - lapStartAt
        local sectorTime = time() - sector2At

        -- Show prompt
        DisplayLapTime(lapTime, lapIsValid)

        -- Submit times
        SubmitSectorTime(3, sectorTime, sectorIsValid)
        SubmitLapTime(lapTime, lapIsValid)
    end

    -- Reset states
    currentSector = 1
    if nextLapIsValid then
        lapIsValid = true
    else
        nextLapIsValid = true
    end
    sectorIsValid = true
    lapStartAt = time()

end

--- Adds a corner cut count to the player
--- @param nextLapInvalid boolean If the corner cut invalidates the next lap
function service:AddCornerCut(nextLapInvalid: boolean)

    if nextLapIsValid and nextLapInvalid then

        if lapIsValid then
            -- If this lap and the next lap has not been invalidated yet, show a popup
            _popupService:NewPopup("CORNER CUT - LAP & NEXT LAP INVALIDATED", _config.Styles.InvalidStatePopup, 300)
        else
            -- If the next lap has not been invalidated yet, show a popup
            _popupService:NewPopup("CORNER CUT - NEXT LAP INVALIDATED", _config.Styles.InvalidStatePopup, 300)
        end
        nextLapIsValid = false
        
    elseif lapIsValid then
        -- If the lap is invalidated for the first time, show a popup
        _popupService:NewPopup("CORNER CUT - LAP INVALIDATED", _config.Styles.InvalidStatePopup, 300)

    elseif _config.PopupEverycut then
        -- Otherwise show this popup instead
        _popupService:NewPopup("CORNER CUT", _config.Styles.InvalidStatePopup, 300)
    end

    -- Register Corner Cut and invalid sector and lap
    sectorIsValid = false
    lapIsValid = false
    
    _remoteHandler:RequestAddCornerCut()

end

--- Calls the server to handle the lap time
---@param lapTime number The laptime that has been set
---@param isValid boolean Whether the laptime is valid
function SubmitLapTime(lapTime: number, isValid: boolean)

    updateLapEvent:FireServer(lapTime, isValid)

end

--- Calls the server to handle the sector time
---@param sector number The sector in which the time was set
---@param sectorTime number The sector time
---@param isValid boolean Whether the sector time is valid
function SubmitSectorTime(sector: number, sectorTime: number, isValid: boolean)

    updateSectorEvent:FireServer(sector, sectorTime, isValid)

end

--- Uses the popup service to display the given lap time
---@param lapTime number The lap time to be displayed
---@param isValid boolean Whether the lap time is valid
function DisplayLapTime(lapTime: number, isValid: boolean)
    
    local frameColor = _config.Styles.InvalidStatePopup
    if isValid then
        local state = _dataService:GetLapTimeStatus(lapTime)
        frameColor = _helpers:GetStatePopupColor(state)
    end

    _popupService:NewPopup(
        _helpers:ConvertTime(lapTime), 
        frameColor
    )

end

return service