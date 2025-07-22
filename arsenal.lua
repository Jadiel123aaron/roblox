-- SERVICES
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG FLAGS
_G.FastAimbotOn = false
_G.SafeAimbotOn = false
_G.SafeWallCheck = false
_G.FastWallCheck = false
_G.TeamCheck = true
_G.ESPOn = false
_G.ESPColor = Color3.fromRGB(255, 0, 0)

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ArsenalUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Arsenal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22

-- Tabs
local Tabs = {"Aim", "ESP", "Safe"}
local TabButtons, TabFrames = {}, {}
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.Size = UDim2.new(1, 0, 0, 40)
TabHolder.BackgroundTransparency = 1

for i, name in ipairs(Tabs) do
	local btn = Instance.new("TextButton", TabHolder)
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, (i - 1) * 110, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	TabButtons[name] = btn

	local content = Instance.new("Frame", MainFrame)
	content.Position = UDim2.new(0, 0, 0, 90)
	content.Size = UDim2.new(1, 0, 1, -90)
	content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	content.BorderSizePixel = 0
	content.Visible = false
	TabFrames[name] = content
	local layout = Instance.new("UIListLayout", content)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(TabFrames) do f.Visible = false end
		content.Visible = true
	end)
end

-- Toggle Button Creator
local function createToggle(name, tab, toggleVar)
	local button = Instance.new("TextButton", TabFrames[tab])
	button.Size = UDim2.new(0, 140, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = name
	button.BorderSizePixel = 0
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
	button.MouseButton1Click:Connect(function()
		_G[toggleVar] = not _G[toggleVar]
		if toggleVar == "FastAimbotOn" then _G.SafeAimbotOn = false end
		if toggleVar == "SafeAimbotOn" then _G.FastAimbotOn = false end
		button.BackgroundColor3 = _G[toggleVar] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 30)
	end)
	button.BackgroundColor3 = _G[toggleVar] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 30)
end

-- Create Toggles
createToggle("Aimbot", "Aim", "FastAimbotOn")
createToggle("Wall Check", "Aim", "FastWallCheck")
createToggle("Aimbot (Safe)", "Safe", "SafeAimbotOn")
createToggle("Wall Check", "Safe", "SafeWallCheck")

-- ESP Setup using 2D Box Drawing
local ESPPDrawings = {}

local function clearESP()
	for _, drawing in pairs(ESPPDrawings) do
		if drawing and drawing.Remove then
			drawing:Remove()
		end
	end
	ESPPDrawings = {}
end

local function updateESP()
	clearESP()
	if not _G.ESPOn then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if not _G.TeamCheck or player.Team ~= LocalPlayer.Team then
				local part = player.Character.HumanoidRootPart
				local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
				if onScreen then
					local distance = (Camera.CFrame.Position - part.Position).Magnitude
					local scale = math.clamp(1 / (distance * 0.05), 0.4, 2)
					local boxWidth, boxHeight = 40 * scale, 60 * scale
					local boxX = vector.X - boxWidth / 2
					local boxY = vector.Y - boxHeight / 2

					local box = Drawing.new("Square")
					box.Size = Vector2.new(boxWidth, boxHeight)
					box.Position = Vector2.new(boxX, boxY)
					box.Color = _G.ESPColor
					box.Filled = true
					box.Transparency = 0.35
					box.Visible = true

					table.insert(ESPPDrawings, box)
				end
			end
		end
	end
end

local function createESPButton()
	local button = Instance.new("TextButton", TabFrames["ESP"])
	button.Size = UDim2.new(0, 140, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = "ESP"
	button.BorderSizePixel = 0
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
	button.MouseButton1Click:Connect(function()
		_G.ESPOn = not _G.ESPOn
		button.BackgroundColor3 = _G.ESPOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 30)
		updateESP()
	end)
end
createESPButton()

RunService.RenderStepped:Connect(function()
	if _G.ESPOn then
		updateESP()
	else
		clearESP()
	end
end)

-- GUI Toggle
local isOpen = false
local function showGUI()
	MainFrame.Visible = true
	TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 500, 0, 400)}):Play()
end

local function hideGUI()
	TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	task.wait(0.3)
	MainFrame.Visible = false
end

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		if isOpen then hideGUI() else showGUI() end
		isOpen = not isOpen
	end
end)

-- Aimbot Logic
local function getClosestTarget(checkWalls)
	local closest, shortest = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and (_G.TeamCheck == false or player.Team ~= LocalPlayer.Team) and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen and (Camera.CFrame.Position - head.Position).Magnitude < shortest then
				if checkWalls then
					local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 999)
					local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character, false, true)
					if hit and hit:IsDescendantOf(player.Character) then
						closest = player
						shortest = (Camera.CFrame.Position - head.Position).Magnitude
					end
				else
					closest = player
					shortest = (Camera.CFrame.Position - head.Position).Magnitude
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	local mode = _G.FastAimbotOn and "FastWallCheck" or (_G.SafeAimbotOn and "SafeWallCheck")
	local wallCheck = _G[mode]
	local target = (_G.FastAimbotOn or _G.SafeAimbotOn) and getClosestTarget(wallCheck)
	if target and target.Character and target.Character:FindFirstChild("Head") then
		local head = target.Character.Head.Position
		local camPos = Camera.CFrame.Position
		local dir = (head - camPos).Unit
		local speed = _G.FastAimbotOn and 0.2 or (_G.SafeAimbotOn and 0.08 or 0)
		Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPos, camPos + dir), speed)
	end
end)

wait(0.2)
showGUI()
isOpen = true
