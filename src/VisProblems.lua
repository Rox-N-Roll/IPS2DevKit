local HOLDER_NAME = "_IPS2DevKit_VisProblems"

local VisProblems = {}

function VisProblems.GetHolder(): Folder?
	return workspace:FindFirstChild(HOLDER_NAME)
end

function VisProblems.Create(name: string, position: Vector3, info: { [string]: any })
	local holder = VisProblems.GetHolder()
	if not holder then
		holder = Instance.new("Folder")
		holder.Name = HOLDER_NAME
		holder.Parent = workspace
	end

	local adornee = Instance.new("Part")
	adornee.Name = name
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
	img.ImageColor3 = Color3.fromRGB(255, 234, 0)
	img.ImageTransparency = 0.3
	img.BackgroundTransparency = 1
	img.Size = UDim2.fromScale(1, 1)

	img.Parent = billboard
	billboard.Parent = adornee
	adornee.Parent = holder
end

function VisProblems.Clear(): boolean
	local holder = VisProblems.GetHolder()

	if holder then
		holder:Destroy()
		return true
	end

	return false
end

return VisProblems
