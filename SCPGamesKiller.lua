--// Player Crasher v5.0 — Universal Global Weapon Abuse

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer      = Players.LocalPlayer

--// ====== НАСТРОЙКИ РЕМОУТА ======
-- Убедись, что путь верный. Если он в другом месте, поменяй.
local REMOTE = ReplicatedStorage:WaitForChild("RE"):WaitForChild("Receiver")

--// ====== ПОЛНЫЙ СПИСОК ОРУЖИЙ (31 шт.) ======
local WEAPON_LIST = {
    "AK", "AUG", "AssaultRifle", "Bizon", "Canon",
    "Crystal Micro Uzi", "Crystal P90", "Cupcake Gun", 
    "Diamond Micro Uzi", "Diamond P90", "Glock", 
    "Golden AssaultRifle", "Laser Gun", "Laser Minigun", 
    "Light Machine Gun", "M60", "MP5", "Machine Gun", 
    "Machine Gun2", "Micro Uzi", "Minigun", "P90", 
    "Red Gun", "Scar", "Shotgun", "Sniper", 
    "Steampunk Rifle", "TMP", "Weapon2", "Weapon5", 
    "Weapon9", "Weird Gun", "Weird Gun 2", "Winter Minigun"
}

--// ====== СПИСКИ ЗАЩИТЫ ======
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

--// ====== ЯДРО АТАКИ ======
local function applyDamageToAllWeapons(humanoid, dmg)
    if not REMOTE or not humanoid then return false end
    
    for _, weaponName in ipairs(WEAPON_LIST) do
        pcall(function()
            -- Формат вызова: "Damage", [Имя оружия], [Humanoid], [Урон]
            REMOTE:FireServer("Damage", weaponName, humanoid, dmg)
        end)
    end
    return true
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

--// ====== БЕССМЕРТИЕ (0/0) ======
local function GodMode()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Шлем 0/0 на себя для ВСЕХ 31 оружия
    for _, weaponName in ipairs(WEAPON_LIST) do
        pcall(function()
            REMOTE:FireServer("Damage", weaponName, humanoid, 0/0)
        end)
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
title.Text = "Player Crasher v5.0"
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
godBtn.Text = "God Mode (All 31 Guns)"
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

--// ====== ФУНКЦИИ ИНТЕРФЕЙСА ======
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
        -- За тик шлем 3 прохода по всему списку (31*3 = 93 вызова) для гарантированного краша
        local ok = Crash(p.Name, 3) 
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
    local found = getPlayers(textBox.Text)
    if #found == 0 then status.Text = "Status: No players found"; return end
    for _, p in ipairs(found) do Kill(p.Name, math.huge) end
    status.Text = "Status: Killed " .. #found .. " player(s)"
end)

godBtn.MouseButton1Click:Connect(function()
    GodMode()
    status.Text = "Status: God mode applied (31 guns)"
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

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Player Crasher",
    Text  = "v5.0 — Загружено 31 оружие",
    Duration = 7
})