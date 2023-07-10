local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)
local assets = IPS2DevKit.Assets

return {
	{
		id = "Kits",
		displays = {
			{
				class = "button",
				text = "Insert Camera Location Kit",

				activated = function()
					local location = Util.GetSpawnLocation(8)

					local camLocation = assets.CamLocation:Clone()
					local cutout = assets.CamLocationCutout:Clone()
					camLocation:PivotTo(location)
					cutout:PivotTo(location)
					camLocation.Parent = workspace
					cutout.Parent = workspace

					Selection:Set({ camLocation, cutout })
					ChangeHistoryService:SetWaypoint("Insert Camera Location Kit")
				end,
			},
			{
				class = "button",
				text = "Insert Standard Items Kit",

				activated = function()
					local kit = assets.StandardItemsKit:Clone()
					kit:PivotTo(Util.GetSpawnLocation(30))
					kit.Parent = workspace

					Selection:Set({ kit })
					ChangeHistoryService:SetWaypoint("Insert Standard Items Kit")
				end,
			},
		},
	},
}
