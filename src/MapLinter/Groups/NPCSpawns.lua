local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local ZONE_Y_SIZE = 0.05

local allowedAttributes = {
	RoundType_Disabled = "string",
	Universal_Disabled = "boolean",
	RateMultiplier = "number",
}

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Require NPCSpawns folder
	local npcSpawns = map:FindFirstChild("NPCSpawns")
	if not npcSpawns or not npcSpawns:IsA("Folder") then
		table.insert(results, {
			ok = false,
			statusMessage = "Unable to find NPCSpawns folder.",
		})
		return results
	end

	-- Ensure each zone is valid
	for _, zone in npcSpawns:GetChildren() do
		if not zone:IsA("Part") then
			table.insert(results, {
				ok = false,
				statusMessage = `Found invalid "{zone.Name}" NPC zone instance.`,
			})
			break
		end

		if zone.CanCollide or zone.CanTouch or zone.CanQuery or not Util.FloatEquals(zone.Size.Y, ZONE_Y_SIZE) then
			table.insert(results, {
				ok = false,
				statusMessage = `Found invalid properties of "{zone.Name}" NPC zone.`,
				subject = zone,
			})
			break
		end

		local isInvalid, invalidName = Util.HasInvalidAttributes(zone, allowedAttributes)
		if isInvalid then
			table.insert(results, {
				ok = false,
				statusMessage = `Found NPC zone "{zone.Name}" with invalid "{invalidName}" attribute.`,
				subject = zone,
			})
			break
		end
	end

	return results
end
