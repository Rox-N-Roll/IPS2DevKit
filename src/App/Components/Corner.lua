local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local e = React.createElement

return function()
	return e("UICorner", {
		CornerRadius = UDim.new(0, 8),
	})
end
