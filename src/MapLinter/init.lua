local IPS2DevKit = script.Parent

local Types = require(IPS2DevKit.Types)

local groups = {}
for _, module in IPS2DevKit.MapLinter.Groups:GetChildren() do
	groups[module.Name] = require(module)
end

local MapLinter = {}

local function runGroup(groupName: string): Types.LinterResult
	local map = workspace:FindFirstChild("Map")
	if not map or not map:IsA("Folder") then
		return {
			ok = false,
			groupName = groupName,
			statusMessage = "Unable to find map.",
		}
	end

	return groups[groupName](map)
end

function MapLinter.Group(name: string): { Types.LinterResult }
	return { runGroup(name) }
end

function MapLinter.All(): { Types.LinterResult }
	local results = {}

	for groupName in groups do
		table.insert(results, runGroup(groupName))
	end

	return results
end

return MapLinter
