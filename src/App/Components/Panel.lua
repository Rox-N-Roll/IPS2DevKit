local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Button = require(IPS2DevKit.App.Components.Button)
local Title = require(IPS2DevKit.App.Components.Title)
local useTheme = require(IPS2DevKit.App.Hooks.useTheme)
local Panels = require(IPS2DevKit.Panels)

local VERT_PADDING = 20
local DISPLAY_SIZE = 50

local e = React.createElement

return function(props: {
	groupOrder: number,
	panelOrder: number,
})
	local theme = useTheme()

	local content = {
		Layout = e("UIListLayout", {
			Padding = theme.padding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
	}

	local numDisplay = 0
	local totalDisplaySize = 0
	for order, display in Panels[props.groupOrder].content[props.panelOrder].displays do
		local element
		if display.class == "title" then
			local size = math.floor(DISPLAY_SIZE * 0.5)
			element = e(Title, {
				text = display.text,
				size = UDim2.new(1, 0, 0, size),
				layoutOrder = order,
			})
			totalDisplaySize += size
		elseif display.class == "button" then
			element = e(Button, {
				text = display.text,
				size = UDim2.new(1, 0, 0, DISPLAY_SIZE),
				layoutOrder = order,
				activated = display.activated,
			})
			totalDisplaySize += DISPLAY_SIZE
		end

		numDisplay += 1
		content[display.class .. order] = element
	end

	local contentSize = totalDisplaySize + math.max(numDisplay - 1, 0) * theme.padding.Offset
	local panelSize = UDim2.new(1, 0, 0, contentSize + VERT_PADDING)

	return e("Frame", {
		Size = panelSize,
		BackgroundTransparency = 1,
		LayoutOrder = props.panelOrder,
	}, content)
end
