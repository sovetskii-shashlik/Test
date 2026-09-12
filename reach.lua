--// reach sword
local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "Aura!"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.5, -25)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 8)
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Color = Color3.new(1, 1, 1)
uiStroke.Thickness = 2
local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0.6, 0)
textBox.Position = UDim2.new(0.1, 0, 0.2, 0)
textBox.BackgroundTransparency = 1
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.Text = "5"
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
local dragDetector = Instance.new("UIDragDetector", frame)
local visualizer = Instance.new("Part")
visualizer.Name = "ReachSphere"
visualizer.BrickColor = BrickColor.Red()
visualizer.Transparency = 0.6
visualizer.Anchored = true
visualizer.CanCollide = false
visualizer.Shape = Enum.PartType.Ball
visualizer.Material = Enum.Material.ForceField
visualizer.BottomSurface = Enum.SurfaceType.Smooth
visualizer.TopSurface = Enum.SurfaceType.Smooth
visualizer.CastShadow = false
visualizer.Parent = workspace
local function updateSphereSize(reach)
    visualizer.Size = Vector3.new(reach, reach, reach)
end
local function onHit(hit, handle)
    local char = hit.Parent
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid and char.Name ~= plr.Name then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                firetouchinterest(part, handle, 0)
                firetouchinterest(part, handle, 1)
            end
        end
    end
end
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    local reach = tonumber(textBox.Text)
    if reach then
        updateSphereSize(reach)
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
    if not tool then
        visualizer.Parent = nil
        return
    end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
    if handle then
        visualizer.Parent = workspace
        local reach = tonumber(textBox.Text) or 5
        visualizer.CFrame = handle.CFrame
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= plr then
                local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local mag = (hrp.Position - handle.Position).Magnitude
                    if mag <= reach then
                        onHit(hrp, handle)
                    end
                end
            end
        end
    end
end)