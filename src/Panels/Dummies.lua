local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)
local assets = IPS2DevKit.Assets

local function insertThief(name: string)
	local thief = assets.Thieves[name]:Clone()
	thief:PivotTo(Util.GetSpawnLocation(7))
	thief.Parent = workspace

	Selection:Set({ thief })
	ChangeHistoryService:SetWaypoint("Insert Thief")
end

return {
	{
		id = "Cameras",
		displays = {
			{
				class = "title",
				text = "Cameras",
			},
			{
				class = "button",
				text = "Basic",

				activated = function()
					local camera = assets.Camera:Clone()
					camera:PivotTo(Util.GetSpawnLocation(6))
					camera.Parent = workspace

					Selection:Set({ camera })
					ChangeHistoryService:SetWaypoint("Insert Camera")
				end,
			},
		},
	},
	{
		id = "Thieves",
		displays = {
			{
				class = "title",
				text = "Thieves",
			},
			{
				class = "button",
				text = "Mr. Black",

				activated = function()
					insertThief("Mr. Black")
				end,
			},
			{
				class = "button",
				text = "Mr. White",

				activated = function()
					insertThief("Mr. White")
				end,
			},
			{
				class = "button",
				text = "Brownie",

				activated = function()
					insertThief("Brownie")
				end,
			},
			{
				class = "button",
				text = "Ms. Purple",

				activated = function()
					insertThief("Ms. Purple")
				end,
			},
			{
				class = "button",
				text = "Pinky",

				activated = function()
					insertThief("Pinky")
				end,
			},
		},
	},
}
