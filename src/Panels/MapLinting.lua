local IPS2DevKit = script.Parent.Parent

local MapLinter = require(IPS2DevKit.MapLinter)
local Types = require(IPS2DevKit.Types)

local function handleResults(category: string, results: { Types.LintResult })
	local parsedResults = {}
	local pass = true

	for _, result in results do
		if not result.ok then
			pass = false
			table.insert(parsedResults, { result.name, result.statusMessage })
		end
	end

	local line = string.rep("-", 35)
	local output = `\n{line}\nLinting: {category}\nResult: {if pass then "PASS" else "FAIL"}\n`
	if #parsedResults > 0 then
		output ..= "Status messages:\n"
		for _, data in parsedResults do
			output ..= `- {data[2]} ({data[1]})\n`
		end
	end
	output ..= line .. "\n"

	print(output)
end

return {
	{
		id = "AllGroups",
		displays = {
			{
				class = "title",
				text = "All Groups",
			},
			{
				class = "button",
				text = "Run",

				activated = function()
					handleResults("All Groups", MapLinter.All())
				end,
			},
		},
	},
	{
		id = "SpecificGroups",
		displays = {
			{
				class = "title",
				text = "Specific Groups",
			},
			{
				class = "button",
				text = "Global",

				activated = function()
					local group = "Global"
					handleResults(group, MapLinter.Group(group))
				end,
			},
			{
				class = "button",
				text = "Items",

				activated = function()
					local group = "Items"
					handleResults(group, MapLinter.Group(group))
				end,
			},
			{
				class = "button",
				text = "Entrances",

				activated = function()
					local group = "Entrances"
					handleResults(group, MapLinter.Group(group))
				end,
			},
			{
				class = "button",
				text = "CamLocations",

				activated = function()
					local group = "CamLocations"
					handleResults(group, MapLinter.Group(group))
				end,
			},
			{
				class = "button",
				text = "NPCSpawns",

				activated = function()
					local group = "NPCSpawns"
					handleResults(group, MapLinter.Group(group))
				end,
			},
			{
				class = "button",
				text = "Clipping",

				activated = function()
					local group = "Clipping"
					handleResults(group, MapLinter.Group(group))
				end,
			},
		},
	},
}
