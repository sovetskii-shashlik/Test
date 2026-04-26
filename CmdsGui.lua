--// Shashlik cmds Gui V1.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer
local currentInput = ""

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CMDSGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 125)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui
local dragDetector = Instance.new("UIDragDetector", frame)
frame.Active = true
frame.Draggable = true
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Commands"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
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

frame.UICorner:GetPropertyChangedSignal("CornerRadius"):Connect(function()
    borderCorner.CornerRadius = frame.UICorner.CornerRadius
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

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 4)
minimizeCorner.Parent = toggleMinimizeBtn

local invisibleExpandBtn = Instance.new("TextButton")
invisibleExpandBtn.Size = UDim2.new(1, 0, 1, 0)
invisibleExpandBtn.Position = UDim2.new(0, 0, 0, 0)
invisibleExpandBtn.BackgroundTransparency = 1
invisibleExpandBtn.Text = ""
invisibleExpandBtn.TextTransparency = 1
invisibleExpandBtn.Visible = false
invisibleExpandBtn.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, 30)
inputBox.Position = UDim2.new(0.05, 0, 0, 40)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.Text = ""
inputBox.PlaceholderText = "enter command (;cmds and f9)"
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

inputBox.TextScaled = false
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Code

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 80)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Execute"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = frame
toggleBtn.Font = Enum.Font.Code
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn
toggleBtn.TextSize = 14
local isMinimized = false
local originalSize = frame.Size
local originalTitle = title.Text

local function toggleMinimize()
    isMinimized = not isMinimized

    local elementsToHide = {
        inputBox, toggleBtn
    }

    if isMinimized then
        title.Text = "CMDS"
        title.TextSize = 18
        title.Size = UDim2.new(1, 0, 1, 0)
        title.Position = UDim2.new(0, 0, 0, 0)

        for _, element in ipairs(elementsToHide) do
            if element then
                element.Visible = false
            end
        end

        local startSize = frame.Size
        local targetSize = UDim2.new(0, 60, 0, 30)

        for i = 0, 1, 0.075 do
            local newHeight = math.floor(startSize.Y.Offset + (30 - startSize.Y.Offset) * i)
            frame.Size = UDim2.new(
                startSize.X.Scale + (targetSize.X.Scale - startSize.X.Scale) * i,
                math.floor(startSize.X.Offset + (60 - startSize.X.Offset) * i),
                0, newHeight
            )
            task.wait(0.01)
        end

        frame.Size = UDim2.new(0, 60, 0, 30)

        invisibleExpandBtn.Size = UDim2.new(1, 0, 1, 0)
        invisibleExpandBtn.Position = UDim2.new(0, 0, 0, 0)
        invisibleExpandBtn.Visible = true
        invisibleExpandBtn.Active = true

        toggleMinimizeBtn.Visible = false
    else
        toggleMinimizeBtn.Visible = true

        local startSize = frame.Size
        for i = 0, 1, 0.075 do
            frame.Size = UDim2.new(
                startSize.X.Scale + (originalSize.X.Scale - startSize.X.Scale) * i,
                math.floor(startSize.X.Offset + (originalSize.X.Offset - startSize.X.Offset) * i),
                startSize.Y.Scale + (originalSize.Y.Scale - startSize.Y.Scale) * i,
                math.floor(startSize.Y.Offset + (originalSize.Y.Offset - startSize.Y.Offset) * i)
            )
            task.wait(0.01)
        end

        frame.Size = originalSize
        title.Text = originalTitle
        title.TextSize = 18
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 5)
        invisibleExpandBtn.Visible = false

        for _, element in ipairs(elementsToHide) do
            if element then element.Visible = true end
        end
    end
end

toggleMinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

invisibleExpandBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        toggleMinimize()
    end
end)

local commands = {
    ";dhex", ";qcmd", ";straw", ";harked", ";krunox", ";comet",
    ";avtor", ";gh", ";na2", ";inf", ";na1", ";le", ";tfling", ";fly", ";sfly", ";fly2", ";sfly2", ";rtt", ";rkt", ";conprint", ";caranims",
    ";tfling2", ";bp1", ";bp2", ";bp3", ";bp4", ";bp5", ";bp6", ";bp7", ";bp8", ";bp9", ";bhtool", ";mvtool", ";grtool", ";tel1", ";tel2", ";glios", ";cmds", ";hth", ";antierr", ";HDAcmdbar", ";AKA",
    ";zomb", ";search", ";knpc", ";jerk", ";punch", ";invis2", ";invis", ";invis3", ";tel3", ";roa", ";akp1", ";akp2", ";akp3", ";keyb3", ";keyb4", ";cvb", ";ska", ";reach", ";reach2", ";reach3", ";reach4", ";hitbox", ";aimbot", ";aimlock", ";cfling", ";finger", ";finger2", ";spdmtr", ";gripfling",
    ";prox", ";rochips", ";fc1", ";fc2", ";synapse", ";synapse2", ";krnl", ";krnlk", ";bypass", ";fc3", ";rp", ";rp2", ";srp", ";srp2", ";tictactoe", ";illus", ";toolgui", ";keyb", ";cspy", ";slock", ";wibtt", ";acl", ";crouch", ";srp3", ";srp4", ";tptool", ";ngp", ";fling", ";esp", ";radar", ";OCDtool", ";fc4", ";guneditor",
    ";rc7", ";cunc", ";keyb2", ";na3", ";backpack", ";backpack2", ";r15anims", ";knpc2", ";conchat",
    ";hydroxide", ";rspy", ";sspyV3", ";dex++", ";dex", ";darkdex", ";sspy", ";sspym", ";sigma (rip)", ";cobalt", ";sspym2", ";sspym3", ";sspym4", ";silentspy", ";saveexec",
}

local function executeCode(code)
    if code == ";cmds" then
        print("Существующие команды:\n" .. table.concat(commands, "\n"))
        inputBox.Text = "Commands printed to F9!"
    elseif code == ";tptool" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Tptool/refs/heads/main/Tptool"))()
    elseif code == ";jerk" then
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") and localPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
            loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
        else
            loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
        end
    elseif code == ";synapse" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Synapse-x/refs/heads/main/Synapse%20x"))()
    elseif code == ";saveexec" then
        loadstring(game:HttpGet("https://weirdgirl.site/banana.lua"))()
    elseif code == ";conprint" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/FE-console-typer/raw/refs/heads/main/Console%20printer"))()
    elseif code == ";antierr" then
        loadstring(game:HttpGet("https://glot.io/snippets/hcfoitpvco/raw/AntiError.lua"))()
    elseif code == ";caranims" then
        local a,b,e=loadstring,http.request,"https://%74%31%70%2E%64%65/%43%61%72%41%6E%69%6D%73"
a(b({Url=e}).Body)()
        elseif code == ";krunox" then
            local a,b,e=loadstring,http.request,"https://github.com/sovetskii-shashlik/Test/raw/main/eaakrun"
a(b({Url=e}).Body)()
    elseif code == ";guneditor" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/Test/raw/main/gun_settings"))()
    elseif code == ";HDAcmdbar" then
        local a,b,e=loadstring,http.request,"https://ogy.de/HDAdminCMDBAR"
a(b({Url=e}).Body)()
    elseif code == ";slock" then
        loadstring(game:HttpGet("https://glot.io/snippets/h9d5rkcl47/raw/ShiftLock.lua"))()
    elseif code == ";cspy" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/CHAT%20SPY%20-%202025/ChatSpy2025.lua"))()
        elseif code == ";harked" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/JxcExploit/Harkedv2-script/main/Leaked-v2hardked"))()
        elseif code == ";comet" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE/main/Comet"))()
    elseif code == ";dhex" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/Destructed-hex/raw/refs/heads/main/Destructed%20hex%20gui"))()
    elseif code == ";straw" then
        loadstring(game:HttpGet("https://github.com/C-Dr1ve/Strawberry/raw/refs/heads/main/Scanner_Source/V3.00.lua"))()
    elseif code == ";fc4" then
        loadstring(game:HttpGet("https://pastebin.com/raw/H3281zhD"))()
    elseif code == ";r15anims" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
    elseif code == ";aimbot" then
        loadstring(game:HttpGet("https://glot.io/snippets/h7sums3610/raw/ArceusAimModified.lua"))()
    elseif code == ";aimlock" then
        loadstring(game:HttpGet("https://glot.io/snippets/h91wfidbpz/raw/aimlock.lua"))()
    elseif code == ";dex" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    elseif code == ";darkdex" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
    elseif code == ";dex++" then
        loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
    elseif code == ";cobalt" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/Test/raw/main/cobalt.lua"))()
    elseif code == ";sigma (rip)" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Sigma-Spy/refs/heads/main/Main.lua"))()
    elseif code == ";sspym" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wfrefdewwss/Discord-Custom-Status-24-7/refs/heads/main/requirements.txt"))()
    elseif code == ";sspym2" then
        loadstring(game:HttpGet("https://github.com/caomod2077/Script/raw/main/RemoteSpy-V2.lua.txt?ysclid=mi9m0t96c728523456"))()
    elseif code == ";sspym3" then
        loadstring(game:HttpGet("https://github.com/Footagesus/random-scripts/raw/main/RedZHub%2FMobileSpy.lua"))()
    elseif code == ";sspym4" then
        loadstring(game:HttpGet("https://github.com/kuro5222/Kuro/raw/refs%2Fheads%2Fmain/RSpy.txt"))()
    elseif code == ";sspy" then
        loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
    elseif code == ";sspyV3" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
    elseif code == ";rspy" then
        loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
    elseif code == ";hydroxide" then
        loadstring(game:HttpGet("https://paste.myconan.net/617098.txt "))()
    elseif code == ";silentspy" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FryzerHub/Biggestscript/refs/heads/main/SilentSpy"))()
    elseif code == ";knpc2" then
        loadstring(game:HttpGet("https://paste.myconan.net/611639.txt"))()
    elseif code == ";OCDtool" then
        loadstring(game:HttpGet("https://glot.io/snippets/h9l8vsvzz6/raw/OCDT.lua"))()
    elseif code == ";esp" then
        loadstring(game:HttpGet("https://glot.io/snippets/h8wks8n8p4/raw/Esp.lua"))()
    elseif code == ";hitbox" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/Hitblox/refs/heads/main/Hitblox"))()
    elseif code == ";cvb" then
        loadstring(game:HttpGet("https://glot.io/snippets/h7je4skic1/raw/cvb.lua"))()
    elseif code == ";ska" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/InstantKillig/refs/heads/main/Coolkillguithingy"))()
    elseif code == ";reach" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wuxuin/Reach-sword/refs/heads/main/Reach%20sword"))()
    elseif code == ";reach2" then
        loadstring(game:HttpGet("https://glot.io/snippets/h7i90cj5s8/raw/reach.lua"))()
    elseif code == ";reach3" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/Test/raw/main/ReachSwordNew.lua"))()
    elseif code == ";reach4" then
        loadstring(game:HttpGet("https://pastebin.com/raw/CCh9W9Tt", true))()
    elseif code == ";cfling" then
        loadstring(game:HttpGet("https://glot.io/snippets/h7t99b052l/raw/FlingTool.lua"))()
    elseif code == ";finger" then
        loadstring(game:HttpGet("https://gitlab.com/sovetskii-shashlik/fingerguiv3/-/raw/main/FingerGuiV3.lua"))()
    elseif code == ";finger2" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ChomikDev/ShitScripts/refs/heads/main/Finger%20FE.lua', true))()
    elseif code == ";spdmtr" then
        loadstring(game:HttpGet("https://pastebin.com/raw/WYi7Bm8u"))()
    elseif code == ";fly2" then
        loadstring(game:HttpGet("https://glot.io/snippets/h9empzjulm/raw/FlyGui.lua"))()
    elseif code == ";invis3" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/Invis/refs/heads/main/Invistoggle"))()
    elseif code == ";fling" then
        loadstring(game:HttpGet("https://glot.io/snippets/h86gnsdgud/raw/FlingGui.lua"))()
    elseif code == ";ngp" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/Gravity-inverter/refs/heads/main/GI"))()
    elseif code == ";rkt" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/RTT-Tool/main/RKT%20Tool"))()
    elseif code == ";radar" then
        loadstring(game:HttpGet("https://glot.io/snippets/h94bz03sm6/raw/Radar.lua"))()
    elseif code == ";bp5" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/Shashlik-bring-parts/raw/refs/heads/main/Shashlik%20Bring%20Parts%20v2"))()
    elseif code == ";bp6" then
        loadstring(game:HttpGet("https://glot.io/snippets/h6k1ijlqsv/raw/vagina.lua"))()
    elseif code == ";bp7" then
        loadstring(game:HttpGet("https://pastebin.com/raw/bbBracWG"))()
    elseif code == ";bp8" then
        loadstring(game:HttpGet("https://glot.io/snippets/h6k1ijlqsv/raw/klitor.lua"))()
    elseif code == ";bp9" then
        loadstring(game:HttpGet("https://glot.io/snippets/h6k1ijlqsv/raw/moshonka.lua"))()
    elseif code == ";synapse2" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Chillz-s-scripts/main/Synapse-X-Remake.lua"))()
    elseif code == ";krnl" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Chillz-s-scripts/refs/heads/main/KRNL%20UI%20Remake.lua"))()
    elseif code == ";mvtool" then
        loadstring(game:HttpGet("https://pastefy.app/Vcuyg09O/raw"))()
    elseif code == ";krnlk" then
        loadstring(game:HttpGet("https://pastebin.com/raw/DfjrwJie"))()
    elseif code == ";akp3" then
        loadstring(game:HttpGet("https://pastebin.com/raw/DfjrwJie"))()
    elseif code == ";rtt" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/RTT-Tool/refs/heads/main/RTT%20Tool"))()
    elseif code == ";bhtool" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Blackhole/refs/heads/main/Blackhole"))()
    elseif code == ";bypass" then
        loadstring(game:HttpGet'https://raw.githubusercontent.com/m1kp0/universal_scripts/refs/heads/main/chat_bypass.lua')()
    elseif code == ";keyb2" then
        loadstring(game:HttpGet("https://github.com/ltseverydayyou/uuuuuuu/raw/refs/heads/main/VirtualKeyboard.lua"))()
    elseif code == ";na3" then
        loadstring(game:HttpGet("https://github.com/ltseverydayyou/Nameless-Admin/raw/refs/heads/main/Source.lua"))()
    elseif code == ";backpack" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/mobileBACKPACK.lua"))()
    elseif code == ";backpack2" then
        loadstring(game:HttpGet("https://glot.io/snippets/h9u1v79k2y/raw/CusInv.lua"))()
    elseif code == ";acl" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/AntiChatLogger.lua"))()
    elseif code == ";srp4" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Avtor-ring-parts-Updated/refs/heads/main/Avtor%20ring%20parts"))()
    elseif code == ";qcmd" then
        loadstring(game:HttpGet("https://gist.github.com/someunknowndude/38cecea5be9d75cb743eac8b1eaf6758/raw"))()
    elseif code == ";knpc" then
        loadstring(game:HttpGet("https://pastebin.com/raw/DcSXwXqC"))()
    elseif code == ";grtool" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/GrabTool/refs/heads/main/GrabToolFix"))()
    elseif code == ";gripfling" then
        loadstring(game:HttpGet("https://paste.myconan.net/646147.txt"))()
    elseif code == ";srp2" then
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Open-Source-Ring-Parts-26702"))()
    elseif code == ";toolgui" then
        loadstring(game:HttpGet("https://pastebin.com/raw/ZvstfPXM"))()
    elseif code == ";srp3" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/sovetskii-shashlik/Super-ring-parts-without-massage/refs/heads/main/Super%20ring%20parts'))()
    elseif code == ";illus" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_11l7Y131YqJjZ31QmV5L8pI23V02b3191sEg26E75472Wl78Vi8870jRv5txZyL1.lua.txt"))()
    elseif code == ";hth" then
        loadstring(game:HttpGet('https://pastefy.app/tI5b3OVD/raw'))()
    elseif code == ";bp4" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/Shashlik-bring-parts/raw/refs/heads/main/Shashlik%20bring%20parts"))()
    elseif code == ";rc7" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE/main/rc7"))()
    elseif code == ";search" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher"))()
    elseif code == ";crouch" then
        loadstring(game:HttpGet("https://pastebin.com/raw/sebBaBWi"))()
    elseif code == ";rp2" then
        loadstring(game:HttpGet("https://pastefy.app/hdd1kF9c/raw"))("T.me/AvtorScripts")
    elseif code == ";zomb" then
        loadstring(game:HttpGet('https://pastefy.app/w7KnPY70/raw'))()
    elseif code == ";rp" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Ritual-parts/refs/heads/main/Ritual%20parts%20without%20message"))()
    elseif code == ";wibtt" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/BaconBossScript/Crazy/main/Crazy'))()
    elseif code == ";keyb" then
        loadstring(game:HttpGet('https://pastefy.app/Te4dwSw2/raw'))()
    elseif code == ";roa" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/new/refs/heads/main/cmd.lua"))()
    elseif code == ";fly" then
        loadstring(game:HttpGet('https://pastefy.app/M0N30XXG/raw'))()
    elseif code == ";srp" then
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-SUPER-RING-PARTS-V3-WITH-NO-MESSAGE-26385"))()
    elseif code == ";fc1" then
        loadstring(game:HttpGet('https://pastefy.app/9CDN9Kaj/raw'))()
    elseif code == ";fc2" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zephyr10101/CameraSpy/main/Script"))()
    elseif code == ";fc3" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Freecam'))()
    elseif code == ";sfly" then
        loadstring(game:HttpGet("https://glot.io/snippets/h8id91ebrx/raw/supermanfly.lua"))()
    elseif code == ";sfly2" then
        loadstring(game:HttpGet("https://glot.io/snippets/hag0gpvlf0/raw/sfly2.lua"))()
    elseif code == ";tfling" then
        loadstring(game:HttpGet("https://pastebin.com/raw/rfKaavP3"))()
    elseif code == ";tfling2" then
        loadstring(game:HttpGet('https://pastebin.com/raw/TXMNj1yy'))()
    elseif code == ";conchat" then
        loadstring(game:HttpGet("https://github.com/sovetskii-shashlik/FE-console-typer/raw/main/chat.lua"))()
    elseif code == ";avtor" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Avtor1zaTion/Avtor/main/AvtorHub'))()
    elseif code == ";gh" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
    elseif code == ";keyb3" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Ata/main/deltakeyboardcrack.txt"))()
    elseif code == ";keyb4" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt"))()
    elseif code == ";na2" then
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Nameless-admin-14114"))()
    elseif code == ";tictactoe" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Tic%20Tac%20Toe'))()
    elseif code == ";inf" then
        loadstring(game:HttpGet("https://github.com/mxsynry/infiniteyield-reborn/raw/refs/heads/master/source"))()
    elseif code == ";na1" then
        loadstring(game:HttpGet("https://github.com/Silly-Exploiter/NamedAdmin/raw/refs/heads/main/Script"))()
    elseif code == ";le" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Lelele-bypasser/refs/heads/main/LeLeBypasser.txt"))()
    elseif code == ";bp1" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))()
    elseif code == ";bp2" then
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Better-Bring-Parts-Ui-SOLARA-and-Fixed-Lags-21780"))()
    elseif code == ";bp3" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GoofyBlox/GoofyZ/refs/heads/main/Best/VorteX.lua"))()
    elseif code == ";tel1" then
        loadstring(game:HttpGet("https://rawscripts.net/raw/a-literal-baseplate.-FE-Telekinesis-15523"))()
    elseif code == ";tel2" then
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty11.lua"))()
    elseif code == ";glios" then
        writefile(".nonecing", "white")
        loadstring(game:HttpGet('https://glot.io/snippets/gua2ntmbdm/raw/main.lua'))()
    elseif code == ";punch" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE/main/punch",true))()
    elseif code == ";akp1" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zephyr10101/ignore-touchinterests/main/main", true))()
    elseif code == ";akp2" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sovetskii-shashlik/Anti-kill-parts-updated-/refs/heads/main/Anti%20kill%20parts%20by%20Zephyr"))()
    elseif code == ";tel3" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sakupenXD/SakupScripts/main/Telekinesis"))()
    elseif code == ";invis" then
        loadstring(game:HttpGet("https://pastebin.com/raw/3Rnd9rHf"))()
    elseif code == ";cunc" then
        loadstring(game:HttpGet("https://glot.io/snippets/h4d9a8gprw/raw/main.lua"))()
    elseif code == ";prox" then
        for i,v in ipairs(workspace:GetDescendants()) do
            if v.ClassName == "ProximityPrompt" then
                v.HoldDuration = 0
            end
        end
    elseif code == ";invis2" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CloudHub111/Scripts/refs/heads/main/Fe%20Invisible%20Beta", Beta))()
    elseif code == ";rochips" then
        local z_x,z_z="gzrux646yj/raw/main.ts","https://glot.io/snippets/"
        local im,lonely,z_c=task.wait,game,loadstring
        z_c(lonely:HttpGet(z_z..""..z_x))()
        return ("This will load in about 2 - 30 seconds" or "according to your device and executor")
    else
        local success, errorMessage = pcall(function()
            loadstring(code)()
        end)
        if not success then
            warn("Execution error:", errorMessage)
        end
    end
end

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = inputBox.Text
        if text and text ~= "" then
            executeCode(text)
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    local text = inputBox.Text
    if text and text ~= "" then
        executeCode(text)
    else
        executeCode(";cmds")
    end
end)

local userId = Players:GetUserIdFromNameAsync("prespeshnikShashlika")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "CMDS GUI",
    Text = "version V1.0",
    Icon = content,
    Duration = 7
})

toggleMinimize()

return {
    executeCode = executeCode,
    commands = commands
}