if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local settings = {
    Enabled = false,
    ShowNames = false,
    ShowOutline = false,
    ShowFill = false,
    ShowLines = false,
    TeamColor = false,
    Font = 2,
    PartsEnabled = false
}

local partEspConnections = {}

local function isPlayerCharacter(character)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == character then
            return player ~= Player
        end
    end
    return false
end

local function addEspToPart(part, player)
    if not part:FindFirstChild(part.Name.."_PESP") then
        local a = Instance.new("BoxHandleAdornment")
        a.Name = part.Name.."_PESP"
        a.Parent = part
        a.Adornee = part
        a.AlwaysOnTop = true
        a.ZIndex = 0
        a.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
        a.Transparency = 0.3
        a.Color3 = Color3.fromRGB(0, 255, 0)
    end
end

local function setupPlayerParts(player)
    if player == Player then return end
    
    local function handleCharacter(character)
        if not isPlayerCharacter(character) then return end
        
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BoxHandleAdornment") and part.Name:find("_PESP") then
                part:Destroy()
            end
        end
        
        if settings.PartsEnabled then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    addEspToPart(part, player)
                end
            end
        end
        
        local conn = character.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") and settings.PartsEnabled then
                addEspToPart(part, player)
            end
        end)
        
        table.insert(partEspConnections, conn)
    end
    
    if player.Character then
        handleCharacter(player.Character)
    end
    
    local conn = player.CharacterAdded:Connect(handleCharacter)
    table.insert(partEspConnections, conn)
end

local function clearPartEsp()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BoxHandleAdornment") and part.Name:find("_PESP") then
            part:Destroy()
        end
    end
    
    for _, conn in ipairs(partEspConnections) do
        conn:Disconnect()
    end
    partEspConnections = {}
end

local function updatePartEsp()
    if settings.PartsEnabled then
        clearPartEsp()
        
        for _, player in ipairs(Players:GetPlayers()) do
            setupPlayerParts(player)
        end
        
        local conn = Players.PlayerAdded:Connect(setupPlayerParts)
        table.insert(partEspConnections, conn)
    else
        clearPartEsp()
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "ESPConfig"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 280)
frame.Position = UDim2.new(0.5, 0, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local dragHandle = Instance.new("TextLabel")
dragHandle.Size = UDim2.new(1, 0, 0, 20)
dragHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dragHandle.Text = "ESP Settings"
dragHandle.TextColor3 = Color3.new(1, 1, 1)
dragHandle.Font = Enum.Font.Gotham
dragHandle.TextSize = 12
dragHandle.Parent = frame

local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(1, -10, 0, 30)
instructions.Position = UDim2.new(0, 5, 1, -35)
instructions.BackgroundTransparency = 1
instructions.Text = "Press K to toggle\nDrag top bar to move"
instructions.TextColor3 = Color3.new(0.8, 0.8, 0.8)
instructions.Font = Enum.Font.Gotham
instructions.TextSize = 12
instructions.TextWrapped = true
instructions.Parent = frame

local function CreateToggle(text, ypos, flag)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.Position = UDim2.new(0, 0, 0, ypos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = frame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 120, 0, 25)
    toggleButton.Position = UDim2.new(0, 10, 0, 2)
    toggleButton.Text = text
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 14
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame

    local stateIndicator = Instance.new("Frame")
    stateIndicator.Size = UDim2.new(0, 20, 0, 20)
    stateIndicator.Position = UDim2.new(1, -30, 0, 5)
    stateIndicator.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    stateIndicator.BorderSizePixel = 0
    stateIndicator.Parent = toggleFrame

    toggleButton.MouseButton1Click:Connect(function()
        settings[flag] = not settings[flag]
        stateIndicator.BackgroundColor3 = settings[flag] and Color3.new(0, 1, 0) or Color3.new(0.2, 0.2, 0.2)
        
        if flag == "PartsEnabled" then
            updatePartEsp()
        else
            UpdateAllESP()
        end
    end)
    
    stateIndicator.BackgroundColor3 = settings[flag] and Color3.new(0, 1, 0) or Color3.new(0.2, 0.2, 0.2)
end

CreateToggle("Enable ESP", 25, "Enabled")
CreateToggle("Show Names", 55, "ShowNames")
CreateToggle("Show Outline", 85, "ShowOutline")
CreateToggle("Show Fill", 115, "ShowFill")
CreateToggle("Show Lines", 145, "ShowLines")
CreateToggle("Team Colors", 175, "TeamColor")
CreateToggle("ESP Parts", 205, "PartsEnabled")

local ESPCache = {}

local function CreateESP(player)
    if ESPCache[player] then 
        if ESPCache[player].Connection then
            ESPCache[player].Connection:Disconnect()
        end
        if ESPCache[player].CharacterConnection then
            ESPCache[player].CharacterConnection:Disconnect()
        end
    else
        ESPCache[player] = {
            Highlight = Instance.new("Highlight"),
            NameLabel = Drawing.new("Text"),
            Line = Drawing.new("Line"),
            Connection = nil,
            CharacterConnection = nil
        }
    end
    
    local esp = ESPCache[player]
    
    esp.Highlight.FillTransparency = 1
    esp.Highlight.OutlineTransparency = 1
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    esp.NameLabel.Visible = false
    esp.NameLabel.Center = true
    esp.NameLabel.Outline = true
    esp.NameLabel.Font = settings.Font
    
    esp.Line.Visible = false
    esp.Line.Thickness = 1
    
    local function setupCharacter(character)
        if esp.Highlight and esp.Highlight.Parent then
            esp.Highlight.Parent = nil
        end
        
        esp.Highlight.Parent = character
        
        if esp.Connection then
            esp.Connection:Disconnect()
        end
        
        esp.Connection = RunService.RenderStepped:Connect(function()
            if not character or not character.Parent then return end
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                local headPos, headOnScreen = Camera:WorldToScreenPoint(character.Head.Position)
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                esp.Highlight.Enabled = settings.Enabled
                esp.Highlight.FillTransparency = settings.ShowFill and 0.5 or 1
                esp.Highlight.OutlineTransparency = settings.ShowOutline and 0 or 1
                
                local color = settings.TeamColor and player.TeamColor.Color or Color3.fromHSV(
                    math.clamp((rootPart.Position - Camera.CFrame.Position).Magnitude / 500, 0, 1),
                    0.75,
                    1
                )
                esp.Highlight.FillColor = color
                esp.Highlight.OutlineColor = color
                
                esp.NameLabel.Visible = settings.Enabled and settings.ShowNames and headOnScreen
                if esp.NameLabel.Visible then
                    esp.NameLabel.Position = Vector2.new(headPos.X, headPos.Y + 30)
                    esp.NameLabel.Text = player.Name
                    esp.NameLabel.Color = color
                    esp.NameLabel.Size = 18
                end
                
                local lineVisible = settings.Enabled and settings.ShowLines and rootPos.Z > 0
                esp.Line.Visible = lineVisible
                if lineVisible then
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.Line.To = Vector2.new(rootPos.X, rootPos.Y)
                    esp.Line.Color = color
                else
                    esp.Line.Visible = false
                end
            end
        end)
    end
    
    if player.Character then
        setupCharacter(player.Character)
    end
    
    esp.CharacterConnection = player.CharacterAdded:Connect(function(character)
        setupCharacter(character)
    end)
end

function UpdateAllESP()
    for player, esp in pairs(ESPCache) do
        if esp.Highlight then
            esp.Highlight.Enabled = settings.Enabled
            esp.Highlight.FillTransparency = settings.ShowFill and 0.5 or 1
            esp.Highlight.OutlineTransparency = settings.ShowOutline and 0 or 1
        end
        if esp.NameLabel then
            esp.NameLabel.Visible = settings.Enabled and settings.ShowNames
        end
        if esp.Line then
            esp.Line.Visible = settings.Enabled and settings.ShowLines
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        CreateESP(player)
        if settings.PartsEnabled then
            setupPlayerParts(player)
        end
    end)
    if player.Character then
        CreateESP(player)
        if settings.PartsEnabled then
            setupPlayerParts(player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPCache[player] then
        if ESPCache[player].Connection then
            ESPCache[player].Connection:Disconnect()
        end
        if ESPCache[player].CharacterConnection then
            ESPCache[player].CharacterConnection:Disconnect()
        end
        if ESPCache[player].Highlight then
            ESPCache[player].Highlight:Destroy()
        end
        if ESPCache[player].NameLabel then
            ESPCache[player].NameLabel:Remove()
        end
        if ESPCache[player].Line then
            ESPCache[player].Line:Remove()
        end
        ESPCache[player] = nil
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Player then
        CreateESP(player)
        if settings.PartsEnabled then
            setupPlayerParts(player)
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        frame.Visible = not frame.Visible
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ESP",
    Text = "script by holodilnik_scripts",
    Duration = 15
})