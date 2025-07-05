-- trungdzv2 | Roblox Script Menu
-- Made by ChatGPT per your instructions
-- Compatible with Delta Executor

-- SETTINGS
local KEY_REQUIRED = "trungdz"
local MAX_ATTEMPTS = 3

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local attempts = 0

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "trungdzv2"
screenGui.ResetOnSpawn = false

-- Key Input Frame
local keyFrame = Instance.new("Frame", screenGui)
keyFrame.Size = UDim2.new(0, 300, 0, 180)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyFrame.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", keyFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "🔑 Nhập Key để tiếp tục"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 50)
keyBox.PlaceholderText = "Nhập key..."
keyBox.Text = ""
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.Font = Enum.Font.SourceSans
keyBox.TextSize = 18
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(1, -20, 0, 35)
keyBtn.Position = UDim2.new(0, 10, 0, 100)
keyBtn.Text = "✔ Xác nhận"
keyBtn.TextColor3 = Color3.new(1, 1, 1)
keyBtn.Font = Enum.Font.SourceSansBold
keyBtn.TextSize = 18
keyBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)

-- Function to create the main UI
local function createMainUI()
    keyFrame:Destroy()
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.Name = "MainUI"

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "💠 trungdzv2 Menu"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 22
    title.BackgroundTransparency = 1

    local info = Instance.new("TextLabel", mainFrame)
    info.Size = UDim2.new(1, 0, 0, 30)
    info.Position = UDim2.new(0, 0, 1, -30)
    info.Text = "🌐 GitHub: github.com/phantatdung233/"
    info.TextColor3 = Color3.new(1,1,1)
    info.Font = Enum.Font.SourceSans
    info.TextSize = 14
    info.BackgroundTransparency = 1

    -- Add features here as needed (Fling, Kill All, Fly, Aim FOV Slider, etc.)
end

-- Key Submit Logic
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY_REQUIRED then
        createMainUI()
    else
        attempts += 1
        keyBox.Text = ""
        keyBox.PlaceholderText = "Sai key! Thử lại (" .. tostring(attempts) .. "/" .. MAX_ATTEMPTS .. ")"
        keyBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)

        if attempts >= MAX_ATTEMPTS then
            keyBox.Visible = false
            keyBtn.Visible = false

            local lockedLabel = Instance.new("TextLabel", keyFrame)
            lockedLabel.Size = UDim2.new(1, -20, 0, 30)
            lockedLabel.Position = UDim2.new(0, 10, 0, 140)
            lockedLabel.Text = "🔒 Đã vượt quá số lần thử. Thử lại sau 30 giây..."
            lockedLabel.TextColor3 = Color3.new(1, 0.4, 0.4)
            lockedLabel.Font = Enum.Font.SourceSansBold
            lockedLabel.TextSize = 16
            lockedLabel.BackgroundTransparency = 1

            task.wait(30)
            attempts = 0
            keyBox.Visible = true
            keyBtn.Visible = true
            lockedLabel:Destroy()
            keyBox.PlaceholderText = "Nhập lại key..."
            keyBox.PlaceholderColor3 = Color3.new(1, 1, 1)
        end
    end
end)
