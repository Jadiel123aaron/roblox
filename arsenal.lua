local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArsenalUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Draggable
MainFrame.Active = true
MainFrame.Draggable = true

-- Top bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "🔫 Arsenal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Tabs
local Tabs = {"Aim", "ESP", "Safe", "Movement", "Credits"}
local TabButtons = {}
local TabFrames = {}

local TabHolder = Instance.new("Frame")
TabHolder.Parent = MainFrame
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.Size = UDim2.new(1, 0, 0, 40)
TabHolder.BackgroundTransparency = 1

for i, name in pairs(Tabs) do
	local btn = Instance.new("TextButton")
	btn.Parent = TabHolder
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, (i - 1) * 110, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	TabButtons[name] = btn

	local content = Instance.new("Frame")
	content.Parent = MainFrame
	content.Position = UDim2.new(0, 0, 0, 80)
	content.Size = UDim2.new(1, 0, 1, -80)
	content.BackgroundTransparency = 1
	content.Visible = false

	local layout = Instance.new("UIListLayout", content)
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	TabFrames[name] = content

	btn.MouseButton1Click:Connect(function()
		for _, frame in pairs(TabFrames) do frame.Visible = false end
		TabFrames[name].Visible = true
	end)
end

-- Default visible tab
TabFrames["Aim"].Visible = true

-- Movement tab example button
local speedBtn = Instance.new("TextButton")
speedBtn.Parent = TabFrames["Movement"]
speedBtn.Size = UDim2.new(0, 200, 0, 35)
speedBtn.Text = "Increase WalkSpeed"
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 14
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 6)

speedBtn.MouseButton1Click:Connect(function()
	local plr = game.Players.LocalPlayer
	if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
		plr.Character.Humanoid.WalkSpeed = 30
	end
end)

-- Credits tab label
local credit = Instance.new("TextLabel")
credit.Parent = TabFrames["Credits"]
credit.Size = UDim2.new(0, 250, 0, 35)
credit.Text = "Made by Jadiel2210 & ChatGPT 😎"
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(255, 255, 255)
credit.Font = Enum.Font.Gotham
credit.TextSize = 14

-- ALT toggle logic
local isOpen = false

local function showGUI()
	MainFrame.Visible = true
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.BackgroundTransparency = 1

	for _, frame in pairs(MainFrame:GetChildren()) do
		if frame:IsA("Frame") or frame:IsA("TextLabel") then
			frame.Visible = true
			frame.BackgroundTransparency = 1
		end
	end

	TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 500, 0, 400),
		BackgroundTransparency = 0
	}):Play()
end

local function hideGUI()
	local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1
	})
	tween:Play()
	tween.Completed:Wait()
	MainFrame.Visible = false
end

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		if isOpen then
			hideGUI()
		else
			showGUI()
		end
		isOpen = not isOpen
	end
end)

-- Auto open once
task.wait(0.2)
showGUI()
isOpen = true
