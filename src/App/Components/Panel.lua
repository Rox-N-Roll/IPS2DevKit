local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local useTheme = require(IPS2DevKit.App.Hooks.useTheme)

local e = React.createElement

return function(props: {
	layoutOrder: number,
	children: table,
})
	local theme = useTheme()

	return e("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
	}, {
		Layout = e("UIListLayout", {
			Padding = theme.padding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		Children = e(React.Fragment, nil, props.children),
	})
end
