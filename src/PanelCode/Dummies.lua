local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)
local assets = IPS2DevKit.Assets

local Dummies = {}

function Dummies.InsertCamera()
	local camera = assets.Camera:Clone()
	camera:PivotTo(Util.GetSpawnLocation(6))
	camera.Parent = workspace

	Selection:Set({ camera })
	ChangeHistoryService:SetWaypoint("Insert Camera")
end

function Dummies.InsertThief(name: string)
	local thief = assets.Thieves[name]:Clone()
	thief:PivotTo(Util.GetSpawnLocation(7))
	thief.Parent = workspace

	Selection:Set({ thief })
	ChangeHistoryService:SetWaypoint("Insert Thief")
end

return Dummies
