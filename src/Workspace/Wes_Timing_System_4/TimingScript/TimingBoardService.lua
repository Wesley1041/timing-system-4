local service = {}

-- Modules
local State = require(script.Parent.Parent.DataModels.State)
local _config = require(script.Parent.Parent._Config)
local _helpers = require(script.Parent.Parent.Modules.Helpers)

-- Variables
local board = _config.Board
local timeTable: ScrollingFrame = board.SurfaceGui.Times
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

--- Updates a row in the timing board with new data
---@param position number The position of the row
---@param data table The new player data that is to be applied
function UpdatePosition(position: number, data: table)

	-- Create bar if it does not exist
	local row = timeTable:FindFirstChild("Row_" .. position)
	if row == nil then
		row = AddRow(position)
	end
	
	-- Update row data
	row.Player.Text = data.DisplayName
	row.Best.Text = _helpers:ConvertTime(data.BestLap.LapTime)
	row.Last.Text = _helpers:ConvertTime(data.CurrentLap.LapTime)

	-- Update current lap state
	row.Last.TextColor3 = _helpers:GetStateTextColor(data.CurrentLap.State)
	-- Update sector states
	UpdateSectorStates(row.Sectors, data)

end

--- Adds a new row to the timing board table
---@param position number The position of the new row
---@return Frame row The new row as Frame
function AddRow(position: number): Frame
	
	local row = timeTable:FindFirstChild("_Item"):Clone()	
	row.Name = "Row_" .. position
	row.Pos.Text = position
	row.Position = UDim2.new(0, 0, 0, rowHeightPixels * (position - 1))
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
---@param sectors Frame The frame where the sectors are located
---@param data table The player data
function UpdateSectorStates(sectors: Frame, data: table)

	if data.CurrentLap.Sector1.Time ~= nil then
		sectors.S1.BackgroundColor3 = _helpers:GetStateColor(data.CurrentLap.Sector1.State)
		sectors.S1.BackgroundTransparency = 0
	else
		sectors.S1.BackgroundColor3 = _helpers:GetStateColor(State.Default)
		sectors.S1.BackgroundTransparency = 0.8
	end
	
	if data.CurrentLap.Sector2.Time ~= nil then
		sectors.S2.BackgroundColor3 = _helpers:GetStateColor(data.CurrentLap.Sector2.State)
		sectors.S2.BackgroundTransparency = 0
	else
		sectors.S2.BackgroundColor3 = _helpers:GetStateColor(State.Default)
		sectors.S2.BackgroundTransparency = 0.8
	end

	if data.CurrentLap.Sector3.Time ~= nil then
		sectors.S3.BackgroundColor3 = _helpers:GetStateColor(data.CurrentLap.Sector3.State)
		sectors.S3.BackgroundTransparency = 0
	else
		sectors.S3.BackgroundColor3 = _helpers:GetStateColor(State.Default)
		sectors.S3.BackgroundTransparency = 0.8
	end

end

return service