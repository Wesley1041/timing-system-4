local config = {
	
	-- Admin users
	AdminUsers = {"Wesley1041"},
	AdminRoles = {
		{
			GroupId = 12345678,
			Rank = 200
		}
	},

	-- Settings
	PlayerMustBeSeated = false,
	CornerCutCooldownSeconds = 1,

	-- Anti Cheat
	CheckForAntiCheat = false,
	MinimumLapTime = 1,
	MinimumSectorTime = 1,
	KickWhenCheat = true,

	-- Input mapping
	ToggleBoardGuiKey = Enum.KeyCode.Q,

	-- References
	Board = script.Parent.Board:WaitForChild("Board"),

	-- Styling
	Styles = {
		PositionBoxBackground = Color3.fromRGB(255, 255, 255),
		PositionBoxText = Color3.fromRGB(0, 0, 0),
		PositionFirstBoxBackground = Color3.fromRGB(146, 12, 255),
		PositionFirstBoxText = Color3.fromRGB(255, 255, 255),

		DefaultState = Color3.fromRGB(255, 255, 255),
		InvalidState = Color3.fromRGB(240, 30, 30),
		PersonalBestState = Color3.fromRGB(71, 255, 71),
		OverallBestState = Color3.fromRGB(146, 12, 255),

		DefaultStateText = Color3.fromRGB(255, 255, 255),
		InvalidStateText = Color3.fromRGB(240, 30, 30),
		PersonalBestStateText = Color3.fromRGB(71, 255, 71),
		OverallBestStateText = Color3.fromRGB(169, 63, 255),

		DefaultStatePopup = Color3.fromRGB(0, 0, 0),
		InvalidStatePopup = Color3.fromRGB(170, 41, 41),
		PersonalBestStatePopup = Color3.fromRGB(44, 175, 44),
		OverallBestStatePopup = Color3.fromRGB(118, 45, 177),
	},
}

return config
