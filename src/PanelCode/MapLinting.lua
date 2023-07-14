local ChangeHistoryService = game:GetService("ChangeHistoryService")

local IPS2DevKit = script.Parent.Parent

local VisProblems = require(IPS2DevKit.VisProblems)
local MapLinter = require(IPS2DevKit.MapLinter)
local Types = require(IPS2DevKit.Types)

local MapLinting = {}

local function handleResults(category: string, results: { Types.LintResult })
	local parsedResults = {}
	local vpCreated = false
	local pass = true

	local vpDeleted = VisProblems.Clear()

	for _, result in results do
		if not result.ok then
			local subj = result.subject
			if result.subject then
				local position = if subj:IsA("Model") then subj:GetPivot() else subj.Position
				VisProblems.Create(subj:GetFullName(), position, {
					statusMessage = result.statusMessage,
					group = result.name,
				})
				vpCreated = true
			end

			table.insert(parsedResults, { result.name, result.statusMessage })
			pass = false
		end
	end

	if vpCreated or vpDeleted then
		ChangeHistoryService:SetWaypoint("Modify VisProblems from MapLinter")
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
