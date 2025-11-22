--// Radar V5.5
local StarterGui = game:GetService("StarterGui")
local a,b,c,d,e,f=game:GetService("Players"),game.Players.LocalPlayer,game.Players.LocalPlayer:GetMouse(),workspace.CurrentCamera,game:GetService("RunService"),game:GetService("UserInputService")
repeat wait()until b.Character and b.Character.PrimaryPart
local g=loadstring(game:HttpGet("https://pastebin.com/raw/wRnsJeid"))():Lerp(Color3.new(1,0,0),Color3.new(0,1,0))
local h={
    Pos=Vector2.new(200,200),
    Rad=75,
    Scale=1,
    BG=Color3.fromRGB(10,10,10),
    Border=Color3.fromRGB(75,75,75),
    LPDot=Color3.new(1,1,1),
    PDot=Color3.fromRGB(60,170,255),
    Team=Color3.new(0,1,0),
    En=Color3.new(1,0,0),
    Health=true,
    TeamC=false,
    HeightIndicator=false,
    FriendHighlight=false
}

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = b:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local radarVisible = false
local radarLocked = false

local CoreGui = game:GetService("CoreGui")
local TopBarApp = CoreGui:WaitForChild("TopBarApp"):WaitForChild("TopBarApp")
local UnibarLeftFrame = TopBarApp:WaitForChild("UnibarLeftFrame")
local UnibarMenu = UnibarLeftFrame:WaitForChild("UnibarMenu")

local sausageHolder = UnibarMenu:WaitForChild("2")
local originalSize = sausageHolder.Size.X.Offset
local minimizedSize = UDim2.new(0, originalSize + 48, 0, sausageHolder.Size.Y.Offset)
local expandedSize = UDim2.new(0, originalSize + 270, 0, sausageHolder.Size.Y.Offset)

local buttonR = Instance.new("TextButton")
buttonR.Text = "R"
buttonR.Font = Enum.Font.Code
buttonR.TextSize = 20
buttonR.TextColor3 = Color3.new(1, 1, 1)
buttonR.Size = UDim2.new(0, 48, 0, 44)
buttonR.AnchorPoint = Vector2.new(0.5, 0.5)
buttonR.Position = UDim2.new(0, originalSize + 24, 0.5, 0)
buttonR.BackgroundTransparency = 1
buttonR.Parent = sausageHolder

local buttonL = Instance.new("TextButton")
buttonL.Text = "L"
buttonL.Font = Enum.Font.Code
buttonL.TextSize = 20
buttonL.TextColor3 = Color3.new(1, 1, 1)
buttonL.Size = UDim2.new(0, 36, 0, 36)
buttonL.AnchorPoint = Vector2.new(0.5, 0.5)
buttonL.Position = UDim2.new(0, originalSize + 72, 0.5, 0)
buttonL.BackgroundTransparency = 1
buttonL.Parent = sausageHolder
buttonL.Visible = false

local buttonT = Instance.new("TextButton")
buttonT.Text = "T"
buttonT.Font = Enum.Font.Code
buttonT.TextSize = 20
buttonT.TextColor3 = h.TeamC and Color3.new(0, 0, 1) or Color3.new(1, 1, 1)
buttonT.Size = UDim2.new(0, 36, 0, 36)
buttonT.AnchorPoint = Vector2.new(0.5, 0.5)
buttonT.Position = UDim2.new(0, originalSize + 120, 0.5, 0)
buttonT.BackgroundTransparency = 1
buttonT.Parent = sausageHolder
buttonT.Visible = false

local buttonH = Instance.new("TextButton")
buttonH.Text = "H"
buttonH.Font = Enum.Font.Code
buttonH.TextSize = 20
buttonH.TextColor3 = h.HeightIndicator and Color3.new(0, 1, 1) or Color3.new(1, 1, 1)
buttonH.Size = UDim2.new(0, 36, 0, 36)
buttonH.AnchorPoint = Vector2.new(0.5, 0.5)
buttonH.Position = UDim2.new(0, originalSize + 168, 0.5, 0)
buttonH.BackgroundTransparency = 1
buttonH.Parent = sausageHolder
buttonH.Visible = false

local buttonF = Instance.new("TextButton")
buttonF.Text = "F"
buttonF.Font = Enum.Font.Code
buttonF.TextSize = 20
buttonF.TextColor3 = h.FriendHighlight and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
buttonF.Size = UDim2.new(0, 36, 0, 36)
buttonF.AnchorPoint = Vector2.new(0.5, 0.5)
buttonF.Position = UDim2.new(0, originalSize + 216, 0.5, 0)
buttonF.BackgroundTransparency = 1
buttonF.Parent = sausageHolder
buttonF.Visible = false

local function toggleButtons(visible)
    buttonL.Visible = visible
    buttonT.Visible = visible
    buttonH.Visible = visible
    buttonF.Visible = visible
end

local function resizeFrame(targetSize)
    local startSize = sausageHolder.Size
    local startTime = tick()
    local duration = 0.2
    
    while tick() - startTime < duration do
        local progress = (tick() - startTime) / duration
        sausageHolder.Size = startSize:lerp(targetSize, progress)
        game:GetService("RunService").RenderStepped:wait()
    end
    sausageHolder.Size = targetSize
end

sausageHolder.Size = minimizedSize

buttonR.MouseButton1Click:Connect(function()
    radarVisible = not radarVisible
    buttonR.TextColor3 = radarVisible and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    
    if radarVisible then
        resizeFrame(expandedSize)
        toggleButtons(true)
    else
        resizeFrame(minimizedSize)
        toggleButtons(false)
    end
end)

buttonL.MouseButton1Click:Connect(function()
    radarLocked = not radarLocked
    buttonL.TextColor3 = radarLocked and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
end)

buttonT.MouseButton1Click:Connect(function()
    h.TeamC = not h.TeamC
    h.Health = not h.TeamC
    buttonT.TextColor3 = h.TeamC and Color3.new(0, 0, 1) or Color3.new(1, 1, 1)
end)

buttonH.MouseButton1Click:Connect(function()
    h.HeightIndicator = not h.HeightIndicator
    buttonH.TextColor3 = h.HeightIndicator and Color3.new(0, 1, 1) or Color3.new(1, 1, 1)
end)

buttonF.MouseButton1Click:Connect(function()
    h.FriendHighlight = not h.FriendHighlight
    buttonF.TextColor3 = h.FriendHighlight and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

local function i(j,k,l,m,n)
    local o=Drawing.new("Circle")
    o.Transparency=j
    o.Color=k
    o.Visible=false
    o.Thickness=n
    o.Position=Vector2.new(0,0)
    o.Radius=l
    o.NumSides=math.clamp(l*55/100,10,75)
    o.Filled=m
    return o 
end

local p,q=i(0.9,h.BG,h.Rad,true,1),i(0.75,h.Border,h.Rad,false,3)
p.Visible,q.Visible=radarVisible,radarVisible
p.Position,q.Position=h.Pos,h.Pos

local function r(s)
    local o=b.Character
    if o and o.PrimaryPart then 
        local t=o.PrimaryPart
        local u=Vector3.new(d.CFrame.Position.X,t.Position.Y,d.CFrame.Position.Z)
        local v=CFrame.new(t.Position,u)
        local w=v:PointToObjectSpace(s)
        return w.X,w.Z 
    end
    return 0,0 
end

local function createFriendSquare()
    local square = Drawing.new("Square")
    square.Thickness = 2
    square.Filled = false
    square.Visible = false
    square.Color = Color3.new(0, 1, 0)
    square.Size = Vector2.new(8, 8)
    return square
end

local function isFriend(player)
    return player:IsFriendsWith(b.UserId) and player ~= b
end

local function x(y)
    local z=i(1,h.PDot,3,true,1)
    local friendSquare = createFriendSquare()
    
    coroutine.wrap(function()
        local o
        o=e.RenderStepped:Connect(function()
            local A=y.Character
            if A and A:FindFirstChildOfClass("Humanoid")and A.PrimaryPart and A:FindFirstChildOfClass("Humanoid").Health>0 then 
                local B=A:FindFirstChildOfClass("Humanoid")
                local C=h.Scale
                local D,E=r(A.PrimaryPart.Position)
                local F=h.Pos-Vector2.new(D*C,E*C)
                
                local myHeight = b.Character and b.Character.PrimaryPart and b.Character.PrimaryPart.Position.Y or 0
                local theirHeight = A.PrimaryPart.Position.Y
                local heightDiff = theirHeight - myHeight
                
                local baseSize = 3
                if h.HeightIndicator then
                    local sizeMultiplier = 1 + math.clamp(math.abs(heightDiff) / 10, 0, 2) 
                    if heightDiff > 0 then
                        z.Radius = baseSize * sizeMultiplier
                    elseif heightDiff < 0 then
                        z.Radius = baseSize / sizeMultiplier
                    else
                        z.Radius = baseSize
                    end
                else
                    z.Radius = baseSize
                end
                
                if(F-h.Pos).magnitude<h.Rad-2 then 
                    z.Position=F
                    z.Visible=radarVisible and not (h.FriendHighlight and isFriend(y))
                    
                    if h.FriendHighlight and isFriend(y) then
                        local squareSize = 8
                        if h.HeightIndicator then
                            local sizeMultiplier = 1 + math.clamp(math.abs(heightDiff) / 10, 0, 2)
                            if heightDiff > 0 then
                                squareSize = 8 * sizeMultiplier
                            elseif heightDiff < 0 then
                                squareSize = 8 / sizeMultiplier
                            end
                        end
                        friendSquare.Size = Vector2.new(squareSize, squareSize)
                        friendSquare.Position = F - Vector2.new(squareSize/2, squareSize/2)
                        friendSquare.Visible = radarVisible
                        if h.TeamC then
                            friendSquare.Color = y.TeamColor.Color
                        else
                            friendSquare.Color = Color3.new(0, 1, 0)
                        end
                    else
                        friendSquare.Visible = false
                    end
                else 
                    local G=(h.Pos-F).magnitude
                    local H=(h.Pos-F).unit*(G-h.Rad)
                    local I=Vector2.new(F.X+H.X,F.Y+H.Y)
                    z.Position=I
                    z.Visible=radarVisible and not (h.FriendHighlight and isFriend(y))
                    
                    if h.FriendHighlight and isFriend(y) then
                        local squareSize = 8
                        if h.HeightIndicator then
                            local sizeMultiplier = 1 + math.clamp(math.abs(heightDiff) / 10, 0, 2)
                            if heightDiff > 0 then
                                squareSize = 8 * sizeMultiplier
                            elseif heightDiff < 0 then
                                squareSize = 8 / sizeMultiplier
                            end
                        end
                        friendSquare.Size = Vector2.new(squareSize, squareSize)
                        friendSquare.Position = I - Vector2.new(squareSize/2, squareSize/2)
                        friendSquare.Visible = radarVisible
                        if h.TeamC then
                            friendSquare.Color = y.TeamColor.Color
                        else
                            friendSquare.Color = Color3.new(0, 1, 0)
                        end
                    else
                        friendSquare.Visible = false
                    end
                end
                
                if h.TeamC then
                    z.Color = y.TeamColor.Color
                else
                    if h.Health then 
                        z.Color=g(B.Health/B.MaxHealth)
                    else
                        z.Color=h.PDot
                    end
                end
            else 
                z.Visible=false
                friendSquare.Visible = false
                if not a:FindFirstChild(y.Name)then 
                    z:Remove()
                    friendSquare:Remove()
                    o:Disconnect()
                end 
            end 
        end)
    end)()
end

for J,K in pairs(a:GetPlayers())do 
    if K~=b then 
        x(K)
    end 
end

local function L()
    local z=Drawing.new("Triangle")
    z.Visible=radarVisible
    z.Thickness=1
    z.Filled=true
    z.Color=h.LPDot
    z.PointA=h.Pos+Vector2.new(0,-6)
    z.PointB=h.Pos+Vector2.new(-3,6)
    z.PointC=h.Pos+Vector2.new(3,6)
    return z 
end

local M=L()
a.PlayerAdded:Connect(function(K)
    if K~=b then 
        x(K)
    end
    M:Remove()
    M=L()
end)

coroutine.wrap(function()
    e.RenderStepped:Connect(function()
        if M then 
            M.Visible = radarVisible
            M.Color=h.LPDot
            M.PointA=h.Pos+Vector2.new(0,-6)
            M.PointB=h.Pos+Vector2.new(-3,6)
            M.PointC=h.Pos+Vector2.new(3,6)
        end
        p.Visible = radarVisible
        q.Visible = radarVisible
        p.Position,q.Position=h.Pos,h.Pos
        p.Radius,q.Radius=h.Rad,h.Rad
        p.Color,q.Color=h.BG,h.Border 
    end)
end)()

local I=game:GetService("GuiService"):GetGuiInset()
local N,O=false,Vector2.new()
local touchStartPos, touchStartRadarPos

f.TouchStarted:Connect(function(touch)
    if not radarVisible or radarLocked then return end
    local touchPos = Vector2.new(touch.Position.X, touch.Position.Y + I.Y)
    if (touchPos - h.Pos).magnitude < h.Rad then
        touchStartPos = touchPos
        touchStartRadarPos = h.Pos
        N = true
    end
end)

f.TouchMoved:Connect(function(touch)
    if N and touchStartPos and touchStartRadarPos and radarVisible and not radarLocked then
        local touchPos = Vector2.new(touch.Position.X, touch.Position.Y + I.Y)
        local delta = touchPos - touchStartPos
        h.Pos = touchStartRadarPos + delta
    end
end)

f.TouchEnded:Connect(function()
    N = false
    touchStartPos = nil
    touchStartRadarPos = nil
end)

f.InputBegan:Connect(function(P)
    if not radarVisible or radarLocked then return end
    if P.UserInputType==Enum.UserInputType.MouseButton1 and(Vector2.new(c.X,c.Y+I.Y)-h.Pos).magnitude<h.Rad then 
        O=h.Pos-Vector2.new(c.X,c.Y)
        N=true 
    end 
end)

f.InputEnded:Connect(function(P)
    if P.UserInputType==Enum.UserInputType.MouseButton1 then 
        N=false 
    end 
end)

coroutine.wrap(function()
    local z=i(1,Color3.new(1,1,1),3,true,1)
    e.RenderStepped:Connect(function()
        if not radarVisible then 
            z.Visible = false
            return 
        end
        
        if(Vector2.new(c.X,c.Y+I.Y)-h.Pos).magnitude<h.Rad then 
            z.Position=Vector2.new(c.X,c.Y+I.Y)
            z.Visible=true 
        else 
            z.Visible=false 
        end
        if N and O and not radarLocked then
            h.Pos=Vector2.new(c.X,c.Y)+O 
        end 
    end)
end)()

local userId = game:GetService("Players"):GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Radar",
    Text = "Version V5.5",
    Icon = content,
    Duration = 7
})