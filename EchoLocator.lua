--// Echo Locator V2.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EchoLocatorGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.5, -110, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = frame

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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Echo Locator"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local textGradient = Instance.new("UIGradient", title)
textGradient.Rotation = 90

local function lerpColor(c1, c2, a)
    return Color3.new(
        c1.R + (c2.R - c1.R) * a,
        c1.G + (c2.G - c1.G) * a,
        c1.B + (c2.B - c1.B) * a
    )
end

task.spawn(function()
    local steps = 60
    local stepTime = 2 / steps
    local c1 = Color3.fromRGB(255, 255, 255)
    local c2 = Color3.fromRGB(0, 0, 0)
    while true do
        for i = 0, steps do
            local a = i / steps
            textGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, lerpColor(c1, c2, a)),
                ColorSequenceKeypoint.new(1, lerpColor(c2, c1, a))
            })
            task.wait(stepTime)
        end
        for i = 0, steps do
            local a = i / steps
            textGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, lerpColor(c2, c1, a)),
                ColorSequenceKeypoint.new(1, lerpColor(c1, c2, a))
            })
            task.wait(stepTime)
        end
    end
end)

local toggleMinimizeBtn = Instance.new("TextButton")
toggleMinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
toggleMinimizeBtn.Position = UDim2.new(1, -25, 0, 5)
toggleMinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleMinimizeBtn.Text = "-"
toggleMinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
toggleMinimizeBtn.TextSize = 14
toggleMinimizeBtn.ZIndex = 2
toggleMinimizeBtn.Parent = frame

local toggleMinimizeCorner = Instance.new("UICorner")
toggleMinimizeCorner.CornerRadius = UDim.new(0, 4)
toggleMinimizeCorner.Parent = toggleMinimizeBtn

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, 30)
inputBox.Position = UDim2.new(0.05, 0, 0, 35)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.Text = ""
inputBox.PlaceholderText = "radius (studs)"
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.ClearTextOnFocus = false
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Code
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 70)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Echo: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

local teamCheckBtn = Instance.new("TextButton")
teamCheckBtn.Size = UDim2.new(0.9, 0, 0, 28)
teamCheckBtn.Position = UDim2.new(0.05, 0, 0, 104)
teamCheckBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teamCheckBtn.Text = "Team Check: OFF"
teamCheckBtn.TextColor3 = Color3.new(1, 1, 1)
teamCheckBtn.TextSize = 13
teamCheckBtn.Font = Enum.Font.Gotham
teamCheckBtn.Parent = frame

local teamCheckCorner = Instance.new("UICorner")
teamCheckCorner.CornerRadius = UDim.new(0, 6)
teamCheckCorner.Parent = teamCheckBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 133)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Parent = frame

local isMinimized = false
local originalSize = frame.Size
local minimizedSize = UDim2.new(0, 60, 0, 30)
local elementsToHide = {inputBox, toggleBtn, teamCheckBtn, statusLabel, toggleMinimizeBtn}

local invisibleExpandBtn = Instance.new("TextButton")
invisibleExpandBtn.Size = UDim2.new(1, 0, 1, 0)
invisibleExpandBtn.Position = UDim2.new(0, 0, 0, 0)
invisibleExpandBtn.BackgroundTransparency = 1
invisibleExpandBtn.Text = ""
invisibleExpandBtn.TextTransparency = 1
invisibleExpandBtn.Visible = false
invisibleExpandBtn.Parent = frame

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        originalSize = frame.Size
        title.Text = "EL"
        title.Size = UDim2.new(1, 0, 1, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        for _, el in ipairs(elementsToHide) do
            el.Visible = false
        end
        frame.Size = minimizedSize
        invisibleExpandBtn.Visible = true
        invisibleExpandBtn.Active = true
    else
        title.Text = "Echo Locator"
        title.Size = UDim2.new(1, 0, 0, 25)
        title.Position = UDim2.new(0, 0, 0, 5)
        for _, el in ipairs(elementsToHide) do
            el.Visible = true
        end
        frame.Size = originalSize
        invisibleExpandBtn.Visible = false
    end
end

toggleMinimizeBtn.MouseButton1Click:Connect(toggleMinimize)
invisibleExpandBtn.MouseButton1Click:Connect(function()
    if isMinimized then toggleMinimize() end
end)

local echoActive = false
local teamCheck = false
local renderConnection = nil
local circlePool = {}
local MAX_CIRCLES = 150
local POINT_RADIUS = 6
local POINT_TRANSPARENCY = 0.5

local function getOrCreateCircle(index)
    if circlePool[index] then
        return circlePool[index]
    end
    if index > MAX_CIRCLES then return nil end
    local c = Drawing.new("Circle")
    c.Filled = true
    c.Radius = POINT_RADIUS
    c.Thickness = 2
    c.Transparency = POINT_TRANSPARENCY
    c.Visible = false
    c.ZIndex = 1
    circlePool[index] = c
    return c
end

local function hideAllCircles()
    for _, c in pairs(circlePool) do
        c.Visible = false
    end
end

local posProviderCache = setmetatable({}, {__mode = "k"})

local function buildPosProvider(sound)
    local obj = sound.Parent
    while obj and obj ~= Workspace do
        if obj:IsA("BasePart") then
            return function() return obj.Position end
        elseif obj:IsA("Attachment") then
            return function() return obj.WorldPosition end
        end
        obj = obj.Parent
    end
    return nil
end

local function getSoundPosition(sound)
    local provider = posProviderCache[sound]
    if provider == nil then
        provider = buildPosProvider(sound) or false
        posProviderCache[sound] = provider
    end
    if provider == false then return nil end
    return provider()
end

local classCache = setmetatable({}, {__mode = "k"})

local function classifySound(sound)
    local myChar = localPlayer.Character

    local obj = sound.Parent
    local modelWithHumanoid = nil
    while obj and obj ~= Workspace do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            modelWithHumanoid = obj
            break
        end
        obj = obj.Parent
    end

    if modelWithHumanoid then
        if modelWithHumanoid == myChar then
            return {kind = "self", color = Color3.fromRGB(0, 0, 0)}
        end
        local plr = Players:GetPlayerFromCharacter(modelWithHumanoid)
        if plr then
            return {kind = "player", color = Color3.fromRGB(255, 50, 50), player = plr}
        end
        return {kind = "npc", color = Color3.fromRGB(0, 0, 0)}
    end

    return {kind = "object", color = Color3.fromRGB(150, 150, 150)}
end

local function classifySoundCached(sound)
    local c = classCache[sound]
    if c then return c end
    c = classifySound(sound)
    classCache[sound] = c
    return c
end

local function watchSound(sound)
    sound.AncestryChanged:Connect(function()
        classCache[sound] = nil
        posProviderCache[sound] = nil
    end)
end

local soundList = {}
local soundSet = {}

local function rebuildSoundList()
    local newList = {}
    local newSet = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            newList[#newList + 1] = obj
            newSet[obj] = true
            if not soundSet[obj] then
                watchSound(obj)
            end
        end
    end
    soundList = newList
    soundSet = newSet

    for s in pairs(posProviderCache) do
        if not newSet[s] then posProviderCache[s] = nil end
    end
    for s in pairs(classCache) do
        if not newSet[s] then classCache[s] = nil end
    end
end

task.spawn(function()
    while true do
        rebuildSoundList()
        task.wait(0.5)
    end
end)

local activeSounds = {}

task.spawn(function()
    while true do
        local active = {}
        for _, s in ipairs(soundList) do
            if s.IsPlaying then
                active[#active + 1] = s
            end
        end
        activeSounds = active
        task.wait(0.1)
    end
end)

local function getRadius()
    local r = tonumber(inputBox.Text)
    if r and r > 0 then return r end
    return nil
end

local function applyStyle(circle, info)
    if teamCheck then
        if info.kind == "player" then
            circle.Filled = true
            circle.Thickness = 1
            circle.Transparency = POINT_TRANSPARENCY
            local plr = info.player
            if plr and plr.Team and plr.TeamColor then
                circle.Color = plr.TeamColor.Color
            else
                circle.Color = Color3.fromRGB(255, 50, 50)
            end
        else
            circle.Filled = false
            circle.Thickness = 2
            circle.Transparency = 0.2
            if info.kind == "npc" then
                circle.Color = Color3.fromRGB(0, 0, 0)
            elseif info.kind == "self" then
                circle.Color = Color3.fromRGB(0, 0, 0)
            else
                circle.Color = Color3.fromRGB(150, 150, 150)
            end
        end
    else
        circle.Filled = true
        circle.Thickness = 1
        circle.Transparency = POINT_TRANSPARENCY
        circle.Color = info.color
    end
end

local function onRender()
    local cam = Workspace.CurrentCamera
    if not cam then return end

    local radiusOverride = getRadius()
    local used = 0
    local camPos = cam.CFrame.Position

    for _, s in ipairs(activeSounds) do
        if used >= MAX_CIRCLES then break end
        local sp = getSoundPosition(s)
        if sp then
            local dist = (sp - camPos).Magnitude
            local maxDist = radiusOverride or s.RollOffMaxDistance
            if maxDist > 0 and dist <= maxDist then
                local screenPos, onScreen = cam:WorldToViewportPoint(sp)
                if onScreen and screenPos.Z > 0 then
                    used = used + 1
                    local circle = getOrCreateCircle(used)
                    if circle then
                        circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                        local info = classifySoundCached(s)
                        applyStyle(circle, info)
                        circle.Visible = true
                    end
                end
            end
        end
    end

    for i = used + 1, #circlePool do
        if circlePool[i] then
            circlePool[i].Visible = false
        end
    end

    statusLabel.Text = "Status: Tracking (" .. used .. ")"
end

local function startEcho()
    if renderConnection then return end
    renderConnection = RunService.RenderStepped:Connect(onRender)
end

local function stopEcho()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    hideAllCircles()
    statusLabel.Text = "Status: Stopped"
end

local function toggleEcho()
    echoActive = not echoActive
    if echoActive then
        startEcho()
        toggleBtn.Text = "Echo: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        statusLabel.Text = "Status: Tracking..."
    else
        stopEcho()
        toggleBtn.Text = "Echo: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

toggleBtn.MouseButton1Click:Connect(toggleEcho)

teamCheckBtn.MouseButton1Click:Connect(function()
    teamCheck = not teamCheck
    if teamCheck then
        teamCheckBtn.Text = "Team Check: ON"
        teamCheckBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    else
        teamCheckBtn.Text = "Team Check: OFF"
        teamCheckBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

local userId = Players:GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

StarterGui:SetCore("SendNotification", {
    Title = "Echo Locator",
    Text = "version V2.0",
    Icon = content,
    Duration = 7
})