local Util = {}

function Util.CreateWidget(plugin: Plugin, name: string): DockWidgetPluginGui
	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left)

	local widget = plugin:CreateDockWidgetPluginGui(name, info)
	widget.Name = name
	widget.Title = name
	widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return widget
end

function Util.CreateToggleButton(toolbar: PluginToolbar, widget: DockWidgetPluginGui): () -> ()
	local button = toolbar:CreateButton(widget.Name, "Opens the utility panel", "rbxassetid://1507949215")

	local clickConn = button.Click:Connect(function()
		widget.Enabled = not widget.Enabled
	end)

	local enabledConn = widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		button:SetActive(widget.Enabled)
	end)

	return function()
		clickConn:Disconnect()
		enabledConn:Disconnect()
	end
end

function Util.GetSpawnLocation(offset: number)
	local camera = workspace.CurrentCamera
	return CFrame.new(camera.CFrame.Position + camera.CFrame.LookVector * offset)
end

return Util
