local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local propertyChecks = {
	"Color",
	"Size",
	"Transparency",
	"Material",
	"CanQuery",
	"CanTouch",
	"CanCollide",
	"CastShadow",
}

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

	-- Ensure tagged camlocations are descendants of the camlocations folder
	local hasStray, stayLoc = Util.HasStrayInstances(map, camLocations, CollectionService:GetTagged("CamLocation"))
	if hasStray then
		table.insert(results, {
			ok = false,
			statusMessage = `Tagged CamLocation "{stayLoc:GetFullName()}" is not in the CamLocations folder.`,
			subject = stayLoc,
		})
	end

	-- Ensure there are at least 4 camera locations
	local locations = camLocations:GetChildren()
	if #locations < 4 then
		table.insert(results, {
			ok = false,
			statusMessage = "Less than 4 camera locations.",
		})
	end

	-- Ensure CamLocations are uniform
	local template = IPS2DevKit.Assets.CamLocation
	for i = 1, #locations do
		local loc = camLocations:FindFirstChild(i)
		if not loc or not loc:IsA("Part") then
			table.insert(results, {
				ok = false,
				statusMessage = `Missing "{i}" camera location. Do you have stray instances?`,
			})
			break
		end

		if not CollectionService:HasTag(loc, "CamLocation") then
			table.insert(results, {
				ok = false,
				statusMessage = `Camera location "{i}" is missing the "CamLocation" tag.`,
				subject = loc,
			})
			break
		end

		local displayName = loc:GetAttribute("DisplayName")
		if typeof(displayName) ~= "string" or string.len(displayName) <= 0 then
			table.insert(results, {
				ok = false,
				statusMessage = `Camera location "{i}" has invalid "DisplayName" attribute.`,
				subject = loc,
			})
		end

		for _, name in propertyChecks do
			if loc[name] ~= template[name] then
				table.insert(results, {
					ok = false,
					statusMessage = `Camera location "{i}" has invalid "{name}" property.`,
					subject = loc,
				})
			end
		end

		local faces = { Enum.NormalId.Top, Enum.NormalId.Bottom }
		local dirTexture = template:FindFirstChildOfClass("Decal")
		for _, child in loc:GetChildren() do
			if not child:IsA("Decal") or child.Texture ~= dirTexture.Texture then
				table.insert(results, {
					ok = false,
					statusMessage = `Camera location "{i}" has invalid children.`,
					subject = child,
				})
				break
			end

			local index = table.find(faces, child.Face)
			if not index then
				table.insert(results, {
					ok = false,
					statusMessage = `Camera location "{i}" has invalid children.`,
					subject = child,
				})
				break
			end

			table.remove(faces, index)
		end

		if #faces ~= 0 then
			table.insert(results, {
				ok = false,
				statusMessage = `Camera location "{i}" has invalid children.`,
				subject = loc,
			})
			break
		end
	end

	return results
end
