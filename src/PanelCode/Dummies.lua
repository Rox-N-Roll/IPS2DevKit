local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)
local assets = IPS2DevKit.Assets

local Dummies = {}

function Dummies.InsertCamera()
	local recording = ChangeHistoryService:TryBeginRecording("Insert Camera")
	if not recording then
		return
	end

	local camera = assets.Camera:Clone()
	camera:PivotTo(Util.GetSpawnLocation(6))
	camera.Parent = Util.GetSelected() or workspace

	Selection:Set({ camera })
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

function Dummies.InsertThief(name: string)
	local recording = ChangeHistoryService:TryBeginRecording("Insert Thief")
	if not recording then
		return
	end

	local thief = assets.Thieves[name]:Clone()
	thief:PivotTo(Util.GetSpawnLocation(7))
	thief.Parent = Util.GetSelected() or workspace

	Selection:Set({ thief })
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

return Dummies
