-- Initialise les RemoteEvents dans ReplicatedStorage
-- Place ce script dans ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureRemoteEvent(name)
    local ev = ReplicatedStorage:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = ReplicatedStorage
        print("RemoteEvent créé: " .. name)
    end
    return ev
end

ensureRemoteEvent("QuestUpdate")
ensureRemoteEvent("UIUpdate")
ensureRemoteEvent("RunDataStoreTest")

print("Network events initialisés")