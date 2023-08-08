local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local AttributeIndex = require(IPS2DevKit.AttributeIndex)
local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local function isInStack(item: Model): boolean
	return item.Parent.Name == "ItemStack"
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

	local isCaseItem = item.Name == "Case"
	local isButtonInteractionItem = item.Name == "ButtonInteraction"
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

		if not foundValidPrimary and not isButtonInteractionItem then
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

		local nested = false
		for _, descendant in item:GetDescendants() do
			if not CollectionService:HasTag(descendant, "Item") then
				continue
			end

			table.insert(results, {
				ok = false,
				statusMessage = `Nested Item "{descendant:GetFullName()}" found.`,
				subject = descendant,
			})

			nested = true
			break
		end

		if nested then
			break
		end
	end

	return results
end
