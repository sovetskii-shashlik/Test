--[[
    AIMBOT SCRIPT
    Remade and optimized by Riky47#3355 for Arceus X
    # spdmteam.com
    Dual-crosshair build:
    - Normal custom crosshair: shows getAimScreenPos(), works as before.
    - Sniper crosshair: shows two angles (yaw/pitch) to target.
        * snipeChecker ON  -> camera is solved so sniper crosshair lands exactly on target (0.0° / 0.0°).
        * snipeChecker OFF -> just reads and displays angles, does not move camera.
        * Works even if main aimbot is OFF (find closest target in detectRange and show angles).
    Solver: exact orthonormal-axis construction (no Euler order drift), pixel-perfect at any distance.
]]

local Script_Title = `Arceus X <font color="rgb(255, 0, 0)">|</font> Aimbot`

-- Instances:
local Arceus = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Intro = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Logo = Instance.new("ImageButton")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local Title = Instance.new("TextLabel")
local Menu = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local Toggle = Instance.new("ImageButton")
local UICorner_3 = Instance.new("UICorner")
local Enabled = Instance.new("Frame")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local UICorner_4 = Instance.new("UICorner")
local Check = Instance.new("Frame")
local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
local UICorner_5 = Instance.new("UICorner")
local Name = Instance.new("TextLabel")
local UIGradient = Instance.new("UIGradient")
local Button = Instance.new("ImageButton")
local UICorner_6 = Instance.new("UICorner")
local Name_2 = Instance.new("TextLabel")
local UIGradient_2 = Instance.new("UIGradient")
local tab = Instance.new("Frame")
local Close = Instance.new("TextButton")
local ComboElem = Instance.new("ImageButton")
local UICorner_7 = Instance.new("UICorner")
local Name_3 = Instance.new("TextLabel")
local UIGradient_3 = Instance.new("UIGradient")
local Img = Instance.new("TextLabel")
local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
local ComboBox = Instance.new("ImageButton")
local UICorner_8 = Instance.new("UICorner")
local Name_4 = Instance.new("TextLabel")
local UIGradient_4 = Instance.new("UIGradient")
local Img_2 = Instance.new("TextLabel")
local UIAspectRatioConstraint_5 = Instance.new("UIAspectRatioConstraint")

--Properties:
Arceus.Name = "Arceus"
Arceus.Enabled = true
Arceus.ResetOnSpawn = true
Arceus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Arceus.DisplayOrder = 999999999

Main.Name = "Main"
Main.Parent = Arceus
Main.Active = true
Main.Draggable = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, -0.2, 0)
Main.Size = UDim2.new(0.3, 0, 0.3, 0)

UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = Main

Intro.Name = "Intro"
Intro.Parent = Main
Intro.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Intro.ClipsDescendants = true
Intro.Size = UDim2.new(1, 0, 1, 0)
Intro.ZIndex = 2

UICorner_2.CornerRadius = UDim.new(0.1, 0)
UICorner_2.Parent = Intro

Logo.Parent = Intro
Logo.AnchorPoint = Vector2.new(0.5, 0.5)
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
Logo.Size = UDim2.new(0.75, 0, 0.75, 0)
Logo.ZIndex = 2
Logo.Image = "http://www.roblox.com/asset/?id=9178187770"
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Active = false

UIAspectRatioConstraint.Parent = Logo

Title.Name = "Title"
Title.Parent = Main
Title.AnchorPoint = Vector2.new(1, 0)
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.975, 0, 0.075, 0)
Title.Size = UDim2.new(0.85, 0, 0.155, 0)
Title.Font = Enum.Font.TitilliumWeb
Title.FontFace = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Bold)
Title.RichText = true
Title.Text = Script_Title
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextSize = 14
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center

Menu.Name = "Menu"
Menu.Parent = Main
Menu.Active = true
Menu.AnchorPoint = Vector2.new(0.5, 1)
Menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Menu.BackgroundTransparency = 1
Menu.AutomaticCanvasSize = Enum.AutomaticSize.Y
Menu.BorderSizePixel = 0
Menu.Position = UDim2.new(0.5, 0, 0.95, 0)
Menu.Size = UDim2.new(0.95, 0, 0.65, 0)
Menu.CanvasSize = UDim2.new(0, 0, 0, 0)
Menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Menu.ScrollBarThickness = Menu.AbsoluteSize.X/25

UIListLayout.Parent = Menu
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

Toggle.Name = "Toggle"
Toggle.Visible = false
Toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Toggle.Size = UDim2.new(0.95, 0, 0, 50)

UICorner_3.CornerRadius = UDim.new(0.25, 0)
UICorner_3.Parent = Toggle

Enabled.Name = "Enabled"
Enabled.Parent = Toggle
Enabled.AnchorPoint = Vector2.new(1, 0.5)
Enabled.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Enabled.Position = UDim2.new(0.975, 0, 0.5, 0)
Enabled.Size = UDim2.new(0.75, 0, 0.75, 0)

UIAspectRatioConstraint_2.Parent = Enabled

UICorner_4.CornerRadius = UDim.new(0.3, 0)
UICorner_4.Parent = Enabled

Check.Name = "Check"
Check.Parent = Enabled
Check.AnchorPoint = Vector2.new(0.5, 0.5)
Check.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Check.Position = UDim2.new(0.5, 0, 0.5, 0)
Check.Size = UDim2.new(0.65, 0, 0.65, 0)

UIAspectRatioConstraint_3.Parent = Check

UICorner_5.CornerRadius = UDim.new(0.3, 0)
UICorner_5.Parent = Check

Name.Name = "Name"
Name.Parent = Toggle
Name.AnchorPoint = Vector2.new(0, 0.5)
Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name.BackgroundTransparency = 1
Name.BorderSizePixel = 0
Name.Position = UDim2.new(0.05, 0, 0.5, 0)
Name.Size = UDim2.new(0.75, 0, 0.8, 0)
Name.Font = Enum.Font.TitilliumWeb
Name.Text = "Script"
Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Name.TextScaled = true
Name.TextSize = 14
Name.TextWrapped = true
Name.TextXAlignment = Enum.TextXAlignment.Left
Name.TextYAlignment = Enum.TextYAlignment.Bottom

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 180, 180))}
UIGradient.Parent = Toggle

Button.Name = "Button"
Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Button.Size = UDim2.new(0.95, 0, 0, 50)

UICorner_6.CornerRadius = UDim.new(0.25, 0)
UICorner_6.Parent = Button

Name_2.Name = "Name"
Name_2.Parent = Button
Name_2.AnchorPoint = Vector2.new(0, 0.5)
Name_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name_2.BackgroundTransparency = 1
Name_2.BorderSizePixel = 0
Name_2.Position = UDim2.new(0.05, 0, 0.5, 0)
Name_2.Size = UDim2.new(0.95, 0, 0.82, 0)
Name_2.Font = Enum.Font.TitilliumWeb
Name_2.Text = "Enabled"
Name_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Name_2.TextScaled = true
Name_2.TextSize = 14
Name_2.TextWrapped = true
Name_2.TextXAlignment = Enum.TextXAlignment.Left
Name_2.TextYAlignment = Enum.TextYAlignment.Bottom

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 180, 180))}
UIGradient_2.Parent = Button

tab.Name = "Tab"
tab.Visible = false
tab.BackgroundTransparency = 1
tab.Size = UDim2.new(0.95, 0, 0.025, 0)

Close.Name = "Close"
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 1
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.8, 0, 0.1, 0)
Close.Size = UDim2.new(0.15, 0, 0.125, 0)
Close.Font = Enum.Font.FredokaOne
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 0, 0)
Close.TextScaled = true
Close.TextSize = 14
Close.TextWrapped = true
Close.TextXAlignment = Enum.TextXAlignment.Right
Close.Parent = Main

ComboElem.Name = "ComboElem"
ComboElem.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ComboElem.Size = UDim2.new(0.95, 0, 0, 50)

UICorner_7.CornerRadius = UDim.new(0.25, 0)
UICorner_7.Parent = ComboElem

Name_3.Name = "Name"
Name_3.Parent = ComboElem
Name_3.AnchorPoint = Vector2.new(0, 0.5)
Name_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name_3.BackgroundTransparency = 1
Name_3.BorderSizePixel = 0
Name_3.Position = UDim2.new(0.05, 0, 0.5, 0)
Name_3.Size = UDim2.new(0.75, 0, 0.8, 0)
Name_3.Font = Enum.Font.TitilliumWeb
Name_3.Text = "Enabled"
Name_3.TextColor3 = Color3.fromRGB(255, 0, 0)
Name_3.TextScaled = true
Name_3.TextSize = 14
Name_3.TextWrapped = true
Name_3.TextXAlignment = Enum.TextXAlignment.Left
Name_3.TextYAlignment = Enum.TextYAlignment.Bottom

UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 180, 180))}
UIGradient_3.Rotation = 180
UIGradient_3.Parent = ComboElem

Img.Name = "Img"
Img.Parent = ComboElem
Img.AnchorPoint = Vector2.new(1, 0.5)
Img.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Img.BackgroundTransparency = 1
Img.BorderSizePixel = 0
Img.Position = UDim2.new(0.975, 0, 0.5, 0)
Img.Rotation = 90
Img.Size = UDim2.new(0.75, 0, 0.75, 0)
Img.Font = Enum.Font.FredokaOne
Img.Text = "^"
Img.TextColor3 = Color3.fromRGB(255, 255, 255)
Img.TextScaled = true
Img.TextSize = 14
Img.TextWrapped = true

UIAspectRatioConstraint_4.Parent = Img

ComboBox.Name = "ComboBox"
ComboBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ComboBox.Size = UDim2.new(0.95, 0, 0, 50)

UICorner_8.CornerRadius = UDim.new(0.25, 0)
UICorner_8.Parent = ComboBox

Name_4.Name = "Name"
Name_4.Parent = ComboBox
Name_4.AnchorPoint = Vector2.new(0, 0.5)
Name_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name_4.BackgroundTransparency = 1.000
Name_4.BorderSizePixel = 0
Name_4.Position = UDim2.new(0.05, 0, 0.5, 0)
Name_4.Size = UDim2.new(0.75, 0, 0.8, 0)
Name_4.Font = Enum.Font.TitilliumWeb
Name_4.Text = "Enabled"
Name_4.TextColor3 = Color3.fromRGB(255, 255, 255)
Name_4.TextScaled = true
Name_4.TextSize = 14
Name_4.TextWrapped = true
Name_4.TextXAlignment = Enum.TextXAlignment.Left
Name_4.TextYAlignment = Enum.TextYAlignment.Bottom

UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 180, 180))}
UIGradient_4.Parent = ComboBox

Img_2.Name = "Img"
Img_2.Parent = ComboBox
Img_2.AnchorPoint = Vector2.new(1, 0.5)
Img_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Img_2.BackgroundTransparency = 1
Img_2.BorderSizePixel = 0
Img_2.Rotation = 180
Img_2.Position = UDim2.new(0.975, 0, 0.5, 0)
Img_2.Size = UDim2.new(0.75, 0, 0.75, 0)
Img_2.Font = Enum.Font.FredokaOne
Img_2.Text = "^"
Img_2.TextColor3 = Color3.fromRGB(255, 0, 0)
Img_2.TextScaled = true
Img_2.TextSize = 14
Img_2.TextWrapped = true

UIAspectRatioConstraint_5.Parent = Img_2

-- SCRIPT
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

Close.MouseButton1Click:Connect(function()
    Logo.Active = true
    TweenService:Create(Intro, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
    task.wait(0.3)
    Logo:TweenSizeAndPosition(UDim2.fromScale(0.75, 0.75), UDim2.fromScale(0.5, 0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, nil)
    task.wait(0.3)
    Main:TweenSize(UDim2.fromScale(0.1, 0.175), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, nil)
    task.wait(0.3)
    for _, obj in pairs(Main:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Intro then obj.Visible = false end
    end
    TweenService:Create(Logo, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 0.8}):Play()
    TweenService:Create(Intro, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0.8}):Play()
end)

Logo.MouseButton1Click:Connect(function()
    Logo.Active = false
    TweenService:Create(Logo, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 0}):Play()
    TweenService:Create(Intro, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
    task.wait(0.3)
    Main:TweenSize(UDim2.fromScale(0.3, 0.3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, nil)
    task.wait(0.3)
    Logo:TweenSizeAndPosition(UDim2.fromScale(0.175, 0.175), UDim2.fromScale(0.075, 0.15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, nil)
    for _, obj in pairs(Main:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Intro then obj.Visible = true end
    end
    task.wait(0.3)
    TweenService:Create(Intro, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
end)

local function uiparent()
    local success, parent = pcall(function() return gethui() end)
    if not success then return game:GetService("CoreGui") end
    return parent
end

local success, err = pcall(function() Arceus.Parent = uiparent() end)
if not success then Arceus.Parent = game:GetService("Players").LocalPlayer.PlayerGui end

local element_height = 50*Menu.AbsoluteSize.Y/210
local elements = 0
local updateCallbacks = {}

local function addSpace(parent)
    local space = tab:Clone()
    space.Parent = parent
    space.LayoutOrder = elements
    space.Visible = true
    elements += 1
end

local function addToggle(name, funct, enabled, ...)
    local newTog = Toggle:Clone()
    local args = {...}
    newTog.MouseButton1Click:Connect(function()
        enabled = not enabled
        newTog:WaitForChild("Enabled"):WaitForChild("Check").Visible = enabled
        funct(enabled, unpack(args))
    end)
    newTog:WaitForChild("Enabled"):WaitForChild("Check").Visible = enabled
    newTog:WaitForChild("Name").Text = name
    newTog.Size = UDim2.new(0.95, 0, 0, element_height)
    newTog.Name = name
    newTog.Parent = Menu
    newTog.LayoutOrder = elements
    newTog.Visible = true
    elements += 1
    addSpace(Menu)
    return newTog
end

local function addButton(name, funct, ...)
    local newBut = Button:Clone()
    local args = {...}
    newBut.MouseButton1Click:Connect(function() funct(unpack(args)) end)
    newBut:WaitForChild("Name").Text = name
    newBut.Size = UDim2.new(0.95, 0, 0, element_height)
    newBut.Name = name
    newBut.Parent = Menu
    newBut.LayoutOrder = elements
    newBut.Visible = true
    elements += 1
    addSpace(Menu)
    return newBut
end

local function addComboBox(text, options, funct, ...)
    local newCombo = ComboBox:Clone()
    local enabled = false
    local elems = {}
    local args = {...}
    local function setBoxState()
        newCombo:WaitForChild("Img").Rotation = enabled and 0 or 180
        for _, elem in ipairs(elems) do elem.Visible = enabled end
    end
    newCombo.MouseButton1Click:Connect(function()
        enabled = not enabled
        setBoxState()
    end)
    newCombo:WaitForChild("Name").Text = text .. ": " .. (#options > 0 and options[1] or "")
    newCombo.Size = UDim2.new(0.95, 0, 0, element_height)
    newCombo.Name = #options > 0 and options[1] or ""
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true
    elements += 1
    addSpace(Menu)
    for _, name in ipairs(options) do
        local newElem = ComboElem:Clone()
        table.insert(elems, newElem)
        newElem.MouseButton1Click:Connect(function()
            newCombo:WaitForChild("Name").Text = text .. ": " .. name
            enabled = false
            setBoxState()
            funct(name, unpack(args))
        end)
        newElem:WaitForChild("Name").Text = name
        newElem.Size = UDim2.new(0.95, 0, 0, element_height)
        newElem.Name = name
        newElem.Parent = Menu
        newElem.LayoutOrder = elements
        newElem.Visible = false
        elements += 1
        addSpace(Menu)
    end
    return newCombo
end

-- Actual Script
local runService = game:GetService("RunService")
local plrsService = game:GetService("Players")
local workspace = game:GetService("Workspace")
local enabled = false
local teamcheck = false
local wallcheck = false
local nonfriends = false
local aimpart = "Head"
local notAggressive = false
local detectRange = 500
local superAim = false
local superAimAngle = 45

local prioritizeClosest = false
local prioritizeHoldingTool = false
local requireTool = false
local snipeChecker = false

local aimOffsetYaw = 0
local aimOffsetPitch = 0
local pixelOffsetX = 0
local pixelOffsetY = 0

-- Снайперский прицел: собственные пиксель-оффсеты (независимо от обычного)
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
local sniperAngleTextH = nil   -- горизонтальный угол (yaw)
local sniperAngleTextV = nil   -- вертикальный угол (pitch)
local sniperAngleTextTotal = nil

local function getAimScreenPos()
    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    local fovRad = math.rad(camera.FieldOfView)
    local tanHalfFov = math.tan(fovRad / 2)
    local aspect = viewport.X / viewport.Y

    -- Горизонтальный пиксель — через viewport.X/2 с учётом aspect
    local yawPixels = (math.tan(math.rad(aimOffsetYaw)) / (tanHalfFov * aspect)) * (viewport.X / 2)
    local pitchPixels = (math.tan(math.rad(aimOffsetPitch)) / tanHalfFov) * (viewport.Y / 2)

    return Vector2.new(
        viewport.X / 2 + pixelOffsetX + yawPixels,
        viewport.Y / 2 + pixelOffsetY + pitchPixels
    )
end

-- Точка снайперского прицела (независимые пиксель-оффсеты)
local function getSniperAimScreenPos()
    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    return Vector2.new(
        viewport.X / 2 + sniperPixelOffsetX,
        viewport.Y / 2 + sniperPixelOffsetY
    )
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

--[[
    ТОЧНЫЙ АНАЛИТИЧЕСКИЙ СОЛВЕР (та же математика, что дала стабильный результат).

    Возвращает CFrame, при котором targetPos проецируется РОВНО в aimScreenPos.
    Строит явные ортонормальные оси через CFrame.fromMatrix. Нет roll, нет накопления.
]]
local function solveCFrameForTarget(targetPos, aimScreenPos)
    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    local camPos = camera.CFrame.Position

    local fovRad = math.rad(camera.FieldOfView)
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

    lookAfterPitch = lookAfterPitch.Unit
    upAfterPitch   = upAfterPitch.Unit
    rightAfterYaw  = rightAfterYaw.Unit

    return CFrame.fromMatrix(camPos, rightAfterYaw, upAfterPitch, -lookAfterPitch)
end

-- Считает угловую разницу между двумя CFrame в градусах (yaw/pitch/total)
local function angleBetweenCFrames(cfA, cfB)
    local fwdA = -cfA.ZVector
    local fwdB = -cfB.ZVector
    -- Локальные координаты fwdB в системе cfA
    local localB = cfA:VectorToObjectSpace(fwdB)
    -- yaw = atan2(x, -z), pitch = asin(-y)
    local yaw   = math.deg(math.atan2(localB.X, -localB.Z))
    local pitch = math.deg(math.asin(math.clamp(localB.Y, -1, 1)))
    local dot = math.clamp(fwdA:Dot(fwdB), -1, 1)
    local total = math.deg(math.acos(dot))
    return yaw, pitch, total
end

local function lookAt(targetPos)
    workspace.CurrentCamera.CFrame = solveCFrameForTarget(targetPos, getAimScreenPos())
end

local function lookAtSmooth(targetPos, alpha)
    local currentCFrame = workspace.CurrentCamera.CFrame
    local targetCFrame = solveCFrameForTarget(targetPos, getAimScreenPos())
    workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, alpha)
end

--[[
    Обновляет снайперский прицел и (опционально) двигает камеру.
    Если snipeChecker ON и targetPos есть — камера докручивается так, чтобы
    центр снайперского прицела точно совпал с targetPos (0.0° / 0.0°).
    Если snipeChecker OFF — только отображает углы, камеру не трогает.
    Если targetPos = nil — прицел отображается, углов нет.
]]
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

    -- Крест побольше, чтобы отличать от обычного
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

    -- Идеальный CFrame для снайпера (цель ровно в центре снайперского креста)
    local idealCF = solveCFrameForTarget(targetPos, aimPos)
    local currentCF = workspace.CurrentCamera.CFrame

    -- Угловая разница текущего положения камеры относительно "идеального для снайпера"
    local yawDeg, pitchDeg, totalDeg = angleBetweenCFrames(currentCF, idealCF)

    -- Цвет по близости к 0
    local function colorFor(d)
        local a = math.abs(d)
        if a < 0.05 then return Color3.fromRGB(0, 255, 120)
        elseif a < 0.5 then return Color3.fromRGB(180, 255, 0)
        elseif a < 3.0 then return Color3.fromRGB(255, 220, 0)
        else return Color3.fromRGB(255, 70, 70) end
    end

    local function signStr(v)
        if v >= 0 then return "+" else return "" end
    end

    sniperAngleTextH.Text = string.format("X: %s%.2f°", signStr(yawDeg), yawDeg)
    sniperAngleTextH.Position = Vector2.new(aimPos.X + 12, aimPos.Y - 22)
    sniperAngleTextH.Color = colorFor(yawDeg)
    sniperAngleTextH.Visible = true

    sniperAngleTextV.Text = string.format("Y: %s%.2f°", signStr(pitchDeg), pitchDeg)
    sniperAngleTextV.Position = Vector2.new(aimPos.X + 12, aimPos.Y - 8)
    sniperAngleTextV.Color = colorFor(pitchDeg)
    sniperAngleTextV.Visible = true

    sniperAngleTextTotal.Text = string.format("Σ: %.2f°%s", totalDeg, totalDeg < 0.1 and " ✓" or "")
    sniperAngleTextTotal.Position = Vector2.new(aimPos.X + 12, aimPos.Y + 6)
    sniperAngleTextTotal.Color = colorFor(totalDeg)
    sniperAngleTextTotal.Visible = true
end

function getAngleToTarget(aimobj)
    local camera = workspace.CurrentCamera
    local cameraPos = camera.CFrame.Position
    local cameraLook = camera.CFrame.LookVector
    local directionToTarget = (aimobj.Position - cameraPos).Unit
    local dot = cameraLook:Dot(directionToTarget)
    return math.deg(math.acos(math.clamp(dot, -1, 1)))
end

local function getAngleFromAimToTarget(aimobj)
    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    local screenPos = camera:WorldToViewportPoint(aimobj.Position)
    local targetScreen = Vector2.new(screenPos.X, screenPos.Y)
    local aimPos = getAimScreenPos()
    local diff = (targetScreen - aimPos).Magnitude
    return (diff / viewport.Y) * 70
end

function isVisible(part)
    if not wallcheck then return true end
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (origin - part.Position).Magnitude
    local ray = Ray.new(origin, direction)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {camera, plrsService.LocalPlayer.Character})
    if hit and hit:IsDescendantOf(part.Parent) then return true end
    return false
end

function isFriend(player)
    local localPlayer = plrsService.LocalPlayer
    local success, isFriend = pcall(function() return player:IsFriendsWith(localPlayer.UserId) end)
    return success and isFriend
end

local function isHoldingTool(player)
    if not player.Character then return false end
    return player.Character:FindFirstChildWhichIsA("Tool") ~= nil
end

local function localHasTool()
    local char = plrsService.LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChildWhichIsA("Tool") ~= nil
end

-- [[ ВАЖНО ]] aimPoint для поиска цели — по СНАЙПЕРСКОМУ прицелу, если он включён,
-- иначе по обычному. Это гарантирует, что снайперский ищет ближайшего к СВОЕМУ кресту.
local function getSearchAimPoint()
    if customSniperCrosshair then
        return getSniperAimScreenPos()
    end
    return getAimScreenPos()
end

function getClosestPlayerToCursor(trg_part)
    local localPlayer = plrsService.LocalPlayer
    if requireTool and not localHasTool() then return nil end
    local myChar = localPlayer.Character
    if not myChar then return nil end
    local myHead = myChar:FindFirstChild("Head")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myHead or not myRoot then return nil end
    local aimPoint = getSearchAimPoint()
    local myPos = myRoot.Position
    local bestClosest = nil
    local bestClosestDist = math.huge
    local bestTool = nil
    local bestToolDist = math.huge
    for _, v in ipairs(plrsService:GetPlayers()) do
        if v ~= localPlayer and myChar:FindFirstChildWhichIsA("Humanoid") and myChar.Humanoid.Health > 0
            and v.Character and v.Character:FindFirstChildWhichIsA("Humanoid") and v.Character.Humanoid.Health > 0 then
            local allowed = not teamcheck
            if teamcheck and v.Team ~= localPlayer.Team then allowed = true end
            if nonfriends and isFriend(v) then allowed = false end
            if allowed then
                local aimobj = v.Character:FindFirstChild(trg_part) or v.Character:FindFirstChild("UpperTorso")
                if aimobj then
                    local distanceToPlayer = (aimobj.Position - myPos).Magnitude
                    if distanceToPlayer <= detectRange then
                        local ePos, vissss = workspace.CurrentCamera:WorldToViewportPoint(aimobj.Position)
                        local AccPos = Vector2.new(ePos.x, ePos.y)
                        local screenDist = (AccPos - aimPoint).magnitude
                        local visibleThroughWalls = true
                        if wallcheck then visibleThroughWalls = isVisible(aimobj) end
                        if vissss and screenDist < 400 and visibleThroughWalls then
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
    if prioritizeClosest and prioritizeHoldingTool then
        if bestClosest and bestTool then
            if bestClosest == bestTool then return bestClosest end
            if bestClosestDist < bestToolDist then return bestClosest else return bestTool end
        elseif bestClosest then return bestClosest
        elseif bestTool then return bestTool end
    elseif prioritizeClosest then return bestClosest
    elseif prioritizeHoldingTool then return bestTool
    else return bestClosest end
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
    local viewport = workspace.CurrentCamera.ViewportSize
    local radiusPixels = (naZoneAngle / 60) * (viewport.Y * 0.5)
    circle.Size = UDim2.new(0, radiusPixels * 2, 0, radiusPixels * 2)
end

local function addTextBox(text, initialText, onChange)
    local newBox = Instance.new("TextBox")
    newBox.Size = UDim2.new(0.95, 0, 0, element_height)
    newBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    newBox.BorderSizePixel = 0
    newBox.Text = initialText
    newBox.PlaceholderText = text
    newBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    newBox.Font = Enum.Font.TitilliumWeb
    newBox.TextSize = 14
    newBox.TextScaled = true
    newBox.ClearTextOnFocus = false
    newBox.Parent = Menu
    newBox.LayoutOrder = elements
    newBox.Visible = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.25, 0)
    corner.Parent = newBox
    newBox.FocusLost:Connect(function()
        local num = tonumber(newBox.Text)
        if num and num > 0 then onChange(num) else newBox.Text = tostring(initialText) end
    end)
    elements += 1
    addSpace(Menu)
    return newBox
end

local function addOffsetComboBox(text, initialValue, onChange)
    local newCombo = ComboBox:Clone()
    local isOpen = false
    local currentValue = initialValue or 0
    local elems = {}
    local function updateText()
        local viewport = workspace.CurrentCamera.ViewportSize
        local fov = math.rad(workspace.CurrentCamera.FieldOfView)
        local tanHalfV = math.tan(fov / 2)
        local aspect = viewport.X / viewport.Y
        local pixelValue = (math.tan(math.rad(currentValue)) / (tanHalfV * aspect)) * (viewport.X / 2)
        local percent = math.floor((currentValue / 45) * 100)
        newCombo:WaitForChild("Name").Text = string.format("%s: %.1f° (%d%%) [~%d px]", text, currentValue, percent, math.floor(pixelValue))
    end
    local function setBoxState()
        newCombo:WaitForChild("Img").Rotation = isOpen and 0 or 180
        for _, elem in ipairs(elems) do elem.Visible = isOpen end
    end
    newCombo.MouseButton1Click:Connect(function() isOpen = not isOpen; setBoxState() end)
    updateText()
    table.insert(updateCallbacks, updateText)
    newCombo.Size = UDim2.new(0.95, 0, 0, element_height)
    newCombo.Name = text
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true
    elements += 1
    addSpace(Menu)
    local buttons = {
        {label = "-5°", value = -5}, {label = "-2.5°", value = -2.5}, {label = "-1°", value = -1},
        {label = "+1°", value = 1}, {label = "+2.5°", value = 2.5}, {label = "+5°", value = 5},
    }
    for _, btnData in ipairs(buttons) do
        local btn = ComboElem:Clone()
        btn:WaitForChild("Name").Text = btnData.label
        btn.Size = UDim2.new(0.95, 0, 0, element_height)
        btn.Name = btnData.label
        btn.Parent = Menu
        btn.LayoutOrder = elements
        btn.Visible = false
        table.insert(elems, btn)
        btn.MouseButton1Click:Connect(function()
            currentValue = math.clamp(currentValue + btnData.value, -45, 45)
            updateText()
            onChange(currentValue)
        end)
        elements += 1
        addSpace(Menu)
    end
    return newCombo
end

local function addPixelOffsetComboBox(text, initialValue, onChange)
    local newCombo = ComboBox:Clone()
    local isOpen = false
    local currentValue = initialValue or 0
    local elems = {}
    local function updateText()
        local viewport = workspace.CurrentCamera.ViewportSize
        local fov = math.rad(workspace.CurrentCamera.FieldOfView)
        local tanHalfV = math.tan(fov / 2)
        local degreesValue = math.deg(math.atan((currentValue / (viewport.Y / 2)) * tanHalfV))
        newCombo:WaitForChild("Name").Text = string.format("%s: %d px [~%.2f°]", text, currentValue, degreesValue)
    end
    local function setBoxState()
        newCombo:WaitForChild("Img").Rotation = isOpen and 0 or 180
        for _, elem in ipairs(elems) do elem.Visible = isOpen end
    end
    newCombo.MouseButton1Click:Connect(function() isOpen = not isOpen; setBoxState() end)
    updateText()
    table.insert(updateCallbacks, updateText)
    newCombo.Size = UDim2.new(0.95, 0, 0, element_height)
    newCombo.Name = text
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true
    elements += 1
    addSpace(Menu)
    local buttons = {
        {label = "-10px", value = -10}, {label = "-5px", value = -5}, {label = "-2px", value = -2}, {label = "-1px", value = -1},
        {label = "+1px", value = 1}, {label = "+2px", value = 2}, {label = "+5px", value = 5}, {label = "+10px", value = 10},
    }
    for _, btnData in ipairs(buttons) do
        local btn = ComboElem:Clone()
        btn:WaitForChild("Name").Text = btnData.label
        btn.Size = UDim2.new(0.95, 0, 0, element_height)
        btn.Name = btnData.label
        btn.Parent = Menu
        btn.LayoutOrder = elements
        btn.Visible = false
        table.insert(elems, btn)
        btn.MouseButton1Click:Connect(function()
            currentValue = currentValue + btnData.value
            updateText()
            onChange(currentValue)
        end)
        elements += 1
        addSpace(Menu)
    end
    return newCombo
end

local function addNAComboBox()
    local newCombo = ComboBox:Clone()
    local isOpen = false
    local elems = {}
    local function setBoxState()
        newCombo:WaitForChild("Img").Rotation = isOpen and 0 or 180
        for _, elem in ipairs(elems) do elem.Visible = isOpen end
    end
    local function updateText()
        newCombo:WaitForChild("Name").Text = string.format("NA: Speed %d%% | Force %d%% | Zone %d°", math.floor(naSmoothness * 100), math.floor((1 - naFlickForce) * 100), naZoneAngle)
    end
    newCombo.MouseButton1Click:Connect(function() isOpen = not isOpen; setBoxState() end)
    updateText()
    table.insert(updateCallbacks, updateText)
    newCombo.Size = UDim2.new(0.95, 0, 0, element_height)
    newCombo.Name = "NotAggressiveSettings"
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true
    elements += 1
    addSpace(Menu)
    local speedButtons = {
        {label = "Speed -10%", value = -0.1}, {label = "Speed -5%", value = -0.05},
        {label = "Speed +5%", value = 0.05}, {label = "Speed +10%", value = 0.1},
    }
    for _, btnData in ipairs(speedButtons) do
        local btn = ComboElem:Clone()
        btn:WaitForChild("Name").Text = btnData.label
        btn.Size = UDim2.new(0.95, 0, 0, element_height)
        btn.Name = btnData.label
        btn.Parent = Menu
        btn.LayoutOrder = elements
        btn.Visible = false
        table.insert(elems, btn)
        btn.MouseButton1Click:Connect(function()
            naSmoothness = math.clamp(naSmoothness + btnData.value, 0.1, 1)
            updateText()
        end)
        elements += 1
        addSpace(Menu)
    end
    local forceButtons = {
        {label = "Tactility -10%", value = 0.1}, {label = "Tactility -5%", value = 0.05},
        {label = "Tactility +5%", value = -0.05}, {label = "Tactility +10%", value = -0.1},
    }
    for _, btnData in ipairs(forceButtons) do
        local btn = ComboElem:Clone()
        btn:WaitForChild("Name").Text = btnData.label
        btn.Size = UDim2.new(0.95, 0, 0, element_height)
        btn.Name = btnData.label
        btn.Parent = Menu
        btn.LayoutOrder = elements
        btn.Visible = false
        table.insert(elems, btn)
        btn.MouseButton1Click:Connect(function()
            naFlickForce = math.clamp(naFlickForce + btnData.value, 0, 1)
            updateText()
        end)
        elements += 1
        addSpace(Menu)
    end
    local zoneButtons = {
        {label = "Zone -5°", value = -5}, {label = "Zone -2.5°", value = -2.5}, {label = "Zone -1°", value = -1},
        {label = "Zone +1°", value = 1}, {label = "Zone +2.5°", value = 2.5}, {label = "Zone +5°", value = 5},
    }
    for _, btnData in ipairs(zoneButtons) do
        local btn = ComboElem:Clone()
        btn:WaitForChild("Name").Text = btnData.label
        btn.Size = UDim2.new(0.95, 0, 0, element_height)
        btn.Name = btnData.label
        btn.Parent = Menu
        btn.LayoutOrder = elements
        btn.Visible = false
        table.insert(elems, btn)
        btn.MouseButton1Click:Connect(function()
            naZoneAngle = math.clamp(naZoneAngle + btnData.value, 5, 180)
            updateText()
            updateZoneGUI()
        end)
        elements += 1
        addSpace(Menu)
    end
end

-- ORDER OF UI ELEMENTS
addTextBox("Detection Range (studs)", "500", function(v) detectRange = v end)
local toggleBtn = addToggle("Toggle aimbot", function(state) enabled = state end, false)
local toggleNotAggressiveBtn = addToggle("Not Aggressive Mode", function(state) notAggressive = state end, false)
addNAComboBox()
local toggleSuperAimBtn = addToggle("Super Aim (Snap to target)", function(state) superAim = state end, false)
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
local toggleTeamCheckBtn = addToggle("Team check", function(state) teamcheck = state end, false)
local toggleNonFriendsBtn = addToggle("Non Friends", function(state) nonfriends = state end, false)
local toggleWallCheckBtn = addToggle("Wall check", function(state) wallcheck = state end, false)
local togglePrioritizeClosestBtn = addToggle("Prioritize Closest", function(state) prioritizeClosest = state end, false)
local togglePrioritizeToolBtn = addToggle("Prioritize Holding Tool", function(state) prioritizeHoldingTool = state end, false)
local toggleRequireToolBtn = addToggle("Require Tool to Aim", function(state) requireTool = state end, false)

local toggleSnipeCheckerBtn = addToggle("Snipe Checker (Snap sniper crosshair to target)", function(state) snipeChecker = state end, false)

local aimPartCombo = addComboBox("Aim part", {"Head", "Torso"}, function(selection) aimpart = selection end)

addOffsetComboBox("Yaw Offset", 0, function(v) aimOffsetYaw = v end)
addOffsetComboBox("Pitch Offset", 0, function(v) aimOffsetPitch = v end)
addPixelOffsetComboBox("Pixel X Offset", 0, function(v) pixelOffsetX = v end)
addPixelOffsetComboBox("Pixel Y Offset", 0, function(v) pixelOffsetY = v end)

-- Снайперский прицел: свои пиксель-оффсеты
addPixelOffsetComboBox("Sniper Pixel X Offset", 0, function(v) sniperPixelOffsetX = v end)
addPixelOffsetComboBox("Sniper Pixel Y Offset", 0, function(v) sniperPixelOffsetY = v end)

local toggleCrosshairBtn = addToggle("Custom Crosshair", function(state)
    customCrosshair = state
    if customCrosshair then createCrosshair()
    else
        if crosshairCenter then crosshairCenter.Visible = false end
        for _, line in ipairs(crosshairLines) do pcall(function() line.Visible = false end) end
    end
end, false)

local toggleSniperCrosshairBtn = addToggle("Custom Sniper Crosshair (with angles)", function(state)
    customSniperCrosshair = state
    if customSniperCrosshair then createSniperCrosshair()
    else
        if sniperCrosshairCenter then sniperCrosshairCenter.Visible = false end
        for _, line in ipairs(sniperCrosshairLines) do pcall(function() line.Visible = false end) end
        if sniperAngleTextH then sniperAngleTextH.Visible = false end
        if sniperAngleTextV then sniperAngleTextV.Visible = false end
        if sniperAngleTextTotal then sniperAngleTextTotal.Visible = false end
    end
end, false)

local resetBtn = addButton("Reset Settings", function()
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
    for _, callback in ipairs(updateCallbacks) do pcall(callback) end
    StarterGui:SetCore("SendNotification", {Title = "Reset", Text = "All settings reset", Duration = 2})
end)

runService.RenderStepped:Connect(function()
    local closest = getClosestPlayerToCursor(aimpart)
    local targetPos = nil

    if closest and closest.Character then
        local aimobj = closest.Character:FindFirstChild(aimpart) or closest.Character:FindFirstChild("UpperTorso")
        if aimobj then targetPos = aimobj.Position end
    end

    -- Обычный прицел рисуется сразу
    updateCrosshair()
    if showZone then updateZoneGUI() end

    -- 1) Основной аимбот
    if targetPos and closest and closest.Character then
        local aimobj = closest.Character:FindFirstChild(aimpart) or closest.Character:FindFirstChild("UpperTorso")
        if aimobj then
            if superAim then
                local angleFromAim = getAngleFromAimToTarget(aimobj)
                if angleFromAim <= superAimAngle then
                    lookAtSmooth(aimobj.Position, 0.25)
                end
            end
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
        end
    end

    -- 2) Снайперский прицел: считаем углы относительно снайперской точки
    --    Если snipeChecker ON и есть цель — докручиваем камеру так, чтобы центр снайперского
    --    прицела совпал с целью (0.0° / 0.0°). Подчиняется NA-зоне и сглаживанию.
    if targetPos then
        if snipeChecker then
            local sniperAimPos = getSniperAimScreenPos()
            local idealCF = solveCFrameForTarget(targetPos, sniperAimPos)

            if notAggressive then
                -- Проверка зоны: угол между текущим look и направлением на цель
                local camPos = workspace.CurrentCamera.CFrame.Position
                local dirToTarget = (targetPos - camPos).Unit
                local curLook = workspace.CurrentCamera.CFrame.LookVector
                local zoneAngle = math.deg(math.acos(math.clamp(curLook:Dot(dirToTarget), -1, 1)))
                if zoneAngle <= naZoneAngle then
                    -- Сглаживание с flick-бустом, как в обычном NA
                    local currentLook = workspace.CurrentCamera.CFrame.LookVector
                    local desiredLook = idealCF.LookVector
                    local dot = math.clamp(currentLook:Dot(desiredLook), -1, 1)
                    local angleRad = math.acos(dot)
                    local angleNorm = angleRad / math.pi
                    local flickBoost = 1 + (naFlickForce * angleNorm * 3)
                    local alpha = math.clamp(naSmoothness * flickBoost, 0, 1)
                    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(idealCF, alpha)
                end
            else
                workspace.CurrentCamera.CFrame = idealCF
            end
        end
        -- Рисуем снайперский прицел и углы (уже после возможного движения камеры)
        updateSniperCrosshair(targetPos)
    else
        -- Нет цели — просто прицел без углов (чтобы не мигал)
        updateSniperCrosshair(nil)
    end
end)

-- INIT
Main:TweenPosition(UDim2.fromScale(0.5, 0.5), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 1, true, nil)
task.wait(1.5)
Logo:TweenSizeAndPosition(UDim2.fromScale(0.175, 0.175), UDim2.fromScale(0.075, 0.15), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 1, true, nil)
task.wait(1.5)
TweenService:Create(Intro, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()