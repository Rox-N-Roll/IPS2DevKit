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
	local recording = ChangeHistoryService:TryBeginRecording("Insert Camera Location")
	if not recording then
		return
	end

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
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

function MapMakingAssets.NPCSpawn()
	local recording = ChangeHistoryService:TryBeginRecording("Insert NPC Spawn")
	if not recording then
		return
	end

	local template = assets.NPCSpawn:Clone()
	template.Name = "Part"
	template:PivotTo(Util.GetSpawnLocation(8))
	template.Parent = getSpawnParent("NPCSpawns")

	Selection:Set({ template })
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

function MapMakingAssets.StandardItemsKit()
	local recording = ChangeHistoryService:TryBeginRecording("Insert Standard Items Kit")
	if not recording then
		return
	end

	local kit = assets.StandardItemsKit:Clone()
	kit:PivotTo(Util.GetSpawnLocation(30))
	kit.Parent = workspace

	Selection:Set({ kit })
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

function MapMakingAssets.ReconcileMapTags()
	local recording = ChangeHistoryService:TryBeginRecording("Reconcile Map Tags")
	if not recording then
		return
	end

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

	ChangeHistoryService:FinishRecording(
		recording,
		Enum.FinishRecordingOperation[if inserted then "Commit" else "Cancel"]
	)
end

return MapMakingAssets
