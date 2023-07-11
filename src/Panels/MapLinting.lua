local IPS2DevKit = script.Parent.Parent

local MapLinter = require(IPS2DevKit.MapLinter)
local Types = require(IPS2DevKit.Types)

local function handleResults(results: { Types.LintResult }) -- TODO handle linter output visually
	local parsedResults = {}
	local pass = true

	for _, result in results do
		if not result.ok then
			pass = false
			table.insert(parsedResults, { result.name, result.statusMessage })
		end
	end

	local line = string.rep("-", 30)
	local output = `\n{line}\nResult: {if pass then "PASS" else "FAIL"}\n`
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
					handleResults(MapLinter.All())
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
				text = "Run Global",

				activated = function()
					handleResults(MapLinter.Group("Global"))
				end,
			},
				end,
			},
		},
	},
}
