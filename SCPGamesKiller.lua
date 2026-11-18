--// Player Crasher v3.1 — Universal Weapon Abuse

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

--// ====== СПИСКИ ======
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

--// ====== ПОИСК ОРУЖИЯ И РЕМОУТОВ ======
local WEAPON_NAMES = {"Shotgun", "AssaultRifle", "Glock", "Sniper", "TMP"}
local REMOTE_NAMES = {"Receiver", "Remote", "Fire", "Shoot"}

local function getWeaponFromPlayer(weaponName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char     = LocalPlayer.Character
    if backpack and backpack:FindFirstChild(weaponName) then
        return backpack:FindFirstChild(weaponName)
    end
    if char and char:FindFirstChild(weaponName) then
        return char:FindFirstChild(weaponName)
    end
    return nil
end

local function getReceiver(weaponName)
    local weapon = getWeaponFromPlayer(weaponName)
    if not weapon then return nil end
    
    -- Ищем ремоут по возможным именам
    for _, rName in ipairs(REMOTE_NAMES) do
        local remote = weapon:FindFirstChild(rName)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            return remote
        end
    end
    return nil
end

local function hasAnyWeapon()
    for _, wName in ipairs(WEAPON_NAMES) do
        if getReceiver(wName) then return true end
    end
    return false
end

--// ====== ФУНКЦИИ АТАКИ ======
local function Kill(victimName, dmg)
    if not victimName then return false end
    local target = Players:FindFirstChild(victimName)
    if not target or not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not canCrash(target.Name) then return false end

    local success = false
    for _, wName in ipairs(WEAPON_NAMES) do
        local receiver = getReceiver(wName)
        if receiver then
            pcall(function()
                receiver:FireServer("Damage", humanoid, dmg or math.huge)
            end)
            success = true
            break -- Используем первое найденное оружие
        end
    end
    return success
end

local function Crash(victimName, intensity)
    if not victimName then return false end
    local target = Players:FindFirstChild(victimName)
    if not target or not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if not canCrash(target.Name) then return false end

    intensity = intensity or 50
    local success = false
    
    for _, wName in ipairs(WEAPON_NAMES) do
        local receiver = getReceiver(wName)
        if receiver then
            for i = 1, intensity do
                pcall(function()
                    receiver:FireServer("Damage", humanoid, math.huge)
                end)
            end
            success = true
            break
        end
    end
    return success
end

--// God Mode для всех оружий (0/0 = NaN)
local function GodMode()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    for _, wName in ipairs(WEAPON_NAMES) do
        local receiver = getReceiver(wName)
        if receiver then
            pcall(function()
                receiver:FireServer("Damage", humanoid, 0/0)
            end)
        end
    end
end

--// ====== UI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerCrasherGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local GUI_W, GUI_H = 220, 140
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
frame.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.35
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0.1, 0)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(75, 75, 255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0.9, 0, 0.15, 0)
title.Position = UDim2.new(0.05, 0, 0.03, 0)
title.BackgroundTransparency = 1
title.Text = "Player Crasher v3.1"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.9, 0, 0.2, 0)
textBox.Position = UDim2.new(0.05, 0, 0.2, 0)
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

local btnRow = Instance.new("Frame", frame)
btnRow.Size = UDim2.new(0.9, 0, 0.22, 0)
btnRow.Position = UDim2.new(0.05, 0, 0.45, 0)
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
godBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
godBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
godBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
godBtn.BackgroundTransparency = 0.35
godBtn.Text = "God Mode (All Weapons)"
godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.TextScaled = true
godBtn.BorderSizePixel = 0
godBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", godBtn).CornerRadius = UDim.new(0.2, 0)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0.12, 0)
status.Position = UDim2.new(0.05, 0, 0.87, 0)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true
status.Font = Enum.Font.Gotham

--// ====== ПОИСК ЦЕЛЕЙ ======
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

--// ====== ЛОГИКА КРАША ======
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
        local ok = Crash(p.Name, 30)
        status.Text = (ok and "Status: Crashing " or "Status: Fail ")
            .. p.Name .. " (" .. currentIndex .. "/" .. #targets .. ")"
    else
        status.Text = "Status: Player lost"
    end
    currentIndex += 1
end

local function startCrash()
    local input = textBox.Text
    if input == "" then status.Text = "Status: Enter nicknames"; return end

    targets = getPlayers(input)
    if #targets == 0 then status.Text = "Status: No players found"; return end

    if not isPlayerAdmin(LocalPlayer.Name) then
        for _, p in ipairs(targets) do
            if isPlayerProtected(p.Name) then
                status.Text = "Status: DENIED — " .. p.Name .. " is protected"
                return
            end
        end
    end

    if not hasAnyWeapon() then
        status.Text = "Status: No weapons with Receiver found!"
        return
    end

    currentIndex = 1
    isCrashing = true
    crashBtn.Text = "Start Crash | ON"
    crashBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    status.Text = "Status: Crashing " .. #targets .. " player(s)"

    crashConn = RunService.Heartbeat:Connect(crashTick)
end

--// ====== ОБРАБОТЧИКИ ======
crashBtn.MouseButton1Click:Connect(function()
    if isCrashing then stopCrash() else startCrash() end
end)

killBtn.MouseButton1Click:Connect(function()
    local found = getPlayers(textBox.Text)
    if #found == 0 then status.Text = "Status: No players found"; return end
    for _, p in ipairs(found) do Kill(p.Name, math.huge) end
    status.Text = "Status: Killed " .. #found .. " player(s)"
end)

godBtn.MouseButton1Click:Connect(function()
    GodMode()
    status.Text = "Status: God mode applied to all guns"
end)

textBox.FocusLost:Connect(function(enter)
    if enter then
        local found = getPlayers(textBox.Text)
        status.Text = #found > 0
            and ("Status: Found " .. #found .. " player(s)")
            or  "Status: Players not found"
    end
end)

Players.PlayerRemoving:Connect(function()
    if isCrashing then
        targets = getPlayers(textBox.Text)
        if #targets == 0 then stopCrash() end
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    stopCrash()
    status.Text = "Status: Character removed"
end)

--// ====== УВЕДОМЛЕНИЕ ======
local ok, thumb = pcall(function()
    return Players:GetUserThumbnailAsync(
        Players:GetUserIdFromNameAsync("prespeshnikShashlika"),
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Player Crasher",
    Text  = "v3.1 — Universal Weapon Abuse",
    Icon  = ok and thumb or "",
    Duration = 7
})