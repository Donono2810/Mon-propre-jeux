-- Gestionnaire pour les tests DataStore déclenchés depuis le client
-- Placez ce script dans ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunTestEvent = ReplicatedStorage:WaitForChild("RunDataStoreTest")
local uiEvent = ReplicatedStorage:FindFirstChild("UIUpdate")

local function isAuthorized(player)
    local ok, creatorId = pcall(function() return game.CreatorId end)
    if ok and creatorId and player.UserId == creatorId then
        return true
    end
    return false
end

RunTestEvent.OnServerEvent:Connect(function(player)
    if not isAuthorized(player) then
        if uiEvent then pcall(function() uiEvent:FireClient(player, { type = "Loading", state = "Error", message = "Non autorisé" }) end) end
        if _G.Log then pcall(_G.Log, "WARN", player.Name .. " a tenté d'exécuter le test DataStore sans autorisation") end
        return
    end

    if uiEvent then pcall(function() uiEvent:FireClient(player, { type = "Loading", state = "Start" }) end) end
    if _G.Log then pcall(_G.Log, "INFO", player.Name .. " a déclenché le test DataStore") end

    -- Phase de simulation
    _G.SimulateDataStoreFailure = true
    if _G.ForceSaveAll then pcall(_G.ForceSaveAll) end
    wait(2)

    -- Retenter sans simulation
    _G.SimulateDataStoreFailure = false
    if _G.ForceSaveAll then pcall(_G.ForceSaveAll) end

    if uiEvent then pcall(function() uiEvent:FireClient(player, { type = "Loading", state = "Done" }) end) end
    if _G.Log then pcall(_G.Log, "INFO", "Test DataStore terminé pour " .. player.Name) end
end)
