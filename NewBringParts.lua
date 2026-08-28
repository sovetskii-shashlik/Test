local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local function safeGui(name, displayOrder)
    local parent = PlayerGui
    pcall(function() local h=gethui(); if h then parent=h end end)
    local old=parent:FindFirstChild(name); if old then old:Destroy() end
    if parent~=PlayerGui then local o2=PlayerGui:FindFirstChild(name); if o2 then o2:Destroy() end end
    local sg=Instance.new("ScreenGui")
    sg.Name=name; sg.ResetOnSpawn=false; sg.DisplayOrder=displayOrder or 100; sg.IgnoreGuiInset=true
    sg.Parent=parent; return sg
end

-- LOADING SCREEN
local LoadSG=safeGui("BH_Loading",99999)
local Overlay=Instance.new("Frame",LoadSG)
Overlay.Size=UDim2.new(1,0,1,0); Overlay.BackgroundColor3=Color3.fromRGB(5,5,5); Overlay.BorderSizePixel=0

local Vignette=Instance.new("ImageLabel",Overlay)
Vignette.Size=UDim2.new(1,0,1,0); Vignette.BackgroundTransparency=1
Vignette.Image="rbxassetid://1316045217"; Vignette.ImageColor3=Color3.fromRGB(0,0,0)
Vignette.ImageTransparency=0.4; Vignette.ScaleType=Enum.ScaleType.Stretch

local Center=Instance.new("Frame",Overlay)
Center.Size=UDim2.new(0,300,0,220); Center.AnchorPoint=Vector2.new(0.5,0.5)
Center.Position=UDim2.new(0.5,0,0.5,0); Center.BackgroundTransparency=1

local Ring=Instance.new("ImageLabel",Center)
Ring.Size=UDim2.new(0,110,0,110); Ring.AnchorPoint=Vector2.new(0.5,0); Ring.Position=UDim2.new(0.5,0,0,0)
Ring.BackgroundTransparency=1; Ring.Image="rbxassetid://4965945816"
Ring.ImageColor3=Color3.fromRGB(200,25,25); Ring.ImageTransparency=0.15

local RingInner=Instance.new("ImageLabel",Center)
RingInner.Size=UDim2.new(0,72,0,72); RingInner.AnchorPoint=Vector2.new(0.5,0); RingInner.Position=UDim2.new(0.5,0,0,19)
RingInner.BackgroundTransparency=1; RingInner.Image="rbxassetid://4965945816"
RingInner.ImageColor3=Color3.fromRGB(255,70,70); RingInner.ImageTransparency=0.45

local CoreDot=Instance.new("Frame",Center)
CoreDot.Size=UDim2.new(0,16,0,16); CoreDot.AnchorPoint=Vector2.new(0.5,0.5)
CoreDot.Position=UDim2.new(0.5,0,0,55); CoreDot.BackgroundColor3=Color3.fromRGB(255,50,50); CoreDot.BorderSizePixel=0
Instance.new("UICorner",CoreDot).CornerRadius=UDim.new(1,0)

local LoadTitle=Instance.new("TextLabel",Center)
LoadTitle.Size=UDim2.new(1,0,0,34); LoadTitle.Position=UDim2.new(0,0,0,118); LoadTitle.BackgroundTransparency=1
LoadTitle.Font=Enum.Font.GothamBold; LoadTitle.Text="BLACKHOLE"; LoadTitle.TextColor3=Color3.fromRGB(255,255,255)
LoadTitle.TextSize=26; LoadTitle.TextXAlignment=Enum.TextXAlignment.Center

local LoadVer=Instance.new("TextLabel",Center)
LoadVer.Size=UDim2.new(1,0,0,16); LoadVer.Position=UDim2.new(0,0,0,152); LoadVer.BackgroundTransparency=1
LoadVer.Font=Enum.Font.Gotham; LoadVer.Text="V2.8  —  by Unknown"; LoadVer.TextColor3=Color3.fromRGB(170,25,25)
LoadVer.TextSize=11; LoadVer.TextXAlignment=Enum.TextXAlignment.Center

local BarBG=Instance.new("Frame",Center)
BarBG.Size=UDim2.new(1,0,0,4); BarBG.Position=UDim2.new(0,0,0,182)
BarBG.BackgroundColor3=Color3.fromRGB(28,28,28); BarBG.BorderSizePixel=0
Instance.new("UICorner",BarBG).CornerRadius=UDim.new(1,0)

local BarFill=Instance.new("Frame",BarBG)
BarFill.Size=UDim2.new(0,0,1,0); BarFill.BackgroundColor3=Color3.fromRGB(210,25,25); BarFill.BorderSizePixel=0
Instance.new("UICorner",BarFill).CornerRadius=UDim.new(1,0)

local LoadStatus=Instance.new("TextLabel",Center)
LoadStatus.Size=UDim2.new(1,0,0,14); LoadStatus.Position=UDim2.new(0,0,0,200); LoadStatus.BackgroundTransparency=1
LoadStatus.Font=Enum.Font.Gotham; LoadStatus.Text="Initializing..."; LoadStatus.TextColor3=Color3.fromRGB(100,100,100)
LoadStatus.TextSize=11; LoadStatus.TextXAlignment=Enum.TextXAlignment.Center

local ringAngle=0
local ringConn=RunService.RenderStepped:Connect(function(dt)
    ringAngle=ringAngle+dt*95; Ring.Rotation=ringAngle; RingInner.Rotation=-ringAngle*1.5
    local p=math.abs(math.sin(tick()*3.5))
    CoreDot.BackgroundColor3=Color3.fromRGB(160+math.floor(95*p),15+math.floor(35*p),15+math.floor(35*p))
end)

local LOAD_STEPS={
    {txt="Loading core modules...",      pct=0.17},
    {txt="Injecting physics engine...",  pct=0.36},
    {txt="Building prediction model...", pct=0.55},
    {txt="Setting up ESP layers...",     pct=0.73},
    {txt="Configuring UI...",            pct=0.89},
    {txt="Ready.",                       pct=1.00},
}
task.spawn(function()
    task.wait(0.25)
    for _,s in ipairs(LOAD_STEPS) do
        LoadStatus.Text=s.txt
        TweenService:Create(BarFill,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
            {Size=UDim2.new(s.pct,0,1,0)}):Play()
        task.wait(0.4)
    end
    task.wait(0.15)
    TweenService:Create(Overlay,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(150,15,15)}):Play()
    task.wait(0.08)
    TweenService:Create(Overlay,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(5,5,5)}):Play()
    task.wait(0.15)
    ringConn:Disconnect()
    TweenService:Create(Overlay,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
    TweenService:Create(Center,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(0.5,0,0.4,0)}):Play()
    task.wait(0.5); LoadSG:Destroy()
end)

-- MAIN GUI
local Gui=Instance.new("ScreenGui")
Gui.Name="BH_Gui_V280"; Gui.ResetOnSpawn=false; Gui.DisplayOrder=50; Gui.IgnoreGuiInset=true
pcall(function() Gui.Parent=gethui() end)
if not Gui.Parent then Gui.Parent=PlayerGui end

local Main=Instance.new("Frame",Gui)
Main.Name="BH_Main"; Main.Size=UDim2.new(0,220,0,175); Main.Position=UDim2.new(0,20,0,20)
Main.BackgroundColor3=Color3.fromRGB(12,12,12); Main.BorderSizePixel=0; Main.Active=true
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)

local TopStripe=Instance.new("Frame",Main)
TopStripe.Size=UDim2.new(1,0,0,3); TopStripe.BackgroundColor3=Color3.fromRGB(220,30,30); TopStripe.BorderSizePixel=0
Instance.new("UICorner",TopStripe).CornerRadius=UDim.new(0,10)

local Header=Instance.new("Frame",Main)
Header.Size=UDim2.new(1,0,0,36); Header.Position=UDim2.new(0,0,0,3)
Header.BackgroundColor3=Color3.fromRGB(18,18,18); Header.BorderSizePixel=0; Header.Active=true

local _dragging,_dragStart,_startPos=false,nil,nil
Header.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        _dragging=true; _dragStart=inp.Position; _startPos=Main.Position
        inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then _dragging=false end end)
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if _dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local d=inp.Position-_dragStart
        Main.Position=UDim2.new(_startPos.X.Scale,_startPos.X.Offset+d.X,_startPos.Y.Scale,_startPos.Y.Offset+d.Y)
    end
end)

local HeaderDot=Instance.new("Frame",Header)
HeaderDot.Size=UDim2.new(0,8,0,8); HeaderDot.Position=UDim2.new(0,12,0.5,-4)
HeaderDot.BackgroundColor3=Color3.fromRGB(220,30,30); HeaderDot.BorderSizePixel=0
Instance.new("UICorner",HeaderDot).CornerRadius=UDim.new(1,0)

task.spawn(function()
    while true do
        TweenService:Create(HeaderDot,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(255,80,80)}):Play()
        task.wait(0.8)
        TweenService:Create(HeaderDot,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(140,10,10)}):Play()
        task.wait(0.8)
    end
end)

local Label=Instance.new("TextLabel",Header)
Label.Size=UDim2.new(1,-30,1,0); Label.Position=UDim2.new(0,28,0,0); Label.BackgroundTransparency=1
Label.Font=Enum.Font.GothamBold; Label.Text="BLACKHOLE  V2.8"; Label.TextColor3=Color3.fromRGB(255,255,255)
Label.TextSize=13; Label.TextXAlignment=Enum.TextXAlignment.Left

local SubLabel=Instance.new("TextLabel",Header)
SubLabel.Size=UDim2.new(1,-30,0,12); SubLabel.Position=UDim2.new(0,28,1,-13); SubLabel.BackgroundTransparency=1
SubLabel.Font=Enum.Font.Gotham; SubLabel.Text="by Unknown"; SubLabel.TextColor3=Color3.fromRGB(140,140,140)
SubLabel.TextSize=10; SubLabel.TextXAlignment=Enum.TextXAlignment.Left

local Divider1=Instance.new("Frame",Main)
Divider1.Size=UDim2.new(1,-24,0,1); Divider1.Position=UDim2.new(0,12,0,42)
Divider1.BackgroundColor3=Color3.fromRGB(40,40,40); Divider1.BorderSizePixel=0

local TargetLabel=Instance.new("TextLabel",Main)
TargetLabel.Size=UDim2.new(1,-24,0,14); TargetLabel.Position=UDim2.new(0,12,0,50)
TargetLabel.BackgroundTransparency=1; TargetLabel.Font=Enum.Font.GothamBold
TargetLabel.Text="TARGET"; TargetLabel.TextColor3=Color3.fromRGB(220,30,30)
TargetLabel.TextSize=10; TargetLabel.TextXAlignment=Enum.TextXAlignment.Left

local Box=Instance.new("TextBox",Main)
Box.Size=UDim2.new(1,-24,0,28); Box.Position=UDim2.new(0,12,0,66)
Box.BackgroundColor3=Color3.fromRGB(22,22,22); Box.BorderSizePixel=0
Box.PlaceholderText="Enter player name..."; Box.PlaceholderColor3=Color3.fromRGB(70,70,70)
Box.Text=""; Box.TextColor3=Color3.fromRGB(255,255,255)
Box.Font=Enum.Font.Gotham; Box.TextSize=12; Box.ClearTextOnFocus=false
Instance.new("UICorner",Box).CornerRadius=UDim.new(0,6)

local BoxAccent=Instance.new("Frame",Box)
BoxAccent.Size=UDim2.new(0,2,0.6,0); BoxAccent.Position=UDim2.new(0,0,0.2,0)
BoxAccent.BackgroundColor3=Color3.fromRGB(220,30,30); BoxAccent.BorderSizePixel=0
Instance.new("UICorner",BoxAccent).CornerRadius=UDim.new(1,0)

local StatusRow=Instance.new("Frame",Main)
StatusRow.Size=UDim2.new(1,-24,0,16); StatusRow.Position=UDim2.new(0,12,0,98); StatusRow.BackgroundTransparency=1

local StatusDot=Instance.new("Frame",StatusRow)
StatusDot.Size=UDim2.new(0,6,0,6); StatusDot.Position=UDim2.new(0,0,0.5,-3)
StatusDot.BackgroundColor3=Color3.fromRGB(80,80,80); StatusDot.BorderSizePixel=0
Instance.new("UICorner",StatusDot).CornerRadius=UDim.new(1,0)

local StatusText=Instance.new("TextLabel",StatusRow)
StatusText.Size=UDim2.new(1,-14,1,0); StatusText.Position=UDim2.new(0,14,0,0)
StatusText.BackgroundTransparency=1; StatusText.Font=Enum.Font.Gotham
StatusText.Text="No target"; StatusText.TextColor3=Color3.fromRGB(100,100,100)
StatusText.TextSize=11; StatusText.TextXAlignment=Enum.TextXAlignment.Left

local Divider2=Instance.new("Frame",Main)
Divider2.Size=UDim2.new(1,-24,0,1); Divider2.Position=UDim2.new(0,12,0,120)
Divider2.BackgroundColor3=Color3.fromRGB(40,40,40); Divider2.BorderSizePixel=0

local BringBtn=Instance.new("TextButton",Main)
BringBtn.Size=UDim2.new(1,-24,0,34); BringBtn.Position=UDim2.new(0,12,0,128)
BringBtn.BackgroundColor3=Color3.fromRGB(180,20,20); BringBtn.BorderSizePixel=0
BringBtn.Font=Enum.Font.GothamBold; BringBtn.Text="▶  ACTIVATE"
BringBtn.TextColor3=Color3.fromRGB(255,255,255); BringBtn.TextSize=13
Instance.new("UICorner",BringBtn).CornerRadius=UDim.new(0,6)

local blackHoleActive=false

BringBtn.MouseEnter:Connect(function()
    if not blackHoleActive then TweenService:Create(BringBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(220,30,30)}):Play() end
end)
BringBtn.MouseLeave:Connect(function()
    if not blackHoleActive then TweenService:Create(BringBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(180,20,20)}):Play() end
end)

local STATUS_DOT_COLORS={
    Alive=Color3.fromRGB(80,220,80),   Sitting=Color3.fromRGB(255,200,50),
    Died=Color3.fromRGB(255,60,60),    Respawn=Color3.fromRGB(140,140,255),
    Left=Color3.fromRGB(120,120,120),  None=Color3.fromRGB(80,80,80),
}
local function updatePanelStatus(status,playerName)
    local col=STATUS_DOT_COLORS[status] or STATUS_DOT_COLORS.None
    StatusDot.BackgroundColor3=col
    if playerName and status~="None" then
        StatusText.Text=playerName.."  —  "..status; StatusText.TextColor3=col
    else
        StatusText.Text="No target"; StatusText.TextColor3=Color3.fromRGB(100,100,100)
    end
end

-- NOTIFICATIONS
local NotifSG=safeGui("BH_Notif",1000); NotifSG.IgnoreGuiInset=true
local NC=Instance.new("Frame",NotifSG)
NC.Size=UDim2.new(0,300,0,56); NC.AnchorPoint=Vector2.new(0.5,0)
NC.Position=UDim2.new(0.5,0,0,10); NC.BackgroundTransparency=1; NC.ClipsDescendants=false

local NotifCard=Instance.new("Frame",NC)
NotifCard.Size=UDim2.new(1,0,1,0); NotifCard.Position=UDim2.new(0,0,0,-70)
NotifCard.BackgroundColor3=Color3.fromRGB(16,16,16); NotifCard.BorderSizePixel=0
Instance.new("UICorner",NotifCard).CornerRadius=UDim.new(0,10)
Instance.new("UIGradient",NotifCard).Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(40,40,40)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(12,12,12)),
})

local NotifAccent=Instance.new("Frame",NotifCard)
NotifAccent.Size=UDim2.new(0,3,0.6,0); NotifAccent.Position=UDim2.new(0,10,0.2,0)
NotifAccent.BackgroundColor3=Color3.fromRGB(255,80,80); NotifAccent.BorderSizePixel=0
Instance.new("UICorner",NotifAccent).CornerRadius=UDim.new(1,0)

local NotifIcon=Instance.new("TextLabel",NotifCard)
NotifIcon.Size=UDim2.new(0,28,1,0); NotifIcon.Position=UDim2.new(0,18,0,0)
NotifIcon.BackgroundTransparency=1; NotifIcon.TextScaled=true
NotifIcon.Font=Enum.Font.GothamBold; NotifIcon.Text="●"; NotifIcon.TextColor3=Color3.new(1,1,1)

local NotifText=Instance.new("TextLabel",NotifCard)
NotifText.Size=UDim2.new(1,-58,1,0); NotifText.Position=UDim2.new(0,50,0,0)
NotifText.BackgroundTransparency=1; NotifText.TextXAlignment=Enum.TextXAlignment.Left
NotifText.TextScaled=true; NotifText.Font=Enum.Font.GothamBold
NotifText.Text=""; NotifText.TextColor3=Color3.new(1,1,1); NotifText.TextStrokeTransparency=0.6

local NotifBar=Instance.new("Frame",NotifCard)
NotifBar.Size=UDim2.new(1,-16,0,3); NotifBar.Position=UDim2.new(0,8,1,-5)
NotifBar.BackgroundColor3=Color3.fromRGB(255,80,80); NotifBar.BorderSizePixel=0
Instance.new("UICorner",NotifBar).CornerRadius=UDim.new(1,0)

local NOTIF_CFG={
    target={icon="🎯",color=Color3.fromRGB(255,80,80)},   on={icon="🌀",color=Color3.fromRGB(100,180,255)},
    off={icon="⛔",color=Color3.fromRGB(120,120,120)},     warn={icon="⚠️",color=Color3.fromRGB(255,180,50)},
    err={icon="❌",color=Color3.fromRGB(200,60,60)},       alive={icon="✅",color=Color3.fromRGB(80,220,80)},
    sitting={icon="💺",color=Color3.fromRGB(255,210,50)},  died={icon="💀",color=Color3.fromRGB(255,60,60)},
    respawn={icon="🔄",color=Color3.fromRGB(140,140,255)}, left={icon="🚪",color=Color3.fromRGB(160,160,160)},
}
local HIDDEN=UDim2.new(0,0,0,-70); local SHOWN=UDim2.new(0,0,0,0)
local nTweenIn,nTweenBar,nTweenOut,nThread=nil,nil,nil,nil

local function showNotif(msg,ntype)
    local cfg=NOTIF_CFG[ntype] or {icon="●",color=Color3.fromRGB(200,200,200)}
    if nTweenIn  then nTweenIn:Cancel();    nTweenIn=nil  end
    if nTweenBar then nTweenBar:Cancel();   nTweenBar=nil end
    if nTweenOut then nTweenOut:Cancel();   nTweenOut=nil end
    if nThread   then task.cancel(nThread); nThread=nil   end
    NotifCard.Position=HIDDEN
    NotifText.Text=msg; NotifIcon.Text=cfg.icon
    NotifAccent.BackgroundColor3=cfg.color; NotifBar.BackgroundColor3=cfg.color
    NotifBar.Size=UDim2.new(1,-16,0,3)
    nTweenIn=TweenService:Create(NotifCard,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=SHOWN})
    nTweenIn:Play()
    nTweenBar=TweenService:Create(NotifBar,TweenInfo.new(2.7,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,3)})
    task.delay(0.3,function() if nTweenBar then nTweenBar:Play() end end)
    nThread=task.delay(3,function()
        nTweenOut=TweenService:Create(NotifCard,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=HIDDEN})
        nTweenOut:Play()
        nTweenOut.Completed:Connect(function() nTweenOut=nil; nThread=nil end)
    end)
end

-- ESP
local tName=Drawing.new("Text");   tName.Size=14;   tName.Center=true;   tName.Outline=true;   tName.Visible=false
local tDist=Drawing.new("Text");   tDist.Size=12;   tDist.Center=true;   tDist.Outline=true;   tDist.Visible=false
local tStatus=Drawing.new("Text"); tStatus.Size=12; tStatus.Center=true; tStatus.Outline=true; tStatus.Visible=false
local Highlight=Instance.new("Highlight",game:GetService("CoreGui"))
Highlight.FillColor=Color3.new(1,0,0)
Highlight.OutlineColor=Color3.fromRGB(255,80,80)

-- ARROW
local ArrowSG=safeGui("BH_Arrow",100); ArrowSG.IgnoreGuiInset=true
local ArrowFrame=Instance.new("Frame",ArrowSG)
ArrowFrame.Size=UDim2.new(0,40,0,40); ArrowFrame.BackgroundTransparency=1
ArrowFrame.Visible=false; ArrowFrame.AnchorPoint=Vector2.new(0.5,0.5)

local ArrowImg=Instance.new("ImageLabel",ArrowFrame)
ArrowImg.Size=UDim2.new(1,0,1,0); ArrowImg.BackgroundTransparency=1
ArrowImg.Image="rbxassetid://6034818379"; ArrowImg.ImageColor3=Color3.fromRGB(255,60,60)
ArrowImg.AnchorPoint=Vector2.new(0.5,0.5); ArrowImg.Position=UDim2.new(0.5,0,0.5,0)

local ArrowDist=Instance.new("TextLabel",ArrowFrame)
ArrowDist.Size=UDim2.new(1,0,0.4,0); ArrowDist.Position=UDim2.new(0,0,1.1,0)
ArrowDist.BackgroundTransparency=1; ArrowDist.TextColor3=Color3.fromRGB(255,255,255)
ArrowDist.TextScaled=true; ArrowDist.Font=Enum.Font.GothamBold
ArrowDist.Text=""; ArrowDist.TextStrokeTransparency=0

local ArrowStatus=Instance.new("TextLabel",ArrowFrame)
ArrowStatus.Size=UDim2.new(2,0,0.4,0); ArrowStatus.Position=UDim2.new(-0.5,0,1.55,0)
ArrowStatus.BackgroundTransparency=1; ArrowStatus.TextColor3=Color3.fromRGB(255,255,100)
ArrowStatus.TextScaled=true; ArrowStatus.Font=Enum.Font.GothamBold
ArrowStatus.Text=""; ArrowStatus.TextStrokeTransparency=0

local EDGE_PADDING=60
local function getScreenEdgePosition(worldPos)
    local vp=Camera.ViewportSize; local cx,cy=vp.X/2,vp.Y/2
    local sp,inFront=Camera:WorldToViewportPoint(worldPos)
    local dx,dy=sp.X-cx,sp.Y-cy
    if not inFront then dx=-dx; dy=-dy end
    local len=math.sqrt(dx*dx+dy*dy)
    if len==0 then return Vector2.new(cx,cy),0 end
    local ndx,ndy=dx/len,dy/len
    local scaleX=ndx~=0 and ((ndx>0 and vp.X-EDGE_PADDING-cx or cx-EDGE_PADDING)/math.abs(ndx)) or math.huge
    local scaleY=ndy~=0 and ((ndy>0 and vp.Y-EDGE_PADDING-cy or cy-EDGE_PADDING)/math.abs(ndy)) or math.huge
    local sc=math.min(scaleX,scaleY)
    return Vector2.new(cx+ndx*sc,cy+ndy*sc),math.deg(math.atan2(ndy,ndx))+90
end

-- TARGET STATUS
local STATUS_COLORS={
    Alive=Color3.fromRGB(100,255,100), Sitting=Color3.fromRGB(255,200,50),
    Died=Color3.fromRGB(255,80,80),    Respawn=Color3.fromRGB(180,180,255),
    Left=Color3.fromRGB(180,180,180),
}
local STATUS_NOTIFTYPE={Alive="alive",Sitting="sitting",Died="died",Respawn="respawn",Left="left"}
local STATUS_MSG={Alive="Target is Alive",Sitting="Target is Sitting",Died="Target Died",Respawn="Target Respawning",Left="Target Left"}
local currentStatus="Alive"; local previousStatus="Alive"; local targetPlayer=nil

local function getTargetStatus(player)
    if not player then return "Left" end
    local found=false
    for _,p in pairs(Players:GetPlayers()) do if p==player then found=true; break end end
    if not found then return "Left" end
    local char=player.Character; if not char then return "Respawn" end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return "Respawn" end
    if hum.Health<=0 then return "Died" end
    if hum.Sit then return "Sitting" end
    return "Alive"
end

local function handleStatusTransition(newStatus)
    if newStatus~=previousStatus then
        previousStatus=newStatus; currentStatus=newStatus
        if targetPlayer then
            showNotif(STATUS_MSG[newStatus] or newStatus,STATUS_NOTIFTYPE[newStatus] or "warn")
            updatePanelStatus(newStatus,targetPlayer.Name)
        end
    end
end

Players.PlayerRemoving:Connect(function(p)
    if p==targetPlayer then handleStatusTransition("Left") end
end)

-- =============================================
-- ANCHOR PART — AlignPosition pulls toward this
-- Moves to target HumanoidRootPart every frame
-- =============================================
local AnchorFolder=Instance.new("Folder",Workspace)
AnchorFolder.Name="BH_Folder"
local AnchorPart=Instance.new("Part",AnchorFolder)
AnchorPart.Name="BH_Anchor"
AnchorPart.Anchored=true
AnchorPart.CanCollide=false
AnchorPart.Transparency=1
AnchorPart.Size=Vector3.new(1,1,1)
AnchorPart.CFrame=CFrame.new(0,-9999,0)
local AnchorAttachment=Instance.new("Attachment",AnchorPart)

-- =============================================
-- NETWORK — SimulationRadius + Velocity trick
-- from the reference script
-- =============================================
if not getgenv().BH_Net then
    getgenv().BH_Net=true
    RunService.Heartbeat:Connect(function()
        pcall(function()
            sethiddenproperty(LocalPlayer,"SimulationRadius",math.huge)
        end)
    end)
end

local function IsPlayerPart(part)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then return true end
    end
    return false
end

-- =============================================
-- PART REGISTRY
-- Each part gets AlignPosition + Torque
-- pointing at AnchorPart — real blackhole pull
-- =============================================
local registeredParts={}

local function CleanupPart(part)
    if not part or not part.Parent then return end
    pcall(function()
        for _,c in ipairs(part:GetChildren()) do
            if c.Name=="BH_Att" or c.Name=="BH_Align" or c.Name=="BH_Torque" then
                c:Destroy()
            end
        end
        part.CanCollide=true
        part.Massless=false
        if part:FindFirstChild("CustomPhysicalProperties") then
            part.CustomPhysicalProperties=PhysicalProperties.new(0.7,0.3,0.5,0.1,0.1)
        end
    end)
    registeredParts[part]=nil
end

local function RegisterPart(part)
    if not part or not part:IsA("BasePart") then return end
    if part.Anchored or part==AnchorPart or IsPlayerPart(part) or registeredParts[part] then return end
    -- skip tool handles so weapons don't fly off
    if part.Name=="Handle" then return end
    if part.Parent and part.Parent:FindFirstChildOfClass("Humanoid") then return end
    if part.Parent and part.Parent:FindFirstChild("Head") then return end
    registeredParts[part]=true
    pcall(function()
        -- destroy existing movers
        for _,x in ipairs(part:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") or x:IsA("Constraint") then
                x:Destroy()
            end
        end
        pcall(function() part:SetNetworkOwner(LocalPlayer) end)
        part.CanCollide=false
        part.Massless=true
        part.CustomPhysicalProperties=PhysicalProperties.new(0,0,0,0,0)

        -- Attachment on part
        local att=Instance.new("Attachment",part); att.Name="BH_Att"

        -- AlignPosition — unlimited force, pulls to AnchorAttachment
        local ap=Instance.new("AlignPosition",part); ap.Name="BH_Align"
        ap.MaxForce    = math.huge
        ap.MaxVelocity = math.huge
        ap.Responsiveness = 200
        ap.Attachment0 = att
        ap.Attachment1 = AnchorAttachment

        -- Torque — spins part so it looks like real debris
        local tq=Instance.new("Torque",part); tq.Name="BH_Torque"
        tq.Torque=Vector3.new(100000,100000,100000)
        tq.Attachment0=att
    end)
    part.AncestryChanged:Connect(function()
        if not part:IsDescendantOf(Workspace) then registeredParts[part]=nil end
    end)
end

-- SCAN LOOP
task.spawn(function()
    while true do
        task.wait(0.5)
        if not blackHoleActive then continue end
        local items=Workspace:GetDescendants()
        for i,v in ipairs(items) do
            if v:IsA("BasePart") and not v.Anchored
               and not IsPlayerPart(v)
               and v~=AnchorPart
               and v.Name~="Handle"
               and not (v.Parent and v.Parent:FindFirstChildOfClass("Humanoid"))
               and not registeredParts[v] then
                RegisterPart(v)
            end
            if i%150==0 then RunService.Heartbeat:Wait() end
        end
    end
end)

Workspace.DescendantAdded:Connect(function(v)
    if blackHoleActive and v:IsA("BasePart") then
        task.defer(function() RegisterPart(v) end)
    end
end)

-- =============================================
-- FLING SYSTEM
-- Every 0.15s snap closest part onto target
-- and blast all body parts upward
-- AlignPosition handles the visual pull,
-- fling system guarantees the hit
-- =============================================
local FLING_POWER    = 6000
local FLING_INTERVAL = 0.15
local targetPos      = Vector3.new(0,-9999,0)
local lastFlingTime  = 0

RunService.Heartbeat:Connect(function()
    if not blackHoleActive then return end
    local now=tick()

    -- Move anchor to target every frame — this is what pulls all parts
    AnchorPart.CFrame=CFrame.new(targetPos)

    -- Find closest part for fling hit
    local closestPart=nil
    local closestDist=math.huge
    for part in pairs(registeredParts) do
        if part and part.Parent then
            local d=(part.Position-targetPos).Magnitude
            if d<closestDist then closestDist=d; closestPart=part end
        else
            registeredParts[part]=nil
        end
    end

    -- Timed fling hit
    if now-lastFlingTime>=FLING_INTERVAL and closestPart then
        if targetPlayer and targetPlayer.Character then
            local root2=targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root2 then
                lastFlingTime=now
                pcall(function() closestPart.CFrame=CFrame.new(root2.Position) end)
                local rx=(math.random()-0.5)*2
                local rz=(math.random()-0.5)*2
                local flingDir=Vector3.new(rx,1.5,rz).Unit
                pcall(function()
                    for _,bp in ipairs(targetPlayer.Character:GetDescendants()) do
                        if bp:IsA("BasePart") then
                            bp.AssemblyLinearVelocity=flingDir*FLING_POWER
                        end
                    end
                end)
                pcall(function()
                    local diff=targetPos-closestPart.Position
                    if diff.Magnitude>0 then
                        closestPart.CFrame=CFrame.new(targetPos-diff.Unit*60)
                    end
                end)
            end
        end
    end
end)

-- RENDER LOOP
RunService.RenderStepped:Connect(function()
    local char=targetPlayer and targetPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local status=getTargetStatus(targetPlayer)
    handleStatusTransition(status); currentStatus=status

    if not targetPlayer or status=="Left" then
        Highlight.Enabled=false
        tName.Visible=false; tDist.Visible=false; tStatus.Visible=false
        ArrowFrame.Visible=false; return
    end
    if not (root and hum) then
        Highlight.Enabled=false
        tName.Visible=false; tDist.Visible=false; tStatus.Visible=false
        ArrowFrame.Visible=false; return
    end

    local alive=hum.Health>0
    local sp,onScreen=Camera:WorldToViewportPoint(root.Position)

    if onScreen and alive then
        Highlight.Adornee=char; Highlight.Enabled=true
        tName.Visible=true; tName.Text=targetPlayer.Name
        tName.Position=Vector2.new(sp.X,sp.Y-50); tName.Color=Color3.new(1,1,1)
        tDist.Visible=true; tDist.Text=math.floor((root.Position-Camera.CFrame.Position).Magnitude).."m"
        tDist.Position=Vector2.new(sp.X,sp.Y-35); tDist.Color=Color3.new(1,1,1)
        tStatus.Visible=true; tStatus.Text="[ "..status.." ]"
        tStatus.Position=Vector2.new(sp.X,sp.Y-20)
        tStatus.Color=STATUS_COLORS[status] or Color3.new(1,1,1)
        ArrowFrame.Visible=false
    else
        Highlight.Enabled=false
        tName.Visible=false; tDist.Visible=false; tStatus.Visible=false
        local ep,ang=getScreenEdgePosition(root.Position)
        ArrowFrame.Visible=true
        ArrowFrame.Position=UDim2.new(0,ep.X,0,ep.Y); ArrowImg.Rotation=ang
        ArrowDist.Text=math.floor((root.Position-Camera.CFrame.Position).Magnitude).."m"
        ArrowStatus.Text=status; ArrowStatus.TextColor3=STATUS_COLORS[status] or Color3.new(1,1,1)
    end

    if alive then
        targetPos=root.Position+Vector3.new(0,1,0)
    end
end)

-- UI BINDINGS
BringBtn.MouseButton1Click:Connect(function()
    if not targetPlayer then showNotif("No target selected!","warn"); return end
    blackHoleActive=not blackHoleActive
    if blackHoleActive then
        BringBtn.Text="⏹  DEACTIVATE"
        BringBtn.BackgroundColor3=Color3.fromRGB(30,30,30)
        BringBtn.TextColor3=Color3.fromRGB(220,30,30)
        showNotif("Blackhole ON","on")
        task.spawn(function()
            local items=Workspace:GetDescendants()
            for i,v in ipairs(items) do
                if v:IsA("BasePart") and not v.Anchored
                   and not IsPlayerPart(v)
                   and v~=AnchorPart
                   and v.Name~="Handle"
                   and not (v.Parent and v.Parent:FindFirstChildOfClass("Humanoid"))
                   and not registeredParts[v] then
                    RegisterPart(v)
                end
                if i%100==0 then RunService.Heartbeat:Wait() end
            end
        end)
    else
        BringBtn.Text="▶  ACTIVATE"
        BringBtn.BackgroundColor3=Color3.fromRGB(180,20,20)
        BringBtn.TextColor3=Color3.fromRGB(255,255,255)
        AnchorPart.CFrame=CFrame.new(0,-9999,0)
        targetPos=Vector3.new(0,-9999,0)
        task.delay(0.8,function()
            for part in pairs(registeredParts) do CleanupPart(part) end
            registeredParts={}
        end)
        showNotif("Blackhole OFF","off")
    end
end)

Box.FocusLost:Connect(function(enter)
    if not enter then return end
    local t=Box.Text:lower()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and (p.Name:lower():find(t) or p.DisplayName:lower():find(t)) then
            targetPlayer=p; Box.Text=p.Name
            currentStatus="Alive"; previousStatus="Alive"
            updatePanelStatus("Alive",p.Name)
            showNotif("Target: "..p.DisplayName,"target")
            return
        end
    end
    showNotif("Player not found","err")
end)