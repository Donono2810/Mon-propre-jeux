-- Logger serveur simple
-- Placez ce script dans ServerScriptService

local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")

local logsFolder = ServerStorage:FindFirstChild("Logs")
if not logsFolder then
    logsFolder = Instance.new("Folder")
    logsFolder.Name = "Logs"
    logsFolder.Parent = ServerStorage
end

local function timestamp()
    local ok, t = pcall(function() return os.date("%Y-%m-%d %H:%M:%S") end)
    if ok and t then return t end
    return tostring(tick())
end

local function writeLog(level, message)
    local entry = Instance.new("StringValue")
    entry.Name = string.format("%s_%d", level or "LOG", tick())
    entry.Value = string.format("[%s][%s] %s", timestamp(), tostring(level or "LOG"), tostring(message))
    entry.Parent = logsFolder
    -- nettoyage automatique après 24h
    Debris:AddItem(entry, 24 * 60 * 60)
    print(entry.Value)
end

-- Exposer la fonction globale
_G.Log = function(level, message)
    pcall(writeLog, level, message)
end

print("Logger serveur chargé: Logs/ dans ServerStorage")