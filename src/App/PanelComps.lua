local IPS2DevKit = script.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Button = require(IPS2DevKit.App.Components.Button)
local Title = require(IPS2DevKit.App.Components.Title)

local DISPLAY_SIZE = 50

local e = React.createElement

local PanelComps = {}

function PanelComps.Title(props: {
	text: string,
	layoutOrder: number,
})
	local size = math.floor(DISPLAY_SIZE * 0.5)
	return e(Title, {
		text = props.text,
		size = UDim2.new(1, 0, 0, size),
		layoutOrder = props.layoutOrder,
	})
end

function PanelComps.Button(props: {
	text: string,
	layoutOrder: number,
	activated: () -> (),
})
	return e(Button, {
		text = props.text,
		size = UDim2.new(1, 0, 0, DISPLAY_SIZE),
		layoutOrder = props.layoutOrder,
		activated = props.activated,
	})
end

return PanelComps
