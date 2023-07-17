local ChangeHistoryService = game:GetService("ChangeHistoryService")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)

local RNG = Random.new()

local assets = IPS2DevKit.Assets

local MapEntrances = {}

function MapEntrances.CreatePathNodeAtNPC()
	local npc = Util.GetSelected()
	if not npc then
		warn("Nothing selected!")
		return
	end

	local hrp = npc:FindFirstChild("HumanoidRootPart")
	if not hrp or not hrp:IsA("BasePart") then
		warn("Invalid selected NPC!")
		return
	end

	local pathNode = assets.PathNode:Clone()
	pathNode.Name = "RENAME_ME"
	pathNode:PivotTo(hrp.CFrame)
	pathNode.Parent = workspace

	ChangeHistoryService:SetWaypoint("Create Path Node at NPC")
end

function MapEntrances.CreateNPCAtPathNode()
	local node = Util.GetSelected()
	if not node then
		warn("Nothing selected!")
		return
	end
	if not node:IsA("BasePart") then
		warn("Invalid selected path node!")
		return
	end

	local npcs = assets.Thieves:GetChildren()
	local npc = npcs[RNG:NextInteger(1, #npcs)]:Clone()
	npc:PivotTo(node.CFrame)
	npc.Parent = node.Parent

	ChangeHistoryService:SetWaypoint("Create NPC at Path Node")
end

function MapEntrances.AddAttribute(name: string, attributeType: string)
	local instance = Util.GetSelected()
	if not instance then
		warn("Nothing selected!")
		return
	end

	if instance:GetAttribute(name) ~= nil then
		warn("Attribute already exists!")
		return
	end

	local defaultValue
	if attributeType == "string" then
		defaultValue = ""
	elseif attributeType == "number" then
		defaultValue = 0
	elseif attributeType == "boolean" then
		defaultValue = true
	else
		error("unsupported attribute type")
	end

	instance:SetAttribute(name, defaultValue)
	ChangeHistoryService:SetWaypoint(`Add {name} Attribute`)
end

return MapEntrances
