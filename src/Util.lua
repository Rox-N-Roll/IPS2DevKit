local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local EPSILON = 1e-5

local Util = {}

function Util.CreateWidget(plugin: Plugin, name: string): DockWidgetPluginGui
	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, false, false, 0, 0, 400, 0)

	local widget = plugin:CreateDockWidgetPluginGui(name, info)
	widget.Name = name
	widget.Title = name
	widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return widget
end

function Util.CreateToggleButton(toolbar: PluginToolbar, widget: DockWidgetPluginGui): () -> ()
	local button = toolbar:CreateButton(widget.Name, "Opens the utility panel", "rbxassetid://14055993659")

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

function Util.HasInvalidAttributes(instance: Instance, allowed: { [string]: string }): (boolean, string?)
	for name, value in instance:GetAttributes() do
		local found = allowed[name]

		if not found or typeof(value) ~= found then
			return true, name
		end
	end

	return false, nil
end

function Util.HasStrayInstances(map: Folder, ancestor: Instance, instances: { Instance }): (boolean, Instance?)
	for _, instance in instances do
		if map:IsAncestorOf(instance) and not ancestor:IsAncestorOf(instance) then
			return true, instance
		end
	end

	return false, nil
end

function Util.FloatEquals(n0: number, n1: number): boolean
	return math.abs(n1 - n0) < EPSILON
end

function Util.GetSelected(): Instance?
	local instances = Selection:Get()
	return if #instances > 0 then instances[1] else nil
end

function Util.AddAttribute(name: string, attributeType: string)
	local added = false

	for _, instance in Selection:Get() do
		if instance:GetAttribute(name) ~= nil then
			continue
		end

		local defaultValue
		if attributeType == "string" then
			defaultValue = ""
		elseif attributeType == "number" then
			defaultValue = 0
		elseif attributeType == "boolean" then
			defaultValue = true
		else
			error("unsupported attribute type")
		end

		instance:SetAttribute(name, defaultValue)
		added = true
	end

	if added then
		ChangeHistoryService:SetWaypoint(`Add {name} Attribute`)
	end
end

return Util
