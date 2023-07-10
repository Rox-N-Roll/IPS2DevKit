local groups = {}
for _, module in script:GetChildren() do
	groups[module.Name] = require(module)
end

return {
	{
		id = "Dummies",
		content = groups.Dummies,
	},
	{
		id = "Map Making Assets",
		content = groups.MapMakingAssets,
	},
	{
		id = "Map Linting",
		content = groups.MapLinting,
	},
}
