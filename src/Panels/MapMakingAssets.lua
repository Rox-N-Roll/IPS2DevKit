local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ServerStorage = game:GetService("ServerStorage")
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
			{
				class = "button",
				text = "Insert Map CollectionService Tags",

				activated = function()
					local tagList = ServerStorage:FindFirstChild("TagList")
					if not tagList then
						tagList = Instance.new("Folder")
						tagList.Name = "TagList"
						tagList.Parent = ServerStorage
					end

					local inserted = false
					for _, tag in assets.MapTags:GetChildren() do
						if not tagList:FindFirstChild(tag.Name) then
							tag:Clone().Parent = tagList
							inserted = true
						end
					end

					if inserted then
						ChangeHistoryService:SetWaypoint("Insert Map CollectionService Tags")
					end
				end,
			},
		},
	},
}
