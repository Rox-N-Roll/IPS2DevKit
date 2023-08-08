local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

local function isMissingChance(condType: string, cond: Folder): Types.LintResultPartial?
	if typeof(cond:GetAttribute("Chance")) ~= "number" then
		return {
			ok = false,
			statusMessage = `{condType} "{cond:GetFullName()}" is missing the numerical "Chance" attribute.`,
			subject = cond,
		}
	end

	return nil
end

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	for _, single in CollectionService:GetTagged("Cond_Single") do
		if not map:IsAncestorOf(results) then
			continue
		end

		local exit = false
		local children = { "Items", "Geometry", "FallbackItems", "FallbackGeometry" }
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

		local invalidRes = if CollectionService:HasTag(single.Parent, "Cond_Group")
			then isMissingChance("Cond_Group", single.Parent)
			else isMissingChance("Cond_Single", single)

		if invalidRes then
			table.insert(results, invalidRes)
			break
		end
	end

	return results
end
