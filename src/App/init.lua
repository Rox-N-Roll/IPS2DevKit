local IPS2DevKit = script.Parent

local React = require(IPS2DevKit.Packages.React)
local PluginContext = require(IPS2DevKit.App.Contexts.PluginContext)
local PanelGroup = require(IPS2DevKit.App.Components.PanelGroup)
local Padding = require(IPS2DevKit.App.Components.Padding)
local useTheme = require(IPS2DevKit.App.Hooks.useTheme)
local Panels = require(IPS2DevKit.Panels)

local SCROLLBAR_SIZE = 8
local TITLE_SIZE = 60
local VERSION_SIZE = 20
local SPACER = 12

local e = React.createElement

return function(props: {
	plugin: Plugin,
	name: string,
	versionString: string,
})
	local theme = useTheme()

	local contents = {
		Padding = e(Padding, {
			right = UDim.new(0, SCROLLBAR_SIZE),
		}),
		Layout = e("UIListLayout", {
			Padding = theme.padding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		}),
	}

	for order, group in Panels do
		contents[group.id] = e(PanelGroup, {
			groupOrder = order,
		})
	end

	return e(PluginContext.Provider, {
		value = props.plugin,
	}, {
		Title = e("TextLabel", {
			Text = props.name,
			BackgroundTransparency = 1,
			TextColor3 = theme.text,
			Font = theme.font,
			TextScaled = true,
			Size = UDim2.new(1, 0, 0, TITLE_SIZE),
		}, {
			Padding = e(Padding, {
				top = UDim.new(0.08, 0),
				bottom = UDim.new(0.02, 0),
				left = UDim.new(0.05, 0),
				right = UDim.new(0.05, 0),
			}),
		}),

		Version = e("TextLabel", {
			Text = props.versionString,
			Position = UDim2.fromOffset(0, TITLE_SIZE),
			BackgroundTransparency = 1,
			TextColor3 = theme.text,
			Font = theme.font,
			TextScaled = true,
			Size = UDim2.new(1, 0, 0, VERSION_SIZE),
		}, {
			Padding = e(Padding, {
				top = UDim.new(0.02, 0),
				bottom = UDim.new(0.08, 0),
				left = UDim.new(0.05, 0),
				right = UDim.new(0.05, 0),
			}),
		}),

		Content = e("ScrollingFrame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, TITLE_SIZE + VERSION_SIZE + SPACER),
			Size = UDim2.new(1, 0, 1, -TITLE_SIZE - VERSION_SIZE - SPACER),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollBarThickness = 8,
		}, contents),
	})
end
