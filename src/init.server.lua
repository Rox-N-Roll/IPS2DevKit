local RunService = game:GetService("RunService")

if RunService:IsRunning() or not RunService:IsEdit() then
	return
end

local IPS2DevKit = script

local ReactRoblox = require(IPS2DevKit.Packages.ReactRoblox)
local React = require(IPS2DevKit.Packages.React)
local Util = require(IPS2DevKit.Util)
local App = require(script.App)

local NAME = "IPS2DevKit"
local VERSION = "v0.2.0"

local toolbar = plugin:CreateToolbar(NAME)
local widget = Util.CreateWidget(plugin, NAME)
local root = ReactRoblox.createRoot(widget)
local cleanupButton = Util.CreateToggleButton(toolbar, widget)

local app = React.createElement(App, {
	plugin = plugin,
	name = NAME,
	versionString = VERSION,
})

local widgetConn = widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	if widget.Enabled then
		root:render(app)
	else
		root:unmount()
	end
end)

if widget.Enabled then
	root:render(app)
end

plugin.Unloading:Connect(function()
	cleanupButton()
	widgetConn:Disconnect()
	root:unmount()
end)
