-- Stealth External Code Detector V4.0

local SafeToFile = true
local FolderName = "MihaLogger"
local FileName = "detected_code.txt"
local ShowNotifications = true

getgenv().StealthLogs = {}

local function safeNotify(title, text, duration)
    if not ShowNotifications then return end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

local function ensureDirectory()
    if not isfolder(FolderName) then
        makefolder(FolderName)
    end
end

local function clearOldLogs()
    if SafeToFile then
        ensureDirectory()
        if isfile(FolderName.."/"..FileName) then
            delfile(FolderName.."/"..FileName)
        end
    end
end

local function logDetectedCode(code, source, extra)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    local logEntry = string.format(
        "[%s] [%s] %s\nCODE:\n%s\n%s\n",
        timestamp, source, extra or "",
        code,
        string.rep("-", 60)
    )
    
    table.insert(getgenv().StealthLogs, {
        timestamp = timestamp,
        code = code,
        source = source,
        extra = extra
    })
    
    if SafeToFile then
        ensureDirectory()
        pcall(function()
            local filePath = FolderName.."/"..FileName
            local fileContent = ""
            
            if isfile(filePath) then
                fileContent = readfile(filePath).."\n"
            else
                fileContent = "-- Stealth Detection Logs --\n\n"
            end
            
            writefile(filePath, fileContent..logEntry)
        end)
    end
    
    safeNotify("Code Detected", source..": "..(extra or ""))
end

local function installStealthHooks()
    local originalFunctions = {
        loadstring = loadstring,
        load = load,
        getfenv = getfenv,
        setfenv = setfenv,
        coroutine = {
            create = coroutine.create,
            wrap = coroutine.wrap
        }
    }
    
    local stealthLoadstring = function(code, chunkname)
        if type(code) == "string" and #code > 10 then
            coroutine.wrap(function()
                wait(0.1)
                logDetectedCode(code, "loadstring", "STEALTH")
            end)()
        end
        return originalFunctions.loadstring(code, chunkname)
    end
    
    local stealthLoad = function(code, chunkname, ...)
        if type(code) == "string" and #code > 10 then
            coroutine.wrap(function()
                wait(0.1)
                logDetectedCode(code, "load", "STEALTH")
            end)()
        end
        return originalFunctions.load(code, chunkname, ...)
    end
    
    local slowHook = function()
        for i = 1, 10 do
            wait(0.05)
            if i == 5 then
                getgenv().loadstring = stealthLoadstring
                getgenv().load = stealthLoad
            end
        end
    end
    
    coroutine.wrap(slowHook)()
end

local function hookHttpRequests()
    local httpService = game:GetService("HttpService")
    
    if httpService then
        local originalGetAsync = httpService.GetAsync
        
        local metaHook = function(self, ...)
            local args = {...}
            local url = args[1]
            
            if type(url) == "string" and (url:find("raw%)") or url:find("pastefy") or url:find("pastebin")) then
                coroutine.wrap(function()
                    wait(0.2)
                    pcall(function()
                        local content = originalGetAsync(self, url)
                        if content and #content > 10 then
                            logDetectedCode(content, "HTTP_GET", "URL: "..url)
                        end
                    end)
                end)()
            end
            
            return originalGetAsync(self, ...)
        end
        
        pcall(function()
            httpService.GetAsync = metaHook
        end)
    end
end

local function bypassHookDetections()
    local g = (getfenv().getgenv or getfenv)()
    
    if g then
        if type(g.is_function_hooked) == "function" then
            g.is_function_hooked = function(f) return false end
        end
        if type(g.isfunctionhooked) == "function" then
            g.isfunctionhooked = function(f) return false end
        end
        if type(g.is_c_closure) == "function" then
            g.is_c_closure = function(f) return true end
        end
        if type(g.iscclosure) == "function" then
            g.iscclosure = function(f) return true end
        end
    end
end

local function installDebugHooks()
    local originalTraceback = debug.traceback
    debug.traceback = function(...)
        local stack = originalTraceback(...)
        if stack:find("%[string%]") and not stack:find("StealthDetector") then
            coroutine.wrap(function()
                wait(0.1)
                logDetectedCode(stack, "DEBUG_TRACEBACK", "EXTERNAL_EXECUTION")
            end)()
        end
        return stack
    end
end

local function installTaskMonitoring()
    local originalSpawn = task.spawn or spawn
    
    if task.spawn then
        task.spawn = function(fn, ...)
            if type(fn) == "function" then
                local info = debug.getinfo(fn)
                if info and info.source and info.source:find("%[string%]") then
                    coroutine.wrap(function()
                        wait(0.1)
                        logDetectedCode(info.source, "TASK_SPAWN", "ASYNC_EXECUTION")
                    end)()
                end
            end
            return originalSpawn(fn, ...)
        end
    end
end

clearOldLogs()

coroutine.wrap(function()
    wait(0.5)
    bypassHookDetections()
end)()

coroutine.wrap(function()
    wait(1)
    installStealthHooks()
end)()

coroutine.wrap(function()
    wait(1.5)
    hookHttpRequests()
end)()

coroutine.wrap(function()
    wait(2)
    installDebugHooks()
end)()

coroutine.wrap(function()
    wait(2.5)
    installTaskMonitoring()
end)()

safeNotify("Stealth Detector", "Advanced detection activated")

while true do
    wait(10)
    pcall(bypassHookDetections)
end