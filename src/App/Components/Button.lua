local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Corner = require(IPS2DevKit.App.Components.Corner)
local Title = require(IPS2DevKit.App.Components.Title)
local useTheme = require(IPS2DevKit.App.Hooks.useTheme)

local e = React.createElement

return function(props: {
	text: string,
	size: UDim2,
	position: UDim2,
	layoutOrder: number,
	activated: () -> (),
})
	local theme = useTheme()

	return e("TextButton", {
		Text = "",
		Size = props.size,
		Position = props.position,
		LayoutOrder = props.layoutOrder,
		BackgroundColor3 = theme.button,

		[React.Event.Activated] = props.activated,
	}, {
		Corner = e(Corner),
		Title = e(Title, {
			text = props.text,
			size = UDim2.fromScale(1, 1),
		}),
	})
end
