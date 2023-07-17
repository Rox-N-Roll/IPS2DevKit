local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Themes = require(IPS2DevKit.App.Themes)

local useMemo = React.useMemo
local useState = React.useState
local useEffect = React.useEffect

local MOCK_STUDIO = {
	ThemeChanged = Instance.new("BindableEvent").Event,
	Theme = {
		Name = "Light",
	},
}

local function useTheme()
	local studio = useMemo(function()
		local success, result = pcall(function()
			return settings().Studio
		end)

		return if success then result else MOCK_STUDIO
	end, {})

	local theme, setTheme = useState(Themes[studio.Theme.Name])

	useEffect(function()
		local conn = studio.ThemeChanged:Connect(function()
			setTheme(Themes[studio.Theme.Name])
		end)

		return function()
			conn:Disconnect()
		end
	end, {})

	return theme
end

return useTheme
