--// SCP Games Kill GUI v10.0

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

local WEAPON_LIST = {
    "AK", "AUG", "AssaultRifle", "Bizon", "Canon",
    "Crystal Micro Uzi", "Crystal P90", "Cupcake Gun", 
    "Diamond Micro Uzi", "Diamond P90", "Glock", 
    "Golden AssaultRifle", "Laser Gun", "Laser Minigun", 
    "Light Machine Gun", "M60", "MP5", "Machine Gun", 
    "Machine Gun2", "Micro Uzi", "Minigun", "P90", 
    "Red Gun", "Scar", "Shotgun", "Sniper", 
    "Steampunk Rifle", "TMP", "Weapon2", "Weapon3", "Weapon4", "Weapon5", "Weapon6", "Weapon7", "Weapon8", 
    "Weapon9", "Weird Gun", "Weird Gun 2", "Winter Minigun"
}

local PROTECTED_PLAYERS = {
    "prespeshnikShashlika","nicto3789","nicto3787","BNKA09024",
    "Kittyqueen300914","xixoww_04","gorenionia_nomer2","New_Buildersman",
    "aboba22809228","b00ferkidd","filvod","momona870","tolik_scripter",
    "GetRenq","MHE_HOPM7575","ekdodieiwkjskfkf","anarcho_kommunist2"
}

local ADMIN_PLAYERS = {
    "prespeshnikShashlika","nicto3789","nicto3787",
    "ekdodieiwkjskfkf","anarcho_kommunist2","New_Buildersman"
}

local function lower(s) return string.lower(tostring(s or "")) end
local function inList(name, list)
    local n = lower(name)
    for _, v in ipairs(list) do if lower(v) == n then return true end end
    return false
end

local function isPlayerAdmin(name)     return inList(name, ADMIN_PLAYERS) end
local function isPlayerProtected(name) return inList(name, PROTECTED_PLAYERS) end
local function canCrash(targetName)
    if isPlayerAdmin(LocalPlayer.Name) then return true end
    return not isPlayerProtected(targetName)
end

local function getAllAvailableReceivers()
    local receivers = {}
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character

    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                if table.find(WEAPON_LIST, item.Name) then
                    local r = item:FindFirstChild("Receiver")
                    if r then table.insert(receivers, r) end
                end
            end
        end
    end

    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                if table.find(WEAPON_LIST, item.Name) then
                    local r = item:FindFirstChild("Receiver")
                    if r then table.insert(receivers, r) end
                end
            end
        end
    end

    return receivers
end

local function applyDamageToAllWeapons(humanoid, dmg)
    if not humanoid then return false end

    local receivers = getAllAvailableReceivers()
    if #receivers == 0 then return false end

    local successCount = 0

    for _, receiver in ipairs(receivers) do
        pcall(function()
            receiver:FireServer("Damage", humanoid, dmg)
        end)
        successCount = successCount + 1
    end

    return successCount > 0
end

local function Kill(victimName, dmg)
    if not victimName then return false end
    local target = Players:FindFirstChild(victimName)
    if not target or not target.Character then return false end
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not canCrash(target.Name) then return false end

    return applyDamageToAllWeapons(humanoid, dmg or math.huge)
end

local function Crash(victimName, intensity)
    if not victimName then return false end
    local target = Players:FindFirstChild(victimName)
    if not target or not target.Character then return false end
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if not canCrash(target.Name) then return false end

    intensity = intensity or 5
    for i = 1, intensity do
        applyDamageToAllWeapons(humanoid, math.huge)
    end
    return true
end

local function GodMode()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local receivers = getAllAvailableReceivers()
    if #receivers == 0 then
        status.Text = "Status: No weapons found for GodMode!"
        return
    end

    for _, receiver in ipairs(receivers) do
        pcall(function()
            receiver:FireServer("Damage", humanoid, 0/0)
        end)
    end
end

local function teleportToPrompt(promptParent, weaponName, promptName)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local prompt = promptParent and promptParent:FindFirstChild(promptName or "ProximityPrompt")
    if not prompt then return false end

    local originalCFrame = hrp.CFrame
    local targetPart = prompt.Parent
    local targetCFrame = targetPart:IsA("BasePart") and targetPart.CFrame or (targetPart:FindFirstChildWhichIsA("BasePart") and targetPart:FindFirstChildWhichIsA("BasePart").CFrame)

    if not targetCFrame then return false end

    hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    task.wait(0.3)

    pcall(function()
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration + 0.1)
        prompt:InputHoldEnd()
    end)

    task.wait(0.5)
    hrp.CFrame = originalCFrame
    return true
end

local function getShotgun()
    local room = workspace:FindFirstChild("Room")
    if not room then
        status.Text = "Status: Room not found"
        return
    end
    local children = room:GetChildren()
    local part = children[67]
    if not part then
        status.Text = "Status: Shotgun part not found"
        return
    end
    if teleportToPrompt(part, "Shotgun") then
        status.Text = "Status: Shotgun acquired"
    else
        status.Text = "Status: Shotgun teleport failed"
    end
end

local function getGoldShotgun()
    local decoration = workspace:FindFirstChild("Decoration")
    if not decoration then
        status.Text = "Status: Decoration not found"
        return
    end
    local children = decoration:GetChildren()
    local part = children[161]
    if not part then
        status.Text = "Status: Gold shotgun part not found"
        return
    end
    if teleportToPrompt(part, "Weapon9") then
        status.Text = "Status: Gold Shotgun acquired"
    else
        status.Text = "Status: Gold Shotgun teleport failed"
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SCPGamesKillGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local GUI_W, GUI_H = 240, 205
local HEADER_H = 22
local BTN_SIZE = 20
local BTN_RIGHT = 6
local TITLE_RIGHT_PAD = BTN_SIZE + BTN_RIGHT

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
frame.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.35
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0.1, 0)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(75, 75, 255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0, GUI_W - 10 - TITLE_RIGHT_PAD, 0, HEADER_H)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SCP Games Kill GUI v10.0"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local collapseBtn = Instance.new("TextButton", frame)
collapseBtn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
collapseBtn.Position = UDim2.new(1, -(BTN_SIZE + BTN_RIGHT), 0, 2)
collapseBtn.BackgroundTransparency = 1
collapseBtn.Text = "–"
collapseBtn.TextColor3 = Color3.new(1,1,1)
collapseBtn.TextScaled = true
collapseBtn.BorderSizePixel = 0
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.AutoButtonColor = false
Instance.new("UICorner", collapseBtn).CornerRadius = UDim.new(0.2, 0)

local collapseStroke = Instance.new("UIStroke", collapseBtn)
collapseStroke.Thickness = 2
collapseStroke.Color = Color3.fromRGB(75, 75, 255)

local textBoxRow = Instance.new("Frame", frame)
textBoxRow.Size = UDim2.new(0.9, 0, 0, 26)
textBoxRow.Position = UDim2.new(0.05, 0, 0, 30)
textBoxRow.BackgroundTransparency = 1

local textBox = Instance.new("TextBox", textBoxRow)
textBox.Size = UDim2.new(0.85, 0, 1, 0)
textBox.Position = UDim2.new(0, 0, 0, 0)
textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
textBox.BackgroundTransparency = 0.35
textBox.PlaceholderText = "nick, nick, или all / nonfriends"
textBox.Text = ""
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.BorderSizePixel = 0
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0.2, 0)

local dropdownArrow = Instance.new("TextButton", textBoxRow)
dropdownArrow.Size = UDim2.new(0.13, 0, 1, 0)
dropdownArrow.Position = UDim2.new(0.87, 0, 0, 0)
dropdownArrow.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
dropdownArrow.BackgroundTransparency = 0.35
dropdownArrow.Text = "▼"
dropdownArrow.TextColor3 = Color3.new(1,1,1)
dropdownArrow.TextScaled = true
dropdownArrow.BorderSizePixel = 0
dropdownArrow.Font = Enum.Font.GothamBold
Instance.new("UICorner", dropdownArrow).CornerRadius = UDim.new(0.2, 0)

local btnRow = Instance.new("Frame", frame)
btnRow.Size = UDim2.new(0.9, 0, 0, 30)
btnRow.Position = UDim2.new(0.05, 0, 0, 60)
btnRow.BackgroundTransparency = 1

local crashBtn = Instance.new("TextButton", btnRow)
crashBtn.Size = UDim2.new(0.62, 0, 1, 0)
crashBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
crashBtn.BackgroundTransparency = 0.35
crashBtn.Text = "Start Crash | Off"
crashBtn.TextColor3 = Color3.new(1,1,1)
crashBtn.TextScaled = true
crashBtn.BorderSizePixel = 0
crashBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", crashBtn).CornerRadius = UDim.new(0.2, 0)

local killBtn = Instance.new("TextButton", btnRow)
killBtn.Size = UDim2.new(0.35, 0, 1, 0)
killBtn.Position = UDim2.new(0.65, 0, 0, 0)
killBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
killBtn.BackgroundTransparency = 0.35
killBtn.Text = "Kill"
killBtn.TextColor3 = Color3.new(1,1,1)
killBtn.TextScaled = true
killBtn.BorderSizePixel = 0
killBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", killBtn).CornerRadius = UDim.new(0.2, 0)

local godBtn = Instance.new("TextButton", frame)
godBtn.Size = UDim2.new(0.9, 0, 0, 22)
godBtn.Position = UDim2.new(0.05, 0, 0, 96)
godBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
godBtn.BackgroundTransparency = 0.35
godBtn.Text = "God Mode (All Guns)"
godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.TextScaled = true
godBtn.BorderSizePixel = 0
godBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", godBtn).CornerRadius = UDim.new(0.2, 0)

local gunRow = Instance.new("Frame", frame)
gunRow.Size = UDim2.new(0.9, 0, 0, 22)
gunRow.Position = UDim2.new(0.05, 0, 0, 122)
gunRow.BackgroundTransparency = 1

local shotgunBtn = Instance.new("TextButton", gunRow)
shotgunBtn.Size = UDim2.new(0.48, 0, 1, 0)
shotgunBtn.Position = UDim2.new(0, 0, 0, 0)
shotgunBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
shotgunBtn.BackgroundTransparency = 0.35
shotgunBtn.Text = "Shotgun"
shotgunBtn.TextColor3 = Color3.new(1,1,1)
shotgunBtn.TextScaled = true
shotgunBtn.BorderSizePixel = 0
shotgunBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", shotgunBtn).CornerRadius = UDim.new(0.2, 0)

local goldShotgunBtn = Instance.new("TextButton", gunRow)
goldShotgunBtn.Size = UDim2.new(0.48, 0, 1, 0)
goldShotgunBtn.Position = UDim2.new(0.52, 0, 0, 0)
goldShotgunBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
goldShotgunBtn.BackgroundTransparency = 0.35
goldShotgunBtn.Text = "Gold Shotgun"
goldShotgunBtn.TextColor3 = Color3.new(1,1,1)
goldShotgunBtn.TextScaled = true
goldShotgunBtn.BorderSizePixel = 0
goldShotgunBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", goldShotgunBtn).CornerRadius = UDim.new(0.2, 0)

local clickKillBtn = Instance.new("TextButton", frame)
clickKillBtn.Size = UDim2.new(0.9, 0, 0, 22)
clickKillBtn.Position = UDim2.new(0.05, 0, 0, 150)
clickKillBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
clickKillBtn.BackgroundTransparency = 0.35
clickKillBtn.Text = "Give Click-Kill Tool"
clickKillBtn.TextColor3 = Color3.new(1,1,1)
clickKillBtn.TextScaled = true
clickKillBtn.BorderSizePixel = 0
clickKillBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", clickKillBtn).CornerRadius = UDim.new(0.2, 0)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0, 178)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true
status.Font = Enum.Font.Gotham

local LIST_W = 180
local LIST_H = 250
local listFrame = Instance.new("Frame")
listFrame.Parent = screenGui
listFrame.Size = UDim2.new(0, LIST_W, 0, LIST_H)
listFrame.Position = UDim2.new(0.5, GUI_W/2 + 8, 0.5, -GUI_H/2)
listFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
listFrame.BackgroundTransparency = 0.35
listFrame.BorderSizePixel = 0
listFrame.Active = true
listFrame.Draggable = true
listFrame.Visible = false
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0.1, 0)

local listStroke = Instance.new("UIStroke", listFrame)
listStroke.Thickness = 2
listStroke.Color = Color3.fromRGB(75, 75, 255)

local listTitle = Instance.new("TextLabel", listFrame)
listTitle.Size = UDim2.new(0.9, 0, 0.1, 0)
listTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
listTitle.BackgroundTransparency = 1
listTitle.Text = "Select Players"
listTitle.TextColor3 = Color3.new(1,1,1)
listTitle.TextScaled = true
listTitle.Font = Enum.Font.GothamBold

local scrollFrame = Instance.new("ScrollingFrame", listFrame)
scrollFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.13, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local selectedPlayers = {}

local function saveSelected()
    local data = {}
    for name, val in pairs(selectedPlayers) do
        if val then table.insert(data, name) end
    end
    pcall(function()
        if writefile and isfolder and makefolder then
            if not isfolder("SCPGamesKillGUI") then makefolder("SCPGamesKillGUI") end
            writefile("SCPGamesKillGUI/selected.json", game:GetService("HttpService"):JSONEncode(data))
        end
    end)
end

local function loadSelected()
    pcall(function()
        if isfile and readfile then
            if isfile("SCPGamesKillGUI/selected.json") then
                local content = readfile("SCPGamesKillGUI/selected.json")
                local data = game:GetService("HttpService"):JSONDecode(content)
                for _, name in ipairs(data) do
                    selectedPlayers[lower(name)] = true
                end
            end
        end
    end)
end

loadSelected()

local playerButtons = {}

local function refreshPlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}

    local players = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(players, p)
        end
    end
    table.sort(players, function(a, b) return lower(a.Name) < lower(b.Name) end)

    local y = 0
    for _, p in ipairs(players) do
        local key = lower(p.Name)
        local btn = Instance.new("TextButton", scrollFrame)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, y)
        btn.BackgroundColor3 = selectedPlayers[key] and Color3.fromRGB(40, 140, 40) or Color3.new(0.3, 0.3, 0.3)
        btn.BackgroundTransparency = 0.35
        btn.Text = p.Name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)

        btn.MouseButton1Click:Connect(function()
            local k = lower(p.Name)
            if selectedPlayers[k] then
                selectedPlayers[k] = nil
                btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            else
                selectedPlayers[k] = true
                btn.BackgroundColor3 = Color3.fromRGB(40, 140, 40)
            end
            saveSelected()
        end)

        playerButtons[key] = btn
        y = y + 35
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function getSelectedPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and selectedPlayers[lower(p.Name)] then
            table.insert(names, p.Name)
        end
    end
    return names
end

Players.PlayerAdded:Connect(function(p)
    task.wait(0.5)
    if selectedPlayers[lower(p.Name)] then
        status.Text = "Status: Auto-selected " .. p.Name
    end
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.2)
    refreshPlayerList()
end)

local function toggleList()
    listFrame.Visible = not listFrame.Visible
    if listFrame.Visible then
        refreshPlayerList()
        dropdownArrow.Text = "▲"
    else
        dropdownArrow.Text = "▼"
    end
end

dropdownArrow.MouseButton1Click:Connect(toggleList)

local isCollapsed = false
local collapseTween = nil

local contentElements = {
    textBoxRow, btnRow, godBtn, gunRow, clickKillBtn, status
}

local function setContentVisible(visible)
    for _, el in ipairs(contentElements) do
        el.Visible = visible
    end
end

local function toggleCollapse()
    isCollapsed = not isCollapsed

    if collapseTween then collapseTween:Cancel() end

    if isCollapsed then
        collapseBtn.Text = "+"
        setContentVisible(false)
        local targetSize = UDim2.new(0, GUI_W, 0, HEADER_H + 4)
        collapseTween = TweenService:Create(
            frame,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = targetSize }
        )
        collapseTween:Play()
    else
        collapseBtn.Text = "–"
        local targetSize = UDim2.new(0, GUI_W, 0, GUI_H)
        collapseTween = TweenService:Create(
            frame,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = targetSize }
        )
        collapseTween:Play()
        task.delay(0.35, function()
            if not isCollapsed then
                setContentVisible(true)
            end
        end)
    end
end

collapseBtn.MouseButton1Click:Connect(toggleCollapse)

local function sortAlpha(list)
    table.sort(list, function(a, b) return lower(a.Name) < lower(b.Name) end)
    return list
end

local function getPlayers(input)
    input = lower(input)
    local out = {}
    if input == "all" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(out, p) end
        end
    elseif input == "nonfriends" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local ok, isFriend = pcall(function() return p:IsFriendsWith(LocalPlayer.UserId) end)
                if not (ok and isFriend) then table.insert(out, p) end
            end
        end
    else
        local terms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = term:match("^%s*(.-)%s*$")
            if term ~= "" then table.insert(terms, term) end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local pn = lower(p.Name)
                local dn = lower(p.DisplayName)
                for _, term in ipairs(terms) do
                    if pn:find(term, 1, true) or dn:find(term, 1, true) then
                        table.insert(out, p); break
                    end
                end
            end
        end
    end
    return sortAlpha(out)
end

local function collectTargets()
    local input = textBox.Text
    local result = {}
    local seen = {}

    if input ~= "" then
        local found = getPlayers(input)
        for _, p in ipairs(found) do
            if not seen[p] then
                seen[p] = true
                table.insert(result, p)
            end
        end
    end

    local selNames = getSelectedPlayerNames()
    for _, name in ipairs(selNames) do
        local p = Players:FindFirstChild(name)
        if p and not seen[p] then
            seen[p] = true
            table.insert(result, p)
        end
    end

    return result
end

local isCrashing      = false
local crashConn       = nil
local targets         = {}
local currentIndex    = 1

local function stopCrash()
    isCrashing = false
    crashBtn.Text = "Start Crash | Off"
    crashBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    status.Text = "Status: Stopped"
    if crashConn then crashConn:Disconnect(); crashConn = nil end
end

local function crashTick()
    if #targets == 0 then status.Text = "Status: No players"; return end
    if currentIndex > #targets then currentIndex = 1 end

    local p = targets[currentIndex]
    if p and p.Parent and p.Character then
        local ok = Crash(p.Name, 5) 
        status.Text = (ok and "Status: Crashing " or "Status: Fail ")
            .. p.Name .. " (" .. currentIndex .. "/" .. #targets .. ")"
    else
        status.Text = "Status: Player lost"
    end
    currentIndex += 1
end

local function startCrash()
    local input = textBox.Text
    local selNames = getSelectedPlayerNames()
    if input == "" and #selNames == 0 then
        status.Text = "Status: Enter nicknames or select players"
        return
    end
    targets = collectTargets()
    if #targets == 0 then status.Text = "Status: No players found"; return end

    if not isPlayerAdmin(LocalPlayer.Name) then
        for _, p in ipairs(targets) do
            if isPlayerProtected(p.Name) then
                status.Text = "Status: DENIED — " .. p.Name .. " is protected"
                return
            end
        end
    end

    if #getAllAvailableReceivers() == 0 then
        status.Text = "Status: No weapons in inventory!"
        return
    end

    currentIndex = 1
    isCrashing = true
    crashBtn.Text = "Start Crash | ON"
    crashBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    status.Text = "Status: Crashing " .. #targets .. " player(s)"
    crashConn = RunService.Heartbeat:Connect(crashTick)
end

crashBtn.MouseButton1Click:Connect(function()
    if isCrashing then stopCrash() else startCrash() end
end)

killBtn.MouseButton1Click:Connect(function()
    local found = collectTargets()
    if #found == 0 then status.Text = "Status: No players found"; return end
    for _, p in ipairs(found) do Kill(p.Name, math.huge) end
    status.Text = "Status: Killed " .. #found .. " player(s)"
end)

godBtn.MouseButton1Click:Connect(function()
    GodMode()
    status.Text = "Status: God mode applied"
end)

shotgunBtn.MouseButton1Click:Connect(function()
    getShotgun()
end)

goldShotgunBtn.MouseButton1Click:Connect(function()
    getGoldShotgun()
end)

local function onKillToolActivated()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Target
    if not target then return end

    local model = target:FindFirstAncestorOfClass("Model")
    if not model then return end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local targetPlayer
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character == model then
            targetPlayer = p
            break
        end
    end

    if targetPlayer then
        if not canCrash(targetPlayer.Name) then
            status.Text = "Status: DENIED — " .. targetPlayer.Name .. " is protected"
            return
        end
        Kill(targetPlayer.Name, math.huge)
        status.Text = "Status: Click-killed " .. targetPlayer.Name
    else
        if humanoid.Health > 0 then
            applyDamageToAllWeapons(humanoid, math.huge)
            status.Text = "Status: Click-killed NPC"
        end
    end
end

local function giveKillTool()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then
        status.Text = "Status: No backpack!"
        return
    end

    local existing = backpack:FindFirstChild("ClickKill") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ClickKill"))
    if existing then
        existing:Destroy()
    end

    local tool = Instance.new("Tool")
    tool.Name = "ClickKill"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.ToolTip = "Click a player to kill them"

    tool.Activated:Connect(onKillToolActivated)

    tool.Parent = backpack
    status.Text = "Status: Click-Kill tool given"
end

clickKillBtn.MouseButton1Click:Connect(giveKillTool)

textBox.FocusLost:Connect(function(enter)
    if enter then
        local found = getPlayers(textBox.Text)
        status.Text = #found > 0
            and ("Status: Found " .. #found .. " player(s)")
            or  "Status: Players not found"
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    stopCrash()
    status.Text = "Status: Character removed"
end)

refreshPlayerList()

local userId = Players:GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SCP Games Kill GUI",
    Text = "version V10.0",
    Icon = content,
    Duration = 7
})