local IPS2DevKit = script.Parent.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local e = React.createElement

local NONE = UDim.new(0, 0)

return function(props: {
	top: UDim?,
	bottom: UDim?,
	left: UDim?,
	right: UDim?,
})
	return e("UIPadding", {
		PaddingTop = props.top or NONE,
		PaddingBottom = props.bottom or NONE,
		PaddingLeft = props.left or NONE,
		PaddingRight = props.right or NONE,
	})
end
