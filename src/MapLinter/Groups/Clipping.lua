local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)

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

	-- Ensure player folder exists
	local player = clipping:FindFirstChild("Player")
	if player and player:IsA("Folder") then
		for _, instance in player:GetChildren() do
			if not instance:IsA("BasePart") then
				table.insert(results, {
					ok = false,
					statusMessage = `Found player clipping "{instance.Name}" is an invalid instance.`,
				})
				break
			end

			if not instance.CanCollide or not instance.CanQuery or not instance.CanTouch then
				table.insert(results, {
					ok = false,
					statusMessage = `Found player clipping "{instance.Name}" has invalid properties.`,
				})
				break
			end

			if not CollectionService:HasTag(instance, "Clip_Player") then
				table.insert(results, {
					ok = false,
					statusMessage = `Found player clipping "{instance.Name}" is missing the "Clip_Player" tag.`,
				})
				break
			end
		end
	else
		table.insert(results, {
			ok = false,
			statusMessage = `Unable to find "Player" clipping folder.`,
		})
	end

	-- Ensure entrance folder exists
	local entrance = clipping:FindFirstChild("Entrance")
	if entrance and entrance:IsA("Folder") then
		for _, instance in entrance:GetChildren() do
			if not instance:IsA("BasePart") then
				table.insert(results, {
					ok = false,
					statusMessage = `Found entrance clipping "{instance.Name}" is an invalid instance.`,
				})
				break
			end

			if not instance.CanCollide or not instance.CanQuery or not instance.CanTouch then
				table.insert(results, {
					ok = false,
					statusMessage = `Found entrance clipping "{instance.Name}" has invalid properties.`,
				})
				break
			end

			if not CollectionService:HasTag(instance, "Clip_Entrance") then
				table.insert(results, {
					ok = false,
					statusMessage = `Found entrance clipping "{instance.Name}" is missing the "Clip_Entrance" tag.`,
				})
				break
			end
		end
	else
		table.insert(results, {
			ok = false,
			statusMessage = `Unable to find "Entrance" clipping folder.`,
		})
	end

	-- Ensure bounds folder exists
	local bounds = clipping:FindFirstChild("Bounds")
	local mapEntrances = map:FindFirstChild("Entrances")
	if bounds and bounds:IsA("Folder") then
		for _, instance in bounds:GetChildren() do
			if not instance:IsA("BasePart") then
				table.insert(results, {
					ok = false,
					statusMessage = `Found bounds clipping "{instance.Name}" is an invalid instance.`,
				})
				break
			end

			if instance.CanCollide or instance.CanQuery or not instance.CanTouch then
				table.insert(results, {
					ok = false,
					statusMessage = `Found bounds clipping "{instance.Name}" has invalid properties.`,
				})
				break
			end

			if not CollectionService:HasTag(instance, "Clip_Bounds") then
				table.insert(results, {
					ok = false,
					statusMessage = `Found bounds clipping "{instance.Name}" is missing the "Clip_Bounds" tag.`,
				})
				break
			end

			if mapEntrances then
				local entranceGoal = instance:GetAttribute("Entrance")
				if not entranceGoal or not mapEntrances:FindFirstChild(entranceGoal) then
					table.insert(results, {
						ok = false,
						statusMessage = `Found bounds clipping "{instance.Name}" has invalid entrance attribute.`,
					})
					break
				end
			end
		end

		if not bounds:FindFirstChild("Broad") then
			table.insert(results, {
				ok = false,
				statusMessage = `Found bounds clipping has no "Broad" parts.`,
			})
		end
	else
		table.insert(results, {
			ok = false,
			statusMessage = `Unable to find "Bounds" clipping folder.`,
		})
	end

	return results
end
