--// The Last Path
--// by prespeshnikShashlika

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer

local Config = {
    PathFile = "TheLastPath_data.json",
    RecordInterval = 0.3,
    MinDistance = 2,
    MaxPoints = 5000,
    DefaultLanguage = "en",
    LineColor = Color3.fromRGB(80, 200, 80),
    LineThickness = 4,
    LineTransparency = 0.3
}

local Localization = {
    ru = {
        title = "Последний путь",
        start_record = "Начать запись",
        stop_record = "Остановить",
        delete_path = "Удалить",
        show_path = "Показать",
        hide_path = "Скрыть",
        no_paths = "Нет сохранённых путей",
        recording = "Запись...",
        saved = "Путь сохранён",
        lang_switch = "EN",
        paths_list = "Сохранённые пути",
        rename_title = "Переименовать путь",
        enter_name = "Введите название",
        save = "Сохранить",
        cancel = "Отмена"
    },
    en = {
        title = "The Last Path",
        start_record = "Start Recording",
        stop_record = "Stop",
        delete_path = "Delete",
        show_path = "Show",
        hide_path = "Hide",
        no_paths = "No saved paths",
        recording = "Recording...",
        saved = "Path saved",
        lang_switch = "RU",
        paths_list = "Saved paths",
        rename_title = "Rename path",
        enter_name = "Enter name",
        save = "Save",
        cancel = "Cancel"
    }
}

local currentLang = Config.DefaultLanguage
local L = Localization[currentLang]

local function switchLang()
    currentLang = (currentLang == "ru") and "en" or "ru"
    L = Localization[currentLang]
end

local placeId = game.PlaceId

local function getPlaceName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(placeId)
    end)
    if success and info then
        return info.Name
    end
    return "Unknown Place"
end

local currentPlaceName = getPlaceName()

local isRecording = false
local currentPath = {}
local lastRecordedPosition = nil
local savedPaths = {}
local activeRenderers = {}
local isMinimized = false
local isListMinimized = true
local activePathButtons = {}

local function loadData()
    local success, data = pcall(function()
        if isfile and isfile(Config.PathFile) then
            return HttpService:JSONDecode(readfile(Config.PathFile))
        end
        return nil
    end)
    if success and data then
        savedPaths = data.paths or {}
    else
        savedPaths = {}
    end
end

local function saveData()
    pcall(function()
        local data = {
            paths = savedPaths
        }
        writefile(Config.PathFile, HttpService:JSONEncode(data))
    end)
end

loadData()

local function startRecording()
    if isRecording then return end
    isRecording = true
    currentPath = {}
    lastRecordedPosition = nil
    
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        table.insert(currentPath, {
            x = character.HumanoidRootPart.Position.X,
            y = character.HumanoidRootPart.Position.Y,
            z = character.HumanoidRootPart.Position.Z
        })
        lastRecordedPosition = character.HumanoidRootPart.Position
    end
    
    task.spawn(function()
        while isRecording do
            task.wait(Config.RecordInterval)
            local char = localPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                if not lastRecordedPosition or (pos - lastRecordedPosition).Magnitude >= Config.MinDistance then
                    if #currentPath < Config.MaxPoints then
                        table.insert(currentPath, {x = pos.X, y = pos.Y, z = pos.Z})
                        lastRecordedPosition = pos
                    end
                end
            end
        end
    end)
end

local function stopRecording()
    if not isRecording then return end
    isRecording = false
    
    if #currentPath < 2 then
        currentPath = {}
        if _G.LastPath_UpdateRecordingUI then
            _G.LastPath_UpdateRecordingUI()
        end
        return
    end
    
    local pathName = "Path " .. os.date("%H:%M:%S")
    
    local pathId = HttpService:GenerateGUID(false)
    savedPaths[pathId] = {
        name = pathName,
        points = currentPath,
        placeId = placeId,
        placeName = currentPlaceName,
        created = os.time()
    }
    saveData()
    
    if _G.LastPath_RefreshList then
        _G.LastPath_RefreshList()
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = L.saved,
        Text = pathName,
        Duration = 3
    })
    
    currentPath = {}
    
    if _G.LastPath_UpdateRecordingUI then
        _G.LastPath_UpdateRecordingUI()
    end
end

localPlayer.CharacterAdded:Connect(function()
    if isRecording then
        task.wait(0.5)
        stopRecording()
    end
end)

localPlayer.CharacterRemoving:Connect(function()
    if isRecording then
        task.wait(0.1)
        stopRecording()
    end
end)

local function clearRenderers(pathId)
    if activeRenderers[pathId] then
        for _, data in ipairs(activeRenderers[pathId].lines) do
            pcall(function() data.line:Remove() end)
        end
        activeRenderers[pathId] = nil
    end
end

local function drawPath(pathId)
    local path = savedPaths[pathId]
    if not path or #path.points < 2 then return end
    
    if activeRenderers[pathId] then
        clearRenderers(pathId)
        return
    end
    
    local lines = {}
    local points = path.points
    
    for i = 1, #points - 1 do
        local p1 = points[i]
        local p2 = points[i + 1]
        
        local line = Drawing.new("Line")
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(0, 0)
        line.Color = Config.LineColor
        line.Thickness = Config.LineThickness
        line.Transparency = Config.LineTransparency
        line.Visible = false
        line.ZIndex = 1
        
        table.insert(lines, {
            line = line,
            from3D = Vector3.new(p1.x, p1.y, p1.z),
            to3D = Vector3.new(p2.x, p2.y, p2.z)
        })
    end
    
    activeRenderers[pathId] = {
        lines = lines,
        visible = true
    }
    
    task.spawn(function()
        while activeRenderers[pathId] and activeRenderers[pathId].visible do
            task.wait()
            local camera = Workspace.CurrentCamera
            if camera then
                for _, data in ipairs(activeRenderers[pathId].lines) do
                    pcall(function()
                        local from2D, fromVisible = camera:WorldToViewportPoint(data.from3D)
                        local to2D, toVisible = camera:WorldToViewportPoint(data.to3D)
                        
                        if fromVisible and toVisible then
                            data.line.From = Vector2.new(from2D.X, from2D.Y)
                            data.line.To = Vector2.new(to2D.X, to2D.Y)
                            data.line.Visible = true
                        else
                            data.line.Visible = false
                        end
                    end)
                end
            end
        end
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TheLastPathGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 102)
frame.Position = UDim2.new(0.5, -110, 0.5, -56)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = frame

local borderFrame = Instance.new("Frame")
borderFrame.Size = frame.Size
borderFrame.Position = frame.Position
borderFrame.BackgroundTransparency = 1
borderFrame.AnchorPoint = frame.AnchorPoint
borderFrame.ZIndex = frame.ZIndex - 1
borderFrame.Parent = screenGui

local borderCorner = frame.UICorner:Clone()
borderCorner.Parent = borderFrame

local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 3
borderStroke.LineJoinMode = Enum.LineJoinMode.Round
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
borderStroke.Parent = borderFrame

frame:GetPropertyChangedSignal("Position"):Connect(function()
    borderFrame.Position = frame.Position
end)

frame:GetPropertyChangedSignal("Size"):Connect(function()
    borderFrame.Size = frame.Size
end)

local toggleMinimizeBtn = Instance.new("TextButton")
toggleMinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
toggleMinimizeBtn.Position = UDim2.new(1, -25, 0, 5)
toggleMinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleMinimizeBtn.Text = "-"
toggleMinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
toggleMinimizeBtn.TextSize = 14
toggleMinimizeBtn.ZIndex = 2
toggleMinimizeBtn.Parent = frame

local toggleMinimizeCorner = Instance.new("UICorner")
toggleMinimizeCorner.CornerRadius = UDim.new(0, 4)
toggleMinimizeCorner.Parent = toggleMinimizeBtn

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "The Last Path"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local textGradient = Instance.new("UIGradient", title)
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

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 35, 0, 25)
langBtn.Position = UDim2.new(1, -210, 0, 5)
langBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
langBtn.Text = "RU"
langBtn.TextColor3 = Color3.new(1, 1, 1)
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 12
langBtn.Parent = frame

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 4)
langCorner.Parent = langBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = frame

local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0.9, 0, 0, 32)
recordBtn.Position = UDim2.new(0.05, 0, 0, 35)
recordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
recordBtn.Text = L.start_record
recordBtn.TextColor3 = Color3.new(1, 1, 1)
recordBtn.Font = Enum.Font.Sarpanch
recordBtn.TextSize = 15
recordBtn.Parent = frame

local recordCorner = Instance.new("UICorner")
recordCorner.CornerRadius = UDim.new(0, 6)
recordCorner.Parent = recordBtn

local listHeader = Instance.new("Frame")
listHeader.Size = UDim2.new(0.9, 0, 0, 22)
listHeader.Position = UDim2.new(0.05, 0, 0, 72)
listHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
listHeader.BorderSizePixel = 0
listHeader.Parent = frame

local listHeaderCorner = Instance.new("UICorner")
listHeaderCorner.CornerRadius = UDim.new(0, 6)
listHeaderCorner.Parent = listHeader

local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(0.8, 0, 1, 0)
listLabel.Position = UDim2.new(0.05, 0, 0, 0)
listLabel.BackgroundTransparency = 1
listLabel.Text = L.paths_list
listLabel.TextColor3 = Color3.new(1, 1, 1)
listLabel.Font = Enum.Font.Gotham
listLabel.TextSize = 12
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = listHeader

local listToggleBtn = Instance.new("TextButton")
listToggleBtn.Size = UDim2.new(0, 20, 0, 20)
listToggleBtn.Position = UDim2.new(1, -22, 0, 1)
listToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
listToggleBtn.Text = "+"
listToggleBtn.TextColor3 = Color3.new(1, 1, 1)
listToggleBtn.TextSize = 14
listToggleBtn.Parent = listHeader

local listToggleCorner = Instance.new("UICorner")
listToggleCorner.CornerRadius = UDim.new(0, 4)
listToggleCorner.Parent = listToggleBtn

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0, 120)
scrollFrame.Position = UDim2.new(0.05, 0, 0, 107)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BackgroundTransparency = 0.5
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Visible = false
scrollFrame.Parent = frame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local refreshList

local renameDialog = Instance.new("Frame")
renameDialog.Size = UDim2.new(0, 220, 0, 100)
renameDialog.Position = UDim2.new(0.5, -110, 0.5, -50)
renameDialog.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
renameDialog.BorderSizePixel = 0
renameDialog.Visible = false
renameDialog.ZIndex = 100
renameDialog.Parent = screenGui

local renameCorner = Instance.new("UICorner")
renameCorner.CornerRadius = UDim.new(0, 8)
renameCorner.Parent = renameDialog

local renameTitle = Instance.new("TextLabel")
renameTitle.Size = UDim2.new(1, 0, 0, 25)
renameTitle.Position = UDim2.new(0, 0, 0, 5)
renameTitle.BackgroundTransparency = 1
renameTitle.Text = L.rename_title
renameTitle.TextColor3 = Color3.new(1, 1, 1)
renameTitle.Font = Enum.Font.GothamBold
renameTitle.TextSize = 14
renameTitle.ZIndex = 101
renameTitle.Parent = renameDialog

local renameInput = Instance.new("TextBox")
renameInput.Size = UDim2.new(0.9, 0, 0, 28)
renameInput.Position = UDim2.new(0.05, 0, 0, 32)
renameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
renameInput.Text = ""
renameInput.PlaceholderText = L.enter_name
renameInput.TextColor3 = Color3.new(1, 1, 1)
renameInput.ClearTextOnFocus = false
renameInput.Font = Enum.Font.Code
renameInput.TextSize = 12
renameInput.ZIndex = 101
renameInput.Parent = renameDialog

local renameInputCorner = Instance.new("UICorner")
renameInputCorner.CornerRadius = UDim.new(0, 4)
renameInputCorner.Parent = renameInput

local renameSave = Instance.new("TextButton")
renameSave.Size = UDim2.new(0.42, 0, 0, 26)
renameSave.Position = UDim2.new(0.05, 0, 0, 66)
renameSave.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
renameSave.Text = L.save
renameSave.TextColor3 = Color3.new(1, 1, 1)
renameSave.Font = Enum.Font.Gotham
renameSave.TextSize = 12
renameSave.ZIndex = 101
renameSave.Parent = renameDialog

local renameSaveCorner = Instance.new("UICorner")
renameSaveCorner.CornerRadius = UDim.new(0, 4)
renameSaveCorner.Parent = renameSave

local renameCancel = Instance.new("TextButton")
renameCancel.Size = UDim2.new(0.42, 0, 0, 26)
renameCancel.Position = UDim2.new(0.53, 0, 0, 66)
renameCancel.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
renameCancel.Text = L.cancel
renameCancel.TextColor3 = Color3.new(1, 1, 1)
renameCancel.Font = Enum.Font.Gotham
renameCancel.TextSize = 12
renameCancel.ZIndex = 101
renameCancel.Parent = renameDialog

local renameCancelCorner = Instance.new("UICorner")
renameCancelCorner.CornerRadius = UDim.new(0, 4)
renameCancelCorner.Parent = renameCancel

local currentRenamingId = nil

refreshList = function()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    activePathButtons = {}
    
    local count = 0
    for pathId, path in pairs(savedPaths) do
        if path.placeId == placeId then
            count = count + 1
            
            local pathFrame = Instance.new("Frame")
            pathFrame.Size = UDim2.new(0.95, 0, 0, 60)
            pathFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            pathFrame.BorderSizePixel = 0
            pathFrame.LayoutOrder = path.created or count
            pathFrame.Parent = scrollFrame
            
            local pathCorner = Instance.new("UICorner")
            pathCorner.CornerRadius = UDim.new(0, 6)
            pathCorner.Parent = pathFrame
            
            local nameBtn = Instance.new("TextButton")
            nameBtn.Size = UDim2.new(0.95, 0, 0, 18)
            nameBtn.Position = UDim2.new(0.025, 0, 0, 2)
            nameBtn.BackgroundTransparency = 1
            nameBtn.Text = path.name
            nameBtn.TextColor3 = Color3.new(1, 1, 1)
            nameBtn.Font = Enum.Font.GothamBold
            nameBtn.TextSize = 11
            nameBtn.TextXAlignment = Enum.TextXAlignment.Left
            nameBtn.Parent = pathFrame
            
            nameBtn.MouseButton1Click:Connect(function()
                currentRenamingId = pathId
                renameInput.Text = path.name
                renameTitle.Text = L.rename_title
                renameInput.PlaceholderText = L.enter_name
                renameSave.Text = L.save
                renameCancel.Text = L.cancel
                renameDialog.Visible = true
            end)
            
            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(0.95, 0, 0, 14)
            infoLabel.Position = UDim2.new(0.025, 0, 0, 21)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = #path.points .. " points"
            infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            infoLabel.Font = Enum.Font.Gotham
            infoLabel.TextSize = 10
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left
            infoLabel.Parent = pathFrame
            
            local showBtn = Instance.new("TextButton")
            showBtn.Size = UDim2.new(0.28, 0, 0, 20)
            showBtn.Position = UDim2.new(0.025, 0, 0, 37)
            showBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            showBtn.Text = L.show_path
            showBtn.TextColor3 = Color3.new(1, 1, 1)
            showBtn.Font = Enum.Font.Gotham
            showBtn.TextSize = 10
            showBtn.Parent = pathFrame
            
            local showCorner = Instance.new("UICorner")
            showCorner.CornerRadius = UDim.new(0, 4)
            showCorner.Parent = showBtn
            
            local deleteBtn = Instance.new("TextButton")
            deleteBtn.Size = UDim2.new(0.28, 0, 0, 20)
            deleteBtn.Position = UDim2.new(0.315, 0, 0, 37)
            deleteBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
            deleteBtn.Text = L.delete_path
            deleteBtn.TextColor3 = Color3.new(1, 1, 1)
            deleteBtn.Font = Enum.Font.Gotham
            deleteBtn.TextSize = 10
            deleteBtn.Parent = pathFrame
            
            local delCorner = Instance.new("UICorner")
            delCorner.CornerRadius = UDim.new(0, 4)
            delCorner.Parent = deleteBtn
            
            activePathButtons[pathId] = {
                showBtn = showBtn,
                nameBtn = nameBtn
            }
            
            showBtn.MouseButton1Click:Connect(function()
                drawPath(pathId)
                if activeRenderers[pathId] then
                    showBtn.Text = L.hide_path
                    showBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
                else
                    showBtn.Text = L.show_path
                    showBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
            end)
            
            deleteBtn.MouseButton1Click:Connect(function()
                clearRenderers(pathId)
                savedPaths[pathId] = nil
                activePathButtons[pathId] = nil
                saveData()
                refreshList()
            end)
        end
    end
    
    if count == 0 then
        local noPathLabel = Instance.new("TextLabel")
        noPathLabel.Size = UDim2.new(1, 0, 0, 30)
        noPathLabel.BackgroundTransparency = 1
        noPathLabel.Text = L.no_paths
        noPathLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        noPathLabel.Font = Enum.Font.Gotham
        noPathLabel.TextSize = 12
        noPathLabel.Parent = scrollFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

_G.LastPath_RefreshList = refreshList

renameSave.MouseButton1Click:Connect(function()
    if currentRenamingId and savedPaths[currentRenamingId] then
        local newName = renameInput.Text
        if newName and newName ~= "" then
            savedPaths[currentRenamingId].name = newName
            saveData()
            refreshList()
        end
    end
    renameDialog.Visible = false
    currentRenamingId = nil
end)

renameCancel.MouseButton1Click:Connect(function()
    renameDialog.Visible = false
    currentRenamingId = nil
end)

local recordingUpdateConn
local function updateRecordingUI()
    if recordingUpdateConn then recordingUpdateConn:Disconnect() end
    if isRecording then
        recordBtn.Text = L.stop_record
        recordBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        statusLabel.Text = L.recording .. " " .. #currentPath .. " points"
        recordingUpdateConn = RunService.Heartbeat:Connect(function()
            if isRecording then
                statusLabel.Text = L.recording .. " " .. #currentPath .. " points"
            end
        end)
    else
        recordBtn.Text = L.start_record
        recordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        statusLabel.Text = ""
    end
end

_G.LastPath_UpdateRecordingUI = updateRecordingUI

recordBtn.MouseButton1Click:Connect(function()
    if isRecording then
        stopRecording()
    else
        startRecording()
    end
    updateRecordingUI()
end)

langBtn.MouseButton1Click:Connect(function()
    switchLang()
    langBtn.Text = L.lang_switch
    recordBtn.Text = isRecording and L.stop_record or L.start_record
    listLabel.Text = L.paths_list
    renameTitle.Text = L.rename_title
    renameInput.PlaceholderText = L.enter_name
    renameSave.Text = L.save
    renameCancel.Text = L.cancel
    
    for pathId, buttons in pairs(activePathButtons) do
        if activeRenderers[pathId] then
            buttons.showBtn.Text = L.hide_path
        else
            buttons.showBtn.Text = L.show_path
        end
    end
    
    refreshList()
end)

local function toggleListMinimize()
    isListMinimized = not isListMinimized
    scrollFrame.Visible = not isListMinimized
    if isListMinimized then
        listToggleBtn.Text = "+"
        frame.Size = UDim2.new(0, 220, 0, 102)
    else
        listToggleBtn.Text = "-"
        frame.Size = UDim2.new(0, 220, 0, 240)
    end
end

listToggleBtn.MouseButton1Click:Connect(toggleListMinimize)

local minimizedSize = UDim2.new(0, 60, 0, 30)
local originalSize = frame.Size
local originalTitle = title.Text
local invisibleExpandBtn = Instance.new("TextButton")
invisibleExpandBtn.Size = UDim2.new(1, 0, 1, 0)
invisibleExpandBtn.Position = UDim2.new(0, 0, 0, 0)
invisibleExpandBtn.BackgroundTransparency = 1
invisibleExpandBtn.Text = ""
invisibleExpandBtn.TextTransparency = 1
invisibleExpandBtn.Visible = false
invisibleExpandBtn.Parent = frame

local elementsToHide = {langBtn, statusLabel, recordBtn, listHeader, scrollFrame, toggleMinimizeBtn}

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        originalSize = frame.Size
        title.Text = "TLP"
        title.Size = UDim2.new(1, 0, 1, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        for _, el in ipairs(elementsToHide) do
            el.Visible = false
        end
        frame.Size = minimizedSize
        invisibleExpandBtn.Size = UDim2.new(1, 0, 1, 0)
        invisibleExpandBtn.Visible = true
        invisibleExpandBtn.Active = true
    else
        title.Text = originalTitle
        title.Size = UDim2.new(1, 0, 0, 25)
        title.Position = UDim2.new(0, 0, 0, 5)
        for _, el in ipairs(elementsToHide) do
            el.Visible = true
        end
        scrollFrame.Visible = not isListMinimized
        if isListMinimized then
            listToggleBtn.Text = "+"
            frame.Size = UDim2.new(0, 220, 0, 102)
        else
            listToggleBtn.Text = "-"
            frame.Size = UDim2.new(0, 220, 0, 240)
        end
        invisibleExpandBtn.Visible = false
    end
end

toggleMinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

invisibleExpandBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        toggleMinimize()
    end
end)

refreshList()
updateRecordingUI()

StarterGui:SetCore("SendNotification", {
    Title = "The Last Path",
    Text = "Loaded. Place: " .. currentPlaceName,
    Duration = 5
})