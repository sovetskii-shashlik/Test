local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local autoAttackActive = false
local attackConnection = nil
local attackDistance = 15

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoAttackGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
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

local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(0.9, 0, 0, 30)
inputContainer.Position = UDim2.new(0.05, 0, 0, 40)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = mainFrame

local distanceInput = Instance.new("TextBox")
distanceInput.Size = UDim2.new(0, 185, 1, 0)
distanceInput.Position = UDim2.new(0, 0, 0, 0)
distanceInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
distanceInput.Text = tostring(attackDistance)
distanceInput.PlaceholderText = "Distance"
distanceInput.TextColor3 = Color3.new(1, 1, 1)
distanceInput.ClearTextOnFocus = false
distanceInput.Parent = inputContainer
distanceInput.TextScaled = false
distanceInput.TextSize = 14
distanceInput.Font = Enum.Font.Code

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = distanceInput

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 1, 0)
toggleButton.Position = UDim2.new(1, -30, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.Parent = inputContainer

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 0, 75)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "by prespeshnikShashlika"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.Parent = mainFrame

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

local function findClosestEnemy()
    local closestPlayer = nil
    local closestDistance = attackDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local enemyHumanoid = player.Character.Humanoid
            local enemyRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local playerRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if enemyHumanoid.Health > 0 and enemyRootPart and playerRootPart then
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