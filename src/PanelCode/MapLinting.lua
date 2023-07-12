local IPS2DevKit = script.Parent.Parent

local MapLinter = require(IPS2DevKit.MapLinter)
local Types = require(IPS2DevKit.Types)

local MapLinting = {}

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

function MapLinting.StartAll()
	handleResults("All Groups", MapLinter.All())
end

function MapLinting.Start(group: string)
	handleResults(group, MapLinter.Group(group))
end

return MapLinting
