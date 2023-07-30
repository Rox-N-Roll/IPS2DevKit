local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local function isInvalidClippingFolder(
	map: Folder,
	holder: Folder,
	name: string,
	customCondition: ((instance: Instance) -> Types.LintResultPartial?)?
): (boolean, Types.LintResultPartial?)
	local clipping = holder:FindFirstChild(name)
	if not clipping or not clipping:IsA("Folder") then
		return true, {
			ok = false,
			statusMessage = `Unable to find "{name}" clipping folder.`,
		}
	end

	local tag = "Clip_" .. name
	local hasStray, strayClipping = Util.HasStrayInstances(map, clipping, CollectionService:GetTagged(tag))
	if hasStray then
		return true,
			{
				ok = false,
				statusMessage = `Tagged {tag} "{strayClipping:GetFullName()}" is not in the {name} clipping folder.`,
				subject = strayClipping,
			}
	end

	for _, instance in clipping:GetChildren() do
		if not instance:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Found {name} clipping "{instance.Name}" is an invalid instance.`,
					subject = instance,
				}
		end

		local propertiesCond = if name == "Bounds"
			then (instance.CanCollide or instance.CanQuery or not instance.CanTouch)
			else (not instance.CanCollide or not instance.CanQuery or not instance.CanTouch)

		if propertiesCond then
			return true,
				{
					ok = false,
					statusMessage = `Found {name} clipping "{instance.Name}" has invalid properties.`,
					subject = instance,
				}
		end

		if not CollectionService:HasTag(instance, tag) then
			return true,
				{
					ok = false,
					statusMessage = `Found {name} clipping "{instance.Name}" is missing the "{tag}" tag.`,
					subject = instance,
				}
		end

		if customCondition then
			local res = customCondition(instance)
			if res then
				return true, res
			end
		end
	end

	return false, nil
end

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Require Clipping folder
	local clipping = map:FindFirstChild("Clipping")
	if not clipping or not clipping:IsA("Folder") then
		table.insert(results, {
			ok = false,
			statusMessage = "Unable to find Clipping folder.",
		})
		return results
	end

	-- Validate clipping folders
	local mapEntrances = map:FindFirstChild("Entrances")
	local function boundsCustomCondition(instance: Instance): Types.LintResultPartial?
		if not mapEntrances then
			return nil
		end

		local entranceGoal = instance:GetAttribute("Entrance")
		if entranceGoal and mapEntrances:FindFirstChild(entranceGoal) then
			return nil
		end

		return {
			ok = false,
			statusMessage = `Found Bounds clipping "{instance.Name}" has invalid entrance attribute.`,
			subject = instance,
		}
	end

	for _, name in { "Player", "Entrance", "Bounds" } do
		local customCondition = if name == "Bounds" then boundsCustomCondition else nil
		local isInvalid, res = isInvalidClippingFolder(map, clipping, name, customCondition)

		if isInvalid then
			table.insert(results, res)
		end
	end

	return results
end
