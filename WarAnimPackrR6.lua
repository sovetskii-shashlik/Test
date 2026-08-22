--// War Anim Pack R6 V1.0
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WARANIMPACK"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -72)
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
title.Text = "War Anim Pack R6"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

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

local crouchBtn = Instance.new("TextButton")
crouchBtn.Size = UDim2.new(0.9, 0, 0, 30)
crouchBtn.Position = UDim2.new(0.05, 0, 0, 40)
crouchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
crouchBtn.Text = "Crouch: OFF"
crouchBtn.TextColor3 = Color3.new(1, 1, 1)
crouchBtn.Parent = frame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 6)
btnCorner1.Parent = crouchBtn

local layBtn = Instance.new("TextButton")
layBtn.Size = UDim2.new(0.9, 0, 0, 30)
layBtn.Position = UDim2.new(0.05, 0, 0, 75)
layBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
layBtn.Text = "Lay: OFF"
layBtn.TextColor3 = Color3.new(1, 1, 1)
layBtn.Parent = frame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = layBtn

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

local defaultSpeed = humanoid.WalkSpeed

local function createAnimationTrack(animId)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animId
    return animator:LoadAnimation(anim)
end

local crouchAnimId = "287325678"
local layAnimId = "282574440"

local crouchTrack = createAnimationTrack(crouchAnimId)
local layTrack = createAnimationTrack(layAnimId)

crouchTrack.Priority = Enum.AnimationPriority.Action
layTrack.Priority = Enum.AnimationPriority.Action

local crouchActive = false
local layActive = false

local function restoreSpeed()
    if crouchActive and layActive then
        humanoid.WalkSpeed = 5
    elseif crouchActive then
        humanoid.WalkSpeed = 8
    elseif layActive then
        humanoid.WalkSpeed = 5
    else
        humanoid.WalkSpeed = defaultSpeed
    end
end

crouchBtn.MouseButton1Click:Connect(function()
    crouchActive = not crouchActive

    if crouchActive then
        crouchBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        crouchBtn.Text = "Crouch: ON"
        if not layActive then
            humanoid.WalkSpeed = 8
        else
            humanoid.WalkSpeed = 5
        end
        crouchTrack:Play()
    else
        crouchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        crouchBtn.Text = "Crouch: OFF"
        crouchTrack:Stop()
        restoreSpeed()
    end
end)

layBtn.MouseButton1Click:Connect(function()
    layActive = not layActive

    if layActive then
        layBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        layBtn.Text = "Lay: ON"
        if not crouchActive then
            humanoid.WalkSpeed = 5
        else
            humanoid.WalkSpeed = 5
        end
        layTrack:Play()
    else
        layBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        layBtn.Text = "Lay: OFF"
        layTrack:Stop()
        restoreSpeed()
    end
end)

localPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    animator = humanoid:WaitForChild("Animator")

    defaultSpeed = humanoid.WalkSpeed

    crouchTrack = createAnimationTrack(crouchAnimId)
    layTrack = createAnimationTrack(layAnimId)
    crouchTrack.Priority = Enum.AnimationPriority.Action
    layTrack.Priority = Enum.AnimationPriority.Action

    crouchActive = false
    layActive = false
    crouchBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    crouchBtn.Text = "Crouch: OFF"
    layBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    layBtn.Text = "Lay: OFF"
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "War Anim Pack R6",
    Text = "Version V1.0",
    Duration = 5
})