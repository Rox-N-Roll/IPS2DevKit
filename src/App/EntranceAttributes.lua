local IPS2DevKit = script.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local PanelComps = require(IPS2DevKit.App.PanelComps)
local MapEntrances = require(IPS2DevKit.PanelCode.MapEntrances)
local Util = require(IPS2DevKit.Util)

local e = React.createElement

return function(props: {
	nextOrder: () -> number,
})
	local content = {}

	for name, attributeType in Util.GetAllowedEntranceAttributes() do
		content[name] = e(PanelComps.Button, {
			text = name,
			layoutOrder = props.nextOrder(),
			activated = function()
				MapEntrances.AddAttribute(name, attributeType)
			end,
		})
	end

	return content
end
