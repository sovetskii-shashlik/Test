for _,c in getconnections(game:GetService("LogService").MessageOut) do c:Disconnect() end for _,c in getconnections(game:GetService("ScriptContext").Error) do c:Disconnect() end

for _,c in getconnections(game:GetService("LogService").MessageOut) do c:Disconnect() end for _,c in getconnections(game:GetService("ScriptContext").Warn) do c:Disconnect() end