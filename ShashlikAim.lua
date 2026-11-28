--// Aimbot V2.5
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.5, -110, 0.5, -100)
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
title.Position = UDim2.new(0, 0, 0, 3)
title.BackgroundTransparency = 1
title.Text = "Aimbot"
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
toggleMinimizeBtn.Position = UDim2.new(1, -25, 0, 3)
toggleMinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleMinimizeBtn.Text = "-"
toggleMinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
toggleMinimizeBtn.TextSize = 14
toggleMinimizeBtn.ZIndex = 2
toggleMinimizeBtn.Parent = frame

local toggleMinimizeCorner = Instance.new("UICorner")
toggleMinimizeCorner.CornerRadius = UDim.new(0, 4)
toggleMinimizeCorner.Parent = toggleMinimizeBtn

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.92, 0, 1, -32)
scrollFrame.Position = UDim2.new(0.04, 0, 0, 28)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 1)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local isMinimized = false
local originalSize = frame.Size
local minimizedSize = UDim2.new(0, 60, 0, 30)
local elementsToHide = {scrollFrame, toggleMinimizeBtn}

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
        title.Text = "AB"
        title.Size = UDim2.new(1, 0, 1, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        for _, el in ipairs(elementsToHide) do
            el.Visible = false
        end
        frame.Size = minimizedSize
        invisibleExpandBtn.Visible = true
        invisibleExpandBtn.Active = true
    else
        title.Text = "Aimbot"
        title.Size = UDim2.new(1, 0, 0, 25)
        title.Position = UDim2.new(0, 0, 0, 3)
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

local enabled = false
local teamcheck = false
local wallcheck = false
local nonfriends = false
local aimpart = "Head"
local sniperAimPart = "Head"
local notAggressive = false
local detectRange = 500
local superAim = false
local superAimAngle = 45

local prioritizeClosest = false
local prioritizeHoldingTool = false
local requireTool = false
local snipeChecker = false

local sniperSnapWhenClose = true
local sniperSnapThreshold = 0.5

local aimOffsetYaw = 0
local aimOffsetPitch = 0
local pixelOffsetX = 0
local pixelOffsetY = 0

local sniperPixelOffsetX = 0
local sniperPixelOffsetY = 0

local naSmoothness = 0.75
local naFlickForce = 0.15
local naZoneAngle = 60

local showZone = false
local zoneGui = nil

local customCrosshair = false
local crosshairCenter = nil
local crosshairLines = {}

local customSniperCrosshair = false
local sniperCrosshairCenter = nil
local sniperCrosshairLines = {}
local sniperAngleTextH = nil
local sniperAngleTextV = nil
local sniperAngleTextTotal = nil

local stickyEnabled = true
local lockedTarget = nil
local lockedPart = nil
local lockLostTimer = 0
local lockGraceTime = 0.6
local lockLeashRange = 1.25
local switchPenalty = 0.35

local betterCheck = false
local bcDistWarn = 0
local bcDistMedium = 0
local bcDistUrgent = 0

local lastHealth = nil
local lastDamageTime = 0
local DAMAGE_WINDOW = 1.0

local lockZoneEnabled = false
local lockZoneAngle = 25
local lockZoneGui = nil
local lockZoneCooldown = 0
local LOCK_ZONE_COOLDOWN = 0.35

local canSeeNoCollide = false
local canSeeTransparent = false
local TRANSPARENT_THRESHOLD = 0.35

local function uiparent()
    local success, parent = pcall(function()
        return gethui()
    end)
    if not success then
        return game:GetService("CoreGui")
    end
    return parent
end

local element_height = 22
local elements = 0
local updateCallbacks = {}

local function addSpace()
    local space = Instance.new("Frame")
    space.Size = UDim2.new(1, 0, 0, 1)
    space.BackgroundTransparency = 1
    space.LayoutOrder = elements
    space.Parent = scrollFrame
    elements += 1
end

local function addToggle(name, funct, startState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, element_height)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. ": " .. (startState and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = scrollFrame
    btn.LayoutOrder = elements

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local state = startState
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(80, 20, 20) or Color3.fromRGB(60, 60, 60)
        if funct then funct(state) end
    end)

    elements += 1
    addSpace()
    return btn
end

local function addButton(name, funct)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, element_height)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.Parent = scrollFrame
    btn.LayoutOrder = elements

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if funct then funct() end
    end)

    elements += 1
    addSpace()
    return btn
end

local function addTextBox(name, initial, onChange)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, element_height)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.Text = tostring(initial)
    box.PlaceholderText = name
    box.TextColor3 = Color3.new(1, 1, 1)
    box.ClearTextOnFocus = false
    box.TextSize = 11
    box.Font = Enum.Font.Code
    box.Parent = scrollFrame
    box.LayoutOrder = elements

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = box

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            if onChange then onChange(num) end
        else
            box.Text = tostring(initial)
        end
    end)

    elements += 1
    addSpace()
    return box
end

local function addCombo(name, options, onChange)
    local main = Instance.new("TextButton")
    main.Size = UDim2.new(1, 0, 0, element_height)
    main.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    main.Text = name .. ": " .. options[1]
    main.TextColor3 = Color3.new(1, 1, 1)
    main.TextSize = 11
    main.Font = Enum.Font.Gotham
    main.TextXAlignment = Enum.TextXAlignment.Left
    main.Parent = scrollFrame
    main.LayoutOrder = elements

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = main

    elements += 1
    addSpace()

    local isOpen = false
    local elems = {}

    local function setState()
        for _, e in ipairs(elems) do
            e.Visible = isOpen
        end
    end

    main.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        setState()
    end)

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, element_height)
        optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 11
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Visible = false
        optBtn.Parent = scrollFrame
        optBtn.LayoutOrder = elements

        local oc = Instance.new("UICorner")
        oc.CornerRadius = UDim.new(0, 6)
        oc.Parent = optBtn

        table.insert(elems, optBtn)
        elements += 1
        addSpace()

        optBtn.MouseButton1Click:Connect(function()
            main.Text = name .. ": " .. opt
            isOpen = false
            setState()
            if onChange then onChange(opt) end
        end)
    end

    return main
end

local function addSliderCombo(name, getValue, setValue, steps, suffix)
    local main = Instance.new("TextButton")
    main.Size = UDim2.new(1, 0, 0, element_height)
    main.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    main.TextColor3 = Color3.new(1, 1, 1)
    main.TextSize = 11
    main.Font = Enum.Font.Gotham
    main.TextXAlignment = Enum.TextXAlignment.Left
    main.Parent = scrollFrame
    main.LayoutOrder = elements

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = main

    local function updateText()
        main.Text = string.format("%s: %.2f%s", name, getValue(), suffix or "")
    end
    updateText()

    elements += 1
    addSpace()

    local isOpen = false
    local elems = {}

    local function setState()
        for _, e in ipairs(elems) do
            e.Visible = isOpen
        end
    end

    main.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        setState()
    end)

    for _, step in ipairs(steps) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, element_height)
        optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optBtn.Text = (step >= 0 and "+" or "") .. tostring(step) .. (suffix or "")
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 11
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Visible = false
        optBtn.Parent = scrollFrame
        optBtn.LayoutOrder = elements

        local oc = Instance.new("UICorner")
        oc.CornerRadius = UDim.new(0, 6)
        oc.Parent = optBtn

        table.insert(elems, optBtn)
        elements += 1
        addSpace()

        optBtn.MouseButton1Click:Connect(function()
            setValue(step)
            updateText()
        end)
    end

    table.insert(updateCallbacks, updateText)
    return main
end

local function createCrosshair()
    if not crosshairCenter then
        crosshairCenter = Drawing.new("Circle")
        crosshairCenter.Radius = 2
        crosshairCenter.Filled = true
        crosshairCenter.Color = Color3.fromRGB(255, 80, 80)
        crosshairCenter.Transparency = 1
        crosshairCenter.Visible = true

        for i = 1, 4 do
            local line = Drawing.new("Line")
            line.Color = Color3.fromRGB(255, 80, 80)
            line.Thickness = 1.5
            line.Visible = true
            table.insert(crosshairLines, line)
        end
    end
end

local function createSniperCrosshair()
    if not sniperCrosshairCenter then
        sniperCrosshairCenter = Drawing.new("Circle")
        sniperCrosshairCenter.Radius = 1.5
        sniperCrosshairCenter.Filled = true
        sniperCrosshairCenter.Color = Color3.fromRGB(0, 255, 120)
        sniperCrosshairCenter.Transparency = 1
        sniperCrosshairCenter.Visible = true

        for i = 1, 4 do
            local line = Drawing.new("Line")
            line.Color = Color3.fromRGB(0, 255, 120)
            line.Thickness = 1.2
            line.Visible = true
            table.insert(sniperCrosshairLines, line)
        end

        sniperAngleTextH = Drawing.new("Text")
        sniperAngleTextH.Size = 12
        sniperAngleTextH.Center = false
        sniperAngleTextH.Outline = true
        sniperAngleTextH.OutlineColor = Color3.fromRGB(0, 0, 0)
        sniperAngleTextH.Color = Color3.fromRGB(0, 255, 120)
        sniperAngleTextH.Visible = false
        sniperAngleTextH.Text = "X: 0.00°"

        sniperAngleTextV = Drawing.new("Text")
        sniperAngleTextV.Size = 12
        sniperAngleTextV.Center = false
        sniperAngleTextV.Outline = true
        sniperAngleTextV.OutlineColor = Color3.fromRGB(0, 0, 0)
        sniperAngleTextV.Color = Color3.fromRGB(0, 255, 120)
        sniperAngleTextV.Visible = false
        sniperAngleTextV.Text = "Y: 0.00°"

        sniperAngleTextTotal = Drawing.new("Text")
        sniperAngleTextTotal.Size = 12
        sniperAngleTextTotal.Center = false
        sniperAngleTextTotal.Outline = true
        sniperAngleTextTotal.OutlineColor = Color3.fromRGB(0, 0, 0)
        sniperAngleTextTotal.Color = Color3.fromRGB(0, 255, 120)
        sniperAngleTextTotal.Visible = false
        sniperAngleTextTotal.Text = "Σ: 0.00°"
    end
end

local function getAimScreenPos()
    local cam = Workspace.CurrentCamera
    local viewport = cam.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local fovRad = math.rad(cam.FieldOfView)
    local tanHalfFov = math.tan(fovRad / 2)

    local yawPixels = (math.tan(math.rad(aimOffsetYaw)) / tanHalfFov) * (viewport.X / 2)
    local pitchPixels = (math.tan(math.rad(aimOffsetPitch)) / tanHalfFov) * (viewport.Y / 2)

    return center + Vector2.new(pixelOffsetX + yawPixels, pixelOffsetY + pitchPixels)
end

local function getSniperAimScreenPos()
    local cam = Workspace.CurrentCamera
    local viewport = cam.ViewportSize
    return Vector2.new(viewport.X / 2 + sniperPixelOffsetX, viewport.Y / 2 + sniperPixelOffsetY)
end

local function updateCrosshair()
    if not customCrosshair then
        if crosshairCenter then crosshairCenter.Visible = false end
        for _, line in ipairs(crosshairLines) do pcall(function() line.Visible = false end) end
        return
    end

    if not crosshairCenter then createCrosshair() end

    local pos = getAimScreenPos()
    crosshairCenter.Position = pos
    crosshairCenter.Visible = true

    local gap = 5
    local len = 10

    crosshairLines[1].From = Vector2.new(pos.X - gap, pos.Y)
    crosshairLines[1].To = Vector2.new(pos.X - gap - len, pos.Y)
    crosshairLines[1].Visible = true
    crosshairLines[2].From = Vector2.new(pos.X + gap, pos.Y)
    crosshairLines[2].To = Vector2.new(pos.X + gap + len, pos.Y)
    crosshairLines[2].Visible = true
    crosshairLines[3].From = Vector2.new(pos.X, pos.Y - gap)
    crosshairLines[3].To = Vector2.new(pos.X, pos.Y - gap - len)
    crosshairLines[3].Visible = true
    crosshairLines[4].From = Vector2.new(pos.X, pos.Y + gap)
    crosshairLines[4].To = Vector2.new(pos.X, pos.Y + gap + len)
    crosshairLines[4].Visible = true
end

local function computeAimCFrame(targetPos, aimScreenPos)
    local cam = Workspace.CurrentCamera
    local viewport = cam.ViewportSize
    local camPos = cam.CFrame.Position

    local fovRad = math.rad(cam.FieldOfView)
    local tanHalfFov = math.tan(fovRad / 2)
    local aspect = viewport.X / viewport.Y

    local dx = aimScreenPos.X - viewport.X / 2
    local dy = aimScreenPos.Y - viewport.Y / 2

    local yawAngle   = math.atan(dx * 2 * tanHalfFov * aspect / viewport.X)
    local pitchAngle = math.atan(dy * 2 * tanHalfFov         / viewport.Y)

    local baseCF = CFrame.new(camPos, targetPos)
    local lookDir  = -baseCF.ZVector
    local rightDir =  baseCF.XVector
    local upDir    =  baseCF.YVector

    local cosY, sinY = math.cos(yawAngle), math.sin(yawAngle)
    local lookAfterYaw  = (lookDir  * cosY) - (rightDir * sinY)
    local rightAfterYaw = (rightDir * cosY) + (lookDir  * sinY)

    local cosP, sinP = math.cos(pitchAngle), math.sin(pitchAngle)
    local lookAfterPitch = (lookAfterYaw * cosP) + (upDir * sinP)
    local upAfterPitch   = (upDir        * cosP) - (lookAfterYaw * sinP)

    lookAfterPitch  = lookAfterPitch.Unit
    upAfterPitch    = upAfterPitch.Unit
    rightAfterYaw   = rightAfterYaw.Unit

    return CFrame.fromMatrix(camPos, rightAfterYaw, upAfterPitch, -lookAfterPitch)
end

local function angleBetweenCFrames(cfA, cfB)
    local fwdA = -cfA.ZVector
    local fwdB = -cfB.ZVector
    local localB = cfA:VectorToObjectSpace(fwdB)
    local yaw   = math.deg(math.atan2(localB.X, -localB.Z))
    local pitch = math.deg(math.asin(math.clamp(localB.Y, -1, 1)))
    local dot = math.clamp(fwdA:Dot(fwdB), -1, 1)
    local total = math.deg(math.acos(dot))
    return yaw, pitch, total
end

local function lookAt(targetPos)
    Workspace.CurrentCamera.CFrame = computeAimCFrame(targetPos, getAimScreenPos())
end

local function lookAtSmooth(targetPos, alpha)
    local currentCFrame = Workspace.CurrentCamera.CFrame
    local targetCFrame = computeAimCFrame(targetPos, getAimScreenPos())
    Workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, alpha)
end

local function updateSniperCrosshair(targetPos)
    if not customSniperCrosshair then
        if sniperCrosshairCenter then sniperCrosshairCenter.Visible = false end
        for _, line in ipairs(sniperCrosshairLines) do pcall(function() line.Visible = false end) end
        if sniperAngleTextH then sniperAngleTextH.Visible = false end
        if sniperAngleTextV then sniperAngleTextV.Visible = false end
        if sniperAngleTextTotal then sniperAngleTextTotal.Visible = false end
        return
    end
    if not sniperCrosshairCenter then createSniperCrosshair() end

    local aimPos = getSniperAimScreenPos()
    sniperCrosshairCenter.Position = aimPos
    sniperCrosshairCenter.Visible = true

    local gap = 6
    local len = 14
    sniperCrosshairLines[1].From = Vector2.new(aimPos.X - gap, aimPos.Y)
    sniperCrosshairLines[1].To = Vector2.new(aimPos.X - gap - len, aimPos.Y)
    sniperCrosshairLines[1].Visible = true
    sniperCrosshairLines[2].From = Vector2.new(aimPos.X + gap, aimPos.Y)
    sniperCrosshairLines[2].To = Vector2.new(aimPos.X + gap + len, aimPos.Y)
    sniperCrosshairLines[2].Visible = true
    sniperCrosshairLines[3].From = Vector2.new(aimPos.X, aimPos.Y - gap)
    sniperCrosshairLines[3].To = Vector2.new(aimPos.X, aimPos.Y - gap - len)
    sniperCrosshairLines[3].Visible = true
    sniperCrosshairLines[4].From = Vector2.new(aimPos.X, aimPos.Y + gap)
    sniperCrosshairLines[4].To = Vector2.new(aimPos.X, aimPos.Y + gap + len)
    sniperCrosshairLines[4].Visible = true

    if not targetPos then
        if sniperAngleTextH then sniperAngleTextH.Visible = false end
        if sniperAngleTextV then sniperAngleTextV.Visible = false end
        if sniperAngleTextTotal then sniperAngleTextTotal.Visible = false end
        return
    end

    local idealCF = computeAimCFrame(targetPos, aimPos)
    local currentCF = Workspace.CurrentCamera.CFrame
    local yawDeg, pitchDeg, totalDeg = angleBetweenCFrames(currentCF, idealCF)

    local function colorFor(d)
        local a = math.abs(d)
        if a < 0.05 then return Color3.fromRGB(0, 255, 120)
        elseif a < 0.5 then return Color3.fromRGB(180, 255, 0)
        elseif a < 3.0 then return Color3.fromRGB(255, 220, 0)
        else return Color3.fromRGB(255, 70, 70) end
    end

    local function signStr(v) if v >= 0 then return "+" else return "" end end

    sniperAngleTextH.Text = string.format("X: %s%.2f°", signStr(yawDeg), yawDeg)
    sniperAngleTextH.Position = Vector2.new(aimPos.X + 12, aimPos.Y - 22)
    sniperAngleTextH.Color = colorFor(yawDeg)
    sniperAngleTextH.Visible = true

    sniperAngleTextV.Text = string.format("Y: %s%.2f°", signStr(pitchDeg), pitchDeg)
    sniperAngleTextV.Position = Vector2.new(aimPos.X + 12, aimPos.Y - 8)
    sniperAngleTextV.Color = colorFor(pitchDeg)
    sniperAngleTextV.Visible = true

    sniperAngleTextTotal.Text = string.format("Σ: %.2f°%s", totalDeg, totalDeg < 0.05 and " ✓" or "")
    sniperAngleTextTotal.Position = Vector2.new(aimPos.X + 12, aimPos.Y + 6)
    sniperAngleTextTotal.Color = colorFor(totalDeg)
    sniperAngleTextTotal.Visible = true
end

local function getAngleToTarget(aimobj)
    local cam = Workspace.CurrentCamera
    local cameraPos = cam.CFrame.Position
    local cameraLook = cam.CFrame.LookVector
    local directionToTarget = (aimobj.Position - cameraPos).Unit
    local dot = cameraLook:Dot(directionToTarget)
    return math.deg(math.acos(math.clamp(dot, -1, 1)))
end

local function getAngleFromAimToTarget(aimobj)
    local cam = Workspace.CurrentCamera
    local camPos = cam.CFrame.Position
    local dirToTarget = (aimobj.Position - camPos).Unit
    local aimLook = cam.CFrame.LookVector
    return math.deg(math.acos(math.clamp(aimLook:Dot(dirToTarget), -1, 1)))
end

local function isVisible(part)
    if not wallcheck then return true end
    local cam = Workspace.CurrentCamera
    local origin = cam.CFrame.Position
    local ignoreList = {cam, localPlayer.Character}

    for _ = 1, 30 do
        local ray = Ray.new(origin, part.Position - origin)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
        if not hit then return false end
        if hit:IsDescendantOf(part.Parent) then return true end
        local passable = false
        if canSeeNoCollide and not hit.CanCollide then
            passable = true
        elseif canSeeTransparent and hit.Transparency > 0 and hit.Transparency <= TRANSPARENT_THRESHOLD then
            passable = true
        end
        if not passable then return false end
        table.insert(ignoreList, hit)
    end
    return false
end

local function isFriend(player)
    local success, isF = pcall(function()
        return player:IsFriendsWith(localPlayer.UserId)
    end)
    return success and isF
end

local function isHoldingTool(player)
    if not player.Character then return false end
    return player.Character:FindFirstChildWhichIsA("Tool") ~= nil
end

local function localHasTool()
    local char = localPlayer.Character
    if not char then return false end
    return char:FindFirstChildWhichIsA("Tool") ~= nil
end

local function getAimPartObject(character, requestedPart)
    if not character then return nil end
    if requestedPart == "Head" then
        return character:FindFirstChild("Head")
    elseif requestedPart == "Torso" then
        return character:FindFirstChild("Torso")
            or character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("HumanoidRootPart")
    end
    return character:FindFirstChild(requestedPart)
end

local function getSearchAimPoint()
    if customSniperCrosshair then
        return getSniperAimScreenPos()
    end
    return getAimScreenPos()
end

local function isTakingDamage()
    local char = localPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return false end
    if lastHealth == nil then lastHealth = hum.Health end
    if hum.Health < lastHealth - 0.01 then
        lastDamageTime = os.clock()
    end
    lastHealth = hum.Health
    return (os.clock() - lastDamageTime) <= DAMAGE_WINDOW
end

local function isTargetValid(player, trg_part)
    if not player or not player.Parent then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    local part = getAimPartObject(char, trg_part)
    if not part then return false end

    if teamcheck and player.Team == localPlayer.Team then return false end
    if nonfriends and isFriend(player) then return false end
    if requireTool and not localHasTool() then return false end

    local myChar = localPlayer.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    if (part.Position - myRoot.Position).Magnitude > detectRange * lockLeashRange then return false end
    if wallcheck and not isVisible(part) then return false end

    local _, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end
    return true, part
end

local function betterCheckSeverity(player, part, myPos)
    if not player or not part then return 0 end
    local dist = (part.Position - myPos).Magnitude
    local hasTool = isHoldingTool(player)

    if bcDistUrgent > 0 and dist <= bcDistUrgent then return 3 end
    if bcDistMedium > 0 and hasTool and dist <= bcDistMedium then return 2 end
    if isTakingDamage() then
        if bcDistWarn > 0 and dist <= bcDistWarn then return 1 end
        if bcDistWarn == 0 then return 1 end
    end
    if bcDistMedium == 0 and hasTool then return 2 end
    return 0
end

local function isCursorOutsideLockZone()
    if not lockZoneEnabled then return false end
    local cam = Workspace.CurrentCamera
    local viewport = cam.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local mp = localPlayer:GetMouse()
    local target = mp.Hit
    local pos
    if target and target.Position then
        local s, on = cam:WorldToViewportPoint(target.Position)
        if on then pos = Vector2.new(s.X, s.Y) end
    end
    if not pos then return false end

    local fovRad = math.rad(cam.FieldOfView)
    local tanHalfFov = math.tan(fovRad / 2)
    local radiusPixels = (math.tan(math.rad(lockZoneAngle)) / tanHalfFov) * (viewport.Y / 2)
    return (pos - center).Magnitude > radiusPixels
end

local function getClosestPlayerToCursor(trg_part)
    if not stickyEnabled then
        lockedTarget = nil
        lockedPart = nil
        lockLostTimer = 0
    end

    if lockedTarget then
        local ok = isTargetValid(lockedTarget, trg_part)
        if ok then
            lockedPart = getAimPartObject(lockedTarget.Character, trg_part)
            lockLostTimer = 0
            return lockedTarget
        end
    end

    local myChar = localPlayer.Character
    if not myChar then return lockedTarget end
    local myHead = myChar:FindFirstChild("Head")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myHead or not myRoot then return nil end

    local aimPoint = getSearchAimPoint()
    local myPos = myRoot.Position

    local viewport = Workspace.CurrentCamera.ViewportSize
    local fovRad = math.rad(Workspace.CurrentCamera.FieldOfView)
    local tanHalfFov = math.tan(fovRad / 2)
    local searchRadiusPixels = (math.tan(math.rad(naZoneAngle)) / tanHalfFov) * (viewport.Y / 2)

    local bestClosest, bestClosestDist = nil, math.huge
    local bestTool, bestToolDist = nil, math.huge

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= localPlayer
            and myChar:FindFirstChildWhichIsA("Humanoid") and myChar.Humanoid.Health > 0
            and v.Character and v.Character:FindFirstChildWhichIsA("Humanoid") and v.Character.Humanoid.Health > 0
        then
            local allowed = not teamcheck
            if teamcheck and v.Team ~= localPlayer.Team then allowed = true end
            if nonfriends and isFriend(v) then allowed = false end

            if allowed then
                local aimobj = getAimPartObject(v.Character, trg_part)
                if aimobj then
                    local distanceToPlayer = (aimobj.Position - myPos).Magnitude
                    if distanceToPlayer <= detectRange then
                        local ePos, vis = Workspace.CurrentCamera:WorldToViewportPoint(aimobj.Position)
                        local screenDist = (Vector2.new(ePos.X, ePos.Y) - aimPoint).Magnitude

                        local visibleThroughWalls = true
                        if wallcheck then visibleThroughWalls = isVisible(aimobj) end

                        if vis and screenDist < searchRadiusPixels and visibleThroughWalls then
                            if distanceToPlayer < bestClosestDist then
                                bestClosestDist = distanceToPlayer
                                bestClosest = v
                            end
                            if isHoldingTool(v) and distanceToPlayer < bestToolDist then
                                bestToolDist = distanceToPlayer
                                bestTool = v
                            end
                        end
                    end
                end
            end
        end
    end

    local rawBest, rawBestDist = nil, math.huge
    if prioritizeClosest and prioritizeHoldingTool then
        if bestClosest and bestTool then
            if bestClosest == bestTool then
                rawBest = bestClosest; rawBestDist = math.min(bestClosestDist, bestToolDist)
            elseif bestClosestDist < bestToolDist then
                rawBest = bestClosest; rawBestDist = bestClosestDist
            else
                rawBest = bestTool; rawBestDist = bestToolDist
            end
        elseif bestClosest then
            rawBest = bestClosest; rawBestDist = bestClosestDist
        elseif bestTool then
            rawBest = bestTool; rawBestDist = bestToolDist
        end
    elseif prioritizeClosest then
        rawBest = bestClosest; rawBestDist = bestClosestDist
    elseif prioritizeHoldingTool then
        rawBest = bestTool; rawBestDist = bestToolDist
    else
        rawBest = bestClosest; rawBestDist = bestClosestDist
    end

    if betterCheck and prioritizeClosest and prioritizeHoldingTool and lockedTarget then
        local bestSev, bestSevPlayer, bestSevPart = 0, nil, nil
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= localPlayer and v ~= lockedTarget
                and v.Character and v.Character:FindFirstChildWhichIsA("Humanoid")
                and v.Character.Humanoid.Health > 0
            then
                local allowed = not teamcheck
                if teamcheck and v.Team ~= localPlayer.Team then allowed = true end
                if nonfriends and isFriend(v) then allowed = false end

                if allowed then
                    local p = getAimPartObject(v.Character, trg_part)
                    if p then
                        local d = (p.Position - myPos).Magnitude
                        if d <= detectRange then
                            local _, vis = Workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                            local okWall = (not wallcheck) or isVisible(p)
                            if vis and okWall then
                                local sev = betterCheckSeverity(v, p, myPos)
                                local sp = Workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                                local lockSp = lockedPart and Workspace.CurrentCamera:WorldToViewportPoint(lockedPart.Position)
                                local newScreenDist = (Vector2.new(sp.X, sp.Y) - aimPoint).Magnitude
                                local lockScreenDist = lockSp and (Vector2.new(lockSp.X, lockSp.Y) - aimPoint).Magnitude or math.huge
                                if newScreenDist < searchRadiusPixels and newScreenDist < lockScreenDist - 5 then
                                    sev = math.max(sev, 1)
                                end
                                if sev > bestSev then
                                    bestSev = sev
                                    bestSevPlayer = v
                                    bestSevPart = p
                                end
                            end
                        end
                    end
                end
            end
        end
        if bestSevPlayer and bestSev >= 1 then
            local lockValid = isTargetValid(lockedTarget, trg_part)
            if not lockValid then
                lockedTarget = bestSevPlayer
                lockedPart = bestSevPart
                lockLostTimer = 0
                return lockedTarget
            end
            if bestSev >= 2 then
                lockedTarget = bestSevPlayer
                lockedPart = bestSevPart
                lockLostTimer = 0
                return lockedTarget
            end
        end
    end

    if lockedTarget then
        if lockLostTimer < lockGraceTime then
            return lockedTarget
        end
        if rawBest and rawBest ~= lockedTarget then
            local lockedDist = math.huge
            local okLock, lockPart = isTargetValid(lockedTarget, trg_part)
            if okLock then
                lockedDist = (lockPart.Position - myPos).Magnitude
            end
            if rawBestDist < lockedDist * (1 - switchPenalty) then
                lockedTarget = rawBest
                lockedPart = getAimPartObject(rawBest.Character, trg_part)
                lockLostTimer = 0
            else
                if not okLock and lockLostTimer >= lockGraceTime then
                    lockedTarget = rawBest
                    lockedPart = rawBest and getAimPartObject(rawBest.Character, trg_part)
                    lockLostTimer = 0
                end
            end
        elseif not rawBest then
            lockedTarget = nil
            lockedPart = nil
            lockLostTimer = 0
        end
    else
        if rawBest then
            lockedTarget = rawBest
            lockedPart = getAimPartObject(rawBest.Character, trg_part)
            lockLostTimer = 0
        end
    end

    return lockedTarget
end

local function createZoneGUI()
    if zoneGui then zoneGui:Destroy() end
    zoneGui = Instance.new("ScreenGui")
    zoneGui.Name = "AimbotZone"
    zoneGui.ResetOnSpawn = false
    zoneGui.IgnoreGuiInset = true
    zoneGui.Parent = uiparent()

    local circle = Instance.new("Frame")
    circle.Name = "ZoneCircle"
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.BackgroundTransparency = 1
    circle.Parent = zoneGui

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 80, 80)
    stroke.Parent = circle

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    return circle
end

local function updateZoneGUI()
    if not showZone or not zoneGui then return end
    local circle = zoneGui:FindFirstChild("ZoneCircle")
    if not circle then return end
    local viewport = Workspace.CurrentCamera.ViewportSize
    local radiusPixels = (naZoneAngle / 60) * (viewport.Y * 0.5)
    circle.Size = UDim2.new(0, radiusPixels * 2, 0, radiusPixels * 2)
end

local function createLockZoneGUI()
    if lockZoneGui then lockZoneGui:Destroy() end
    lockZoneGui = Instance.new("ScreenGui")
    lockZoneGui.Name = "AimbotLockZone"
    lockZoneGui.ResetOnSpawn = false
    lockZoneGui.IgnoreGuiInset = true
    lockZoneGui.Parent = uiparent()

    local circle = Instance.new("Frame")
    circle.Name = "LockZoneCircle"
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.BackgroundTransparency = 1
    circle.Parent = lockZoneGui

    local stroke = Instance.new("UIStroke")
    stroke.Name = "LockZoneStroke"
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(140, 140, 140)
    stroke.Parent = circle

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    return circle
end

local function updateLockZoneGUI()
    if not lockZoneEnabled or not lockZoneGui then return end
    local circle = lockZoneGui:FindFirstChild("LockZoneCircle")
    if not circle then return end
    local viewport = Workspace.CurrentCamera.ViewportSize
    local fovRad = math.rad(Workspace.CurrentCamera.FieldOfView)
    local tanHalfFov = math.tan(fovRad / 2)
    local radiusPixels = (math.tan(math.rad(lockZoneAngle)) / tanHalfFov) * (viewport.Y / 2)
    circle.Size = UDim2.new(0, radiusPixels * 2, 0, radiusPixels * 2)

    local stroke = circle:FindFirstChild("LockZoneStroke")
    if stroke then
        if lockedTarget and lockedTarget.Parent and lockedTarget.Character then
            stroke.Color = Color3.fromRGB(80, 255, 120)
        else
            stroke.Color = Color3.fromRGB(140, 140, 140)
        end
    end
end

addTextBox("Detection Range (studs)", 500, function(v) detectRange = v end)

local toggleBtn = addToggle("Toggle aimbot", function(state)
    enabled = state
    if not state then
        lockedTarget = nil
        lockedPart = nil
        lockLostTimer = 0
    end
end, false)

local toggleStickyBtn = addToggle("Sticky Target (hold lock)", function(state)
    stickyEnabled = state
    if not state then
        lockedTarget = nil
        lockedPart = nil
        lockLostTimer = 0
    end
end, true)

local toggleNotAggressiveBtn = addToggle("Not Aggressive Mode", function(state)
    notAggressive = state
end, false)

addSliderCombo("NA Speed", function() return naSmoothness * 100 end, function(step)
    naSmoothness = math.clamp(naSmoothness + step / 100, 0.1, 1)
end, {-10, -5, 5, 10}, "%")

addSliderCombo("NA Force", function() return (1 - naFlickForce) * 100 end, function(step)
    naFlickForce = math.clamp(naFlickForce - step / 100, 0, 1)
end, {-10, -5, 5, 10}, "%")

addSliderCombo("NA Zone", function() return naZoneAngle end, function(step)
    naZoneAngle = math.clamp(naZoneAngle + step, 5, 180)
    updateZoneGUI()
end, {-5, -2.5, -1, 1, 2.5, 5}, "°")

local toggleSuperAimBtn = addToggle("Super Aim (Snap to target)", function(state)
    superAim = state
end, false)

local toggleZoneBtn = addToggle("Show Zone", function(state)
    showZone = state
    if showZone then
        if not zoneGui then createZoneGUI() end
        if zoneGui then zoneGui.Enabled = true end
        updateZoneGUI()
    else
        if zoneGui then zoneGui.Enabled = false end
    end
end, false)

local toggleTeamCheckBtn = addToggle("Team check", function(state)
    teamcheck = state
end, false)

local toggleNonFriendsBtn = addToggle("Non Friends", function(state)
    nonfriends = state
end, false)

local toggleWallCheckBtn = addToggle("Wall check", function(state)
    wallcheck = state
end, false)

local toggleNoCollideBtn = addToggle("Check through no-collide objects", function(state)
    canSeeNoCollide = state
end, false)

local toggleTransparentBtn = addToggle("Check through transparent objects", function(state)
    canSeeTransparent = state
end, false)

local togglePrioritizeClosestBtn = addToggle("Prioritize Closest", function(state)
    prioritizeClosest = state
end, false)

local togglePrioritizeToolBtn = addToggle("Prioritize Holding Tool", function(state)
    prioritizeHoldingTool = state
end, false)

local toggleRequireToolBtn = addToggle("Require Tool to Aim", function(state)
    requireTool = state
end, false)

local toggleBetterCheckBtn = addToggle("Better Check (smart lock)", function(state)
    betterCheck = state
    if not state then
        lockedTarget = nil
        lockedPart = nil
        lockLostTimer = 0
    end
end, false)

addTextBox("BC: Warn dist (0 = max)", 0, function(v) bcDistWarn = v end)
addTextBox("BC: Medium dist (0 = max)", 0, function(v) bcDistMedium = v end)
addTextBox("BC: Urgent dist (0 = max)", 0, function(v) bcDistUrgent = v end)

local toggleSnipeCheckerBtn = addToggle("Snipe Checker (Smooth Direct Aim)", function(state)
    snipeChecker = state
end, false)

local toggleSniperSnapBtn = addToggle("Sniper: Snap when close", function(state)
    sniperSnapWhenClose = state
end, true)

addSliderCombo("Sniper Snap Threshold", function() return sniperSnapThreshold end, function(step)
    sniperSnapThreshold = math.clamp(sniperSnapThreshold + step, 0, 5)
end, {-0.5, -0.25, -0.1, -0.05, 0.05, 0.1, 0.25, 0.5}, "°")

addCombo("Aim part (main)", {"Head", "Torso"}, function(v) aimpart = v end)
addCombo("Sniper aim part", {"Head", "Torso"}, function(v) sniperAimPart = v end)

addSliderCombo("Yaw Offset", function() return aimOffsetYaw end, function(step)
    aimOffsetYaw = math.clamp(aimOffsetYaw + step, -45, 45)
end, {-5, -2.5, -1, 1, 2.5, 5}, "°")

addSliderCombo("Pitch Offset", function() return aimOffsetPitch end, function(step)
    aimOffsetPitch = math.clamp(aimOffsetPitch + step, -45, 45)
end, {-5, -2.5, -1, 1, 2.5, 5}, "°")

addSliderCombo("Pixel X Offset", function() return pixelOffsetX end, function(step)
    pixelOffsetX = pixelOffsetX + step
end, {-10, -5, -2.5, -1, -0.25, -0.1, 0.1, 0.25, 1, 2.5, 5, 10}, "px")

addSliderCombo("Pixel Y Offset", function() return pixelOffsetY end, function(step)
    pixelOffsetY = pixelOffsetY + step
end, {-10, -5, -2.5, -1, -0.25, -0.1, 0.1, 0.25, 1, 2.5, 5, 10}, "px")

addSliderCombo("Sniper Pixel X Offset", function() return sniperPixelOffsetX end, function(step)
    sniperPixelOffsetX = sniperPixelOffsetX + step
end, {-10, -5, -2.5, -1, -0.25, -0.1, 0.1, 0.25, 1, 2.5, 5, 10}, "px")

addSliderCombo("Sniper Pixel Y Offset", function() return sniperPixelOffsetY end, function(step)
    sniperPixelOffsetY = sniperPixelOffsetY + step
end, {-10, -5, -2.5, -1, -0.25, -0.1, 0.1, 0.25, 1, 2.5, 5, 10}, "px")

local toggleCrosshairBtn = addToggle("Custom Crosshair", function(state)
    customCrosshair = state
    if customCrosshair then
        createCrosshair()
    else
        if crosshairCenter then crosshairCenter.Visible = false end
        for _, line in ipairs(crosshairLines) do pcall(function() line.Visible = false end) end
    end
end, false)

local toggleSniperCrosshairBtn = addToggle("Custom Sniper Crosshair", function(state)
    customSniperCrosshair = state
    if customSniperCrosshair then
        createSniperCrosshair()
    else
        if sniperCrosshairCenter then sniperCrosshairCenter.Visible = false end
        for _, line in ipairs(sniperCrosshairLines) do pcall(function() line.Visible = false end) end
        if sniperAngleTextH then sniperAngleTextH.Visible = false end
        if sniperAngleTextV then sniperAngleTextV.Visible = false end
        if sniperAngleTextTotal then sniperAngleTextTotal.Visible = false end
    end
end, false)

local toggleLockZoneBtn = addToggle("Lock Zone (manual reset)", function(state)
    lockZoneEnabled = state
    if lockZoneEnabled then
        if not lockZoneGui then createLockZoneGUI() end
        if lockZoneGui then lockZoneGui.Enabled = true end
        updateLockZoneGUI()
    else
        if lockZoneGui then lockZoneGui.Enabled = false end
    end
end, false)

addSliderCombo("Lock Zone Angle", function() return lockZoneAngle end, function(step)
    lockZoneAngle = math.clamp(lockZoneAngle + step, 5, 80)
    updateLockZoneGUI()
end, {-5, -2.5, -1, 1, 2.5, 5}, "°")

addButton("Reset Settings", function()
    aimOffsetYaw = 0
    aimOffsetPitch = 0
    pixelOffsetX = 0
    pixelOffsetY = 0
    sniperPixelOffsetX = 0
    sniperPixelOffsetY = 0
    naSmoothness = 0.75
    naFlickForce = 0.15
    naZoneAngle = 60
    detectRange = 500
    sniperSnapThreshold = 0.5
    bcDistWarn = 0
    bcDistMedium = 0
    bcDistUrgent = 0
    lockZoneAngle = 25
    lockZoneEnabled = false
    canSeeNoCollide = false
    canSeeTransparent = false
    if lockZoneGui then lockZoneGui.Enabled = false end
    for _, cb in ipairs(updateCallbacks) do pcall(cb) end
    StarterGui:SetCore("SendNotification", {
        Title = "Reset",
        Text = "All settings reset to default",
        Duration = 2
    })
end)

RunService.RenderStepped:Connect(function(dt)
    local char = localPlayer.Character
    if char then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            if lastHealth == nil then lastHealth = hum.Health end
            if hum.Health < lastHealth - 0.01 then
                lastDamageTime = os.clock()
            end
            lastHealth = hum.Health
        end
    end

    if lockedTarget then
        local ok = isTargetValid(lockedTarget, aimpart)
        if not ok then
            lockLostTimer = lockLostTimer + dt
            if lockLostTimer > lockGraceTime then
                lockedTarget = nil
                lockedPart = nil
                lockLostTimer = 0
            end
        else
            lockLostTimer = 0
        end
    end

    if lockZoneEnabled and lockZoneCooldown <= 0 and isCursorOutsideLockZone() then
        lockedTarget = nil
        lockedPart = nil
        lockLostTimer = 0
        lockZoneCooldown = LOCK_ZONE_COOLDOWN
    end
    if lockZoneCooldown > 0 then
        lockZoneCooldown = math.max(0, lockZoneCooldown - dt)
    end

    updateCrosshair()
    if showZone then updateZoneGUI() end
    if lockZoneEnabled then updateLockZoneGUI() end

    local hasToolNow = localHasTool()
    local aimbotBlocked = requireTool and not hasToolNow

    if aimbotBlocked then
        lockedTarget = nil
        lockedPart = nil
        lockLostTimer = 0
        updateSniperCrosshair(nil)
        return
    end

    local closest = getClosestPlayerToCursor(aimpart)
    local targetPos = nil
    if closest and closest.Character then
        local aimobj = getAimPartObject(closest.Character, aimpart)
        if aimobj then targetPos = aimobj.Position end
    end

    local sniperClosest = nil
    local sniperTargetPos = nil
    if customSniperCrosshair then
        if snipeChecker or not closest then
            sniperClosest = getClosestPlayerToCursor(sniperAimPart)
            if sniperClosest and sniperClosest.Character then
                local sObj = getAimPartObject(sniperClosest.Character, sniperAimPart)
                if sObj then sniperTargetPos = sObj.Position end
            end
        end
        if not sniperTargetPos and closest and closest.Character then
            local sObj = getAimPartObject(closest.Character, sniperAimPart)
            if sObj then
                sniperClosest = closest
                sniperTargetPos = sObj.Position
            end
        end
    end

    if closest and closest.Character then
        local aimobj = getAimPartObject(closest.Character, aimpart)
        if aimobj then
            if enabled then
                if notAggressive then
                    local angle = getAngleToTarget(aimobj)
                    if angle <= naZoneAngle then
                        lookAtSmooth(aimobj.Position, naSmoothness)
                    end
                else
                    lookAt(aimobj.Position)
                end
            end

            if superAim then
                local angleFromAim = getAngleFromAimToTarget(aimobj)
                if angleFromAim <= superAimAngle then
                    lookAtSmooth(aimobj.Position, 0.25)
                end
            end

            if snipeChecker and not customSniperCrosshair then
                local shouldAim = true
                local smoothness = naSmoothness
                if notAggressive then
                    local angle = getAngleToTarget(aimobj)
                    if angle > naZoneAngle then shouldAim = false end
                else
                    smoothness = 0.35
                end
                if shouldAim then
                    lookAtSmooth(aimobj.Position, smoothness)
                end
            end
        end
    end

    if customSniperCrosshair and sniperTargetPos then
        if snipeChecker then
            local sniperAimPos = getSniperAimScreenPos()
            local idealCF = computeAimCFrame(sniperTargetPos, sniperAimPos)
            if notAggressive then
                local camPos = Workspace.CurrentCamera.CFrame.Position
                local dirToTarget = (sniperTargetPos - camPos).Unit
                local curLook = Workspace.CurrentCamera.CFrame.LookVector
                local zoneAngle = math.deg(math.acos(math.clamp(curLook:Dot(dirToTarget), -1, 1)))
                if zoneAngle <= naZoneAngle then
                    local currentLook = Workspace.CurrentCamera.CFrame.LookVector
                    local desiredLook = idealCF.LookVector
                    local dot = math.clamp(currentLook:Dot(desiredLook), -1, 1)
                    local angleRad = math.acos(dot)
                    local angleNorm = angleRad / math.pi
                    local flickBoost = 1 + (naFlickForce * angleNorm * 3)
                    local baseAlpha = math.min(1, naSmoothness * 1.5)
                    local alpha = math.clamp(baseAlpha * flickBoost, 0, 1)
                    Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(idealCF, alpha)
                    if sniperSnapWhenClose and math.deg(angleRad) < sniperSnapThreshold then
                        Workspace.CurrentCamera.CFrame = idealCF
                    end
                end
            else
                Workspace.CurrentCamera.CFrame = idealCF
            end
        end
        updateSniperCrosshair(sniperTargetPos)
    else
        updateSniperCrosshair(nil)
    end
end)

local userId = Players:GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

StarterGui:SetCore("SendNotification", {
    Title = "Aimbot",
    Text = "version V2.5",
    Icon = content,
    Duration = 7
})