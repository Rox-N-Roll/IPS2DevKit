local ChangeHistoryService = game:GetService("ChangeHistoryService")

local IPS2DevKit = script.Parent.Parent

local VisProblems = require(IPS2DevKit.VisProblems)
local MapLinter = require(IPS2DevKit.MapLinter)
local Types = require(IPS2DevKit.Types)

local MapLinting = {}

local function getFolderPosition(folder: Folder): Vector3?
	local children = folder:GetChildren()
	local center = Vector3.zero
	local hasPV = false

	for _, instance in children do
		if instance:IsA("PVInstance") then
			center += instance:GetPivot().Position
			hasPV = true
		end
	end

	if hasPV then
		return center / #children
	end

	return nil
end

local function handleResults(category: string, results: { Types.LintResult })
	local parsedResults = {}
	local vpCreated = false
	local pass = true

	local vpDeleted = VisProblems.Clear()

	for _, result in results do
		if not result.ok then
			local subj = result.subject
			if result.subject then
				local pos
				if subj:IsA("Folder") then
					pos = getFolderPosition(subj)
				elseif subj:IsA("PVInstance") then
					pos = subj:GetPivot().Position
				else
					error("unsupported subject")
				end

				if pos then
					VisProblems.Create(subj:GetFullName(), pos, {
						statusMessage = result.statusMessage,
						group = result.group,
					})
					vpCreated = true
				end
			end

			table.insert(parsedResults, { result.statusMessage, result.group })
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
			output ..= `- {data[1]} ({data[2]})\n`
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
