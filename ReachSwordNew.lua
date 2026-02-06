local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local autoAttackActive = false
local attackConnection = nil
local attackDistance = 15
local attackMode = "all"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoAttackGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Distance Attack"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.Parent = mainFrame

local textGradient = Instance.new("UIGradient", titleLabel)
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

local distanceContainer = Instance.new("Frame")
distanceContainer.Size = UDim2.new(0.75, 0, 0,30)
distanceContainer.Position = UDim2.new(0.05, 0, 0, 40)
distanceContainer.BackgroundTransparency = 1
distanceContainer.Parent = mainFrame

local distanceInput = Instance.new("TextBox")
distanceInput.Size = UDim2.new(1, 0, 1, 0)
distanceInput.Position = UDim2.new(0, 0, 0, 0)
distanceInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
distanceInput.Text = tostring(attackDistance)
distanceInput.PlaceholderText = "Distance"
distanceInput.TextColor3 = Color3.new(1, 1, 1)
distanceInput.ClearTextOnFocus = false
distanceInput.Parent = distanceContainer
distanceInput.TextScaled = false
distanceInput.TextSize = 14
distanceInput.Font = Enum.Font.Code

local distanceInputCorner = Instance.new("UICorner")
distanceInputCorner.CornerRadius = UDim.new(0, 6)
distanceInputCorner.Parent = distanceInput

local modeSelector = Instance.new("TextButton")
modeSelector.Size = UDim2.new(0.9, 0, 0, 30)
modeSelector.Position = UDim2.new(0.05, 0, 0, 75)
modeSelector.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
modeSelector.Text = "Mode: all"
modeSelector.TextColor3 = Color3.new(1, 1, 1)
modeSelector.Font = Enum.Font.Code
modeSelector.TextSize = 14
modeSelector.Parent = mainFrame

local modeSelectorCorner = Instance.new("UICorner")
modeSelectorCorner.CornerRadius = UDim.new(0, 6)
modeSelectorCorner.Parent = modeSelector

local modeDropdown = Instance.new("Frame")
modeDropdown.Size = UDim2.new(0.9, 0, 0, 120)
modeDropdown.Position = UDim2.new(0.05, 0, 0, 105)
modeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
modeDropdown.BorderSizePixel = 0
modeDropdown.Visible = false
modeDropdown.Parent = mainFrame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = modeDropdown

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.Padding = UDim.new(0, 2)
dropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dropdownLayout.Parent = modeDropdown

local modeAll = Instance.new("TextButton")
modeAll.Size = UDim2.new(0.95, 0, 0, 28)
modeAll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
modeAll.Text = "All"
modeAll.TextColor3 = Color3.new(1, 1, 1)
modeAll.Font = Enum.Font.Code
modeAll.TextSize = 14
modeAll.Parent = modeDropdown

local modeNonFriends = Instance.new("TextButton")
modeNonFriends.Size = UDim2.new(0.95, 0, 0, 28)
modeNonFriends.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
modeNonFriends.Text = "Non-Friends"
modeNonFriends.TextColor3 = Color3.new(1, 1, 1)
modeNonFriends.Font = Enum.Font.Code
modeNonFriends.TextSize = 14
modeNonFriends.Parent = modeDropdown

local modeNonTeam = Instance.new("TextButton")
modeNonTeam.Size = UDim2.new(0.95, 0, 0, 28)
modeNonTeam.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
modeNonTeam.Text = "Non-Team"
modeNonTeam.TextColor3 = Color3.new(1, 1, 1)
modeNonTeam.Font = Enum.Font.Code
modeNonTeam.TextSize = 14
modeNonTeam.Parent = modeDropdown

local modeNonFriendsTeam = Instance.new("TextButton")
modeNonFriendsTeam.Size = UDim2.new(0.95, 0, 0, 28)
modeNonFriendsTeam.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
modeNonFriendsTeam.Text = "Non-Friends & Team"
modeNonFriendsTeam.TextColor3 = Color3.new(1, 1, 1)
modeNonFriendsTeam.Font = Enum.Font.Code
modeNonFriendsTeam.TextSize = 14
modeNonFriendsTeam.Parent = modeDropdown

local function updateButtonColors()
    modeAll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    modeNonFriends.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    modeNonTeam.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    modeNonFriendsTeam.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    if attackMode == "all" then
        modeAll.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    elseif attackMode == "nonfriends" then
        modeNonFriends.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    elseif attackMode == "nonteam" then
        modeNonTeam.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    elseif attackMode == "nonfriendsteam" then
        modeNonFriendsTeam.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    end
end

modeAll.MouseButton1Click:Connect(function()
    attackMode = "all"
    modeSelector.Text = "Mode: all"
    modeDropdown.Visible = false
    updateButtonColors()
end)

modeNonFriends.MouseButton1Click:Connect(function()
    attackMode = "nonfriends"
    modeSelector.Text = "Mode: nonfriends"
    modeDropdown.Visible = false
    updateButtonColors()
end)

modeNonTeam.MouseButton1Click:Connect(function()
    attackMode = "nonteam"
    modeSelector.Text = "Mode: nonteam"
    modeDropdown.Visible = false
    updateButtonColors()
end)

modeNonFriendsTeam.MouseButton1Click:Connect(function()
    attackMode = "nonfriendsteam"
    modeSelector.Text = "Mode: nonfriendsteam"
    modeDropdown.Visible = false
    updateButtonColors()
end)

modeSelector.MouseButton1Click:Connect(function()
    modeDropdown.Visible = not modeDropdown.Visible
end)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(0.95, -30, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

local borderFrame = Instance.new("Frame")
borderFrame.Size = mainFrame.Size
borderFrame.Position = mainFrame.Position
borderFrame.BackgroundTransparency = 1
borderFrame.AnchorPoint = mainFrame.AnchorPoint
borderFrame.ZIndex = mainFrame.ZIndex - 1
borderFrame.Parent = screenGui

local borderCorner = mainFrame.UICorner:Clone()
borderCorner.Parent = borderFrame

local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 3
borderStroke.LineJoinMode = Enum.LineJoinMode.Round
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
borderStroke.Parent = borderFrame

mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    borderFrame.Position = mainFrame.Position
end)

mainFrame:GetPropertyChangedSignal("Size"):Connect(function()
    borderFrame.Size = mainFrame.Size
end)

mainFrame.UICorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    borderCorner.CornerRadius = mainFrame.UICorner.CornerRadius
end)

local function isValidTarget(player)
    if player == localPlayer then return false end
    if not player.Character then return false end
    if not player.Character:FindFirstChild("Humanoid") then return false end
    if player.Character.Humanoid.Health <= 0 then return false end
    
    local playerRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not playerRootPart then return false end
    
    if attackMode == "all" then
        return true
    elseif attackMode == "nonfriends" then
        return not localPlayer:IsFriendsWith(player.UserId)
    elseif attackMode == "nonteam" then
        if not localPlayer.Team then return true end
        return localPlayer.Team ~= player.Team
    elseif attackMode == "nonfriendsteam" then
        local isFriend = localPlayer:IsFriendsWith(player.UserId)
        if isFriend then return false end
        
        if not localPlayer.Team then return true end
        return localPlayer.Team ~= player.Team
    end
    
    return false
end

local function findClosestEnemy()
    local closestPlayer = nil
    local closestDistance = attackDistance

    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local enemyRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local playerRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if enemyRootPart and playerRootPart then
                local distance = (enemyRootPart.Position - playerRootPart.Position).Magnitude

                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer, closestDistance
end

local function performAttack()
    if not localPlayer.Character then return end

    local character = localPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end

    local closestEnemy, enemyDistance = findClosestEnemy()

    if closestEnemy and closestEnemy.Character then
        local enemyRootPart = closestEnemy.Character:FindFirstChild("HumanoidRootPart")
        if enemyRootPart then
            humanoidRootPart.CFrame = CFrame.new(
                humanoidRootPart.Position,
                Vector3.new(enemyRootPart.Position.X, humanoidRootPart.Position.Y, enemyRootPart.Position.Z)
            )

            local equippedTool = character:FindFirstChildWhichIsA("Tool")
            if equippedTool then
                equippedTool:Activate()
                if equippedTool.Handle then
                    equippedTool.Handle.Position = enemyRootPart.Position
                end
            end

            if localPlayer.Backpack:FindFirstChildOfClass("Tool") and character:FindFirstChildOfClass("Tool") == nil then
                local toolToEquip = localPlayer.Backpack:FindFirstChildOfClass("Tool")
                humanoid:EquipTool(toolToEquip)
            end
        end
    end

    return closestEnemy
end

local function startAutoAttack()
    if attackConnection then
        attackConnection:Disconnect()
    end

    attackConnection = RunService.Heartbeat:Connect(function()
        if autoAttackActive and localPlayer.Character then
            pcall(function()
                performAttack()
            end)
        end
    end)
end

local function stopAutoAttack()
    if attackConnection then
        attackConnection:Disconnect()
        attackConnection = nil
    end
end

local function toggleAutoAttack()
    autoAttackActive = not autoAttackActive

    if autoAttackActive then
        local newDistance = tonumber(distanceInput.Text)
        if newDistance and newDistance > 0 then
            attackDistance = newDistance
        else
            distanceInput.Text = tostring(attackDistance)
        end

        startAutoAttack()
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    else
        stopAutoAttack()
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

distanceInput:GetPropertyChangedSignal("Text"):Connect(function()
    if autoAttackActive then
        local newDistance = tonumber(distanceInput.Text)
        if newDistance and newDistance > 0 then
            attackDistance = newDistance
        end
    end
end)

localPlayer.CharacterAdded:Connect(function(character)
    if autoAttackActive then
        task.wait(1)
        startAutoAttack()
    end
end)

toggleButton.MouseButton1Click:Connect(toggleAutoAttack)

updateButtonColors()