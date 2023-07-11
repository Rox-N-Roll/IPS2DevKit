local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Map shouldn't be tagged
	if #CollectionService:GetTags(map) > 0 then
		table.insert(results, {
			ok = false,
			statusMessage = "Map is tagged.",
		})
	end

	-- No unachored BaseParts
	for _, instance in map:GetDescendants() do
		if instance:IsA("BasePart") and not instance.Anchored then
			table.insert(results, {
				ok = false,
				statusMessage = "Map contains unanchored BaseParts.",
			})
			break
		end
	end

	return results
end
