--// Client Bring v3.3
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local bringActive = false
local connection = nil
local processedPlayers = {}
local mode = 0
local currentInput = ""

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClientBringGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui

local dragDetector = Instance.new("UIDragDetector", frame)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Client Bring"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, 30)
inputBox.Position = UDim2.new(0.05, 0, 0, 40)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.Text = ""
inputBox.PlaceholderText = "nickname, all, nonfriends"
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 80)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Bring Players: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.9, 0, 0, 35)
modeBtn.Position = UDim2.new(0.05, 0, 0, 125)
modeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
modeBtn.Text = "Mode: Front"
modeBtn.TextColor3 = Color3.new(1, 1, 1)
modeBtn.Parent = frame

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 6)
modeCorner.Parent = modeBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 170)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Waiting..."
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = frame

local function getRoot(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
end

local function disableCollision(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.CanCollide = false
                part.Massless = true
            end)
        end
    end
end

local function getPlayers(input)
    local players = {}
    input = string.lower(input or "")
    
    if input == "all" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                table.insert(players, player)
            end
        end
    elseif input == "nonfriends" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local success, isFriend = pcall(function()
                    return player:IsFriendsWith(localPlayer.UserId)
                end)
                if not (success and isFriend) then
                    table.insert(players, player)
                end
            end
        end
    else
        local searchTerms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = string.match(term, "^%s*(.-)%s*$")
            if term ~= "" then
                table.insert(searchTerms, term)
            end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local playerName = string.lower(player.Name)
                local displayName = player.DisplayName and string.lower(player.DisplayName) or ""
                
                for _, term in ipairs(searchTerms) do
                    if string.find(playerName, term) or string.find(displayName, term) then
                        table.insert(players, player)
                        break
                    end
                end
            end
        end
    end
    
    return players
end

local function updateStatus()
    local activeCount = 0
    for player, _ in pairs(processedPlayers) do
        if player and player.Character and player.Character.Parent ~= nil then
            activeCount = activeCount + 1
        end
    end
    statusLabel.Text = "Status: Bringing "..activeCount.." players"
end

local function addPlayerToProcessed(player)
    if not player or player == localPlayer then return end
    
    local matchesFilter = false
    local input = string.lower(currentInput)
    
    if input == "all" then
        matchesFilter = true
    elseif input == "nonfriends" then
        local success, isFriend = pcall(function()
            return player:IsFriendsWith(localPlayer.UserId)
        end)
        matchesFilter = not (success and isFriend)
    else
        local searchTerms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = string.match(term, "^%s*(.-)%s*$")
            if term ~= "" then
                table.insert(searchTerms, term)
            end
        end
        
        local playerName = string.lower(player.Name)
        local displayName = player.DisplayName and string.lower(player.DisplayName) or ""
        
        for _, term in ipairs(searchTerms) do
            if string.find(playerName, term) or string.find(displayName, term) then
                matchesFilter = true
                break
            end
        end
    end
    
    if matchesFilter then
        processedPlayers[player] = true
        if player.Character then
            disableCollision(player.Character)
        end
        player.CharacterAdded:Connect(function(character)
            if character then
                disableCollision(character)
            end
        end)
        updateStatus()
    end
end

local function bringPlayers()
    if not localPlayer or not localPlayer.Character then return end
    
    local localRoot = getRoot(localPlayer.Character)
    if not localRoot then return end
    
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera and camera.CFrame or localRoot.CFrame
    
    for player, _ in pairs(processedPlayers) do
        if player and player.Character and player.Character.Parent ~= nil then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local root = getRoot(player.Character)
            
            if humanoid and root then
                pcall(function()
                    humanoid.Sit = false
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
                
                local targetPos, lookAtPos
                
                if mode == 1 then
                    local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
                        if handle then
                            targetPos = handle.Position + Vector3.new(0, 1, 0)
                            lookAtPos = handle.Position + Vector3.new(0, 1, 1)
                        end
                    end
                else
                    local offset = mode == 2 and 1.7 or 3
                    local rightOffset = mode == 2 and 1.5 or 0
                    local heightOffset = 2
                    
                    targetPos = localRoot.Position + 
                                (cameraCFrame.LookVector * offset) + 
                                (cameraCFrame.RightVector * rightOffset) + 
                                Vector3.new(0, heightOffset, 0)
                    
                    lookAtPos = targetPos + cameraCFrame.LookVector
                end
                
                if targetPos and lookAtPos then
                    pcall(function()
                        root.Velocity = Vector3.new()
                        root.CFrame = CFrame.new(targetPos, lookAtPos)
                    end)
                end
            end
        end
    end
    
    updateStatus()
end

local function cycleMode()
    mode = (mode + 1) % 3
    
    if mode == 0 then
        modeBtn.Text = "Mode: Front"
        modeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    elseif mode == 1 then
        modeBtn.Text = "Mode: Tool"
        modeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    else
        modeBtn.Text = "Mode: Right"
        modeBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
    end
end

local function toggleBring()
    bringActive = not bringActive
    
    if bringActive then
        currentInput = string.lower(inputBox.Text)
        local players = getPlayers(currentInput)
        
        if #players == 0 then
            statusLabel.Text = "Status: No players found!"
            bringActive = false
            return
        end
        
        processedPlayers = {}
        for _, player in ipairs(players) do
            addPlayerToProcessed(player)
        end
        
        toggleBtn.Text = "Bring Players: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        
        connection = RunService.Heartbeat:Connect(function()
            if bringActive then
                pcall(bringPlayers)
            end
        end)
    else
        toggleBtn.Text = "Bring Players: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        statusLabel.Text = "Status: Stopped"
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        processedPlayers = {}
    end
end

Players.PlayerAdded:Connect(function(player)
    if bringActive then
        addPlayerToProcessed(player)
    end
end)

toggleBtn.MouseButton1Click:Connect(toggleBring)
modeBtn.MouseButton1Click:Connect(cycleMode)

game:BindToClose(function()
    if connection then connection:Disconnect() end
end)