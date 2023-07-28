local IPS2DevKit = script.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local PanelComps = require(IPS2DevKit.App.PanelComps)
local Util = require(IPS2DevKit.Util)

local e = React.createElement

return function(props: {
	attributes: { [string]: string },
	nextOrder: () -> number,
})
	local content = {}

	for name, attributeType in props.attributes do
		content[name] = e(PanelComps.Button, {
			text = name,
			layoutOrder = props.nextOrder(),
			activated = function()
				Util.AddAttribute(name, attributeType)
			end,
		})
	end

	return content
end
