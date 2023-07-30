local WARN_COLOR = Color3.fromRGB(255, 234, 0)
local HOLDER_NAME = "_IPS2DevKit_VisProblems"

local VisProblems = {}

local function getHolder(): Folder?
	return workspace:FindFirstChild(HOLDER_NAME)
end

local function getFolderPosition(folder: Folder): Vector3?
	local children = folder:GetChildren()
	local center = Vector3.zero
	local hasPV = false

	for _, instance in children do
		if instance:IsA("PVInstance") then
			center += instance:GetPivot().Position
			hasPV = true
		end
	end

	if hasPV then
		return center / #children
	end

	return nil
end

function VisProblems.IsSupportedSource(source: Instance): boolean
	return source:IsA("Folder") or source:IsA("PVInstance")
end

function VisProblems.Create(source: Instance, info: { [string]: any })
	local position
	if source:IsA("Folder") then
		position = getFolderPosition(source)
	elseif source:IsA("PVInstance") then
		position = source:GetPivot().Position
	else
		error("unsupported source")
	end

	if not position then
		return
	end

	local holder = getHolder()
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
	local holder = getHolder()
	if holder then
		holder:Destroy()
	end
end

return VisProblems
