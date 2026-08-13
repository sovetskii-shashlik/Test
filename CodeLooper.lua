--// Code Looper GUI v3.0
  --// by prespeshnikShashlika
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer
local looperActive = false
local looperConnection = nil
local looperThread = nil
local loopType = "while wait() do"
local loopDelay = 0.1
local codeExpanded = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CodeLooperGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 3)
title.BackgroundTransparency = 1
title.Text = "Code Looper"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
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

local codeExpandBtn = Instance.new("TextButton")
codeExpandBtn.Size = UDim2.new(0.9, 0, 0, 25)
codeExpandBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
codeExpandBtn.Text = "Code: Show"
codeExpandBtn.TextColor3 = Color3.new(1, 1, 1)
codeExpandBtn.Font = Enum.Font.Code
codeExpandBtn.TextSize = 12
codeExpandBtn.Parent = frame

local codeExpandBtnCorner = Instance.new("UICorner")
codeExpandBtnCorner.CornerRadius = UDim.new(0, 6)
codeExpandBtnCorner.Parent = codeExpandBtn

local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(0.9, 0, 0, 60)
codeInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
codeInput.Text = ""
codeInput.PlaceholderText = "your code here..."
codeInput.TextColor3 = Color3.new(1, 1, 1)
codeInput.ClearTextOnFocus = false
codeInput.MultiLine = true
codeInput.TextWrapped = true
codeInput.TextScaled = false
codeInput.TextSize = 12
codeInput.Font = Enum.Font.Code
codeInput.Visible = false
codeInput.Parent = frame

local codeInputCorner = Instance.new("UICorner")
codeInputCorner.CornerRadius = UDim.new(0, 6)
codeInputCorner.Parent = codeInput

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.9, 0, 0, 25)
delayInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
delayInput.Text = tostring(loopDelay)
delayInput.PlaceholderText = "delay (seconds)"
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.ClearTextOnFocus = false
delayInput.TextScaled = false
delayInput.TextSize = 12
delayInput.Font = Enum.Font.Code
delayInput.Parent = frame

local delayInputCorner = Instance.new("UICorner")
delayInputCorner.CornerRadius = UDim.new(0, 6)
delayInputCorner.Parent = delayInput

local loopTypeSelector = Instance.new("TextButton")
loopTypeSelector.Size = UDim2.new(0.9, 0, 0, 25)
loopTypeSelector.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
loopTypeSelector.Text = "Loop: while wait() do"
loopTypeSelector.TextColor3 = Color3.new(1, 1, 1)
loopTypeSelector.Font = Enum.Font.Code
loopTypeSelector.TextSize = 12
loopTypeSelector.Parent = frame

local loopTypeSelectorCorner = Instance.new("UICorner")
loopTypeSelectorCorner.CornerRadius = UDim.new(0, 6)
loopTypeSelectorCorner.Parent = loopTypeSelector

local loopTypeDropdown = Instance.new("Frame")
loopTypeDropdown.Size = UDim2.new(0.9, 0, 0, 160)
loopTypeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loopTypeDropdown.BorderSizePixel = 0
loopTypeDropdown.Visible = false
loopTypeDropdown.ZIndex = 10
loopTypeDropdown.Parent = frame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = loopTypeDropdown

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.Padding = UDim.new(0, 2)
dropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dropdownLayout.Parent = loopTypeDropdown

local loopTypes = {
    "while wait() do",
    "while task.wait() do",
    "while true do",
    "RunService.Heartbeat",
    "RunService.Stepped",
    "RunService.RenderStepped"
}

for _, name in ipairs(loopTypes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.ZIndex = 11
    btn.Parent = loopTypeDropdown
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        loopType = name
        loopTypeSelector.Text = "Loop: " .. name
        loopTypeDropdown.Visible = false
    end)
end

loopTypeSelector.MouseButton1Click:Connect(function()
    loopTypeDropdown.Visible = not loopTypeDropdown.Visible
end)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Looper: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = frame
toggleBtn.Font = Enum.Font.Sarpanch

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Waiting..."
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = frame

local function updateLayout()
    local y = 30
    
    codeExpandBtn.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 28
    
    if codeExpanded then
        codeInput.Visible = true
        codeInput.Position = UDim2.new(0.05, 0, 0, y)
        y = y + 63
    else
        codeInput.Visible = false
    end
    
    delayInput.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 28
    
    loopTypeSelector.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 28
    
    loopTypeDropdown.Position = UDim2.new(0.05, 0, 0, y)
    if loopTypeDropdown.Visible then
        y = y + 165
    else
        y = y + 3
    end
    
    toggleBtn.Position = UDim2.new(0.05, 0, 0, y)
    y = y + 33
    
    statusLabel.Position = UDim2.new(0, 0, 0, y)
    y = y + 20
    
    frame.Size = UDim2.new(0, 220, 0, y + 3)
end

codeExpandBtn.MouseButton1Click:Connect(function()
    codeExpanded = not codeExpanded
    if codeExpanded then
        codeExpandBtn.Text = "Code: Hide"
    else
        codeExpandBtn.Text = "Code: Show"
    end
    updateLayout()
end)

local function stopLooper()
    if looperThread and coroutine.status(looperThread) ~= "dead" then
        coroutine.close(looperThread)
    end
    looperThread = nil
    
    if looperConnection then
        looperConnection:Disconnect()
        looperConnection = nil
    end
end

local function executeCode()
    local code = codeInput.Text
    if code == "" then return end
    
    local delay = tonumber(delayInput.Text) or 0.1
    
    if loopType == "while wait() do" then
        while looperActive do
            pcall(function() loadstring(code)() end)
            wait(delay)
        end
    elseif loopType == "while task.wait() do" then
        while looperActive do
            pcall(function() loadstring(code)() end)
            task.wait(delay)
        end
    elseif loopType == "while true do" then
        while looperActive do
            pcall(function() loadstring(code)() end)
            task.wait(delay)
        end
    elseif loopType == "RunService.Heartbeat" then
        looperConnection = RunService.Heartbeat:Connect(function()
            if looperActive then
                pcall(function() loadstring(code)() end)
            end
        end)
    elseif loopType == "RunService.Stepped" then
        looperConnection = RunService.Stepped:Connect(function()
            if looperActive then
                pcall(function() loadstring(code)() end)
            end
        end)
    elseif loopType == "RunService.RenderStepped" then
        looperConnection = RunService.RenderStepped:Connect(function()
            if looperActive then
                pcall(function() loadstring(code)() end)
            end
        end)
    end
end

local function startLooper()
    stopLooper()
    
    if loopType == "RunService.Heartbeat" or loopType == "RunService.Stepped" or loopType == "RunService.RenderStepped" then
        executeCode()
    else
        looperThread = coroutine.create(executeCode)
        coroutine.resume(looperThread)
    end
end

local function toggleLooper()
    looperActive = not looperActive
    
    if looperActive then
        loopDelay = tonumber(delayInput.Text) or 0.1
        startLooper()
        toggleBtn.Text = "Looper: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        statusLabel.Text = "Running (" .. loopType .. ")"
    else
        stopLooper()
        toggleBtn.Text = "Looper: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        statusLabel.Text = "Stopped"
    end
end

delayInput:GetPropertyChangedSignal("Text"):Connect(function()
    if looperActive then
        loopDelay = tonumber(delayInput.Text) or 0.1
        statusLabel.Text = "Running (delay: " .. loopDelay .. ")"
    end
end)

toggleBtn.MouseButton1Click:Connect(toggleLooper)

local userId = Players:GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Code Looper",
    Text = "Version V3.0",
    Icon = content,
    Duration = 7
})

updateLayout()