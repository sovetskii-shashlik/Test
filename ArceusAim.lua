--[[
    AIMBOT SCRIPT

    Remade and optimized by Riky47#3355 for Arceus X
    # spdmteam.com
    Modified: Aim offset, Not Aggressive tweaks, Zone visualizer, Detection Range
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
Close.MouseButton1Click:Connect(function()
    Logo.Active = true
    TweenService:Create(Intro, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()

    task.wait(0.3)
    Logo:TweenSizeAndPosition(
        UDim2.fromScale(0.75, 0.75),
        UDim2.fromScale(0.5, 0.5),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.25, true, nil
    )

    task.wait(0.3)
    Main:TweenSize(
        UDim2.fromScale(0.1, 0.175),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.25, true, nil
    )

    task.wait(0.3)
    for _, obj in pairs(Main:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Intro then
            obj.Visible = false
        end
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
    Main:TweenSize(
        UDim2.fromScale(0.3, 0.3),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.25, true, nil
    )

    task.wait(0.3)
    Logo:TweenSizeAndPosition(
        UDim2.fromScale(0.175, 0.175),
        UDim2.fromScale(0.075, 0.15),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.25, true, nil
    )

    for _, obj in pairs(Main:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Intro then
            obj.Visible = true
        end
    end

    task.wait(0.3)
    TweenService:Create(Intro, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
end)

local function uiparent()
    local success, parent = pcall(function()
        return gethui()
    end)

    if not success then
        return game:GetService("CoreGui")
    end

    return parent
end

local success, err = pcall(function()
    Arceus.Parent = uiparent()
end)

if not success then
    Arceus.Parent = game:GetService("Players").LocalPlayer.PlayerGui
end

local element_height = 50*Menu.AbsoluteSize.Y/210
local elements = 0

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

    newBut.MouseButton1Click:Connect(function()
        funct(unpack(args))
    end)

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
        for _, elem in ipairs(elems) do
            elem.Visible = enabled
        end
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
    newCombo.Parent = Menu
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

local aimOffsetYaw = 0
local aimOffsetPitch = 0

local naSmoothness = 0.75
local naFlickForce = 0.15
local naZoneAngle = 60

local showZone = false
local zoneGui = nil

function lookAt(target, eye, yawOff, pitchOff)
    local baseCF = CFrame.new(target, eye)
    local yawRad = math.rad(yawOff or 0)
    local pitchRad = math.rad(pitchOff or 0)
    workspace.CurrentCamera.CFrame = baseCF * CFrame.Angles(pitchRad, yawRad, 0)
end

function lookAtSmooth(target, eye, alpha, yawOff, pitchOff)
    local currentCFrame = workspace.CurrentCamera.CFrame
    local baseCF = CFrame.new(target, eye)
    local yawRad = math.rad(yawOff or 0)
    local pitchRad = math.rad(pitchOff or 0)
    local targetCFrame = baseCF * CFrame.Angles(pitchRad, yawRad, 0)
    workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, alpha)
end

function getAngleToTarget(aimobj)
    local camera = workspace.CurrentCamera
    local cameraPos = camera.CFrame.Position
    local cameraLook = camera.CFrame.LookVector
    local directionToTarget = (aimobj.Position - cameraPos).Unit
    local dot = cameraLook:Dot(directionToTarget)
    local angle = math.deg(math.acos(math.clamp(dot, -1, 1)))
    return angle
end

function isVisible(part)
    if not wallcheck then return true end

    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (origin - part.Position).Magnitude
    local ray = Ray.new(origin, direction)

    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {camera, plrsService.LocalPlayer.Character})

    if hit and hit:IsDescendantOf(part.Parent) then
        return true
    end

    return false
end

function isFriend(player)
    local localPlayer = plrsService.LocalPlayer
    local success, isFriend = pcall(function()
        return player:IsFriendsWith(localPlayer.UserId)
    end)
    return success and isFriend
end

function getClosestPlayerToCursor(trg_part)
    local nearest = nil
    local last = math.huge
    local localPlayer = plrsService.LocalPlayer
    local myPos = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position

    for i, v in ipairs(plrsService:GetPlayers()) do
        if v ~= localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid") and localPlayer.Character:FindFirstChildWhichIsA("Humanoid").Health > 0
            and v.Character and v.Character:FindFirstChildWhichIsA("Humanoid") and v.Character:FindFirstChildWhichIsA("Humanoid").Health > 0
        then
            local allowed = not teamcheck
            if teamcheck and v.Team ~= localPlayer.Team then
                allowed = true
            end

            if nonfriends and isFriend(v) then
                allowed = false
            end

            if allowed then
                local aimobj = v.Character:FindFirstChild(trg_part) or v.Character:FindFirstChild("UpperTorso")
                if aimobj then
                    if localPlayer.Character:FindFirstChild("Head") then
                        local distanceToPlayer = myPos and (aimobj.Position - myPos).Magnitude or 0
                        if distanceToPlayer <= detectRange then
                            local ePos, vissss = workspace.CurrentCamera:WorldToViewportPoint(aimobj.Position)
                            local AccPos = Vector2.new(ePos.x, ePos.y)
                            local mousePos = Vector2.new(workspace.CurrentCamera.ViewportSize.x / 2, workspace.CurrentCamera.ViewportSize.y / 2)
                            local distance = (AccPos - mousePos).magnitude

                            local visibleThroughWalls = true
                            if wallcheck then
                                visibleThroughWalls = isVisible(aimobj)
                            end

                            if distance < last and vissss and distance < 400 and visibleThroughWalls then
                                last = distance
                                nearest = v
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
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

local function addOffsetComboBox(text, initialValue, onChange)
    local newCombo = ComboBox:Clone()
    local isOpen = false
    local currentValue = initialValue or 0
    local elems = {}

    local function updateText()
        local percent = math.floor((currentValue / 45) * 100)
        newCombo:WaitForChild("Name").Text = string.format("%s: %.1f° (%d%%)", text, currentValue, percent)
    end

    local function setBoxState()
        newCombo:WaitForChild("Img").Rotation = isOpen and 0 or 180
        for _, elem in ipairs(elems) do
            elem.Visible = isOpen
        end
    end

    newCombo.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        setBoxState()
    end)

    updateText()
    newCombo.Size = UDim2.new(0.95, 0, 0, element_height)
    newCombo.Name = text
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true

    elements += 1
    addSpace(Menu)

    local buttons = {
        {label = "-5°",   value = -5},
        {label = "-2.5°", value = -2.5},
        {label = "-1°",   value = -1},
        {label = "+1°",   value = 1},
        {label = "+2.5°", value = 2.5},
        {label = "+5°",   value = 5},
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

local function addNAComboBox()
    local newCombo = ComboBox:Clone()
    local isOpen = false
    local elems = {}

    local function setBoxState()
        newCombo:WaitForChild("Img").Rotation = isOpen and 0 or 180
        for _, elem in ipairs(elems) do
            elem.Visible = isOpen
        end
    end

    local function updateText()
        newCombo:WaitForChild("Name").Text = string.format("NA: Speed %d%% | Force %d%% | Zone %d°", math.floor(naSmoothness * 100), math.floor((1 - naFlickForce) * 100), naZoneAngle)
    end

    newCombo.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        setBoxState()
    end)

    updateText()
    newCombo.Size = UDim2.new(0.95, 0, 0, element_height)
    newCombo.Name = "NotAggressiveSettings"
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true

    elements += 1
    addSpace(Menu)

    local speedButtons = {
        {label = "Speed -10%", value = -0.1},
        {label = "Speed -5%",  value = -0.05},
        {label = "Speed +5%",  value = 0.05},
        {label = "Speed +10%", value = 0.1},
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
        {label = "Tactility -10%", value = 0.1},
        {label = "Tactility -5%",  value = 0.05},
        {label = "Tactility +5%",  value = -0.05},
        {label = "Tactility +10%", value = -0.1},
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
        {label = "Zone -5°",   value = -5},
        {label = "Zone -2.5°", value = -2.5},
        {label = "Zone -1°",   value = -1},
        {label = "Zone +1°",   value = 1},
        {label = "Zone +2.5°", value = 2.5},
        {label = "Zone +5°",   value = 5},
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
        if num and num > 0 then
            onChange(num)
        else
            newBox.Text = tostring(initialText)
        end
    end)

    elements += 1
    addSpace(Menu)

    return newBox
end

local toggleBtn
toggleBtn = addToggle("Toggle aimbot", function(state)
    enabled = state
end, false)

local toggleTeamCheckBtn
toggleTeamCheckBtn = addToggle("Team check", function(state)
    teamcheck = state
end, false)

local toggleWallCheckBtn
toggleWallCheckBtn = addToggle("Wall check", function(state)
    wallcheck = state
end, false)

local toggleNonFriendsBtn
toggleNonFriendsBtn = addToggle("Non Friends", function(state)
    nonfriends = state
end, false)

local toggleNotAggressiveBtn
toggleNotAggressiveBtn = addToggle("Not Aggressive Mode", function(state)
    notAggressive = state
end, false)

local aimPartCombo
aimPartCombo = addComboBox("Aim part", {"Head", "Torso"}, function(selection)
    aimpart = selection
end)

addTextBox("Detection Range (studs)", "500", function(v) detectRange = v end)

addOffsetComboBox("Yaw Offset", 0, function(v) aimOffsetYaw = v end)
addOffsetComboBox("Pitch Offset", 0, function(v) aimOffsetPitch = v end)

addNAComboBox()

local toggleZoneBtn
toggleZoneBtn = addToggle("Show Zone", function(state)
    showZone = state
    if showZone then
        if not zoneGui then createZoneGUI() end
        if zoneGui then zoneGui.Enabled = true end
        updateZoneGUI()
    else
        if zoneGui then zoneGui.Enabled = false end
    end
end, false)

runService.RenderStepped:Connect(function()
    if showZone then
        updateZoneGUI()
    end
    
    local closest = getClosestPlayerToCursor(aimpart)
    if enabled and closest then
        local aimobj = closest.Character:FindFirstChild(aimpart) or closest.Character:FindFirstChild("UpperTorso")
        if aimobj then
            if notAggressive then
                local angle = getAngleToTarget(aimobj)
                if angle <= naZoneAngle then
                    lookAtSmooth(workspace.CurrentCamera.CFrame.p, aimobj.Position, naSmoothness, aimOffsetYaw, aimOffsetPitch)
                end
            else
                lookAt(workspace.CurrentCamera.CFrame.p, aimobj.Position, aimOffsetYaw, aimOffsetPitch)
            end
        end
    end
end)

-- INIT

Main:TweenPosition(
    UDim2.fromScale(0.5, 0.5),
    Enum.EasingDirection.In,
    Enum.EasingStyle.Quad,
    1, true, nil
)

task.wait(1.5)
Logo:TweenSizeAndPosition(
    UDim2.fromScale(0.175, 0.175),
    UDim2.fromScale(0.075, 0.15),
    Enum.EasingDirection.In,
    Enum.EasingStyle.Quad,
    1, true, nil
)

task.wait(1.5)
TweenService:Create(Intro, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()