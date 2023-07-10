local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Padding = require(IPS2DevKit.App.Components.Padding)
local useTheme = require(IPS2DevKit.App.Hooks.useTheme)

local PADDING = UDim.new(0.05, 0)

local e = React.createElement

return function(props: {
	text: string,
	size: UDim2,
	position: UDim2,
	layoutOrder: number,
})
	local theme = useTheme()

	return e("TextLabel", {
		Text = props.text,
		Size = props.size,
		Position = props.position,
		LayoutOrder = props.layoutOrder,
		TextColor3 = theme.text,
		BackgroundTransparency = 1,
		Font = theme.font,
		TextScaled = true,
	}, {
		Padding = e(Padding, {
			top = PADDING,
			bottom = PADDING,
			left = PADDING,
			right = PADDING,
		}),
	})
end
