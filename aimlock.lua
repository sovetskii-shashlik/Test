local localPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://12221967"
sound.Parent = game:GetService("SoundService")
sound:Play()

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(0, 99, 0, 44)
controlPanel.Position = UDim2.new(0, 115, 0, 49)
controlPanel.AnchorPoint = Vector2.new(0.5, 1)
controlPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
controlPanel.BackgroundTransparency = 0.2
controlPanel.Active = true
controlPanel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.8, 0)
corner.Parent = controlPanel

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.Text = "Aim Lock"
toggleButton.BackgroundTransparency = 1
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 10
toggleButton.Parent = controlPanel

local outline = Instance.new("UIStroke")
outline.Thickness = 2
outline.Color = Color3.fromRGB(255, 255, 0)
outline.Enabled = false
outline.Parent = controlPanel

local targetIndicator = Instance.new("Frame")
targetIndicator.Size = UDim2.new(0, 290, 0, 290)
targetIndicator.Position = UDim2.new(0.5, -1, 0.5, -20)
targetIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
targetIndicator.BackgroundTransparency = 1
targetIndicator.Parent = screenGui

local targetOutline = Instance.new("UIStroke")
targetOutline.Thickness = 2
targetOutline.Color = Color3.fromRGB(1, 0, 0)
targetOutline.Parent = targetIndicator

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(1, 0)
targetCorner.Parent = targetIndicator

local aimAssistActive = false
toggleButton.MouseButton1Click:Connect(function()
    aimAssistActive = not aimAssistActive
    outline.Enabled = aimAssistActive
    
    if not aimAssistActive then
        local camera = workspace.CurrentCamera
        if camera then
            camera.CFrame = camera.CFrame
        end
    end
end)

local function isVisible(targetPosition, character)
    local localCharacter = localPlayer.Character
    if not localCharacter then return false end
    
    local rootPart = localCharacter:FindFirstChild("HumanoidRootPart") or localCharacter:FindFirstChild("UpperTorso")
    if not rootPart then return false end
    
    local ray = Ray.new(rootPart.Position, (targetPosition - rootPart.Position).Unit * 1000)
    local hitPart, hitPosition = workspace:FindPartOnRay(ray, localCharacter)
    
    if hitPart then
        return hitPart:IsDescendantOf(character)
    end
    return false
end

local function findBestTarget()
    local bestTarget = nil
    local closestDistance = math.huge
    local localCharacter = localPlayer.Character
    
    if not localCharacter then return nil end
    
    local rootPart = localCharacter:FindFirstChild("HumanoidRootPart") or localCharacter:FindFirstChild("UpperTorso")
    if not rootPart then return nil end
    
    local screenGui = localPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ScreenGui")
    if not screenGui then return nil end
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local targetCenter = targetIndicator.AbsolutePosition + (targetIndicator.AbsoluteSize / 2)
    local targetRadius = targetIndicator.AbsoluteSize.X / 2
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local character = player.Character
            local enemyRoot = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
            
            if enemyRoot then
                local screenPosition, onScreen = camera:WorldToScreenPoint(enemyRoot.Position)
                local distanceFromCenter = (Vector2.new(screenPosition.X, screenPosition.Y) - targetCenter).Magnitude
                
                if onScreen and distanceFromCenter <= targetRadius and distanceFromCenter < closestDistance and isVisible(enemyRoot.Position, character) then
                    closestDistance = distanceFromCenter
                    bestTarget = player
                end
            end
        end
    end
    
    return bestTarget
end

local function handleAimAssist()
    if aimAssistActive then
        local target = findBestTarget()
        
        if target and target.Character then
            local enemyRoot = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("UpperTorso")
            
            if enemyRoot then
                local camera = workspace.CurrentCamera
                if camera then
                    local targetPosition = enemyRoot.Position
                    local cameraPosition = camera.CFrame.Position
                    local targetCFrame = CFrame.new(cameraPosition, targetPosition)
                    camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.3)
                end
            end
        end
    end
end

local aimAssistConnection
aimAssistConnection = RunService.RenderStepped:Connect(function()
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Humanoid") or localPlayer.Character.Humanoid.Health <= 0 then
        return
    end
    
    handleAimAssist()
end)

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Died:Connect(function()
            if aimAssistActive then
                handleAimAssist()
            end
        end)
    end)
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= localPlayer then
        onPlayerAdded(player)
    end
end

localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if aimAssistActive then
            handleAimAssist()
        end
    end)
end)

local isDragging = false
local dragStartPosition = Vector2.new(0, 0)
local dragStartOffset = UDim2.new(0, 0, 0, 0)

controlPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPosition = input.Position
        dragStartOffset = controlPanel.Position
    end
end)

controlPanel.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
        local dragDelta = input.Position - dragStartPosition
        controlPanel.Position = UDim2.new(
            dragStartOffset.X.Scale, 
            dragStartOffset.X.Offset + dragDelta.X, 
            dragStartOffset.Y.Scale, 
            dragStartOffset.Y.Offset + dragDelta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)