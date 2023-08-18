local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local AttributeIndex = require(IPS2DevKit.AttributeIndex)
local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local function isInStack(item: Model): boolean
	return string.find(item:GetFullName(), ".ItemStack.") ~= nil
end

local function isInAssembly(item: Model): boolean
	return string.find(item:GetFullName(), ".AssemblyItems.") ~= nil
end

local function isButtonInteraction(item: Model): boolean
	return item.Name == "ButtonInteraction"
end

local function isInvalidItem(item: Model): (boolean, Types.LintResultPartial?)
	if not item:IsA("Model") then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item.Name}" is an invalid instance.`,
				subject = item,
			}
	end

	if not CollectionService:HasTag(item, "Item") then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" is missing the "Item" tag.`,
				subject = item,
			}
	end

	if
		CollectionService:HasTag(item, "LinkedItem")
		and not item:GetAttribute("LinkId")
		and not item:GetAttribute("TargetLinkId")
	then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" has unneeded "LinkedItem" tag.`,
				subject = item,
			}
	end

	if isInStack(item) and typeof(item:GetAttribute("Order")) ~= "number" then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" is missing the numerical "Order" attribute.`,
				subject = item,
			}
	end

	local isInvalid, invalidName = Util.HasInvalidAttributes(item, AttributeIndex.Items)
	if isInvalid then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" has invalid "{invalidName}" attribute.`,
				subject = item,
			}
	end

	if isButtonInteraction(item) then
		local assembly = item:FindFirstChild("Assembly")
		if not assembly or not assembly:IsA("Model") or not assembly.PrimaryPart then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid Assembly.`,
					subject = item,
				}
		end

		local assemblyOrigin = item:FindFirstChild("AssemblyOrigin")
		if not assemblyOrigin or not assemblyOrigin:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid AssemblyOrigin.`,
					subject = item,
				}
		end

		local assemblyTarget = item:FindFirstChild("AssemblyTarget")
		if not assemblyTarget or not assemblyTarget:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid AssemblyTarget.`,
					subject = item,
				}
		end

		local assemblyItems = item:FindFirstChild("AssemblyItems")
		if assemblyItems and not assemblyItems:IsA("Folder") then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid AssemblyItems container.`,
					subject = item,
				}
		end
	else
		local foundValidPrimary = false
		for _, instance in item:GetChildren() do
			if instance:IsA("BasePart") and string.sub(instance.Name, 1, 1) ~= "_" then
				foundValidPrimary = true
				break
			end
		end

		if not foundValidPrimary and not isButtonInteraction(item) then
			return true,
				{
					ok = false,
					statusMessage = `Item "{item:GetFullName()}" has no valid primary volume.`,
					subject = item,
				}
		end
	end

	return false, nil
end

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Require Items folder
	local items = map:FindFirstChild("Items")
	if not items or not items:IsA("Folder") then
		table.insert(results, {
			ok = false,
			statusMessage = "Unable to find Items folder.",
		})
	end

	-- Ensure items are valid and not nested
	for _, item in CollectionService:GetTagged("Item") do
		if not map:IsAncestorOf(item) then
			continue
		end

		local isInvalid, res = isInvalidItem(item)
		if isInvalid then
			table.insert(results, res)
			break
		end

		if isInAssembly(item) then
			continue
		end

		local hasNestedItems = false
		for _, descendant in item:GetDescendants() do
			if not CollectionService:HasTag(descendant, "Item") then
				continue
			end

			table.insert(results, {
				ok = false,
				statusMessage = `Nested Item "{descendant:GetFullName()}" found.`,
				subject = descendant,
			})

			hasNestedItems = true
			break
		end

		if hasNestedItems then
			break
		end
	end

	return results
end
