local IPS2DevKit = script.Parent.Parent.Parent
local React = require(IPS2DevKit.Packages.React)

local PluginContext = React.createContext()
local e = React.createElement

local function PluginProvider(props: {
	plugin: Plugin,
	children: any,
})
	return e(PluginContext.Provider, {
		value = props.plugin,
	}, props.children)
end

return {
	Context = PluginContext,
	Consumer = PluginContext.Consumer,
	Provider = PluginProvider,
}
