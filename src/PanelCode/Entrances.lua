local ChangeHistoryService = game:GetService("ChangeHistoryService")

local IPS2DevKit = script.Parent.Parent

local Util = require(IPS2DevKit.Util)

local RNG = Random.new()

local assets = IPS2DevKit.Assets

local Entrances = {}

function Entrances.CreatePathNodeAtNPC()
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

	local recording = ChangeHistoryService:TryBeginRecording("Create Path Node at NPC")
	if not recording then
		return
	end

	local pathHolder
	local map = workspace:FindFirstChild("Map")
	if map then
		local entrances = map:FindFirstChild("Entrances")
		if entrances then
			for _, entrance in entrances:GetChildren() do
				local path = entrance:FindFirstChild("Path")
				local npcPath = entrance:FindFirstChild("NPCPath")

				if path and npc.Parent == path then
					pathHolder = path
					break
				elseif npcPath and npc.Parent == npcPath then
					pathHolder = npcPath
					break
				end
			end
		end
	end

	-- Don't add one to number children because the NPC itself is parented there
	local name = if pathHolder then #pathHolder:GetChildren() else "RENAME_ME"

	local pathNode = assets.PathNode:Clone()
	pathNode.Name = name
	pathNode:PivotTo(hrp.CFrame)
	pathNode.Parent = pathHolder or workspace

	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

function Entrances.CreateNPCAtPathNode()
	local node = Util.GetSelected()
	if not node then
		warn("Nothing selected!")
		return
	end
	if not node:IsA("BasePart") then
		warn("Invalid selected path node!")
		return
	end

	local recording = ChangeHistoryService:TryBeginRecording("Create NPC at Path Node")
	if not recording then
		return
	end

	local npcs = assets.Thieves:GetChildren()
	local npc = npcs[RNG:NextInteger(1, #npcs)]:Clone()
	npc:PivotTo(node.CFrame)
	npc.Parent = node.Parent

	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

return Entrances
