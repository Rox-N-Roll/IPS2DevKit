local WARN_COLOR = Color3.fromRGB(255, 234, 0)
local HOLDER_NAME = "_IPS2DevKit_VisProblems"

local VisProblems = {}

function VisProblems.GetHolder(): Folder?
	return workspace:FindFirstChild(HOLDER_NAME)
end

function VisProblems.Create(source: Instance, position: Vector3, info: { [string]: any })
	local holder = VisProblems.GetHolder()
	if not holder then
		holder = Instance.new("Folder")
		holder.Name = HOLDER_NAME
		holder.Parent = workspace
	end

	local adornee = Instance.new("Part")
	adornee.Name = source:GetFullName()
	adornee.Transparency = 1
	adornee.Size = Vector3.zero
	adornee.Position = position
	adornee.Anchored = true
	adornee.CanCollide = false
	adornee.CanQuery = false
	adornee.CanTouch = false

	for property, value in info do
		adornee:SetAttribute(property, value)
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Display"
	billboard.AlwaysOnTop = true
	billboard.Adornee = adornee
	billboard.Size = UDim2.new(0.3, 30, 0.3, 30)
	billboard.LightInfluence = 0

	local img = Instance.new("ImageLabel")
	img.Name = "Img"
	img.Image = "rbxassetid://14056981780"
	img.ImageColor3 = WARN_COLOR
	img.ImageTransparency = 0.3
	img.BackgroundTransparency = 1
	img.Size = UDim2.fromScale(1, 1)

	if source:IsA("PVInstance") then -- TODO support for folders
		local selection = Instance.new("SelectionBox")
		selection.Name = "Outline"
		selection.Color3 = WARN_COLOR
		selection.SurfaceColor3 = WARN_COLOR
		selection.SurfaceTransparency = 0.9
		selection.Transparency = 0.7
		selection.LineThickness = 0.02
		selection.Adornee = source
		selection.Parent = adornee
	end

	img.Parent = billboard
	billboard.Parent = adornee
	adornee.Parent = holder
end

function VisProblems.Clear()
	local holder = VisProblems.GetHolder()
	if holder then
		holder:Destroy()
	end
end

return VisProblems
