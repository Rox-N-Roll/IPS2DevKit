local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local allowedAttributes = {
	DisplayName = "string",
	CashValue = "number",
	Order = "number",
}

local function getItemByOrder(stack: Folder, order: number): Model?
	for _, item in stack:GetChildren() do
		if item:GetAttribute("Order") == order then
			return item
		end
	end

	return nil
end

local function isInvalidItem(item: Model): (boolean, Types.LintResultPartial?)
	local missingItemTag = not CollectionService:HasTag(item, "Item")
	if missingItemTag and not CollectionService:HasTag(item, "SpecialItem") then
		return true, {
			ok = false,
			statusMessage = `Item "{item:GetFullName()}" is missing the "Item" tag.`,
		}
	end

	local foundValidPrimary = false
	for _, instance in item:GetChildren() do
		if instance:IsA("BasePart") and string.sub(instance.Name, 1, 1) ~= "_" then
			foundValidPrimary = true
			break
		end
	end
	if not foundValidPrimary and not missingItemTag and not item:FindFirstChild("Actions") then
		return true, {
			ok = false,
			statusMessage = `Item "{item:GetFullName()}" has no valid primary volume.`,
		}
	end

	local isInvalid, invalidName = Util.HasInvalidAttributes(item, allowedAttributes)
	if isInvalid then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" has invalid "{invalidName}" attribute.`,
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

	-- Ensure items are valid
	for _, item in items:GetChildren() do
		if item:IsA("Model") then
			local isInvalid, res = isInvalidItem(item)
			if isInvalid then
				table.insert(results, res)
				break
			end
		elseif item:IsA("Folder") then
			if item.Name ~= "ItemStack" then
				table.insert(results, {
					ok = false,
					statusMessage = `ItemStack "{item:GetFullName()}" is not named properly.`,
				})
				break
			end

			local cancel = false
			for i = 1, #item:GetChildren() do
				local childItem = getItemByOrder(item, i)
				if not childItem then
					table.insert(results, {
						ok = false,
						statusMessage = `ItemStack "{item:GetFullName()}" is missing order "{i}" item.`,
					})
					cancel = true
					break
				end

				local isInvalid, res = isInvalidItem(childItem)
				if isInvalid then
					table.insert(results, res)
					cancel = true
					break
				end
			end

			if cancel then
				break
			end
		else
			table.insert(results, {
				ok = false,
				statusMessage = `Item "{item.Name}" is an invalid instance.`,
			})
			break
		end
	end

	return results
end
