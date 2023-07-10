local IPS2DevKit = script.Parent.Parent.Parent

local Types = IPS2DevKit.Types

local GROUP_NAME = "Global"

return function(map: Folder): Types.LinterResult
	-- No unachored BaseParts
	for _, instance in map:GetDescendants() do
		if instance:IsA("BasePart") and not instance.Anchored then
			return {
				ok = false,
				groupName = GROUP_NAME,
				statusMessage = "Map contains unanchored BaseParts.",
			}
		end
	end

	-- Pass
	return {
		ok = true,
		groupName = GROUP_NAME,
	}
end
