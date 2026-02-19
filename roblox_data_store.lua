-- Système de sauvegarde simple (DataStore)
-- Placez ce script dans ServerScriptService

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = nil
if ReplicatedStorage:FindFirstChild("GameConfig") then
    local ok, mod = pcall(function() return require(ReplicatedStorage:WaitForChild("GameConfig")) end)
    if ok then Config = mod end
end

local SAVE_INTERVAL = 60 -- secondes
local dataStoreName = "MonPropreJeux_v1"
local DataStore
local successInit, err = pcall(function()
    DataStore = DataStoreService:GetDataStore(dataStoreName)
end)
if not successInit then
    warn("DataStoreService inaccessible: " .. tostring(err))
end

-- Flag de test pour simuler des échecs DataStore (modifiable par d'autres scripts)
if _G.SimulateDataStoreFailure == nil then
    _G.SimulateDataStoreFailure = false
end

-- Retry / exponential backoff settings
local MAX_RETRIES = 5
local BASE_DELAY = 1 -- seconde

local function withRetry(fn)
    for attempt = 1, MAX_RETRIES do
        -- si on simule des échecs, forcer une erreur
        if _G.SimulateDataStoreFailure then
            local result = "simulated failure"
            local delayTime = BASE_DELAY * (2 ^ (attempt - 1))
            delayTime = delayTime * (0.8 + math.random() * 0.4)
            if _G.Log then pcall(_G.Log, "WARN", string.format("DataStore simulated attempt %d failed: %s — retrying in %.2fs", attempt, tostring(result), delayTime)) end
            wait(delayTime)
        else
            local ok, result = pcall(fn)
            if ok then
                return true, result
            end
            local delayTime = BASE_DELAY * (2 ^ (attempt - 1))
            -- ajouter jitter
            delayTime = delayTime * (0.8 + math.random() * 0.4)
            if _G.Log then pcall(_G.Log, "WARN", string.format("DataStore attempt %d failed: %s — retrying in %.2fs", attempt, tostring(result), delayTime)) end
            wait(delayTime)
        end
    end
    return false, "max retries reached"
end

local function serializePlayer(player)
    local data = {}
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        data.Gold = ls:FindFirstChild("Gold") and ls.Gold.Value or 0
        data.XP = ls:FindFirstChild("XP") and ls.XP.Value or 0
        data.Level = ls:FindFirstChild("Level") and ls.Level.Value or 1
    end
    data.Inventory = {}
    local invFolder = player:FindFirstChild("Inventory")
    if invFolder then
        for _, item in ipairs(invFolder:GetChildren()) do
            table.insert(data.Inventory, item.Name)
        end
    end
    return data
end

local function restorePlayer(player, data)
    if not data then return end
    if not player then return end

    -- leaderstats
    if player:FindFirstChild("leaderstats") then
        local ls = player.leaderstats
        ls.Gold.Value = data.Gold or ls.Gold.Value
        ls.XP.Value = data.XP or ls.XP.Value
        ls.Level.Value = data.Level or ls.Level.Value
    end

    -- inventory
    local inv = player:FindFirstChild("Inventory")
    if not inv then
        inv = Instance.new("Folder")
        inv.Name = "Inventory"
        inv.Parent = player
    else
        for _, v in ipairs(inv:GetChildren()) do v:Destroy() end
    end
    if data.Inventory then
        for _, name in ipairs(data.Inventory) do
            local sv = Instance.new("StringValue")
            sv.Name = name
            sv.Value = name
            sv.Parent = inv
        end
    end
end

local function savePlayer(player)
    if not DataStore then return end
    local key = "player_" .. tostring(player.UserId)
    local data = serializePlayer(player)
    local ok, res = withRetry(function() return DataStore:SetAsync(key, data) end)
    if not ok then
        warn("Failed saving " .. player.Name .. ": " .. tostring(res))
    else
        print("Saved data for " .. player.Name)
    end
end

local function loadPlayer(player)
    if not DataStore then return end
    local key = "player_" .. tostring(player.UserId)
    local ok, data = withRetry(function() return DataStore:GetAsync(key) end)
    if not ok then
        warn("Failed loading data for " .. player.Name .. ": " .. tostring(data))
        return
    end
    if data then
        restorePlayer(player, data)
        print("Loaded data for " .. player.Name)
    else
        print("No saved data for " .. player.Name)
    end
end

Players.PlayerAdded:Connect(function(player)
    -- Attendre que leaderstats / inventory soient créés par d'autres scripts
    local ready = false
    local timer = 0
    while not ready and timer < 5 do
        if player:FindFirstChild("leaderstats") then ready = true break end
        wait(0.5)
        timer = timer + 0.5
    end
    wait(0.2)
    -- notifier le client que le chargement commence (si RemoteEvent présent)
    local uiEvent = ReplicatedStorage:FindFirstChild("UIUpdate")
    if uiEvent then
        pcall(function() uiEvent:FireClient(player, { type = "Loading", state = "Start" }) end)
    end

    -- charger les données
    local ok, err = pcall(function() loadPlayer(player) end)
    if not ok then
        warn("Error loading for " .. player.Name .. ": " .. tostring(err))
        if uiEvent then pcall(function() uiEvent:FireClient(player, { type = "Loading", state = "Error", message = tostring(err) }) end) end
    else
        if uiEvent then pcall(function() uiEvent:FireClient(player, { type = "Loading", state = "Done" }) end) end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    local ok, err = pcall(function() savePlayer(player) end)
    if not ok then warn("Error saving for " .. player.Name .. ": " .. tostring(err)) end
end)

-- Sauvegarde périodique
spawn(function()
    while true do
        wait(SAVE_INTERVAL)
        for _, player in ipairs(Players:GetPlayers()) do
            pcall(savePlayer, player)
        end
    end
end)

-- Exposer une fonction globale pour sauvegarder manuellement
_G.ForceSaveAll = function()
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(savePlayer, player)
    end
    print("ForceSaveAll done")
end

print("DataStore script chargé (si DataStore disponible)")