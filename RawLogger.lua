-- Raw Links Hook Logger V2.0 

-- Settings
local SafeToFile = true
local CopyToClipboard = false
local FolderName = "MihaLogger"
local FileName = "raw_hooks_logs.txt"
local ShowNotifications = true

getgenv().RawHooksLogs = {}

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

local function writeToFile(content)
    if not SafeToFile then return end
    
    ensureDirectory()
    pcall(function()
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local filePath = FolderName.."/"..FileName
        local fileContent = ""
        
        if isfile(filePath) then
            fileContent = readfile(filePath).."\n"
        else
            fileContent = "-- Raw Hooks Logs --\n\n"
        end
        
        local newContent = string.format("-- [%s] --\n%s\n", timestamp, content)
        writefile(filePath, fileContent..newContent)
    end)
end

local function copyToClipboard(content)
    if not CopyToClipboard then return end
    pcall(function()
        if setclipboard then
            setclipboard(content)
        end
    end)
end

local function logRawAccess(url, source)
    local timestamp = os.date("%H:%M:%S")
    local logEntry = string.format("[%s] %s - %s", timestamp, url, source)
    
    table.insert(getgenv().RawHooksLogs, logEntry)
    writeToFile(logEntry)
    copyToClipboard(url)
    safeNotify("Raw Hook", "Intercepted: "..url:sub(1, 30).."...")
end

local function hookHttpService()
    local httpService = game:GetService("HttpService")
    
    local originalGetAsync = httpService.HttpGetAsync
    httpService.HttpGetAsync = function(self, url, ...)
        if type(url) == "string" then
            if url:find("raw") or url:find("%.lua") or url:find("%.txt") or url:find("%.luau") then
                logRawAccess(url, "HttpService:GetAsync")
            end
        end
        return originalGetAsync(self, url, ...)
    end
    
    local originalPostAsync = httpService.PostAsync
    httpService.PostAsync = function(self, url, ...)
        if type(url) == "string" then
            if url:find("raw") or url:find("%.lua") or url:find("%.txt") or url:find("%.luau") then
                logRawAccess(url, "HttpService:PostAsync")
            end
        end
        return originalPostAsync(self, url, ...)
    end
end

local function hookRequire()
    local originalRequire = require
    getgenv().require = function(module, ...)
        if type(module) == "string" then
            if module:find("raw") or module:find("%.lua") or module:find("%.txt") or module:find("%.luau") then
                logRawAccess(module, "require")
            end
        end
        return originalRequire(module, ...)
    end
end

-- Hook loadstring for direct raw content loading
local originalLoadstring = loadstring or load
getgenv().loadstring = function(code, ...)
    if type(code) == "string" then
        -- Check for raw URLs in the code
        for url in code:gmatch("['\"]([^'\"]*raw[^'\"]*)['\"]") do
            if url:find("raw") or url:find("%.lua") or url:find("%.txt") or url:find("%.luau") then
                logRawAccess(url, "loadstring")
            end
        end
    end
    return originalLoadstring(code, ...)
end

getgenv().load = getgenv().loadstring

local function hookHttpFunctions()
    if type(game.HttpGet) == "function" then
        local originalHttpGet = game.HttpGet
        game.HttpGet = function(self, url, ...)
            if type(url) == "string" then
                if url:find("raw") or url:find("%.lua") or url:find("%.txt") or url:find("%.luau") then
                    logRawAccess(url, "game:HttpGet")
                end
            end
            return originalHttpGet(self, url, ...)
        end
    end
    
    if type(game.HttpPost) == "function" then
        local originalHttpPost = game.HttpPost
        game.HttpPost = function(self, url, ...)
            if type(url) == "string" then
                if url:find("raw") or url:find("%.lua") or url:find("%.txt") or url:find("%.luau") then
                    logRawAccess(url, "game:HttpPost")
                end
            end
            return originalHttpPost(self, url, ...)
        end
    end
end

local function hookFileOperations()
    if type(dofile) == "function" then
        local originalDofile = dofile
        getgenv().dofile = function(filename, ...)
            if type(filename) == "string" then
                if filename:find("raw") or filename:find("%.lua") or filename:find("%.txt") or filename:find("%.luau") then
                    logRawAccess(filename, "dofile")
                end
            end
            return originalDofile(filename, ...)
        end
    end
    
    if type(loadfile) == "function" then
        local originalLoadfile = loadfile
        getgenv().loadfile = function(filename, ...)
            if type(filename) == "string" then
                if filename:find("raw") or filename:find("%.lua") or filename:find("%.txt") or filename:find("%.luau") then
                    logRawAccess(filename, "loadfile")
                end
            end
            return originalLoadfile(filename, ...)
        end
    end
end

local function hookStringPatterns()
    local stringMeta = getmetatable("")
    if stringMeta then
        local originalMatch = stringMeta.match
        stringMeta.match = function(self, pattern, ...)
            local result = originalMatch(self, pattern, ...)
            if type(result) == "string" and (result:find("raw") or result:find("%.lua") or result:find("%.txt") or result:find("%.luau")) then
                logRawAccess(result, "string:match")
            end
            return result
        end
        
        local originalGmatch = stringMeta.gmatch
        stringMeta.gmatch = function(self, pattern, ...)
            local iterator = originalGmatch(self, pattern, ...)
            return function()
                local result = iterator()
                if type(result) == "string" and (result:find("raw") or result:find("%.lua") or result:find("%.txt") or result:find("%.luau")) then
                    logRawAccess(result, "string:gmatch")
                end
                return result
            end
        end
    end
end

clearOldLogs()
hookHttpService()
hookRequire()
hookHttpFunctions()
hookFileOperations()
hookStringPatterns()

safeNotify("Raw Links Hook Logger", "All hooks installed successfully")