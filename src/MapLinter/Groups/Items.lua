local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local allowedAttributes = {
	DisplayName = "string",
	CashValue = "number",
	Order = "number",
}

local function isInvalidItem(item: Model): (boolean, Types.LintResultPartial?)
	if not item:IsA("Model") then
		return true, {
			ok = false,
			statusMessage = `Item "{item.Name}" is an invalid instance.`,
		}
	end

	local missingItemTag = not CollectionService:HasTag(item, "Item")
	if missingItemTag and not CollectionService:HasTag(item, "SpecialItem") then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" is missing the "Item" tag.`,
				subject = item,
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
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" has no valid primary volume.`,
				subject = item,
			}
	end

	local isInvalid, invalidName = Util.HasInvalidAttributes(item, allowedAttributes)
	if isInvalid then
		return true,
			{
				ok = false,
				statusMessage = `Item "{item:GetFullName()}" has invalid "{invalidName}" attribute.`,
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
					subject = item,
				})
				break
			end

			for _, childItem in item:GetChildren() do
				local order = childItem:GetAttribute("Order")
				if typeof(order) ~= "number" then
					table.insert(results, {
						ok = false,
						statusMessage = `Item "{childItem:GetFullName()}" is missing the numerical "Order" attribute.`,
						subject = item,
					})
					break
				end

				local isInvalid, res = isInvalidItem(childItem)
				if isInvalid then
					table.insert(results, res)
					break
				end
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
