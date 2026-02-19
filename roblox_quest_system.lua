-- Système de quêtes simple (serveur)
-- Place ce script dans ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local questEvent = ReplicatedStorage:FindFirstChild("QuestUpdate")

-- Table mémoire des quêtes par joueur
local playerQuests = {}

-- Définition des quêtes disponibles
local Quests = {
    CollectCoins = {
        id = "CollectCoins",
        name = "Collecteur de pièces",
        description = "Collecte 10 pièces",
        eventType = "Collect",
        collectibleType = "Coin",
        goal = 10,
        reward = { gold = 30, xp = 50 }
    },
    KillEnemies = {
        id = "KillEnemies",
        name = "Chasseur",
        description = "Tue 5 ennemis",
        eventType = "Kill",
        goal = 5,
        reward = { gold = 60, xp = 120 }
    }
}

-- Helper: initialiser la quête active pour un joueur
local function assignDefaultQuest(player)
    local q = Quests.CollectCoins
    playerQuests[player.UserId] = {
        quest = q,
        progress = 0
    }

    -- Créer des valeurs visibles sur le joueur
    if not player:FindFirstChild("Quests") then
        local folder = Instance.new("Folder")
        folder.Name = "Quests"
        folder.Parent = player
        local nameVal = Instance.new("StringValue")
        nameVal.Name = "ActiveQuest"
        nameVal.Value = q.name
        nameVal.Parent = folder
        local progressVal = Instance.new("IntValue")
        progressVal.Name = "Progress"
        progressVal.Value = 0
        progressVal.Parent = folder
        local goalVal = Instance.new("IntValue")
        goalVal.Name = "Goal"
        goalVal.Value = q.goal
        goalVal.Parent = folder
    else
        local folder = player:FindFirstChild("Quests")
        folder.ActiveQuest.Value = q.name
        folder.Progress.Value = 0
        folder.Goal.Value = q.goal
    end
    -- Notifier le client de la quête assignée
    if questEvent then
        questEvent:FireClient(player, { type = "Assigned", questId = q.id, name = q.name, progress = 0, goal = q.goal })
    end
end

-- Compléter une quête et attribuer récompense
local function completeQuest(player)
    local data = playerQuests[player.UserId]
    if not data or not data.quest then return end
    local q = data.quest

    if q.reward then
        if _G.AddGold then _G.AddGold(player, q.reward.gold or 0) end
        if _G.AddXP then _G.AddXP(player, q.reward.xp or 0) end
        if q.reward.item and _G.AddItemToInventory then
            _G.AddItemToInventory(player, q.reward.item)
        end
    end

    -- message simple
    print(player.Name .. " a complété la quête: " .. q.name)

    -- notifier le client de la complétion
    if questEvent then
        questEvent:FireClient(player, { type = "Completed", questId = q.id, name = q.name })
    end

    -- Réassigner la quête suivante (simple rotation)
    if q.id == "CollectCoins" then
        playerQuests[player.UserId] = { quest = Quests.KillEnemies, progress = 0 }
        local folder = player:FindFirstChild("Quests")
        if folder then
            folder.ActiveQuest.Value = Quests.KillEnemies.name
            folder.Progress.Value = 0
            folder.Goal.Value = Quests.KillEnemies.goal
        end
            if questEvent then
                questEvent:FireClient(player, { type = "Assigned", questId = Quests.KillEnemies.id, name = Quests.KillEnemies.name, progress = 0, goal = Quests.KillEnemies.goal })
            end
    else
        playerQuests[player.UserId] = { quest = Quests.CollectCoins, progress = 0 }
        local folder = player:FindFirstChild("Quests")
        if folder then
            folder.ActiveQuest.Value = Quests.CollectCoins.name
            folder.Progress.Value = 0
            folder.Goal.Value = Quests.CollectCoins.goal
        end
            if questEvent then
                questEvent:FireClient(player, { type = "Assigned", questId = Quests.CollectCoins.id, name = Quests.CollectCoins.name, progress = 0, goal = Quests.CollectCoins.goal })
            end
    end
end

-- Rapport d'événements global: utilisé par d'autres scripts
_G.ReportEvent = function(eventType, player, data)
    if not player or not playerQuests[player.UserId] then return end
    local entry = playerQuests[player.UserId]
    local q = entry.quest
    if not q then return end

    if eventType == "Collect" and q.eventType == "Collect" then
        -- vérifier le type de collectible
        if data and data.collectibleType == q.collectibleType then
            entry.progress = entry.progress + 1
            local folder = player:FindFirstChild("Quests")
            if folder then folder.Progress.Value = entry.progress end
            print(player.Name .. " progression quête (Collect): " .. entry.progress .. "/" .. q.goal)
            if questEvent then
                questEvent:FireClient(player, { type = "Progress", questId = q.id, progress = entry.progress, goal = q.goal })
            end
            if entry.progress >= q.goal then
                completeQuest(player)
            end
        end
    elseif eventType == "Kill" and q.eventType == "Kill" then
        entry.progress = entry.progress + (data and data.amount or 1)
        local folder = player:FindFirstChild("Quests")
        if folder then folder.Progress.Value = entry.progress end
        print(player.Name .. " progression quête (Kill): " .. entry.progress .. "/" .. q.goal)
        if questEvent then
            questEvent:FireClient(player, { type = "Progress", questId = q.id, progress = entry.progress, goal = q.goal })
        end
        if entry.progress >= q.goal then
            completeQuest(player)
        end
    end
end

-- When player joins
Players.PlayerAdded:Connect(function(player)
    assignDefaultQuest(player)
end)

Players.PlayerRemoving:Connect(function(player)
    playerQuests[player.UserId] = nil
end)

print("Système de quêtes chargé!")