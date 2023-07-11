local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Require CamLocations folder
	local camLocations = map:FindFirstChild("CamLocations")
	if not camLocations or not camLocations:IsA("Folder") then
		table.insert(results, {
			ok = false,
			statusMessage = "Unable to find CamLocations folder.",
		})
		return results
	end

	-- No stray CamLocation tags
	for _, instance in CollectionService:GetTagged("CamLocation") do
		if map:IsAncestorOf(instance) and instance.Parent ~= camLocations then
			table.insert(results, {
				ok = false,
				statusMessage = "Stray CamLocation tag found.",
			})
			break
		end
	end

	-- TODO

	return results
end
