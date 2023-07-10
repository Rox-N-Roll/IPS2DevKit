local IPS2DevKit = script.Parent.Parent

local MapLinter = require(IPS2DevKit.MapLinter)
local Types = require(IPS2DevKit.Types)

type LinterFunc = ((name: string) -> { Types.LinterResult }) | (() -> { Types.LinterResult })

local function handleResult(func: LinterFunc, ...: any...) -- TODO handle linter output visually
	local results = func(...) :: { Types.LinterResult }
	local messages = {}
	local pass = true

	for _, result in results do
		if not result.ok then
			pass = false
			table.insert(messages, result.statusMessage)
		end
	end

	local line = string.rep("-", 25)
	local output = `\n{line}\nResult: {if pass then "PASS" else "FAIL"}\n`
	if #messages > 0 then
		output ..= "Status messages:\n"
		for _, message in messages do
			output ..= "- " .. message .. "\n"
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
					handleResult(MapLinter.All)
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
					handleResult(MapLinter.Group, "Global")
				end,
			},
		},
	},
}
