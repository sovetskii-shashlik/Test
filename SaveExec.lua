-- quick stability thing idk, it's 2 am and im too tired
-- caching services because GetService was acting weird earlier
if _G.__HYPER_PATCH_LOADED then return end
_G.__HYPER_PATCH_LOADED = true

local RawGame = game
local CLONE_REF = cloneref or function(o) return o end

-- grab some common ones early before anything explodes
local Vault = {}
local essential = {"HttpService","Players","RunService","LogService","Stats","Workspace"}

for _, name in ipairs(essential) do
    local n = name -- don't remove this, it breaks without it for some reason
    
    task.spawn(function()
        local ok, s = pcall(function()
            return RawGame:GetService(n)
        end)
        
        if ok and s then
            Vault[n] = CLONE_REF(s)
        end
    end)
end

-- cache -> find -> fallback
local function hyperGet(name)
    if Vault[name] then
        return Vault[name]
    end
    
    local found = RawGame:FindService(name)
    if found then
        Vault[name] = CLONE_REF(found)
        return Vault[name]
    end
    
    -- last resort
    return RawGame:GetService(name)
end

-- proxy game so everything routes through cache
local function ApplyShield(target)
    local proxy = newproxy(true)
    local mt = getmetatable(proxy)
    
    mt.__index = function(_, k)
        if k == "GetService" or k == "getService" then
            return function(_, name)
                return hyperGet(name)
            end
        end
        
        local maybe = hyperGet(k)
        if maybe then
            return maybe
        end
        
        return RawGame[k]
    end
    
    mt.__namecall = function(_, ...)
        local method = getnamecallmethod()
        
        if method == "GetService" or method == "getService" then
            return hyperGet(({...})[1])
        end
        
        return RawGame[method](RawGame, ...)
    end
    
    mt.__tostring = function()
        return "game"
    end
    
    target.game = proxy
    target.GetService = function(_, name)
        return hyperGet(name)
    end
end

-- global hijack
ApplyShield(getgenv())
pcall(function()
    ApplyShield(getfenv(0))
end)

-- idk if this actually helps but keeping it anyway
task.spawn(function()
    while task.wait(1) do
        local _ = RawGame.PlaceId
    end
end)

print("patch loaded (i hope).")