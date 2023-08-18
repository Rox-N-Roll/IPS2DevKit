local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	for _, link in CollectionService:GetTagged("Item") do
		if not map:IsAncestorOf(link) then
			continue
		end

		if
			CollectionService:HasTag(link, "Link")
			and not link:GetAttribute("LinkId")
			and not link:GetAttribute("TargetLinkId")
		then
			table.insert(results, {
				ok = false,
				statusMessage = `Link "{link:GetFullName()}" has unneeded "Link" tag.`,
				subject = link,
			})
			return results
		end
	end

	return results
end
