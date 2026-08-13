local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

WindUI:SetTheme("Dark")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local blackHoleActive = false
local targetPlayer = nil
local humanoidRootPart = nil
local DescendantAddedConnection = nil
local CharacterAddedConnection = nil

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

    getgenv().Network.RetainPart = function(PartToRetain)
        if PartToRetain:IsA("BasePart") and PartToRetain:IsDescendantOf(Workspace) then
            table.insert(getgenv().Network.BaseParts, PartToRetain)
            PartToRetain.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            PartToRetain.CanCollide = false
        end
    end

    local LocalPlayer = Players.LocalPlayer
    LocalPlayer.ReplicationFocus = Workspace
    
    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        
        if blackHoleActive then
            for _, Part in pairs(getgenv().Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = getgenv().Network.Velocity
                end
            end
        end
    end)
end

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored 
       and not v.Parent:FindFirstChildOfClass("Humanoid") 
       and not v.Parent:FindFirstChild("Head") 
       and v.Name ~= "Handle" then
        if v:IsDescendantOf(Players.LocalPlayer.Character) then
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
        
        getgenv().Network.RetainPart(v)
        
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

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        getgenv().Network.BaseParts = {}
        
        for _, v in ipairs(Workspace:GetDescendants()) do
            ForcePart(v)
        end

        DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then
                ForcePart(v)
            end
        end)

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not blackHoleActive then
                connection:Disconnect()
                return
            end
            
            if humanoidRootPart then
                Attachment1.WorldCFrame = humanoidRootPart.CFrame
            end
        end)
    else
        if DescendantAddedConnection then
            DescendantAddedConnection:Disconnect()
            DescendantAddedConnection = nil
        end
        
        getgenv().Network.BaseParts = {}
    end
end

local function getPlayer(name)
    local lowerName = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        local lowerPlayer = string.lower(p.Name)
        if string.find(lowerPlayer, lowerName) then
            return p
        elseif string.find(string.lower(p.DisplayName), lowerName) then
            return p
        end
    end
end

function UI()
    local ButtonColor = Color3.new(1,1,1)
    if game.CoreGui:FindFirstChild("ShashlikBringParts") then
        game.CoreGui:FindFirstChild("ShashlikBringParts"):Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "ShashlikBringParts"
    
    local Size = UDim2.new(0,300,0,420)
    
    local CanvasGroup = Instance.new("CanvasGroup", ScreenGui)
    CanvasGroup.Size = Size
    CanvasGroup.Position = UDim2.new(0.5,0,0.5,0)
    CanvasGroup.Active = true
    CanvasGroup.AnchorPoint = Vector2.new(0.5,0.5)
    CanvasGroup.BackgroundColor3 = Color3.fromHex("#161616")
    CanvasGroup.BackgroundTransparency = .15

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        CanvasGroup.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
    end
    CanvasGroup.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = CanvasGroup.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    CanvasGroup.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    local UICorner = Instance.new("UICorner", CanvasGroup)
    UICorner.CornerRadius = UDim.new(0,12)
    
    local UIPadding = Instance.new("UIPadding", CanvasGroup)
    UIPadding.PaddingTop = UDim.new(0,14)
    UIPadding.PaddingLeft = UDim.new(0,14)
    UIPadding.PaddingRight = UDim.new(0,14)
    UIPadding.PaddingBottom = UDim.new(0,14)
    
    local UIListLayout = Instance.new("UIListLayout", CanvasGroup)
    UIListLayout.FillDirection = "Vertical"
    UIListLayout.SortOrder = "LayoutOrder"
    UIListLayout.Padding = UDim.new(0,16)
    
    local TextLabel = Instance.new("TextLabel", CanvasGroup)
    TextLabel.Size = UDim2.new(1,0,0,0)
    TextLabel.TextXAlignment = "Left"
    TextLabel.AutomaticSize = "Y"
    TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.new(1,1,1)
    TextLabel.Text = "Hurricane"
    TextLabel.TextSize = 22
    TextLabel.TextWrapped = true
    TextLabel.LayoutOrder = 1
    
    local ImageButton = Instance.new("ImageButton", TextLabel)
    ImageButton.Size = UDim2.new(0,TextLabel.AbsoluteSize.Y,0,TextLabel.AbsoluteSize.Y)
    ImageButton.Position = UDim2.new(1,0,0,0)
    ImageButton.AnchorPoint= Vector2.new(1,0)
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = "rbxassetid://10747384394"
    
    local Closed = false
    
    ImageButton.MouseButton1Click:Connect(function()
        if not Closed then
            TweenService:Create(CanvasGroup, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(
                    0,
                    TextLabel.TextBounds.X + UIPadding.PaddingLeft.Offset*3 + TextLabel.TextBounds.Y,
                    0,
                    TextLabel.TextBounds.Y + UIPadding.PaddingTop.Offset*2
                )
            }):Play()
            TweenService:Create(ImageButton, TweenInfo.new(.25), {Rotation = 45}):Play()
        else
            TweenService:Create(CanvasGroup, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = Size
            }):Play()
            
            TweenService:Create(ImageButton, TweenInfo.new(.25), {Rotation = 0}):Play()
        end
        Closed = not Closed
    end)
    
    local TextBoxCanvas = Instance.new("Frame", CanvasGroup)
    TextBoxCanvas.Size = UDim2.new(1,0,0,35)
    TextBoxCanvas.BackgroundColor3 = Color3.new(1,1,1)
    TextBoxCanvas.BackgroundTransparency = .95
    TextBoxCanvas.LayoutOrder = 2
    
    local TextBoxPadding = Instance.new("UIPadding", TextBoxCanvas)
    TextBoxPadding.PaddingTop = UDim.new(0,9)
    TextBoxPadding.PaddingLeft = UDim.new(0,12)
    TextBoxPadding.PaddingRight = UDim.new(0,12)
    TextBoxPadding.PaddingBottom = UDim.new(0,9)
    
    local UIStroke = Instance.new("UIStroke", TextBoxCanvas)
    UIStroke.Thickness = .6
    UIStroke.Color = Color3.new(1,1,1)
    UIStroke.Transparency = .8
    
    Instance.new("UICorner", TextBoxCanvas).CornerRadius = UDim.new(0,8)
    
    local TextBox = Instance.new("TextBox", TextBoxCanvas)
    TextBox.Size = UDim2.new(1,0,1,0)
    TextBox.TextWrapped = false
    TextBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(1,1,1)
    TextBox.PlaceholderText = "Enter player nickname..."
    TextBox.TextXAlignment = "Left"
    TextBox.TextSize = 18
    TextBox.BackgroundTransparency = 1
    TextBox.ClearTextOnFocus = false
    TextBox.ClipsDescendants = true
    TextBox.TextTruncate = Enum.TextTruncate.AtEnd
    
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            targetPlayer = getPlayer(TextBox.Text)
            if targetPlayer then
                TextBox.Text = targetPlayer.Name
                humanoidRootPart = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if CharacterAddedConnection then
                    CharacterAddedConnection:Disconnect()
                end
                CharacterAddedConnection = targetPlayer.CharacterAdded:Connect(function(character)
                    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                end)
                WindUI:Notify({
                    Title = "Player Found",
                    Content = "Target set to: " .. targetPlayer.Name,
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Player not found!",
                    Duration = 3
                })
            end
        end
    end)
    
    local BringButton = Instance.new("TextButton", CanvasGroup)
    BringButton.Size = UDim2.new(1,0,0,35)
    BringButton.Text = "Bring Parts | Off"
    BringButton.AutoButtonColor = false
    BringButton.TextColor3 = Color3.new(0,0,0)
    BringButton.BackgroundColor3 = ButtonColor
    BringButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    BringButton.TextSize = 18
    BringButton.LayoutOrder = 3
    
    BringButton.MouseEnter:Connect(function()
        TweenService:Create(BringButton, TweenInfo.new(.1), {
            BackgroundColor3 = Color3.new(
                ButtonColor.R-.4,
                ButtonColor.G-.4,
                ButtonColor.B-.4
            )
        }):Play()
    end)
    BringButton.MouseLeave:Connect(function()
        TweenService:Create(BringButton, TweenInfo.new(.1), {
            BackgroundColor3 = ButtonColor
        }):Play()
    end)
    
    BringButton.MouseButton1Click:Connect(function()
        if targetPlayer then
            toggleBlackHole()
            if blackHoleActive then
                BringButton.Text = "Bring Parts | On"
                BringButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
                WindUI:Notify({
                    Title = "Bring Parts",
                    Content = "Bring Parts activated for " .. targetPlayer.Name,
                    Duration = 3
                })
            else
                BringButton.Text = "Bring Parts | Off"
                BringButton.BackgroundColor3 = ButtonColor
                WindUI:Notify({
                    Title = "Bring Parts",
                    Content = "Bring Parts deactivated",
                    Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a valid player nickname first!",
                Duration = 3
            })
        end
    end)
    
    Instance.new("UICorner", BringButton).CornerRadius = UDim.new(0,8)
    
    local FooterLabel = Instance.new("TextLabel", CanvasGroup)
    FooterLabel.Size = UDim2.new(1,0,0,20)
    FooterLabel.TextXAlignment = "Center"
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.TextColor3 = Color3.new(1,1,1)
    FooterLabel.Text = "By PrespeshnikShashlika"
    FooterLabel.TextSize = 14
    FooterLabel.TextTransparency = 0.5
    FooterLabel.LayoutOrder = 4
    
    CanvasGroup.Size = UDim2.new(0,300,0,UIListLayout.AbsoluteContentSize.Y+15+15)
    Size = UDim2.new(0,300,0,UIListLayout.AbsoluteContentSize.Y+15+15)
end

UI()