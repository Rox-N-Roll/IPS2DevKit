local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ServerStorage = game:GetService("ServerStorage")
local Selection = game:GetService("Selection")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)
local assets = IPS2DevKit.Assets

local function getSpawnParent(mapFolderName: string?): Instance
	local map = workspace:FindFirstChild("Map")
	if map then
		if mapFolderName then
			local folder = map:FindFirstChild(mapFolderName)
			if folder then
				return folder
			end
		else
			return map
		end
	end

	return workspace
end

local MapMakingAssets = {}

function MapMakingAssets.CameraLocation()
	local location = Util.GetSpawnLocation(8)

	local camLocations = getSpawnParent("CamLocations")
	local name = if camLocations.Name == "CamLocations" then #camLocations:GetChildren() + 1 else "RENAME_ME"

	local camLocation = assets.CamLocation:Clone()
	local cutout = assets.CamLocationCutout:Clone()
	camLocation.Name = name
	camLocation:PivotTo(location)
	cutout:PivotTo(location)
	camLocation.Parent = camLocations
	cutout.Parent = getSpawnParent()

	Selection:Set({ camLocation, cutout })
	ChangeHistoryService:SetWaypoint("Insert Camera Location")
end

function MapMakingAssets.NPCSpawn()
	local template = assets.NPCSpawn:Clone()
	template.Name = "Part"
	template:PivotTo(Util.GetSpawnLocation(8))
	template.Parent = getSpawnParent("NPCSpawns")

	Selection:Set({ template })
	ChangeHistoryService:SetWaypoint("Insert NPC Spawn")
end

function MapMakingAssets.StandardItemsKit()
	local kit = assets.StandardItemsKit:Clone()
	kit:PivotTo(Util.GetSpawnLocation(30))
	kit.Parent = workspace

	Selection:Set({ kit })
	ChangeHistoryService:SetWaypoint("Insert Standard Items Kit")
end

function MapMakingAssets.ReconcileMapTags()
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
		ChangeHistoryService:SetWaypoint("Reconcile Map Tags")
	end
end

return MapMakingAssets
