local player = game:GetService("Players").LocalPlayer

local DoorOpenerTool = Instance.new("Tool")
DoorOpenerTool.Name = "Door Opener"
DoorOpenerTool.RequiresHandle = false
DoorOpenerTool.Parent = player.Backpack

player.CharacterAdded:Connect(function()
    DoorOpenerTool.Parent = player.Backpack
end)

local function findDoorClickDetector(target)
    if not target then return nil end
    
    local keycodeModel = target:FindFirstAncestorOfClass("Model")
    if not keycodeModel then return nil end
    
    local openPart = keycodeModel:FindFirstChild("Open", true)
    return openPart and openPart:FindFirstChildOfClass("ClickDetector")
end

DoorOpenerTool.Activated:Connect(function()
    local target = player:GetMouse().Target
    if not target then return end
    
    local clickDetector = findDoorClickDetector(target)
    if clickDetector then
        fireclickdetector(clickDetector)
    end
end)