local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Settings
local AIM_PART = "Head"
local MAX_DISTANCE = 300
local FOV_RADIUS = 200

local aimEnabled = false
local espEnabled = false

-- Drawing circle for FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = FOV_RADIUS
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Visible = true

-- Tables to hold ESP boxes and names
local espBoxes = {}
local espNames = {}

-- Find closest target within FOV
local function getClosestTarget()
	local closestTarget = nil
	local shortestDistance = MAX_DISTANCE

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer
			and player.Character
			and player.Character:FindFirstChild(AIM_PART)
			and player.Character:FindFirstChild("Humanoid")
			and player.Character.Humanoid.Health > 0 then

			local part = player.Character[AIM_PART]
			local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
				local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

				if distFromCenter <= FOV_RADIUS then
					local worldDist = (part.Position - camera.CFrame.Position).Magnitude
					if worldDist < shortestDistance then
						closestTarget = part
						shortestDistance = worldDist
					end
				end
			end
		end
	end

	return closestTarget
end

-- ESP update function
local function updateESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			local rootPart = player.Character.HumanoidRootPart
			local head = player.Character:FindFirstChild("Head")
			if not rootPart or not head then
				if espBoxes[player] then espBoxes[player].Visible = false end
				if espNames[player] then espNames[player].Visible = false end
			else
				local rootPos, onScreenRoot = camera:WorldToViewportPoint(rootPart.Position)
				local headPos, onScreenHead = camera:WorldToViewportPoint(head.Position)
				if onScreenRoot and onScreenHead then
					local height = math.abs(rootPos.Y - headPos.Y)
					local width = height / 2

					local box = espBoxes[player]
					if not box then
						box = Drawing.new("Square")
						box.Thickness = 2
						box.Transparency = 1
						box.Color = Color3.new(1, 0, 0)
						box.Filled = false
						espBoxes[player] = box
					end
					box.Size = Vector2.new(width * 2, height)
					box.Position = Vector2.new(rootPos.X - width, rootPos.Y - height)
					box.Visible = espEnabled

					local nameLabel = espNames[player]
					if not nameLabel then
						nameLabel = Drawing.new("Text")
						nameLabel.Color = Color3.new(1, 0, 0)
						nameLabel.Outline = true
						nameLabel.Size = 16
						nameLabel.Center = true
						espNames[player] = nameLabel
					end
					nameLabel.Position = Vector2.new(headPos.X, headPos.Y - 20)
					nameLabel.Text = player.Name
					nameLabel.Visible = espEnabled
				else
					if espBoxes[player] then espBoxes[player].Visible = false end
					if espNames[player] then espNames[player].Visible = false end
				end
			end
		else
			if espBoxes[player] then espBoxes[player].Visible = false end
			if espNames[player] then espNames[player].Visible = false end
		end
	end
end

-- RenderStepped loop
RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

	if aimEnabled then
		local target = getClosestTarget()
		if target then
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
		end
	end

	if espEnabled then
		updateESP()
	end
end)

-- GUI Creation
local playerGui = localPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AimESPMenu"

local aimButton = Instance.new("TextButton", screenGui)
aimButton.Size = UDim2.new(0, 120, 0, 40)
aimButton.Position = UDim2.new(0, 10, 0, 10)
aimButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
aimButton.TextColor3 = Color3.new(1, 1, 1)
aimButton.Font = Enum.Font.SourceSansBold
aimButton.TextSize = 20
aimButton.Text = "Aimbot: OFF"

local espButton = Instance.new("TextButton", screenGui)
espButton.Size = UDim2.new(0, 120, 0, 40)
espButton.Position = UDim2.new(0, 10, 0, 60)
espButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 20
espButton.Text = "ESP: OFF"

-- Button toggles
aimButton.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	if aimEnabled then
		aimButton.Text = "Aimbot: ON"
		aimButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		aimButton.Text = "Aimbot: OFF"
		aimButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
end)

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		espButton.Text = "ESP: ON"
		espButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		espButton.Text = "ESP: OFF"
		espButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		-- Hide all ESP drawings immediately when turned off
		for _, box in pairs(espBoxes) do
			box.Visible = false
		end
		for _, nameLabel in pairs(espNames) do
			nameLabel.Visible = false
		end
	end
end)