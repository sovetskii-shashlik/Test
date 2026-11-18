--// Kill NPC Gui V1.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer
local flyActive = false
local connection = nil
local processedPlayers = {}
local currentInput = ""
local isOnMobile = UserInputService.TouchEnabled

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KNPCGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 85)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui
local dragDetector = Instance.new("UIDragDetector", frame)
frame.Active = true
frame.Draggable = true
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "FE Kill NPC"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Kill NPC: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

local textGradient = Instance.new("UIGradient", title)
textGradient.Rotation = 90

local function lerpColor(color1, color2, alpha)
    return Color3.new(
        color1.R + (color2.R - color1.R) * alpha,
        color1.G + (color2.G - color1.G) * alpha,
        color1.B + (color2.B - color1.B) * alpha
    )
end

local function animateTextGradient()
    local duration = 2
    local steps = 60
    local stepTime = duration / steps
    local color1 = Color3.fromRGB(255, 255, 255)
    local color2 = Color3.fromRGB(0, 0, 0)

    while true do
        for i = 0, steps do
            local alpha = i / steps
            textGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, lerpColor(color1, color2, alpha)),
                ColorSequenceKeypoint.new(1, lerpColor(color2, color1, alpha))
            })
            task.wait(stepTime)
        end

        for i = 0, steps do
            local alpha = i / steps
            textGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, lerpColor(color2, color1, alpha)),
                ColorSequenceKeypoint.new(1, lerpColor(color1, color2, alpha))
            })
            task.wait(stepTime)
        end
    end
end

task.spawn(animateTextGradient)

local borderFrame = Instance.new("Frame")
borderFrame.Size = frame.Size
borderFrame.Position = frame.Position
borderFrame.BackgroundTransparency = 1
borderFrame.AnchorPoint = frame.AnchorPoint
borderFrame.ZIndex = frame.ZIndex - 1
borderFrame.Parent = screenGui

local borderCorner = frame.UICorner:Clone()
borderCorner.Parent = borderFrame

local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 3
borderStroke.LineJoinMode = Enum.LineJoinMode.Round
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
borderStroke.Parent = borderFrame

frame:GetPropertyChangedSignal("Position"):Connect(function()
    borderFrame.Position = frame.Position
end)

frame:GetPropertyChangedSignal("Size"):Connect(function()
    borderFrame.Size = frame.Size
end)

frame.UICorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    borderCorner.CornerRadius = frame.UICorner.CornerRadius
end)

local killNPCEnabled = false
local heartbeatConnection = nil

local function killNPCs()
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 112412400000)
    sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", 112412400000)
    
    for _, d in pairs(game:GetService("Workspace"):GetDescendants()) do
        if d.ClassName == 'Humanoid' and d.Parent:IsA("Model") and not game.Players:FindFirstChild(d.Parent.Name) then
            d.Health = 0
        end
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    killNPCEnabled = not killNPCEnabled
    
    if killNPCEnabled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        toggleBtn.Text = "Kill NPC: ON"
        
        while killNPCEnabled do
            killNPCs()
            wait(1)
        end
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleBtn.Text = "Kill NPC: OFF"
    end
end)

local userId = Players:GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Kill Npc GUI",
    Text = "version V1.0",
    Icon = content,
    Duration = 7
})