local CollectionService = game:GetService("CollectionService")

local IPS2DevKit = script.Parent.Parent.Parent

local Types = require(IPS2DevKit.Types)
local Util = require(IPS2DevKit.Util)

local function isInvalidPath(path: Folder): (boolean, Instance?)
	for i = 1, #path:GetChildren() do
		local node = path:FindFirstChild(i)
		if not node or not node:IsA("Part") or node.CanCollide or node.CanQuery or node.CanTouch then
			return true, node
		end
	end

	return false, nil
end

return function(map: Folder): { Types.LintResultPartial }
	local results = {}

	-- Require Entrances folder
	local entrances = map:FindFirstChild("Entrances")
	if not entrances or not entrances:IsA("Folder") then
		table.insert(results, {
			ok = false,
			statusMessage = "Unable to find Entrances folder.",
		})
		return results
	end

	-- Verify individual entrances
	local totalSeats = 0
	for _, entrance in entrances:GetChildren() do
		if not entrance:IsA("Folder") then
			table.insert(results, {
				ok = false,
				statusMessage = `Entrance "{entrance.Name}" is an invalid instance.`,
			})
			continue
		end

		for _, instance in { entrance, unpack(entrance:GetDescendants()) } do
			local isInvalid, invalidName = Util.HasInvalidAttributes(instance, Util.GetAllowedEntranceAttributes())

			if isInvalid then
				local res = {
					ok = false,
					statusMessage = `Entrance "{entrance.Name}" has instance "{instance:GetFullName()}" with invalid "{invalidName}" attribute.`,
				}

				if instance:IsA("BasePart") then
					res.subject = instance
				end

				table.insert(results, res)
				break
			end
		end

		local node = entrance:FindFirstChild("Node")
		if
			not node
			or not node:IsA("Part")
			or not node.CanQuery
			or node.CanTouch
			or node.CanCollide
			or not CollectionService:HasTag(node, "EntranceNode")
		then
			local res = {
				ok = false,
				statusMessage = `Entrance "{entrance.Name}" has invalid node.`,
			}

			if node and node:IsA("BasePart") then
				res.subject = node
			end

			table.insert(results, res)
		end

		local seats = entrance:FindFirstChild("Seats")
		if seats and seats:IsA("Folder") then
			local numSeats = #seats:GetChildren()

			if node and #node:GetChildren() > numSeats then
				table.insert(results, {
					ok = false,
					statusMessage = `Entrance "{entrance.Name}" node has excess attachments.`,
					subject = node,
				})
			end

			for i = 1, numSeats do
				local seat = seats:FindFirstChild(i)
				if not seat or not seat:IsA("Seat") then
					table.insert(results, {
						ok = false,
						statusMessage = `Entrance "{entrance.Name}" is missing the "{i}" seat. Do you have stray instances?`,
					})
					break
				end

				if node then
					local att = node:FindFirstChild(i)
					if not att then
						table.insert(results, {
							ok = false,
							statusMessage = `Entrance "{entrance.Name}" node is missing the "{i}" attachment.`,
							subject = node,
						})
						break
					end
				end

				totalSeats += 1
			end
		else
			table.insert(results, {
				ok = false,
				statusMessage = `Unable to find entrance "{entrance.Name}" seats.`,
			})
		end

		local actions = entrance:FindFirstChild("Actions")
		if not actions or not actions:IsA("Folder") then
			table.insert(results, {
				ok = false,
				statusMessage = `Unable to find entrance "{entrance.Name}" actions.`,
			})
		end

		local path = entrance:FindFirstChild("Path")
		if path and path:IsA("Folder") then
			local isInvalid, instance = isInvalidPath(path)

			if isInvalid then
				local res = {
					ok = false,
					statusMessage = `Entrance "{entrance.Name}" path has invalid children. Do you have stray instances or incorrect properties?`,
				}

				if instance:IsA("BasePart") then
					res.subject = instance
				end

				table.insert(results, res)
			end
		else
			table.insert(results, {
				ok = false,
				statusMessage = `Unable to find entrance "{entrance.Name}" path.`,
			})
		end

		local npcPath = entrance:FindFirstChild("NPCPath")
		if npcPath and npcPath:IsA("Folder") then
			local spawnLoc = npcPath:FindFirstChild("1")

			if spawnLoc and actions then
				local seatName = spawnLoc:GetAttribute("Sit")
				if seatName then
					local seatPart = actions:FindFirstChild(seatName)
					if not seatPart or not seatPart:IsA("Seat") then
						table.insert(results, {
							ok = false,
							statusMessage = `Entrance "{entrance.Name}" NPC path start has a missing seat assigned.`,
							subject = spawnLoc,
						})
					end
				end
			end

			local isInvalid, instance = isInvalidPath(npcPath)
			if isInvalid then
				local res = {
					ok = false,
					statusMessage = `Entrance "{entrance.Name}" NPC path has invalid children. Do you have stray instances or incorrect properties?`,
				}

				if instance:IsA("BasePart") then
					res.subject = instance
				end

				table.insert(results, res)
			end
		else
			table.insert(results, {
				ok = false,
				statusMessage = `Unable to find entrance "{entrance.Name}" NPC path.`,
			})
		end
	end

	if totalSeats < 12 then
		table.insert(results, {
			ok = false,
			statusMessage = "Map is lacking at least 12 valid seats with corresponding node attachments.",
		})
	end

	return results
end
