local service = {}

-- Modules
local State = require(workspace.Wes_Timing_System_4.DataModels.State)
local _config = require(workspace.Wes_Timing_System_4._Config)
local _helpers = require(workspace.Wes_Timing_System_4.Modules.Helpers)

-- Variables
local player = game.Players.LocalPlayer
local gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("WesTimingGui")
local timeTable = gui.TimeTable.Times

local rowCount = 0
local rowHeightPixels = timeTable:FindFirstChild("_Item").Size.Y.Offset

-- Update the board in workspace with the new times (sorted list)
function service:UpdateBoard(times: table)
	
	-- Remove rows if there are more rows than provided times
	local positions = #times
	for position = positions + 1, rowCount do
		RemoveRow(position)
	end

	-- Add/Update rows
	for position, data in pairs(times) do
		UpdatePosition(position, data)
	end

	-- Update board height
	timeTable.CanvasSize = UDim2.new(0, 0, 0, positions * rowHeightPixels)
	
end

--- Either show or hide the visibility of the board
function service:ToggleBoardVisibility(visible: boolean)
	
	gui.TimeTable.Visible = visible

end

--- Updates a row in the timing board with new data
---@param position number The position of the row
---@param data table The new player data that is to be applied
function UpdatePosition(position: number, data: table)

	-- Wait until timeTable is not null
	repeat task.wait() until timeTable ~= nil

	-- Create bar if it does not exist
	local row = timeTable:FindFirstChild("Row_" .. position)
	if row == nil then
		row = AddRow(position)
	end
	
	-- Update row data
	row.Player.Text = data.DisplayName
	row.Best.Text = _helpers:ConvertTime(data.BestLap.LapTime)
	row.Last.Text = _helpers:ConvertTime(data.CurrentLap.LapTime)
	row.S1.Text = _helpers:ConvertTime(data.CurrentLap.Sector1.Time)
	row.S2.Text = _helpers:ConvertTime(data.CurrentLap.Sector2.Time)
	row.S3.Text = _helpers:ConvertTime(data.CurrentLap.Sector3.Time)

	-- Highlight local player
	if data.UserId == player.UserId then
		row.Player.TextColor3 = Color3.fromRGB(255, 255, 164)
	else
		row.Player.TextColor3 = Color3.fromRGB(255, 255, 255)
	end

	-- Update current lap state
	row.Last.TextColor3 = _helpers:GetStateTextColor(data.CurrentLap.State)
	-- Update sector states
	UpdateSectorStates(row, data)

end

--- Adds a new row to the timing board table
---@param position number The position of the new row
---@return Frame row The new row as Frame
function AddRow(position: number)
	
	local row = timeTable:FindFirstChild("_Item"):Clone()	
	row.Name = "Row_" .. position
	row.Pos.Text = position
	row.Position = UDim2.new(0, 0, 0, row.Size.Y.Offset * (position - 1))
	row.Visible = true
	row.Parent = timeTable

	-- Apply colours
	if position == 1 then
		row.Pos.BackgroundColor3 = _config.Styles.PositionFirstBoxBackground
		row.Pos.TextColor3 = _config.Styles.PositionFirstBoxText
	else
		row.Pos.BackgroundColor3 = _config.Styles.PositionBoxBackground
		row.Pos.TextColor3 = _config.Styles.PositionBoxText
	end

	if position % 2 == 0 then
		row.BackgroundTransparency = 0.95
	end

	rowCount += 1
	
	return row
	
end

--- Removes a row from the timing board table
---@param position number The position of the row that should be removed
function RemoveRow(position: number)
	
	local row = timeTable:FindFirstChild("Row_" .. position)
	
	if row ~= nil then
		row:Destroy()
		rowCount -= 1
	end
	
end

--- Update the states of all sectors
---@param row Frame The frame where the sectors are located
---@param data table The player data
function UpdateSectorStates(row: Frame, data: table)

	if data.CurrentLap.Sector1.Time ~= nil then
		row.S1.TextColor3 = _helpers:GetStateTextColor(data.CurrentLap.Sector1.State)
		row.S1.TextTransparency = 0.2
	else
		row.S1.TextColor3 = _helpers:GetStateTextColor(State.Default)
		row.S1.TextTransparency = 0.8
	end
	
	if data.CurrentLap.Sector2.Time ~= nil then
		row.S2.TextColor3 = _helpers:GetStateTextColor(data.CurrentLap.Sector2.State)
		row.S2.TextTransparency = 0.2
	else
		row.S2.TextColor3 = _helpers:GetStateTextColor(State.Default)
		row.S2.TextTransparency = 0.8
	end

	if data.CurrentLap.Sector3.Time ~= nil then
		row.S3.TextColor3 = _helpers:GetStateTextColor(data.CurrentLap.Sector3.State)
		row.S3.TextTransparency = 0.2
	else
		row.S3.TextColor3 = _helpers:GetStateTextColor(State.Default)
		row.S3.TextTransparency = 0.8
	end

end

return service