local player = game.Players.LocalPlayer
local chr = player.Character or player.CharacterAdded:Wait()

local btool = Instance.new("Tool")
btool.Name = "Universal Click Fling Tool"
btool.RequiresHandle = false
btool.Parent = player.Backpack

local IsEquipped = false
local Mouse = player:GetMouse()

btool.Equipped:Connect(function()
    IsEquipped = true
end)

btool.Unequipped:Connect(function()
    IsEquipped = false
end)

btool.Activated:Connect(function()
    if not IsEquipped then return end
    
    local targetModel = Mouse.Target and Mouse.Target.Parent
    if not targetModel then return end
    
    while targetModel ~= nil do
        if targetModel:IsA("Model") and targetModel:FindFirstChild("HumanoidRootPart") and targetModel:FindFirstChildOfClass("Humanoid") then
            break
        end
        targetModel = targetModel.Parent
    end
    
    if not targetModel then return end
    
    local TargetRoot = targetModel.HumanoidRootPart
    
    local OldVelocity = chr.HumanoidRootPart.Velocity
    local OldPos = chr.HumanoidRootPart.CFrame
    
    local Running = game:GetService("RunService").Stepped:Connect(function(step)
        step = step - workspace.DistributedGameTime
        chr.HumanoidRootPart.CFrame = (TargetRoot.CFrame - Vector3.new(0, 1e6, 0) * step) + (TargetRoot.Velocity * (step * 30))
        chr.HumanoidRootPart.Velocity = Vector3.new(0, 1e6, 0)
    end)
    
    local startTime = tick()
    repeat
        task.wait()
    until tick() - startTime >= 8
    
    Running:Disconnect()
    
    local Restore = game:GetService("RunService").Stepped:Connect(function()
        chr.HumanoidRootPart.Velocity = OldVelocity
        chr.HumanoidRootPart.CFrame = OldPos
    end)
    
    task.wait(0.5)
    
    chr.HumanoidRootPart.Anchored = true
    Restore:Disconnect()
    chr.HumanoidRootPart.Anchored = false
    
    chr.HumanoidRootPart.Velocity = OldVelocity
    chr.HumanoidRootPart.CFrame = OldPos
end)