local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local AttributeIndex = require(IPS2DevKit.AttributeIndex)
local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local ItemEval = {}

function ItemEval.IsInvalidItem(item: Model): (boolean, Types.LintResultPartial?)
	if not item:IsA("Model") then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item.Name}" is an invalid instance.`,
				subject = item,
			}
	end

	local isCaseItem = item.Name == "Case"
	local isButtonInteractionItem = item.Name == "ButtonInteraction"
	local isSpecialItem = CollectionService:HasTag(item, "SpecialItem")
	local missingItemTag = not CollectionService:HasTag(item, "Item")

	if missingItemTag and not isSpecialItem then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" is missing the "Item" tag.`,
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

	if isCaseItem then
		local axis = item:FindFirstChild("Axis")
		if not axis or not axis:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Item/Case "{item:GetFullName()}" has an invalid axis.`,
					subject = item,
				}
		end

		local goal = axis:FindFirstChild("Goal")
		if not goal or not goal:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Item/Case "{item:GetFullName()}" has an invalid goal.`,
					subject = item,
				}
		end

		local caseItems = item:FindFirstChild("CaseItems")
		if not caseItems or not caseItems:IsA("Folder") then
			return true,
				{
					ok = false,
					statusMessage = `Item/Case "{item:GetFullName()}" has invalid an case items folder.`,
					subject = item,
				}
		end

		for _, childItem in caseItems:GetChildren() do
			local isInvalidChild, res = ItemEval.IsInvalidItemResolvable(childItem)
			if isInvalidChild then
				return true, res
			end
		end
	elseif isButtonInteractionItem then
		local actions = item:FindFirstChild("Actions")
		if not actions or not actions:IsA("Folder") then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid actions folder.`,
					subject = item,
				}
		end

		local doorOrigin = actions:FindFirstChild("DoorOrigin")
		if not doorOrigin or not doorOrigin:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid origin.`,
					subject = item,
				}
		end

		local doorTarget = actions:FindFirstChild("DoorTarget")
		if not doorTarget or not doorTarget:IsA("BasePart") then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid target.`,
					subject = item,
				}
		end

		local door = actions:FindFirstChild("Door")
		if not door or not door:IsA("Model") or not door.PrimaryPart then
			return true,
				{
					ok = false,
					statusMessage = `Item/ButtonInteraction "{item:GetFullName()}" has an invalid door.`,
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

		if not foundValidPrimary and not missingItemTag and not isButtonInteractionItem then
			return true,
				{
					ok = false,
					statusMessage = `Item "{item:GetFullName()}" has no valid primary volume.`,
					subject = item,
				}
		end
	end

	if isSpecialItem then
		local childItems = {}

		local fallbackItems = item:FindFirstChild("FallbackItems")
		if fallbackItems then
			for _, childItem in fallbackItems:GetChildren() do
				table.insert(childItems, childItem)
			end
		end

		local extraItems = item:FindFirstChild("ExtraItems")
		if extraItems then
			for _, childItem in extraItems:GetChildren() do
				table.insert(childItems, childItem)
			end
		end

		for _, childItem in childItems do
			local isInvalidChild, res = ItemEval.IsInvalidItemResolvable(childItem)
			if isInvalidChild then
				return true, res
			end
		end
	end

	return false, nil
end

function ItemEval.IsInvalidItemResolvable(item: Instance): (boolean, Types.LintResultPartial?)
	if item:IsA("Model") then
		local isInvalid, res = ItemEval.IsInvalidItem(item)
		if isInvalid then
			return true, res
		end
	elseif item:IsA("Folder") then
		if item.Name ~= "ItemStack" then
			return true,
				{
					ok = false,
					statusMessage = `ItemStack "{item:GetFullName()}" is not named properly.`,
					subject = item,
				}
		end

		for _, childItem in item:GetChildren() do
			local order = childItem:GetAttribute("Order")
			if typeof(order) ~= "number" then
				return true,
					{
						ok = false,
						statusMessage = `Item "{childItem:GetFullName()}" is missing the numerical "Order" attribute.`,
						subject = item,
					}
			end

			local isInvalid, res = ItemEval.IsInvalidItem(childItem)
			if isInvalid then
				return true, res
			end
		end
	else
		return true,
			{
				ok = false,
				statusMessage = `Item "{item.Name}" is an invalid instance.`,
				subject = item,
			}
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
		return results
	end

	-- Ensure no nested items
	for _, item in CollectionService:GetTagged("Item") do
		if not map:IsAncestorOf(item) then
			continue
		end

		for _, descendant in item:GetDescendants() do
			if not CollectionService:HasTag(descendant, "Item") then
				continue
			end

			table.insert(results, {
				ok = false,
				statusMessage = `Nested Item "{descendant:GetFullName()}" found.`,
				subject = descendant,
			})
		end
	end

	-- Ensure items are valid
	for _, item in items:GetChildren() do
		local isInvalid, res = ItemEval.IsInvalidItemResolvable(item)
		if isInvalid then
			table.insert(results, res)
			break
		end
	end

	return results
end
