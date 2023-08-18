local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Verify conditionals
	for _, single in CollectionService:GetTagged("Cond_Single") do
		if not map:IsAncestorOf(single) then
			continue
		end

		local children = {
			"Items",
			"Geometry",
			"NPCSpawns",
			"CamLocations",
			"FallbackItems",
			"FallbackGeometry",
			"FallbackNPCSpawns",
			"FallbackCamLocations",
		}

		local exit = false
		for _, child in single:GetChildren() do
			local index = table.find(children, child.Name)
			if not index then
				table.insert(results, {
					ok = false,
					statusMessage = `Cond_Single child "{child:GetFullName()}" is unknown or repeated.`,
					subject = child,
				})

				exit = true
				break
			end

			table.remove(children, index)
		end

		if exit then
			break
		end

		local isGroup = CollectionService:HasTag(single.Parent, "Cond_Group")
		local chanceSource = if isGroup then single.Parent else single

		if isGroup and single:GetAttribute("Chance") ~= nil then
			table.insert(results, {
				ok = false,
				statusMessage = `Cond_Single "{single:GetFullName()}" has unneeded "Chance" attribute.`,
				subject = single,
			})
			break
		end

		if typeof(chanceSource:GetAttribute("Chance")) ~= "number" then
			local condType = if isGroup then "Cond_Group" else "Cond_Single"
			table.insert(results, {
				ok = false,
				statusMessage = `{condType} "{chanceSource:GetFullName()}" is missing the numerical "Chance" attribute.`,
				subject = chanceSource,
			})
			break
		end
	end

	return results
end
