local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	for _, instance in map:GetDescendants() do
		if instance:IsA("BasePart") and not instance.Anchored then
			table.insert(results, {
				ok = false,
				statusMessage = "Map contains unanchored BaseParts.",
				subject = instance,
			})
			break
		elseif instance:IsA("BaseScript") then
			table.insert(results, {
				ok = false,
				statusMessage = "Map contains scripts.",
			})
			break
		end
	end

	local geometry = map:FindFirstChild("Geometry")
	if not geometry or not geometry:IsA("Folder") then
		table.insert(results, {
			ok = false,
			statusMessage = "Unable to find Geometry folder.",
		})
	end

	return results
end
