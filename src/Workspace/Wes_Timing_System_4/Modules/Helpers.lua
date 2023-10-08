local helpers = {}

-- Modules
local _config = require(script.Parent.Parent._Config)
local State = require(script.Parent.Parent.DataModels.State)

--- Checks whether the given player has admin rights
---@param player Player The player that should be checked
---@return boolean isAdmin True if the player is an admin
function helpers:CheckPlayerIsAdmin(player: Player): boolean
	
	-- Check admin groups list
	for _, value in pairs(_config.AdminRoles) do
		if player:GetRankInGroup(value.GroupId) >= value.Rank then
			return true
		end
	end
	
	-- Check admin users list
	for _, value in pairs(_config.AdminUsers) do
		
		if typeof(value) == "string" and value == player.Name then
			return true
		elseif value == player.UserId then
			return true
		end
		
	end
	
	return false
	
end

--- Converts the time from number to string
---@param value number | nil The time as a number
---@return string time The time as a string
function helpers:ConvertTime(value: number | nil)
	
	if value == nil then
		return "-:--.---"
	end

	local minutes = math.floor(value / 60)
	local seconds = math.floor(value - minutes * 60)
	local miliseconds = math.floor((value % 1) * 1000)

	if seconds < 10 then
		seconds = "0" .. seconds
	end
	if miliseconds < 10 then
		miliseconds = "00" .. miliseconds
	elseif miliseconds < 100 then
		miliseconds = "0" .. miliseconds
	end

	if minutes == 0 then
		return seconds .. "." .. miliseconds	
	else
		return minutes .. ":" .. seconds .. "." .. miliseconds	
	end

end

--- Gets the color that is associated to the state
---@param state number State value
---@return Color3 color The color of the state
function helpers:GetStateColor(state: number): Color3

	if state == State.Default then
		return _config.Styles.DefaultState
	elseif state == State.Invalid then
		return _config.Styles.InvalidState
	elseif state == State.PersonalBest then
		return _config.Styles.PersonalBestState
	elseif state == State.OverallBest then
		return _config.Styles.OverallBestState
	end

	return _config.Styles.DefaultState

end

--- Gets the text color that is associated to the state
---@param state number State value
---@return Color3 color The color of the state
function helpers:GetStateTextColor(state: number): Color3

	if state == State.Default then
		return _config.Styles.DefaultStateText
	elseif state == State.Invalid then
		return _config.Styles.InvalidStateText
	elseif state == State.PersonalBest then
		return _config.Styles.PersonalBestStateText
	elseif state == State.OverallBest then
		return _config.Styles.OverallBestStateText
	end

	return _config.Styles.DefaultStateText

end

--- Gets the popup color that is associated to the state
---@param state number State value
---@return Color3 color The color of the state
function helpers:GetStatePopupColor(state: number): Color3

	if state == State.Default then
		return _config.Styles.DefaultStatePopup
	elseif state == State.Invalid then
		return _config.Styles.InvalidStatePopup
	elseif state == State.PersonalBest then
		return _config.Styles.PersonalBestStatePopup
	elseif state == State.OverallBest then
		return _config.Styles.OverallBestStatePopup
	end

	return _config.Styles.DefaultStatePopup

end

return helpers