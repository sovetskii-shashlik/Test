--[[
 _______  _______  _______  _______ _________          _______  _______  _          _______  _______          
(  ____ \(  ____ )(  ___  )(  ____ \\__   __/|\     /|(  ___  )(  ___  )| \    /\  (  ____ \(  ____ )|\     /|
| (    \/| (    )|| (   ) || (    \/   ) (   | )   ( || (   ) || (   ) ||  \  / /  | (    \/| (    )|( \   / )
| (__    | (____)|| |   | || (_____    | |   | (___) || |   | || |   | ||  (_/ /   | (_____ | (____)| \ (_) / 
|  __)   |     __)| |   | |(_____  )   | |   |  ___  || |   | || |   | ||   _ (    (_____  )|  _____)  \   /  
| (      | (\ (   | |   | |      ) |   | |   | (   ) || |   | || |   | ||  ( \ \         ) || (         ) (   
| )      | ) \ \__| (___) |/\____) |   | |   | )   ( || (___) || (___) ||  /  \ \  /\____) || )         | |   
|/       |/   \__/(_______)\_______)   )_(   |/     \|(_______)(_______)|_/    \/  \_______)|/          \_/   

~ Nootchtai; 12/13/2019;

~ KNOWN BUGS ~
    * Dropdown showing up even when not hovered on a target frame.
    * PROTMOSASHER: Can't track Http (they're protected)
~ FIXED ~
	* Fixed dropdown menu not working sometimes.

Possbile future features:
    Upvalue scanning
    Viewing all hooks in real time in an output style window
Not yet implemented:
    /shrug
--[==[Mandatory Functions for operation]==]--
        * hookfunction
        * newcclosure
        * getreg
        * setclipboard
        * setreadonly
        * checkcaller
        * debug library (period)
]]--

local FrostHook = {
    Tooltips = true, -- Tooltips for understanding what certain buttons do.
    Monitoring = { -- What remotes/bindables to monitor.
        ["RemoteEvent"]=true, -- :FireServer(arguments)
        ["RemoteFunction"]=true, -- :InvokeServer(arguments)
        ["BindableEvent"]=true, -- :Fire(arguments)
        ["BindableFunction"]=true, -- :Invoke(arguments)
        ["__namecall"]=true, -- FireServer(remote, arguments)
        -- maybe hook __index?? /shrug
        ["HttpGet"]=true, -- game:HttpGet(...)
        ["HttpPost"]=true, -- game:HttpPost(...)
        ["GetObjects"]=true, -- game:GetObjects(...)
    },
    Ignored_Remotes = { -- Ignore remotes by name
        -- ROBLOCK CHAT STUFFS
        ["GetInitDataRequest"]=true,
        ["MutePlayerRequest"]=true,
        ["UnMutePlayerRequest"]=true,
        ["ChannelNameColorUpdated"]=true,
        ["OnChannelJoined"]=true,
        ["OnChannelLeft"]=true,
        ["OnMainChannelSet"]=true,
        ["OnMessageDoneFiltering"]=true,
        ["OnMuted"]=true,
        ["OnNewMessage"]=true,
        ["OnNewSystemMessage"]=true,
        ["MessagesChanged"]=true,
        ["MessagePosted"]=true,
        ["ChatBarFocusChanged"]=true,
        ["OnUnmuted"]=true,
        ["SayMessageRequest"]=true,
        ["SetBlockedUserIdsRequest"]=true,
        -- /shrug
        ["Event"]=true, -- nani wonder where this is comin from
    },
    Data_Type_Colors = { -- The colors of the data types in the call viewer (unknown will be white)
        ["string"] = Color3.fromRGB(85, 170, 127),
        ["table"] = Color3.fromRGB(60, 60, 60),
        ["boolean"] = Color3.fromRGB(85, 170, 255),
    },
    EditorColors = { -- The color types for the Code editor
        ["Word"] = Color3.fromRGB(58, 117, 175),
        ["Nil"] = Color3.fromRGB(115, 115, 172),
        ["Table"] = Color3.fromRGB(181, 120, 90),
        ["Scope"] = Color3.fromRGB(194, 64, 97),
        ["Comment"] = Color3.fromRGB(50, 50, 50),
        ["String"] = Color3.fromRGB(85, 170, 127),
    },
    RemoteColors = { -- The colors for the remotes in the Cache + List views.
        ["RemoteEvent"] = Color3.fromRGB(85, 170, 255),
        ["RemoteFunction"] = Color3.fromRGB(85, 170, 255),
        ["BindableEvent"] = Color3.fromRGB(85, 170, 255),
        ["BindableFunction"] = Color3.fromRGB(85, 170, 255),
    },
    HttpColors = {
        ["HttpGet"] = Color3.fromRGB(85, 170, 255),
        ["HttpPost"] = Color3.fromRGB(85, 170, 255),
        ["GetObjects"] = Color3.fromRGB(85, 170, 255),
    },
    Constraints = { -- Interface Constraints for resizing.
        Min = UDim2.new(0,400,0,250),
        Max = UDim2.new(0,800,0,500)
    },
    env = { -- Inherited from Hydroxide.
        get_upvalues = debug.getupvalues or getupvalues or getupvals or false, -- 
        get_upvalue = debug.getupvalue or getupvalue or getupval or false, --
        get_metatable = getrawmetatable or debug.getmetatable or false, --
        get_namecall = getnamecallmethod or get_namecall_method or false, --
        get_reg = getreg or debug.getregistry or false, --
        set_readonly = setreadonly or ((make_writeable and make_readonly) and function(t,b) if b then return make_readonly(t) else return make_writeable(t) end end) or false, --
        is_l_closure = islclosure or is_l_closure or (iscclosure and function(closure) return not iscclosure(closure) end) or false, --
        is_x_closure = is_synapse_function or is_protosmasher_closure or issentinelclosure or false, --
        hook_function = hookfunction or hookfunc or detour_function or false, --
        new_cclosure = newcclosure or function(t) return t end or false, -- why proto why
        to_clipboard = (syn and syn.write_clipboard) or writeclipboard or toclipboard or setclipboard or false, --
        check_caller = checkcaller or is_protosmasher_caller or false, --
    },
    Services = setmetatable({},{__index = function(self, index)
        return game:GetService(index) or nil;
    end}),

    -- Internals --
    Search_Directories = {
        game:GetService("ReplicatedStorage"),
        game:GetService("Players").LocalPlayer,
        game:GetService("Players").LocalPlayer.Character,
    },
    Cache = {
        _entry = nil,
    },
    HttpCache = {
        _entry = nil,
    },
    Hook_Cache = {},
    FireCounts = {
        ["RemoteEvent"] = 0,
        ["RemoteFunction"] = 0,
        ["BindableEvent"] = 0,
        ["BindableFunction"] = 0,
        ["HttpGet"] = 0,
        ["HttpPost"] = 0,
        ["GetObjects"] = 0,
        _updated = false,
        _latest = false,
    },
    RemoteFuncRef = {
        ["RemoteFunction"] = "InvokeServer",
        ["RemoteEvent"] = "FireServer",
        ["BindableFunction"] = "Invoke",
        ["BindableEvent"] = "Fire",
    },
    HttpFuncRef = {
        ["GetObjects"] = game.GetObjects,
        ["HttpGet"] = game.HttpGet,
        ["HttpPost"] = game.HttpPost,
    },
    Internal_Ignored = {},
    Interface = game:GetObjects("rbxassetid://4507087024")[1],
    Connections = {},
    CustomDrag = {
        DragActive = {},
        ResizeActive = {},
    },
    ScriptGeneration = {
        AppendBeginning = "\n", -- These two will be for appending comments to the beggining/end of the generated script.
        AppendEnding = "\n",
    },
    TextEditor = {
        Interface = script.Parent,
        TabSize = 8,
        Font = "SourceSansSemibold",
        FontSize = 14,
        Cache = {},
        LineCache = {_len=0},
        Imported = false,
    },
}

FrostHook.Keywords = { -- Keyword string matching for code editor.
    ["and"] = {FrostHook.EditorColors.Word, "[%s-]", "[%s-]"},
    ["break"] = {FrostHook.EditorColors.Word, "[%s?%p?]","[%s?%p?]"},
    ["do"] = {FrostHook.EditorColors.Word, "%s*", "[%s]"},
    ["if"] = {FrostHook.EditorColors.Word, "%s*", "[%s]"},
    ["else"] = {FrostHook.EditorColors.Word, "[%s]", "[%s]"},
    ["elseif"] = {FrostHook.EditorColors.Word, "[%s]", "[%s]"},
    ["then"] = {FrostHook.EditorColors.Word, "[%s]", "[%s]"},
    ["end"] = {FrostHook.EditorColors.Word, "%s*%p*", "[%s-%p-]"},
    ["true"] = {FrostHook.EditorColors.Nil, "%s*", "[%s-%p-]"},
    ["false"] = {FrostHook.EditorColors.Nil, "%s*", "[%s-%p-]"},
    ["for"] = {FrostHook.EditorColors.Word, "%s*", "%s"},
    ["function"] = {FrostHook.EditorColors.Word, "%s?%p?", "[%s?%p?]"},
    ["in"] = {FrostHook.EditorColors.Word, ".", "[%s]"},
    ["local"] = {FrostHook.EditorColors.Scope, "%s?", "[%s]"},
    ["nil"] = {FrostHook.EditorColors.Nil, "%s?", "[%s?%p?]"},
    ["not"] = {FrostHook.EditorColors.Word, "[%s?%p?]", "[%s?%p?]"},
    ["or"] = {FrostHook.EditorColors.Word, "[%s]", "[%s]"},
    ["repeat"] = {FrostHook.EditorColors.Word, "%s*%p*", "[%s]"},
    ["return"] = {FrostHook.EditorColors.Word, "[%s]", "[%s?%p?]"},
    ["until"] = {FrostHook.EditorColors.Word, "[%s]", "[%s]"},
    ["while"] = {FrostHook.EditorColors.Word, "[%s]*", "[%s]*"},

    ["self"] = {FrostHook.EditorColors.Nil, "", ""},
    ["game"] = {FrostHook.EditorColors.Word, "", ""},
    ["script"] = {FrostHook.EditorColors.Word, "", ""},

    ["table"] = {FrostHook.EditorColors.Table, "[.]*", "%."},
    ["math"] = {FrostHook.EditorColors.Table, "[.]*", "%."},
    ["string"] = {FrostHook.EditorColors.Table, "[.]*", "%."},

    ["print"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["loadstring"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["tostring"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["dofile"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["require"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["tonumber"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["writefile"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
    ["readfile"] = {FrostHook.EditorColors.Word, "[.]*", "[%p]"},
}

for i,v in next, FrostHook.env do
    assert(v, "Your exploit does not support FrostHook's Spy Tool :(")
end

repeat 
    wait()
until game:IsLoaded();

local Mouse = FrostHook.Services.Players.LocalPlayer:GetMouse();

do -- FrostHook Main Object
    local metadata = {};
    local methods = {
        Destroy = function(self)
            getgenv().FrostHookSpy = nil;
            self.Interface:Destroy();
            for _,Connection in pairs(self.Connections) do
                Connection:Disconnect();
            end
            self:StopTracking();
            FrostHook = nil;
        end,
        RegisterConnection = function(self, event, runtime_func)
            local connection;
            connection = event:Connect(function(...)
                local arguments = {...}
                local status,error_msg = pcall(function()
                    return runtime_func(unpack(arguments))
                end);
                if not status then
                    warn("Connection fault: "..tostring(error_msg))
                    for i,v in pairs(FrostHook.Connections) do
                        if v == connection then
                            table.remove(FrostHook.Connections, i)
                            v:Disconnect();
                        end
                    end
                end
            end)
            table.insert(self.Connections, connection);
            return connection;
        end,
        RequestCache = function(self, reqtype, varargs)
            if self.HttpCache[reqtype] then
                table.insert(self.HttpCache[reqtype].Logs, varargs)
                self.FireCounts[reqtype] = self.FireCounts[reqtype] - self.HttpCache[reqtype].FireCount;
                self.HttpCache[reqtype].FireCount = #self.HttpCache[reqtype].Logs;
                self.FireCounts[reqtype] = self.FireCounts[reqtype] + self.HttpCache[reqtype].FireCount;
                self.FireCounts["_latest"]:Fire(reqtype); -- hmmm idk about this
                self.HttpCache[reqtype].Updated:Fire("Add", varargs);
                self.FireCounts._updated:Fire(true);
            elseif not self.HttpCache[reqtype] then
                local updated = Instance.new("BindableEvent")
                updated.Name = "Updated";
                self.Internal_Ignored[updated] = true;

                self.HttpCache[reqtype] = {
                    Logs = {
                        varargs,
                    },
                    Spying = true,
                    FireCount = 1,
                    Updated = updated;
                }

                self.FireCounts[reqtype] = self.FireCounts[reqtype] + 1;
                self.FireCounts._updated:Fire(true);
            end
        end,
        ClearRequestCache = function(self, reqtype)
            if self.HttpCache[reqtype] then
                self.HttpCache[reqtype].Logs = {};
                self.FireCounts[reqtype] = self.FireCounts[reqtype] - self.HttpCache[reqtype].FireCount;
                self.HttpCache[reqtype].FireCount = 0;
                self.HttpCache[reqtype].Updated:Fire("Clear");
                self.FireCounts._updated:Fire();
            end
        end,
        CacheData = function(self, remote, varargs, populate)
            if populate and not self.Cache[remote] then -- populate the cache with already known remotes/bindables
                local updated = Instance.new("BindableEvent")
                updated.Name = "Updated";
                self.Internal_Ignored[updated] = true;

                self.Cache[remote] = {
                    Logs = {},
                    Spying = true,
                    FireCount = 0,
                    Updated = updated,
                }
                return;
            end

            if self.Cache[remote] then
                local s,e = pcall(function()
                    table.insert(self.Cache[remote].Logs, varargs)
                    self.FireCounts[remote.ClassName] = self.FireCounts[remote.ClassName] - self.Cache[remote].FireCount; -- take away old firecount
                    self.Cache[remote].FireCount = #self.Cache[remote].Logs;
                    self.FireCounts[remote.ClassName] = self.FireCounts[remote.ClassName] + self.Cache[remote].FireCount; -- add new firecount
                    self.FireCounts["_latest"]:Fire(remote); -- The latest updated remote

                    self.Cache[remote].Updated:Fire("Add", varargs);
                    self.FireCounts._updated:Fire(true);
                end)
                if not s then
                    warn("FH Cache error: ", e);
                end
            else -- First time set-up for the unexpected data.
                self.FireCounts[remote.ClassName] = self.FireCounts[remote.ClassName] + 1;

                local updated = Instance.new("BindableEvent")
                updated.Name = "Updated";
                self.Internal_Ignored[updated] = true;

                self.Cache[remote] = {
                    Logs = {
                        varargs,
                    },
                    Spying = true,
                    FireCount = 1,
                    Updated = updated,
                }
            end
        end,
        ClearCacheData = function(self, remote)
            if self.Cache[remote] then
                self.Cache[remote].Logs = {}; -- clear cache
                self.FireCounts[remote.ClassName] = self.FireCounts[remote.ClassName] - self.Cache[remote].FireCount;
                self.Cache[remote].FireCount = 0;
                self.Cache[remote].Updated:Fire("Clear");
                self.FireCounts._updated:Fire();
            end
        end,
        IsRemote = function(self, obj)
            return obj.ClassName == "RemoteEvent" or obj.ClassName == "RemoteFunction" or obj.ClassName == "BindableEvent" or obj.ClassName == "BindableFunction" 
        end,
        TrackHttp = function(self)
            for name,func in pairs(self.HttpFuncRef) do
                if self.Monitoring[name] then
                    pcall(function()
                        local temp_hook;
                        temp_hook = self.env.hook_function(func, self.env.new_cclosure(function(req, ...)
                            local varargs = {...}
                            if self.HttpCache[name] and self.HttpCache[name].Spying then
                                self:RequestCache(name, varargs);
                            elseif not self.HttpCache[name] then
                                self:RequestCache(name, varargs);
                            end
                            return temp_hook(name, ...)
                        end))
                        self.Hook_Cache[name] = temp_hook;
                    end);
                end
            end
        end,
        TrackRemotes = function(self)
            local to_hook = {
                ["RemoteEvent"] = Instance.new("RemoteEvent").FireServer,
                ["RemoteFunction"] = Instance.new("RemoteFunction").InvokeServer,
                ["BindableEvent"] = Instance.new("BindableEvent").Fire,
                ["BindableFunction"] = Instance.new("BindableFunction").Invoke,
            }
        
            for class,func in pairs(to_hook) do
                if self.Monitoring[class] then
                    local temp_hook;
                    temp_hook = self.env.hook_function(func, self.env.new_cclosure(function(remote, ...)
                        local varargs = {...};
                        if self.env.check_caller() or (self.Internal_Ignored[remote]) then
                            return temp_hook(remote, ...);
                        end

                        if not(self.Ignored_Remotes[remote.Name]) then
                            if self.Cache[remote] and self.Cache[remote].Spying then
                                self:CacheData(remote, varargs)
                            elseif not self.Cache[remote] then
                                self:CacheData(remote, varargs)
                            end
                        end
                        return temp_hook(remote, ...);
                    end))
                    self.Hook_Cache[class] = temp_hook;
                end
            end

            if self.Monitoring["__namecall"] then
                local gmeta = getrawmetatable(game);
                self.Hook_Cache["namecall"] = gmeta.__namecall;
                self.env.set_readonly(gmeta, false);

                local namecall = Instance.new("BindableFunction")
                self.Internal_Ignored[namecall] = true;
                namecall.OnInvoke = self.env.new_cclosure(function(remote, varargs)
                    if not(self.Ignored_Remotes[remote.Name]) then
                        if self.Cache[remote] and self.Cache[remote].Spying then
                            self:CacheData(remote, varargs)
                        elseif not self.Cache[remote] then
                            self:CacheData(remote, varargs)
                        end
                    end
                end);

                gmeta.__namecall = self.env.new_cclosure(function(remote, ...)
                    local varargs = {...};

                    if self:IsRemote(remote) then
                        if self.env.check_caller() or (self.Internal_Ignored[remote]) then
                            return self.Hook_Cache["namecall"](remote, ...);
                        end
                        namecall.Invoke(namecall, remote, varargs);
                    end
                    
                    return self.Hook_Cache["namecall"](remote, ...);
                end)

                self.env.set_readonly(gmeta, true);
            end
        end,
        StopTracking = function(self) -- This will also stop tracking http calls in future
            local to_fix = {
                ["RemoteEvent"] = Instance.new("RemoteEvent").FireServer,
                ["RemoteFunction"] = Instance.new("RemoteFunction").InvokeServer,
                ["BindableEvent"] = Instance.new("BindableEvent").Fire,
                ["BindableFunction"] = Instance.new("BindableFunction").Invoke,
            }

            for class,func in pairs(to_fix) do
                for ref,hook in pairs(self.Hook_Cache) do
                    if class == ref then
                        self.env.hook_function(func, hook);
                    end
                end
            end

            for name,func in pairs(self.HttpFuncRef) do
                for ref,hook in pairs(self.Hook_Cache) do
                    if name == ref then
                        self.env.hook_function(func, hook);
                    end
                end
            end

            if self.Monitoring["__namecall"] and self.Hook_Cache["namecall"] then
                local gmeta = getrawmetatable(game);
                self.env.set_readonly(gmeta, false)
                gmeta.__namecall = self.Hook_Cache["namecall"];
                self.env.set_readonly(gmeta, true);
            end
        end,
        SetTooltip = function(self, this_object, description)
            if not(self.Tooltips) then
                return;
            end

            local tooltip = self.Interface.Templates.Tooltip;

            local textSize = game:GetService("TextService"):GetTextSize(description, 14, "SourceSansBold", Vector2.new(math.huge,20))

            this_object.MouseEnter:Connect(function()
                tooltip.Text = description;
                tooltip.Size = UDim2.new(0,textSize.X + 5,0,20)
                tooltip.Visible = true;
            end)

            this_object.MouseLeave:Connect(function()
                tooltip.Text = "";
                tooltip.Visible = false;
            end)

            this_object.AncestryChanged:Connect(function()
                tooltip.Text = "";
                tooltip.Visible = false;
            end)
        end,
        DatatypeFormat = function(self, data)
            local datatype = typeof(data);
            local cleaned_string = tostring(data);
            local datacol = Color3.new(1,1,1)
            local potential_col = self.Data_Type_Colors[datatype]
            
            if potential_col ~= nil then
                datacol = potential_col;
            end;

            if datatype == "string" then
                cleaned_string = '"'..tostring(data)..'"';
            elseif datatype == "Vector3" then
                cleaned_string = "Vector3.new("..table.concat({data.X,data.Y,data.Z}, ", ")..")"
            elseif datatype == "UDim2" then
                cleaned_string = "UDim2.new("..table.concat({data.X.Scale,data.X.Offset,data.Y.Scale,data.Y.Offset}, ", ")..")"
            elseif datatype == "UDim" then
                cleaned_string = "UDim.new("..table.concat({data.Scale,data.Offset}, ", ")..")"
            elseif datatype == "CFrame" then
                cleaned_string = "CFrame.new("..table.concat({data.X,data.Y,data.Z}, ", ")..")" -- this is a piss poor way of handling cframes
            elseif datatype == "Vector2" then
                cleaned_string = "Vector2.new("..table.concat({data.X,data.Y}, ", ")..")"
            end
            return datacol, cleaned_string;
        end,
    };

    metadata.__index = function(self, index)
        if methods[index] then
            return function(s, ...)
                return methods[index](self, ...);
            end
        end
    end

    metadata.__call = function(self)
        assert(getgenv().FrostHookSpy==nil, "FrostHook RemoteSpy is already running!")
        getgenv().FrostHookSpy = true;

        if self.Services.CoreGui:FindFirstChild("FH_SPY") then
            self.Services.CoreGui.FH_SPY:Destroy();
        end

        if syn and syn.protectgui then
            syn.protectgui(self.Interface);
        end

        self.Interface.Parent = self.Services.CoreGui;

        do -- set up the entry added bindable
            local Entry = Instance.new("BindableEvent")
            Entry.Name = "Entry";
            self.Cache["_entry"] = Entry;
            self.Internal_Ignored[Entry] = true;
            local Latest = Instance.new("BindableEvent")
            Latest.Name = "Latest"
            self.FireCounts["_latest"] = Latest;
            self.Internal_Ignored[Latest] = true;
            local FCUpdated = Instance.new("BindableEvent")
            FCUpdated.Name = "FireCountUpdated";
            self.FireCounts._updated = FCUpdated;
            self.Internal_Ignored[FCUpdated] = true;
        end

        do -- Handle Interface
            local Spy = self.Interface;
                local topbar = Spy.Topbar;
                    local Main = topbar.Main;
                        local drag = Main.drag
                        local MainPanel = Main.MainPanel;
                        local TabPanel = Main.TabPanel;
                            local SearchBar = TabPanel.Space.Search;
                            local ExecuteButton = TabPanel.Space.Execute;
                        local CloseButton = Main.Topbar_shadow.TopbarButtons.Close;
                        self:SetTooltip(CloseButton, "Close window")
                        local DestroyButton = Main.Topbar_shadow.TopbarButtons:FindFirstChild("Destroy"); -- Yuck, .Destroy thinks it's the roblox method
                        self:SetTooltip(DestroyButton, "Spy:Destroy()")
                local Templates = Spy.Templates;
                    local tooltip = Templates.Tooltip;
                    local ExampleCall = Templates.ExampleCall;
                local OpenButton = Spy.Open.button;
            local CurrentTab = "List";
            local ViewingType = "";
            local Panels,Categories,Tabs = {},{},{};
            local HoveringObject;
            local HoveringCallData = {
                object = nil,
                varargs = nil,
            };
            local AddRemoveOverride = false;
            local TabSize = 10;

            local function CreateObjectTemplate(object, Remote)
                local ObjectFrame = object:Clone();
                ObjectFrame.Name = tostring(Remote);
                ObjectFrame.Label.Text = tostring(Remote);
                
                local _textSize = game:GetService("TextService"):GetTextSize(tostring(Remote), 14, "SourceSansBold", Vector2.new(math.huge,20))
                
                ObjectFrame.Label.Size = UDim2.new(0,_textSize.X + 5,1,0)

                local _info = TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
                local _select = game:GetService("TweenService"):Create(ObjectFrame.Label, _info, {["TextStrokeTransparency"]=0.1})
                local _unselect = game:GetService("TweenService"):Create(ObjectFrame.Label, _info, {["TextStrokeTransparency"]=1})

                ObjectFrame.MouseEnter:Connect(function()
                    HoveringObject = Remote;
                    _select:Play();
                end)
                
                ObjectFrame.MouseLeave:Connect(function()
                    if HoveringObject == Remote then
                        HoveringObject = nil;
                    end
                    _unselect:Play();
                end)
                
                ObjectFrame.Visible = true;
                return ObjectFrame;
            end

            local function PopulateObject2(Remote, Data)
                local ObjectFrame = CreateObjectTemplate(Templates.Object_2, Remote)
                local switch = ObjectFrame.Switch_Toggle;

                local thisRemoteColor = self.RemoteColors[Remote.ClassName];
                ObjectFrame.Emblem.ImageColor3 = thisRemoteColor
                
                local function toggle_switch(bool)
                    if not bool then
                        switch.Visible_Switch.ImageColor3 = Color3.new(1,1,1);
                        switch.Visible_Switch.Position = UDim2.new(0,7,0.5,0);
                        return
                    end
                    switch.Visible_Switch.ImageColor3 = thisRemoteColor;
                    switch.Visible_Switch.Position = UDim2.new(1,-21,0.5,0);
                end

                toggle_switch(Data.Spying)

                local cached;
                cached = Data.Updated.Event:Connect(function(Operation)
                    if Operation == "SpyChange" then
                        toggle_switch(Data.Spying) 
                        return;
                    end
                end)

                ObjectFrame.AncestryChanged:Connect(function()
                    if ObjectFrame.Parent == nil then
                        cached:Disconnect();
                    end
                end)

                switch.Interact.MouseButton1Down:Connect(function()
                    Data.Spying = not Data.Spying;
                    toggle_switch(Data.Spying)
                end)

                ObjectFrame.Parent = Panels["List"];
            end

            local function PopulateHttpObject2(Type, Data)
                local ObjectFrame = CreateObjectTemplate(Templates.Object_2, Type)
                local switch = ObjectFrame.Switch_Toggle;

                local thisReqColor = self.HttpColors[Type];
                ObjectFrame.Emblem.ImageColor3 = thisReqColor
                
                local function toggle_switch(bool)
                    if not bool then
                        switch.Visible_Switch.ImageColor3 = Color3.new(1,1,1);
                        switch.Visible_Switch.Position = UDim2.new(0,7,0.5,0);
                        return
                    end
                    switch.Visible_Switch.ImageColor3 = thisReqColor;
                    switch.Visible_Switch.Position = UDim2.new(1,-21,0.5,0);
                end

                toggle_switch(Data.Spying)

                local cached;
                cached = Data.Updated.Event:Connect(function(Operation)
                    if Operation == "SpyChange" then
                        toggle_switch(Data.Spying) 
                        return;
                    end
                end)

                ObjectFrame.AncestryChanged:Connect(function()
                    if ObjectFrame.Parent == nil then
                        cached:Disconnect();
                    end
                end)

                switch.Interact.MouseButton1Down:Connect(function()
                    Data.Spying = not Data.Spying;
                    toggle_switch(Data.Spying)
                end)

                ObjectFrame.Parent = Panels["List"];
            end

            local function PopulateObject(Remote, Data)
                local ObjectFrame = CreateObjectTemplate(Templates.Object, Remote)
                local FireAmount = ObjectFrame.Label.amount;
                local Clear_Cache = ObjectFrame.Clear;
                local thisRemoteColor = self.RemoteColors[Remote.ClassName];

                ObjectFrame.Emblem.ImageColor3 = thisRemoteColor
                Clear_Cache.BackgroundColor3 = thisRemoteColor;
                Clear_Cache.Font = "SourceSansBold"
                FireAmount.Text = tostring(Data.FireCount)

                Clear_Cache.MouseButton1Down:Connect(function()
                    self:ClearCacheData(Remote);
                    ObjectFrame:Destroy();
                end)

                Data.Updated.Event:Connect(function(Operation)
                    if FireAmount and Operation ~= "SpyChange" then
                        FireAmount.Text = Data.FireCount;
                    end
                end)

                ObjectFrame.Parent = Panels["View"];
                return FireAmount;
            end

            local function PopulateHttpObject(Type, Data)
                local ObjectFrame = CreateObjectTemplate(Templates.Object, Type)
                local FireAmount = ObjectFrame.Label.amount;
                local Clear_Cache = ObjectFrame.Clear;

                local thisReqColor = self.HttpColors[Type];

                ObjectFrame.Emblem.ImageColor3 = thisReqColor;
                Clear_Cache.BackgroundColor3 = thisReqColor;
                Clear_Cache.Font = "SourceSansBold"
                FireAmount.Text = tostring(Data.FireCount)

                Clear_Cache.MouseButton1Down:Connect(function()
                    print(Type)
                    self:ClearRequestCache(Type);
                    ObjectFrame:Destroy();
                end)

                Data.Updated.Event:Connect(function(Operation)
                    if FireAmount and Operation ~= "SpyChange" then
                        FireAmount.Text = Data.FireCount;
                    end
                end)

                ObjectFrame.Parent = Panels["View"];
                return FireAmount;
            end

            local function PopulateObjects(Type)
                for _,OldObject in pairs(Panels["View"]:GetChildren()) do
                    if OldObject:IsA("Frame") then
                        OldObject:Destroy();
                    end
                end

                local NumObjects = 0;
                for Remote,Data in pairs(self.Cache) do
                    if tostring(Remote) ~= "_entry" and Remote.ClassName == Type and Data.FireCount > 0 then
                        PopulateObject(Remote, Data);
                        NumObjects = NumObjects + 1;
                    end
                end

                Panels["View"].CanvasSize = UDim2.new(0,0,0,20*NumObjects)
                Panels["View"].CanvasPosition = Vector2.new();
            end

            local function PopulateHttpObjects(Type)
                for _,OldObject in pairs(Panels["View"]:GetChildren()) do
                    if OldObject:IsA("Frame") then
                        OldObject:Destroy();
                    end
                end

                local NumObjects = 0;
                for Req,Data in pairs(self.HttpCache) do
                    if Req ~= "_entry" and Req == Type and Data.FireCount > 0 then
                        PopulateHttpObject(Req, Data);
                        NumObjects = NumObjects + 1;
                    end
                end

                Panels["View"].CanvasSize = UDim2.new(0,0,0,20*NumObjects)
                Panels["View"].CanvasPosition = Vector2.new();
            end

            local function PopulateListObjects(Type)
                for _,OldObject in pairs(Panels["List"]:GetChildren()) do
                    if OldObject:IsA("Frame") then
                        OldObject:Destroy();
                    end
                end

                local NumObjects = 0;
                for Remote,Data in pairs(self.Cache) do
                    if tostring(Remote) ~= "_entry" and Remote.ClassName == Type then
                        PopulateObject2(Remote, Data);
                        NumObjects = NumObjects + 1;
                    end
                end

                Panels["List"].CanvasSize = UDim2.new(0,0,0,20*NumObjects)
                Panels["List"].CanvasPosition = Vector2.new();
            end

            local function PopulateHttpListObjects(Type)
                for _,OldObject in pairs(Panels["List"]:GetChildren()) do
                    if OldObject:IsA("Frame") then
                        OldObject:Destroy();
                    end
                end

                local NumObjects = 0;
                for Req,Data in pairs(self.HttpCache) do
                    if Req ~= "_entry" and Req == Type then
                        PopulateHttpObject2(Req, Data);
                        NumObjects = NumObjects + 1;
                    end
                end
            end

            local function CallDropdown(remote, string_func, varargs)
                if Spy:FindFirstChild("CallDropdown") then
                    Spy.CallDropdown:Destroy();
                end
                local this_dropdown = Templates.CallDropdown:Clone();
                this_dropdown.Position = UDim2.new(0,Mouse.X - 5,0,Mouse.Y - 5)

                this_dropdown.MouseLeave:Connect(function()
                    if HoveringCallData.object == remote or HoveringCallData.varargs == varargs then
                        HoveringCallData.object = nil;
                        HoveringCallData.varargs = nil;
                    end
                    this_dropdown:Destroy();
                end)

                local Call = this_dropdown.CallAgain;
                local GenerateScript = this_dropdown.GenScript;

                Call.MouseButton1Down:Connect(function()
                    local func = remote[self.RemoteFuncRef[remote.ClassName]];
                    if func then
                        pcall(function()
                            func(remote, unpack(varargs));
                        end);
                    end
                end)

                GenerateScript.MouseButton1Down:Connect(function()
                    local Code = FrostHook.ScriptGeneration.AppendBeginning;
                    local Variables,Cache = {},{table=0,number=0,userdata=0,string=0,boolean=0};

                    for i,v in pairs(varargs) do
                        local var, new_Cache = FrostHook.ScriptGeneration:var_name(Cache, v);
                        local RefValue = FrostHook.ScriptGeneration:transform_value(v)
                        Cache = new_Cache;

                        table.insert(Variables, {
                            Variable = var,
                            Value =  RefValue,
                        })
                    end

                    table.insert(Variables, {
                        Variable = "Target",
                        Value = FrostHook.ScriptGeneration:transform_value(remote);
                    })

                    for _,data in next, Variables do
                        Code = Code.."local "..data.Variable.." = "..data.Value..";\n";
                    end

                    Code = Code.."Target:"..string_func.."("

                    local ArrayVars = {};

                    for _,data in pairs(Variables) do
                        if data.Variable ~= "Target" then
                            table.insert(ArrayVars, data.Variable)
                        end
                    end

                    Code = Code..table.concat(ArrayVars, ", ")
                    Code = Code..");";
                    Code = Code..FrostHook.ScriptGeneration.AppendEnding;
                    FrostHook.TextEditor:SetCode(Code);
                end)

                this_dropdown.Visible = true;
                this_dropdown.Parent = Spy;
            end

            local function HTTPCallDropdown(reqtype, varargs)
                if Spy:FindFirstChild("CallDropdown") then
                    Spy.CallDropdown:Destroy();
                end
                local this_dropdown = Templates.CallDropdown:Clone();
                this_dropdown.Position = UDim2.new(0,Mouse.X - 5,0,Mouse.Y - 5)

                this_dropdown.MouseLeave:Connect(function()
                    if HoveringCallData.object == remote or HoveringCallData.varargs == varargs then
                        HoveringCallData.object = nil;
                        HoveringCallData.varargs = nil;
                    end
                    this_dropdown:Destroy();
                end)

                local Call = this_dropdown.CallAgain;
                local GenerateScript = this_dropdown.GenScript;

                Call.MouseButton1Down:Connect(function()
                    local func = game[reqtype];
                    if func then
                        pcall(function()
                            func(remote, unpack(varargs));
                        end);
                    end
                end)

                GenerateScript.MouseButton1Down:Connect(function()
                    local Code = FrostHook.ScriptGeneration.AppendBeginning;
                    local Variables,Cache = {},{table=0,number=0,userdata=0,string=0,boolean=0};

                    for i,v in pairs(varargs) do
                        local var, new_Cache = FrostHook.ScriptGeneration:var_name(Cache, v);
                        local RefValue = FrostHook.ScriptGeneration:transform_value(v)
                        Cache = new_Cache;

                        table.insert(Variables, {
                            Variable = var,
                            Value =  RefValue,
                        })
                    end

                    for _,data in next, Variables do
                        Code = Code.."local "..data.Variable.." = "..data.Value..";\n";
                    end

                    Code = Code.."game:"..reqtype.."("

                    local ArrayVars = {};

                    for _,data in pairs(Variables) do
                        if data.Variable ~= "Target" then
                            table.insert(ArrayVars, data.Variable)
                        end
                    end

                    Code = Code..table.concat(ArrayVars, ", ")
                    Code = Code..");";
                    Code = Code..FrostHook.ScriptGeneration.AppendEnding;
                    FrostHook.TextEditor:SetCode(Code);
                end);

                this_dropdown.Visible = true;
                this_dropdown.Parent = Spy;
            end
            
            local function ViewCalls(Object)
                local ReadingNewCalls = true;
                local Data = self.HttpCache[Object] or self.Cache[Object];

                if not(Data) then
                    print("Denied")
                    return;
                end

                local this_callview = Templates.CallView:Clone();
                local main = this_callview.Main;
                local buttons = main.Topbar_shadow.TopbarButtons
                local CallFrame = main.Calls;

                local Hook_FuncRef = self.RemoteFuncRef;

                local _info = TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)

                local function PreviewCall(array)
                    local this_Call = ExampleCall:Clone();

                    if #array <= 0 then
                        this_Call.Expand.Visible = false;
                    end
                    
                    local ArgDataTypes = {}
                    local StateImages = {
                        [true] = "rbxassetid://4317834259",
                        [false] = "rbxassetid://4317835953"
                    }
                    local Expanded = false;
                    local _select = game:GetService("TweenService"):Create(this_Call, _info, {["BackgroundColor3"]=Color3.new(0.5,0.5,0.5)})
                    local _unselect = game:GetService("TweenService"):Create(this_Call, _info, {["BackgroundColor3"]=Color3.new(0,0,0)})

                    for i,v in pairs(array) do
                        if tostring(typeof(v)) == "nil" then
                            array[i] = "nil";
                        end
                    end

                    for i=1,#array do
                        local arg = array[i];
                        table.insert(ArgDataTypes, typeof(arg))
                        local add_Data = this_Call.Templates["AdditionalData"]:Clone();
                        local data_color,formatted_data = self:DatatypeFormat(arg)
                        add_Data.Data.Text = formatted_data;
                        add_Data.ImageLabel.ImageColor3 = data_color;
                        add_Data.Visible = true;
                        add_Data.Parent = this_Call.Additional;
                    end

                    this_Call.CallType.Text = tostring((type(Object)=="string" and Object or Hook_FuncRef[Object.ClassName]) ).."("..table.concat(ArgDataTypes, ", ")..")";

                    this_Call.MouseEnter:Connect(function()
                        HoveringCallData.object = Object;
                        HoveringCallData.varargs = array;
                        _select:Play();
                    end)

                    this_Call.MouseLeave:Connect(function()
                        _unselect:Play();
                    end)

                    this_Call.Expand.MouseButton1Down:Connect(function()
                        Expanded = not Expanded;
                        this_Call.Expand.Image = StateImages[Expanded];
                        if Expanded then
                            this_Call:TweenSize(UDim2.new(1,0,0,20 + 22*#array), "Out", "Quad", 0.2, true, function()
                                CallFrame.CanvasSize = UDim2.new(0,0,0,CallFrame.CanvasSize.Y.Offset+(#array*22));
                            end);
                        else
                            this_Call:TweenSize(UDim2.new(1,0,0,20), "Out", "Quad", 0.2, true, function()
                                CallFrame.CanvasSize = UDim2.new(0,0,0,CallFrame.CanvasSize.Y.Offset-(#array*22));
                            end);
                        end
                    end)

                    this_Call.Visible = true;
                    CallFrame.CanvasSize = UDim2.new(0,0,0,CallFrame.CanvasSize.Y.Offset+20);
                    this_Call.Parent = CallFrame;
                end

                for i=1,#Data.Logs do
                    PreviewCall(Data.Logs[i]);
                end

                self.CustomDrag:SetDragging(true, this_callview, main);
                
                buttons.Close.MouseButton1Down:Connect(function()
                    self.CustomDrag:SetDragging(false, this_callview, main);
                    this_callview:Destroy();
                end)
                
                buttons.Export.MouseButton1Down:Connect(function()
                    self.env.to_clipboard(self.ScriptGeneration:dump_table(Data.Logs))
                end)

                if Data.Spying then
                    buttons.Play.Visible = false;
                    buttons.Stop.Visible = true;
                else
                    buttons.Play.Visible = true;
                    buttons.Play.Visible = false;
                end
                
                buttons.Play.MouseButton1Down:Connect(function()
                    Data.Spying = true;
                    Data.Updated:Fire("SpyChange")
                    buttons.Stop.Visible = true;
                    buttons.Play.Visible = false;
                end)
                
                buttons.Stop.MouseButton1Down:Connect(function()
                    Data.Spying = false;
                    Data.Updated:Fire("SpyChange")
                    buttons.Stop.Visible = false;
                    buttons.Play.Visible = true;
                end)

                CallFrame.MouseLeave:Connect(function()
                    HoveringCallData.object = nil;
                    HoveringCallData.varargs = nil;
                end)

                Data.Updated.Event:Connect(function(Operation, varargs)
                    if Operation == "Add" then
                        PreviewCall(varargs);
                    elseif Operation == "Clear" then
                        for _,Object in pairs(CallFrame:GetChildren()) do
                            if Object.ClassName == "Frame" or Object.ClassName == "ScrollingFrame" then
                                Object:Destroy();
                            end
                        end
                        CallFrame.CanvasSize = UDim2.new(0,0,0,0);
                    end
                end)

                self:SetTooltip(buttons.Stop, "Stop")
                self:SetTooltip(buttons.Play, "Start")
                self:SetTooltip(buttons.Export, "Export Calls")
                self:SetTooltip(buttons.Close, "Close window")
                
                main.Topbar_shadow.Viewing.Text = tostring(Object);
                this_callview.Visible = true;
                this_callview.Parent = Spy;
            end
            
            local function Dropdown(Object)
                if Spy:FindFirstChild("Dropdown") then
                    Spy.Dropdown:Destroy();
                end
                local this_dropdown = Templates.Dropdown:Clone();
                this_dropdown.Position = UDim2.new(0,Mouse.X - 5,0,Mouse.Y - 5)
                this_dropdown.Visible = true;
                this_dropdown.Parent = Spy;
                
                this_dropdown.MouseLeave:Connect(function()
                    this_dropdown:Destroy();
                end)
                
                local CallView = this_dropdown.Calls;
                local GetPath = this_dropdown.GetPath;
                
                GetPath.MouseButton1Down:Connect(function()
                    if type(Object) == "string" then
                        FrostHook.env.to_clipboard("game:"..Object.."()")
                    else
                        FrostHook.env.to_clipboard(FrostHook.ScriptGeneration:transform_path(Object:GetFullName()))
                    end
                end)
                
                CallView.MouseButton1Down:Connect(function()
                    ViewCalls(Object);
                end)
            end
            
            local function ViewTab(tab_name)
                for _,Tab in pairs(Tabs) do
                    if Tab.Name == tab_name then
                        Tab.BackgroundTransparency = 1;
                    else
                        Tab.BackgroundTransparency = 0.8;
                    end
                end
                
                SearchBar.Visible = (tab_name=="List")and true or false;
                ExecuteButton.Visible = (tab_name=="Code")and true or false;
            
                for PanName,Panel in pairs(Panels) do
                    if PanName == tab_name then
                        Panel.Visible = true;
                    else
                        Panel.Visible = false;
                    end
                end
            end

            local function fixCanvas_View()
                if FrostHook and not AddRemoveOverride then
                    Panels["View"].CanvasSize = UDim2.new(0,0,0,20*#(Panels["View"]:GetChildren())-1)
                    Panels["List"].CanvasSize = UDim2.new(0,0,0,20*#(Panels["List"]:GetChildren())-1)
                end
            end

            for _,Directory in pairs(self.Search_Directories) do -- Populates the Cache full of every remote/bindable in the game.
                for _,Obj in pairs(Directory:GetDescendants()) do
                    local Class = Obj.ClassName;
                    if Class == "RemoteEvent" or Class == "RemoteFunction" or Class == "BindableEvent" or Class == "BindableFunction" then
                        self:CacheData(Obj,nil,true);
                    end
                end
            end

            for _,Obj in pairs(TabPanel:GetChildren()) do -- Populates the Tabs
                if Obj:IsA("TextButton") or Obj.Name == "Space" then
                    Tabs[Obj.Name] = Obj;
                    if Obj:IsA("TextButton") then
                        Obj.MouseButton1Down:Connect(function()
                            ViewTab(Obj.Name);
                        end)
                    end
                end
            end
            
            for _,Obj in pairs(MainPanel:GetChildren()) do -- Populates the Panels
                if Obj:IsA("ScrollingFrame") then
                    Panels[Obj.Name] = Obj;
                end
            end
            
            for _,Obj in pairs(Main.SidePanel:GetChildren()) do -- Populates the Sub-Categories.
                if Obj:IsA("Frame") then
                    Categories[Obj.Name] = {["Object"] = Obj, ["ResetAllAmounts"] = false, ["SubOptions"] = false, ["_init"] = false};
                end
            end

            local ForceUnset = Instance.new("BindableEvent");
            ForceUnset.Name = "Force-Unset"
            self.Internal_Ignored[ForceUnset] = true;
        
            for CatName,CatObj in pairs(Categories) do
                local Content = CatObj.Object.Content;
                local expand = Content.expand;
                local CatFireAmount = Content.amount;
                local State = false;
                local StateImages = {
                    [true] = "rbxassetid://4317834259",
                    [false] = "rbxassetid://4317835953"
                }
                
                local SubOptions = {_len=0};

                self.FireCounts._updated.Event:Connect(function()
                    if CatName == "Remotes" then
                        local EventAmount = self.FireCounts["RemoteEvent"];
                        local FunctionAmount = self.FireCounts["RemoteFunction"];
                        CatFireAmount.Text = tostring(EventAmount + FunctionAmount)
                    elseif CatName == "Bindables" then
                        local EventAmount = self.FireCounts["BindableEvent"];
                        local FunctionAmount = self.FireCounts["BindableFunction"];
                        CatFireAmount.Text = tostring(EventAmount + FunctionAmount)
                    elseif CatName == "HTTP" then
                        local GetAmount = self.FireCounts["HttpGet"];
                        local PostAmount = self.FireCounts["HttpPost"];
                        local GetObjAmount = self.FireCounts["GetObjects"];
                        CatFireAmount.Text = tostring(GetAmount + PostAmount + GetObjAmount);
                    end
                end)
                
                for _,Obj in pairs(CatObj.Object:GetChildren()) do
                    if Obj:IsA("TextButton") then
                        SubOptions._len = SubOptions._len + 1;
                        
                        local TypeRef = CatName=="HTTP" and (Obj.Name=="GetObjects" and "GetObjects" or "Http"..Obj.Name) or Obj:FindFirstChild("_type")
                        local FireAmount = Obj.amount;
                        local Selected = false;

                        self.FireCounts._updated.Event:Connect(function()
                            if TypeRef then
                                if CatName == "HTTP" then
                                    local MyCount = self.FireCounts[(Obj.Name=="GetObjects" and "GetObjects" or "Http"..Obj.Name)];
                                    FireAmount.Text = MyCount;
                                else
                                    local MyCount = self.FireCounts[TypeRef.Value];
                                    FireAmount.Text = MyCount;
                                end
                            end
                        end)
                        
                        SubOptions[Obj.Name] = {["Object"] = Obj};
                        
                        local _info = TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
                        local _select = game:GetService("TweenService"):Create(Obj, _info, {["BackgroundTransparency"]=0.9})
                        local _unselect = game:GetService("TweenService"):Create(Obj, _info, {["BackgroundTransparency"]=1})
                        local _setcat = game:GetService("TweenService"):Create(Obj, _info, {["BackgroundColor3"]=Color3.new(85/255, 170/255, 1)})
                        local _unsetcat = game:GetService("TweenService"):Create(Obj, _info, {["BackgroundColor3"]=Color3.new(120/255, 120/255, 120/255)})
                        
                        Obj.MouseEnter:Connect(function()
                            if not(Selected) then
                                _select:Play();
                            end
                        end)
                        
                        Obj.MouseLeave:Connect(function()
                            if not(Selected) then
                                _unselect:Play()
                            end
                        end)

                        ForceUnset.Event:Connect(function(selector)
                            if selector == Obj then
                                Selected = true;
                                return
                            end
                            Selected = false;
                            _unsetcat:Play();
                            _unselect:Play();
                        end)
                        
                        Obj.MouseButton1Down:Connect(function()
                            if TypeRef and CatName ~= "HTTP" then
                                ForceUnset:Fire(Obj);
                                _select:Play();
                                _setcat:Play();
                                ViewingType = tostring(TypeRef.Value)
                                AddRemoveOverride = true;
                                PopulateObjects(TypeRef.Value);
                                PopulateListObjects(TypeRef.Value);
                                AddRemoveOverride = false;
                            else
                                ForceUnset:Fire(Obj);
                                _select:Play();
                                _setcat:Play();
                                ViewingType = tostring(TypeRef)
                                AddRemoveOverride = true;
                                PopulateHttpObjects(TypeRef);
                                PopulateHttpListObjects(TypeRef);
                                AddRemoveOverride = false;
                            end
                        end)
                    end
                end
                
                Categories[CatName].SubOptions = SubOptions;
                Categories[CatName].ResetAllAmounts = CategoryResetAllAmounts;
                Categories[CatName]._init = true;
                
                expand.MouseButton1Down:Connect(function()
                    State = not State;
                    expand.Image = StateImages[State];
                    if State then
                        CatObj.Object:TweenSize(UDim2.new(1,0,0,20*(SubOptions._len+1)), "Out", "Quad", 0.25, true)
                    else
                        CatObj.Object:TweenSize(UDim2.new(1,0,0,20), "Out", "Quad", 0.25, true)
                    end
                end)
            end

            self:RegisterConnection(self.FireCounts._latest.Event, function(remote)
                if type(remote) == "string" then -- HTTP
                    if ViewingType == remote then
                        if not(Panels["View"]:FindFirstChild(remote)) then
                            PopulateHttpObject(remote, self.HttpCache[remote]);
                        elseif not(Panels["List"]:FindFirstChild(remote)) then
                            PopulateHttpObject2(remote, self.HttpCache[remote]);
                        end
                    end
                else -- REMOTE
                    if ViewingType == tostring(remote.ClassName) then
                        if not(Panels["View"]:FindFirstChild(remote.Name)) then
                            PopulateObject(remote, self.Cache[remote])
                        elseif not(Panels["List"]:FindFirstChild(remote.Name)) then
                            PopulateObject2(remote, self.Cache[remote])
                        end
                    end
                end
            end)

            self:RegisterConnection(Panels["View"].ChildAdded, fixCanvas_View)
            self:RegisterConnection(Panels["View"].ChildRemoved, fixCanvas_View)

            self:RegisterConnection(OpenButton.MouseButton1Down, function()
                OpenButton.Parent.Visible = false;
                topbar.Visible = true;
            end)

            self:RegisterConnection(CloseButton.MouseButton1Down, function()
                OpenButton.Parent.Visible = true;
                topbar.Visible = false;
            end)

            self:RegisterConnection(DestroyButton.MouseButton1Down, function()
                self:Destroy();
            end)

            self:RegisterConnection(SearchBar.FocusLost, function()
                if SearchBar.Text == "" then
                    SearchBar.Close.Visible = false;
                end
            end)
            
            self:RegisterConnection(SearchBar.Close.MouseButton1Down, function()
                SearchBar:ReleaseFocus(false);
                SearchBar.Text = "";
                SearchBar.Close.Visible = false;
                fixCanvas_View();
                for _,Object in pairs(Panels["List"]:GetChildren()) do
                    if Object:IsA("Frame") then
                        Object.Visible = true;
                    end
                end
            end)

            self:RegisterConnection(ExecuteButton.MouseButton1Down, function()
                local CodeText = Panels["Code"].Main.Input.Text or "";
                if self.TextEditor.Imported then
                    CodeText = self.TextEditor:RevertTabs(CodeText);
                end

                local success,error = pcall(function()
                    spawn(loadstring(CodeText)() or function()end)
                end)

                local OldColor = ExecuteButton.BackgroundColor3;

                if success then
                    print("Execute Error: ", error);
                end
            end)

            self:RegisterConnection(self.Services.UserInputService.InputBegan, function(inputObject)
                local InputType = inputObject.UserInputType;
                if InputType == Enum.UserInputType.MouseButton2 then
                    if HoveringObject then
                        Dropdown(HoveringObject)
                    end
                    if HoveringCallData.object and HoveringCallData.varargs then
                        if type(HoveringCallData.object) == "string" then
                            HTTPCallDropdown(HoveringCallData.object, HoveringCallData.varargs);
                        else
                            CallDropdown(HoveringCallData.object, self.RemoteFuncRef[HoveringCallData.object.ClassName], HoveringCallData.varargs);
                        end
                    end
                end
            end)

            self.CustomDrag:SetDragging(true, topbar, Main);
            self.CustomDrag:SetResizing(true, topbar, Main, drag);
            ViewTab(CurrentTab);

            self:RegisterConnection(self.Services.RunService.RenderStepped, function()
                if SearchBar.Text ~= "" and SearchBar.Close.Visible == false then
                    SearchBar.Close.Visible = true
                end
                
                if SearchBar.Text ~= "" then
                    for _,Object in pairs(Panels["List"]:GetChildren()) do
                        local Visible_Objects = 0;
                        if Object:IsA("Frame") then
                            if Object.Name:lower():find(SearchBar.Text:lower()) then
                                Visible_Objects = Visible_Objects + 1;
                                Object.Visible = true;
                            else
                                Object.Visible = false;
                            end
                        end
                        Panels["List"].CanvasSize = UDim2.new(0,0,0,20*Visible_Objects)
                    end
                end

                if tooltip.Visible then
                    tooltip.Position = UDim2.new(0,Mouse.X + 5,0,Mouse.Y - tooltip.AbsoluteSize.Y)
                end
            end)

            do -- Lines
                local function CreateFadedLineH(holder)
                    local globtrans = 0
                    holder.BackgroundTransparency = 1;
                    for i=holder.AbsoluteSize.X/2,holder.AbsoluteSize.X,1 do
                        globtrans = globtrans + (1/(holder.AbsoluteSize.X/2))
                        local p = Instance.new("Frame", holder)
                        p.Size = UDim2.new(0,1,1,0)
                        p.BorderSizePixel = 0;
                        p.Parent = holder
                        p.BackgroundColor3 = holder.BackgroundColor3
                        p.Position = UDim2.new(0,i,0,0)
                        p.BackgroundTransparency = globtrans
                    end
                    globtrans = 1
                    for i=0,holder.AbsoluteSize.X/2,1 do
                        globtrans = globtrans - (1/(holder.AbsoluteSize.X/2))
                        local p = Instance.new("Frame", holder)
                        p.Size = UDim2.new(0,1,1,0)
                        p.BorderSizePixel = 0;
                        p.Parent = holder
                        p.BackgroundColor3 = holder.BackgroundColor3
                        p.Position = UDim2.new(0,i,0,0)
                        p.BackgroundTransparency = globtrans
                    end
                end
                
                local function CreateFadedLineV(holder)
                    local globtrans = 0
                    holder.BackgroundTransparency = 1;
                    for i=holder.AbsoluteSize.Y/2,holder.AbsoluteSize.Y,1 do
                        globtrans = globtrans + (1/(holder.AbsoluteSize.Y/2))
                        local p = Instance.new("Frame", holder)
                        p.Size = UDim2.new(1,0,0,1)
                        p.BorderSizePixel = 0;
                        p.Parent = holder
                        p.BackgroundColor3 = holder.BackgroundColor3
                        p.Position = UDim2.new(0,0,0,i)
                        p.BackgroundTransparency = globtrans
                    end
                    globtrans = 1
                    for i=0,holder.AbsoluteSize.Y/2,1 do
                        globtrans = globtrans - (1/(holder.AbsoluteSize.Y/2))
                        local p = Instance.new("Frame", holder)
                        p.Size = UDim2.new(1,0,0,1)
                        p.BorderSizePixel = 0;
                        p.Parent = holder
                        p.BackgroundColor3 = holder.BackgroundColor3
                        p.Position = UDim2.new(0,0,0,i)
                        p.BackgroundTransparency = globtrans
                    end
                end
                
                for _, obj in next, Spy:GetDescendants() do
                    if obj.Name == "HorizontalLine" then
                        CreateFadedLineH(obj);
                    end
                end
                for _, obj in next, Spy:GetDescendants() do
                    if obj.Name == "VerticalLine" then
                        CreateFadedLineV(obj);
                    end
                end
            end
        end

        self.TextEditor();
        self.TextEditor:SetCode("");
        self.CustomDrag();

        self:TrackRemotes(); -- Start tracking all remotes
        self:TrackHttp(); -- Start tracking all http requests
    end
    setmetatable(FrostHook, metadata);
end

do -- Custom Dragging/Resizing object.
    local metadata = {};
    local Cached_ResizeConnections = {};
    local Cached_DragConnections = {};
    local methods = {
        SetDragging = function(self, toggle, frame, main)
            if toggle then
                if Cached_DragConnections[frame] then
                    return;
                end

                self.DragActive[frame] = {
                    ["Main"] = main,
                    Dragging = false,
                    MouseOnTopBar = false,
                    startPosition = Vector2.new(),
                    TopbarPosition = Vector2.new(),
                };

                local mE = frame.MouseEnter:Connect(function()
                    self.DragActive[frame].MouseOnTopBar = true;
                end)

                local mL = frame.MouseLeave:Connect(function()
                    self.DragActive[frame].MouseOnTopBar = false;
                end)

                Cached_DragConnections[frame] = {mE,mL};
            else
                for obj,cons in pairs(Cached_DragConnections) do
                    if obj == frame then
                        for _,con in pairs(cons) do
                            con:Disconnect();
                        end
                    end
                end
                self.DragActive[frame] = nil;
            end
        end,
        SetResizing = function(self, toggle, frame, main, dragbtn)
            if toggle then
                if self.ResizeActive[frame] then
                    return;
                end
                self.ResizeActive[frame] = {
                    ["Main"] = main,
                    Resizing = false,
                    startPosition = Vector2.new(),
                    MainStartPosition = UDim2.new(),
                    MainStartSize = UDim2.new(),
                };

                local dBD = dragbtn.MouseButton1Down:Connect(function()
                    self.ResizeActive[frame].startPosition = Vector2.new(Mouse.X, Mouse.Y)
                    self.ResizeActive[frame].MainStartSize = main.Size;
                    self.ResizeActive[frame].MainStartPosition = main.Position;
                    self.ResizeActive[frame].Resizing = true;
                end)

                Cached_ResizeConnections[frame] = dBD;
            else
                if Cached_ResizeConnections[frame] then
                    Cached_ResizeConnections[frame]:Disconnect();
                end
                self.ResizeActive[frame] = nil;
            end
        end,
    };

    metadata.__index = function(self, index)
        if methods[index] then
            return function(s, ...)
                return methods[index](self, ...);
            end
        end
    end

    metadata.__call = function(self)
        FrostHook:RegisterConnection(FrostHook.Services.UserInputService.InputBegan, function(inputObject)
            local InputType = inputObject.UserInputType;
            if InputType == Enum.UserInputType.MouseButton1 then
                for topbar,data in pairs(self.DragActive) do
                    if data.MouseOnTopBar then
                        data.Dragging = true;
                        data.startPosition = Vector2.new(Mouse.X, Mouse.Y)
                        data.TopbarPosition = topbar.Position;
                    end
                end
            end
        end)

        FrostHook:RegisterConnection(FrostHook.Services.UserInputService.InputEnded, function(inputObject)
            local InputType = inputObject.UserInputType;
            if InputType == Enum.UserInputType.MouseButton1 then
                for topbar,data in pairs(self.DragActive) do
                    data.Dragging = false;
                end
                for topbar,data in pairs(self.ResizeActive) do
                    data.Resizing = false;
                end
            end
        end)

        local function KeepInBounds(_p, _s)
            local appropriated_p = _p
            local AbsolutePos = Vector2.new(((_p.X.Scale*Mouse.ViewSizeX)+_p.X.Offset), ((_p.Y.Scale*Mouse.ViewSizeY)+_p.Y.Offset))	
            
            local S_O_X = _p.X.Scale * Mouse.ViewSizeX;
            local S_O_Y = _p.Y.Scale * Mouse.ViewSizeY;
            
            if AbsolutePos.X + _s.X >= Mouse.ViewSizeX then
                appropriated_p = UDim2.new(
                    _p.X.Scale,
                    Mouse.ViewSizeX - S_O_X - _s.X,
                    appropriated_p.Y.Scale,
                    appropriated_p.Y.Offset
                )
            end
            
            if AbsolutePos.X <= 0 then
                appropriated_p = UDim2.new(
                    _p.X.Scale,
                    -S_O_X,
                    appropriated_p.Y.Scale,
                    appropriated_p.Y.Offset
                )
            end
            
            if AbsolutePos.Y + _s.Y - 20 >= Mouse.ViewSizeY then
                appropriated_p = UDim2.new(
                    appropriated_p.X.Scale,
                    appropriated_p.X.Offset,
                    _p.Y.Scale,
                    Mouse.ViewSizeY - S_O_Y - _s.Y + 20
                )
            end
            
            if AbsolutePos.Y <= -20 then
                appropriated_p = UDim2.new(
                    appropriated_p.X.Scale,
                    appropriated_p.X.Offset,
                    _p.Y.Scale,
                    -S_O_Y - 20
                )
            end
            
            return appropriated_p;
        end

        local function ConstraintApply(_s)
            local appropriated_s = _s;
            
            if _s.X.Offset <= FrostHook.Constraints.Min.X.Offset then
                appropriated_s = UDim2.new(0, FrostHook.Constraints.Min.X.Offset, 0, appropriated_s.Y.Offset)
            elseif _s.X.Offset >= FrostHook.Constraints.Max.X.Offset then
                appropriated_s = UDim2.new(0, FrostHook.Constraints.Max.X.Offset, 0, appropriated_s.Y.Offset)
            end
            
            if _s.Y.Offset <= FrostHook.Constraints.Min.Y.Offset then -- Fix X Offset
                appropriated_s = UDim2.new(0, appropriated_s.X.Offset, 0, FrostHook.Constraints.Min.Y.Offset)
            elseif _s.Y.Offset >= FrostHook.Constraints.Max.Y.Offset then
                appropriated_s = UDim2.new(0, appropriated_s.X.Offset, 0, FrostHook.Constraints.Max.Y.Offset)
            end
            
            return appropriated_s;
        end

        FrostHook:RegisterConnection(FrostHook.Services.RunService.RenderStepped, function()
            for Topbar, Data in pairs(self.DragActive) do
                local Main = Data.Main;

                if Data.startPosition and Data.Dragging then
                    local AbsolutePixelChange = Vector2.new(Mouse.X,Mouse.Y) - Data.startPosition;
                    local AbsolutePixelUDim2 = UDim2.new(0,AbsolutePixelChange.X,0,AbsolutePixelChange.Y)
                    Topbar.Position = KeepInBounds(
                        (UDim2.new(
                            0.5, Data.TopbarPosition.X.Offset,
                            0.5, Data.TopbarPosition.Y.Offset)
                             + AbsolutePixelUDim2
                        ),
                        Main.AbsoluteSize
                    );
                end
            end

            for Topbar, Data in pairs(self.ResizeActive) do
                local Main = Data.Main;

                if Data.startPosition and Data.Resizing then
                    local AbsolutePixelChange = Vector2.new(Mouse.X,Mouse.Y) - Data.startPosition;
                    local AbsolutePixelUDim2 = UDim2.new(0,AbsolutePixelChange.X,0,AbsolutePixelChange.Y)
                    Main.Size = ConstraintApply(Data.MainStartSize + AbsolutePixelUDim2)
                    Topbar.Size = UDim2.new(0,Main.Size.X.Offset,Topbar.Size.Y.Scale,Topbar.Size.Y.Offset)
                    Main.Position = Data.MainStartPosition;
                end
            end
        end)
    end

    setmetatable(FrostHook.CustomDrag, metadata);
end

do -- Script Generation (WIP)
    local metadata = {}
    local methods = {
        var_name = function(self, Cache, value)
            local ttype = type(value)
            if ttype == "table" then
                Cache["table"] = Cache["table"] + 1;
                value = "table_"..tostring(Cache["table"])
            elseif ttype == "userdata" then
                Cache["userdata"] = Cache["userdata"] + 1;    
                value = "userdata_"..tostring(Cache["userdata"]);
            elseif ttype == "string" then
                Cache["string"] = Cache["string"] + 1;
                value = "string_"..tostring(Cache["string"]);
            elseif ttype == "number" then
                Cache["number"] = Cache["number"] + 1;
                value = "number_"..tostring(Cache["number"])
            elseif ttype == "boolean" then
                Cache["boolean"] = Cache["boolean"] + 1;
                value = "bool_"..tostring(Cache["boolean"])
            end
            return value, Cache
        end,
        transform_path = function(self, path) -- Pulled from Hydroxide @Modified
            local split = path:split('.')
            local result = ""
            local name = FrostHook.Services.Players.LocalPlayer.Name;
            
            if #split == 1 and not game:FindFirstChild(split[1]) then
                return split[1] .. " --[[ Parent is \"nil\" or object is destroyed ]]"
            end

            if pcall(game.GetService, game, split[1]) then
                split[1] = "GetService(\"" .. split[1] .. "\")"
            end
            
            for i,v in next, split do
                if (v:sub(1, 1):match("%A") or v:find("%W")) and not v:find("GetService") then
                    result = result:sub(1, result:len())
                    v = "[\"" .. v .. "\"]"
                elseif v:find("GetService") then
                    v = ':' .. v
                else
                    v = '.' .. v
                end
                
                result = result .. v
            end
            
            result = result:gsub("GetService(\"Players\")." .. name, "GetService(\"Players\").LocalPlayer")
            result = result:gsub("GetService(\"Players\")[\"" .. name .. "\"]", "GetService(\"Players\").LocalPlayer")

            return "game" .. result
        end,
        transform_value = function(self, value) -- Pulled from Hydroxide @Modified
            local result = ""
            local ttype = typeof(value)
          
            if ttype == "table" then
                result = result .. self:dump_table(value) 
            elseif ttype == "string" then
                result = result .. '"' .. value .. '"'
            elseif ttype == "Instance" then
                result = result .. self:transform_path(value:GetFullName())
            elseif ttype == "Vector3" then
                result = result .. "Vector3.new(" .. tostring(value) .. ")"
            elseif ttype == "CFrame" then
                result = result .. "CFrame.new(" .. tostring(value) .. ")"
            elseif ttype == "Color3" then
                result = result .. "Color3.new(" .. tostring(value) .. ")"
            elseif ttype == "Ray" then
                local split = tostring(value):split('}, ')
                local origin = split[1]:gsub('{', "Vector3.new("):gsub('}', ')')
                local direction = split[2]:gsub('{', "Vector3.new("):gsub('}', ')')
                result = result .. "Ray.new(" .. origin .. "), " .. direction .. ')'
            elseif ttype == "ColorSequence" then
                result = result .. "ColorSequence.new(" .. self:dump_table(v.Keypoints) .. ')'
            elseif ttype == "ColorSequenceKeypoint" then
                result = result .. "ColorSequenceKeypoint.new(" .. value.Time .. ", Color3.new(" .. tostring(value.Value) .. "))" 
            else
                if type(value) == "userdata" then
                    print(ttype)
                end
                
                result = result .. tostring(value)
            end
        
            return result
        end,
        dump_table = function(self, node, tree, indentation) -- Pulled from StackOverflow @ Alundaio // kris2k; @Modified
            local cache, stack, output = {},{},{}
            local depth = 1

            if type(node) ~= "table" then
                return "only table type is supported, got " .. type(node)
            end

            if nil == indentation then indentation = 1 end

            local NEW_LINE = "\n"
            local TAB_CHAR = "\t"

            if nil == tree then
                NEW_LINE = "\n"
            elseif not tree then
                NEW_LINE = ""
                TAB_CHAR = ""
            end

            local output_str = "{" .. NEW_LINE

            while true do
                local size = 0
                for k,v in pairs(node) do
                    size = size + 1
                end

                local cur_index = 1
                for k,v in pairs(node) do
                    if (cache[node] == nil) or (cur_index >= cache[node]) then
                        if (string.find(output_str,"}",output_str:len())) then
                            output_str = output_str .. "," .. NEW_LINE
                        elseif not (string.find(output_str,NEW_LINE,output_str:len())) then
                            output_str = output_str .. NEW_LINE
                        end
                        table.insert(output,output_str)
                        output_str = ""

                        local key
                        if (type(k) == "number" or type(k) == "boolean") then
                            key = "["..tostring(k).."]"
                        else
                            key = '["'..tostring(k)..'"]'
                        end
                        if (type(v) == "number" or type(v) == "boolean") then
                            output_str = output_str .. string.rep(TAB_CHAR,depth*indentation) .. key .. " = "..tostring(v)
                        elseif (type(v) == "table") then
                            output_str = output_str .. string.rep(TAB_CHAR,depth*indentation) .. key .. " = {" .. NEW_LINE
                            table.insert(stack,node)
                            table.insert(stack,v)
                            cache[node] = cur_index+1
                            break
                        else
                            output_str = output_str .. string.rep(TAB_CHAR,depth*indentation) .. key .. " = '"..tostring(v).."'"
                        end

                        if (cur_index == size) then
                            output_str = output_str .. NEW_LINE .. string.rep(TAB_CHAR,(depth-1)*indentation) .. "}"
                        else
                            output_str = output_str .. ","
                        end
                    else
                        if (cur_index == size) then
                            output_str = output_str .. NEW_LINE .. string.rep(TAB_CHAR,(depth-1)*indentation) .. "}"
                        end
                    end
                    cur_index = cur_index + 1
                end

                if (size == 0) then
                    output_str = output_str .. NEW_LINE .. string.rep(TAB_CHAR,(depth-1)*indentation) .. "}"
                end

                if (#stack > 0) then
                    node = stack[#stack]
                    stack[#stack] = nil
                    depth = cache[node] == nil and depth + 1 or depth - 1
                else
                    break
                end
            end
            table.insert(output,output_str)
            return table.concat(output)
        end,
    }

    metadata.__index = function(self, index)
        if methods[index] then
            return function(s, ...)
                return methods[index](self, ...);
            end
        end
    end

    setmetatable(FrostHook.ScriptGeneration, metadata);
end

do -- Text Editor
	local metadata = {};
	local methods = {
		CorrectTabs = function(self, code)
			return string.gsub(code, "\t", (string.rep("\t", self.TabSize+1)))
		end,
		RevertTabs = function(self, code)
			return code:gsub(string.rep("\t", self.TabSize+1), "\t")
		end,
		GetTextSize = function(self, text)
			text = (text~=nil)and text or "";
			return game:GetService("TextService"):GetTextSize(text, self.FontSize, self.Font, Vector2.new(math.huge, math.huge));
		end,
        SetCode = function(self, code)
            self.Imported = true;
			FrostHook.Interface.Topbar.Main.MainPanel.Code.Main.Input.Text = self:CorrectTabs(code);
		end,
		ExportCode = function(self, code)
			return self:RevertTabs(code);
		end,
		GetEndOfLine = function(self, code, start)
			local pos = start;
		    while true do
		        local char = string.sub(code, pos, pos)
		        if string.byte(char) == 10 or string.byte(char) == 13 then
		            break;
		        elseif pos > string.len(code) then
		            break;
		        else
		            pos = pos + 1;
		        end
		    end
		    return pos - 1;
		end,
        GetStartOfLine = function(self, code, start)
            local pos = start;
            while true do
                local char = string.sub(code, pos, pos)
                if string.byte(char) == 10 or string.byte(char) == 13 then
                    break;
                elseif pos <= 0 then
                    pos = 0;
                    break;
                else
                    pos = pos - 1;
                end
            end
            return pos + 1;
        end,
        GetLineText = function(self, code, start)
            local LineText = "";
            local first = self:GetStartOfLine(code, start);
            local second = self:GetEndOfLine(code, start);
            if first and second then
                LineText = string.sub(code, first, second);
            end
            return LineText;
        end,
		ClearHighlights = function(self)
			for d,p in pairs(self.Cache) do
				if p.Object then
					p.Object:Destroy();
				end
				self.Cache[d] = nil;
			end
		end,
	};
	
	metadata.__index = function(self, index)
		if methods[index] then
			return function(s, ...)
				return methods[index](self, ...);
			end
		end
	end
	
    metadata.__call = function(self)
        local Spy = FrostHook.Interface;
		local Templates = Spy.Templates;
		local Editor = Spy.Topbar.Main.MainPanel.Code;
		local Main = Editor.Main;
		local Highlights = Main.Highlights;
		local LineNumbers = Editor.Lines;
        local InputBox = Main.Input;
		
        FrostHook:RegisterConnection(InputBox:GetPropertyChangedSignal("Text"), function()

			local Lines = self:GetTextSize(InputBox.Text).Y/14
			
			if self.LineCache._len > Lines then
				for i=Lines,self.LineCache._len,1 do
					local Line = self.LineCache[i]
					if Line then
						Line:Destroy();
						self.LineCache[i] = nil;
					end
				end
			end
			
			self.LineCache._len = Lines;
			
			for i=1,Lines do
				local Line = self.LineCache[i]
				if not Line then
					Line = Templates.Line:Clone();
					Line.Visible = true;
					Line.Parent = LineNumbers;
					self.LineCache[i] = Line;
				end
				Line.Text = i;
				Line.Name = i;
				Line.LayoutOrder = i;
			end
			
			Main.CanvasSize = UDim2.new(0,0,0,LineNumbers.Layout.AbsoluteContentSize.Y)
			
			if math.abs(InputBox.CursorPosition - string.len(InputBox.Text)) <= 5 then
				Main.CanvasPosition = Vector2.new(0,LineNumbers.Layout.AbsoluteContentSize.Y)
			end
			
			self:ClearHighlights();
			
			if InputBox.Text ~= "" then
                for keyword,data in pairs(FrostHook.Keywords) do
                    local lastPosition = 0;
                    local cachedPosition = -1;
                    local StackOverflow = false;
                    local patternA = data[2]
                    local patternB = data[3]
                    while true do
                        if lastPosition == cachedPosition then
                            warn("Highlighting had a stack overflow!")
                            break;
                        end
                        cachedPosition = lastPosition;
                        local a,b = string.find(InputBox.Text, patternA..keyword..patternB, lastPosition, false)
                        if a and b then
                            local word = string.sub(InputBox.Text, a, b)
                            local iterations = 0;
                            repeat
                                iterations = iterations + 1;
                                if iterations >= 5 then
                                    StackOverflow = true;
                                    break;
                                end
                                local first = word:sub(1,1);
                                if first:find("%p") or first:find("%s") then
                                    a = a + 1;
                                    word = string.sub(InputBox.Text, a, b);
                                end
                                local last = word:sub(#word,#word)
                                if last:find("%p") or last:find("%s") then
                                    b = b - 1;
                                    word = string.sub(InputBox.Text, a, b);
                                end
                            until word == keyword or StackOverflow;

                            if not StackOverflow then
                                local LineStart = self:GetStartOfLine(InputBox.Text, a);
                                local LineText = InputBox.Text:sub(LineStart, a-1);
                                
                                self.Cache[tostring(a..":"..b)] = {
                                    ["Word"] = word,
                                    ["LineText"] = LineText,
                                    ["Object"] = nil,
                                }
                                lastPosition = b;
                            else
                                warn("Highlighting had a stack overflow!")
                            end;
                        else
                            break;
                        end
                    end
				end
				
				for PositionData,Data in pairs(self.Cache) do
					if Data and Data.Word and Data.LineText then
						local Word = Data.Word
						local LineText = Data.LineText;
                        local KeywordData = FrostHook.Keywords[tostring(Word)]
                        if KeywordData then
                            local ColorData = KeywordData[1]
                            local a,b = unpack(string.split(PositionData, ":"));
                        
                            local LineHeight = InputBox.LineHeight;
                            local Relative_Y = self:GetTextSize(string.sub(InputBox.Text, 1, b)).Y
                            Relative_Y = Relative_Y * LineHeight - (LineHeight*3)
                            local Relative_X = self:GetTextSize(Data.LineText).X
                            local keywordSize = self:GetTextSize(Word)
                            
                            local newLabel = Templates.Highlight:Clone();
                                newLabel.Position = UDim2.new(0,Relative_X,0,Relative_Y)
                                newLabel.Size = UDim2.new(0,keywordSize.X,0,keywordSize.Y)
                                newLabel.Text = Word;
                                newLabel.Name = a..":"..b;
                                newLabel.TextColor3 = ColorData;
                                newLabel.TextStrokeColor3 = Color3.new(ColorData.r-0.4,ColorData.g-0.4,ColorData.b-0.4)
                            newLabel.Parent = Highlights;
                            self.Cache[PositionData].Object = newLabel;
                        end
					end
				end
            elseif Text == "" then
                self.Imported = false;
            end
		end)
		
        FrostHook:RegisterConnection(FrostHook.Services.UserInputService.InputBegan, function(inputObject)
			local KeyCode = inputObject.KeyCode;
			local CursorPos = InputBox.CursorPosition
			local current_char = string.sub(InputBox.Text, CursorPos, CursorPos)
			local prev_char = string.sub(InputBox.Text, CursorPos-1,CursorPos-1)
			local next_char = string.sub(InputBox.Text, CursorPos+1,CursorPos+1)
			
			local CtrlDown = FrostHook.Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
			
            if KeyCode == Enum.KeyCode.C and CtrlDown then
                local Code = self.Imported and self:ExportCode(InputBox.Text) or InputBox.Text;
                FrostHook.env.to_clipboard(Code);
            elseif KeyCode == Enum.KeyCode.V and CtrlDown then
                self.Imported = false;
			elseif CtrlDown then
				return;
			end
			
			if InputBox:IsFocused() and InputBox.Text ~= "" then
				if KeyCode == Enum.KeyCode.Tab then -- working
					local all_before = string.sub(InputBox.Text, 1, CursorPos-1);
					local all_after = string.sub(InputBox.Text, CursorPos, string.len(InputBox.Text))
					InputBox.Text = all_before..string.rep("\t", self.TabSize)..all_after;
					InputBox.CursorPosition = CursorPos + self.TabSize;
				elseif KeyCode == Enum.KeyCode.Backspace then
					if prev_char == "\t" then
						local all_before = string.sub(InputBox.Text, 1, CursorPos-self.TabSize-1);
						local all_after = string.sub(InputBox.Text, CursorPos, string.len(InputBox.Text))
						InputBox.Text = all_before..all_after;
						InputBox.CursorPosition = CursorPos - self.TabSize;
					end
				elseif KeyCode == Enum.KeyCode.Left then
					if current_char == "\t" then
						CursorPos = CursorPos - self.TabSize;
						InputBox.CursorPosition = CursorPos;
					end
				elseif KeyCode == Enum.KeyCode.Right then
					if current_char == "\t" then
						CursorPos = CursorPos + self.TabSize;
						InputBox.CursorPosition = CursorPos;
					end
				elseif KeyCode == Enum.KeyCode.Up then
					if current_char == "\n" then
						CursorPos = CursorPos - 1;
					end
					local startLine = self:GetStartOfLine(InputBox.Text, CursorPos);
					InputBox.CursorPosition = startLine - 1;
				elseif KeyCode == Enum.KeyCode.Down then
					local endLine = self:GetEndOfLine(InputBox.Text, CursorPos);
                    endLine = self:GetEndOfLine(InputBox.Text, endLine) + 2;
                    endLine = self:GetEndOfLine(InputBox.Text, endLine)
					InputBox.CursorPosition = endLine + 1;
				end
			end
        end)
	end
	
	setmetatable(FrostHook.TextEditor, metadata);
end

FrostHook(); -- Initialize FrostHook Spy..