if getgenv().UAFlingLoaded then
    return nil
else
    getgenv().UAFlingLoaded = true
end

-- Создаем все элементы интерфейса
local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Box = Instance.new("TextBox")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Label = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Button = Instance.new("TextButton")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local UIStroke = Instance.new("UIStroke")

-- Настройка GUI
Gui.Name = "UAFling"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Настройка главного фрейма
Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.35, 0, 0.35, 0)
Main.Size = UDim2.new(0.18, 0, 0.15, 0)
Main.Active = true
Main.Draggable = true

-- Add "Bring Parts" title label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = Main
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0.02, 0)
TitleLabel.Size = UDim2.new(1, 0, 0.2, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "BRING PARTS"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextScaled = true
TitleLabel.TextSize = 8
TitleLabel.TextWrapped = true

-- Закругление для Main (отдельный экземпляр)
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- Обводка
UIStroke.Parent = Main
UIStroke.Color = Color3.fromRGB(70, 70, 70)
UIStroke.Thickness = 1

-- Настройка текстового поля
Box.Name = "Box"
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Box.BorderSizePixel = 0
Box.Position = UDim2.new(0.1, 0, 0.25, 0)
Box.Size = UDim2.new(0.8, 0, 0.25, 0)
Box.FontFace = Font.new("rbxasset://fonts/families/SourceSansSemibold.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Box.PlaceholderText = "Enter player name..."
Box.Text = ""
Box.TextColor3 = Color3.fromRGB(235, 235, 235)
Box.TextScaled = true
Box.TextWrapped = true
UITextSizeConstraint.Parent = Box
UITextSizeConstraint.MaxTextSize = 18

-- Закругление для Box (отдельный экземпляр)
local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = Box

-- Настройка кнопки
Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.1, 0, 0.55, 0)
Button.Size = UDim2.new(0.8, 0, 0.3, 0)
Button.Font = Enum.Font.Nunito
Button.Text = "Unanchor Fling | Off"
Button.TextColor3 = Color3.fromRGB(240, 240, 240)
Button.TextScaled = true
Button.TextWrapped = true
UITextSizeConstraint_3.Parent = Button
UITextSizeConstraint_3.MaxTextSize = 26

-- Закругление для Button (отдельный экземпляр)
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = Button

-- Полный исходный код функционала (без изменений)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local character
local humanoidRootPart
local mainStatus = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
        mainStatus = not mainStatus
        Main.Visible = mainStatus
    end
end)

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }
    
    Network.RetainPart = function(Part)
        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end
    
    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end
    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        if v:IsDescendantOf(LocalPlayer.Character) then
            return
        end
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local blackHoleActive = false
local DescendantAddedConnection

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        Button.Text = "Unanchor fling | On"
        for _, v in ipairs(Workspace:GetDescendants()) do
            ForcePart(v)
        end

        DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then
                ForcePart(v)
            end
        end)
        task.spawn(function()
            while blackHoleActive and RunService.RenderStepped:Wait() do
                if humanoidRootPart then
                    Attachment1.WorldCFrame = humanoidRootPart.CFrame
                end
            end
        end)
    else
        Button.Text = "Unanchor fling | Off"
        if DescendantAddedConnection then
            DescendantAddedConnection:Disconnect()
        end
    end
end

local function getPlayer(name)
    local lowerName = string.lower(name)
    local bestMatch = nil
    local bestMatchLength = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        local playerName = string.lower(p.Name)
        local lowerDisplayName = string.lower(p.DisplayName)

        if string.sub(playerName, 1, #lowerName) == lowerName or string.sub(lowerDisplayName, 1, #lowerName) == lowerName then
            local matchLength = math.min(#lowerName, #playerName)
            if matchLength < bestMatchLength then
                bestMatch = p
                bestMatchLength = matchLength
            end
        end
    end

    return bestMatch
end

local function onButtonClicked()
    local playerName = Box.Text
    if playerName ~= "" then
        local targetPlayer = getPlayer(playerName)
        if targetPlayer then
            Box.Text = targetPlayer.Name
            local function applyBallFling(targetCharacter)
                humanoidRootPart = targetCharacter:WaitForChild("HumanoidRootPart")
                toggleBlackHole()
            end
            local targetCharacter = targetPlayer.Character
            if targetCharacter then
                applyBallFling(targetCharacter)
            else
                Box.Text = "Player not found"
            end

            targetPlayer.CharacterAdded:Connect(function(newCharacter)
                applyBallFling(newCharacter)
            end)
        else
            Box.Text = "Player not found"
        end
    end
end

Button.MouseButton1Click:Connect(onButtonClicked)

return Gui