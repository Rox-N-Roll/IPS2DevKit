local IPS2DevKit = script.Parent

local Types = require(IPS2DevKit.Types)

local groups = {}
for _, module in IPS2DevKit.MapLinter.Groups:GetChildren() do
	groups[module.Name] = require(module)
end

local MapLinter = {}

local function runGroups(groupNames: { string }): { Types.LintResult }
	local results = {}

	local map = workspace:FindFirstChild("Map")
	if not map or not map:IsA("Folder") then
		table.insert(results, {
			ok = false,
			name = "MapLinter",
			statusMessage = "Unable to find map.",
		})

		return results -- Skip lint groups, map needs to exist first
	end

	for _, groupName in groupNames do
		for _, result: Types.LintResultPartial in groups[groupName](map) do
			result.name = groupName
			table.insert(results, result :: Types.LintResult)
		end
	end

	return results
end

function MapLinter.Group(name: string): { Types.LintResult }
	return runGroups({ name })
end

function MapLinter.All(): { Types.LintResult }
	local groupNames = {}
	for groupName in groups do
		table.insert(groupNames, groupName)
	end

	return runGroups(groupNames)
end

return MapLinter
