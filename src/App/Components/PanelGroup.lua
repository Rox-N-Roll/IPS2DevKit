local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Padding = require(IPS2DevKit.App.Components.Padding)
local useTheme = require(IPS2DevKit.App.Hooks.useTheme)

local PANEL_PADDING = 20
local SIDE_PADDING = 15
local CONTROL_SIZE = 32
local VERT_PADDING = 10

local e = React.createElement
local useState = React.useState

return function(props: {
	name: string,
	layoutOrder: number,
	children: table,
})
	local collapsed, setCollapsed = useState(true)
	local theme = useTheme()

	local controlPadding = math.floor(CONTROL_SIZE * 0.6)

	local contentFrame
	if not collapsed then
		contentFrame = e("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, CONTROL_SIZE),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, {
			Padding = e(Padding, {
				top = UDim.new(0, VERT_PADDING),
				bottom = UDim.new(0, VERT_PADDING),
				left = UDim.new(0, SIDE_PADDING),
				right = UDim.new(0, SIDE_PADDING),
			}),
			Layout = e("UIListLayout", {
				Padding = UDim.new(0, PANEL_PADDING),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),

			Children = e(React.Fragment, nil, props.children),
		})
	end

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
	}, {
		Control = e("TextButton", {
			Text = `{if collapsed then ">" else "\\/"} {props.name}`,
			BackgroundColor3 = theme.button,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, CONTROL_SIZE),
			TextColor3 = theme.text,
			Font = theme.font,
			TextScaled = true,
			TextXAlignment = Enum.TextXAlignment.Left,

			[React.Event.Activated] = function()
				setCollapsed(not collapsed)
			end,
		}, {
			Padding = e(Padding, {
				top = UDim.new(0.08, 0),
				bottom = UDim.new(0.08, 0),
				left = UDim.new(0, controlPadding),
				right = UDim.new(0, controlPadding),
			}),
		}),

		Content = contentFrame,
	})
end
