-- ============================================
-- SYSTÈME DE SCORE ET POINTS
-- ============================================
-- Place ce script dans ServerScriptService

-- Système de score amélioré: leaderstats avec Gold, XP, Level et level-up
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uiEvent = ReplicatedStorage:FindFirstChild("UIUpdate")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))

local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local gold = Instance.new("IntValue")
    gold.Name = "Gold"
    gold.Value = 0
    gold.Parent = leaderstats

    local xp = Instance.new("IntValue")
    xp.Name = "XP"
    xp.Value = 0
    xp.Parent = leaderstats

    local level = Instance.new("IntValue")
    level.Name = "Level"
    level.Value = 1
    level.Parent = leaderstats
end

local function xpToNextLevel(currentLevel)
    local base = Config.xpPerLevelBase or 100
    return base * currentLevel
end

local function addGold(player, amount)
    if player and player:FindFirstChild("leaderstats") then
        local gold = player.leaderstats:FindFirstChild("Gold")
        if gold then
            gold.Value = gold.Value + amount
            print(player.Name .. " a gagné " .. amount .. " gold. Total: " .. gold.Value)
            -- notifier le client
            if uiEvent then
                local xpVal = player.leaderstats:FindFirstChild("XP")
                local lvlVal = player.leaderstats:FindFirstChild("Level")
                uiEvent:FireClient(player, { type = "Leaderstats", gold = gold.Value, xp = xpVal and xpVal.Value or 0, level = lvlVal and lvlVal.Value or 1 })
            end
        end
    end
end

local function addXP(player, amount)
    if not (player and player:FindFirstChild("leaderstats")) then return end
    local xp = player.leaderstats:FindFirstChild("XP")
    local level = player.leaderstats:FindFirstChild("Level")
    if not xp or not level then return end

    xp.Value = xp.Value + amount
    print(player.Name .. " gagne " .. amount .. " XP. Total XP: " .. xp.Value)

    -- level up
    while xp.Value >= xpToNextLevel(level.Value) do
        xp.Value = xp.Value - xpToNextLevel(level.Value)
        level.Value = level.Value + 1
        -- récompense de montée de niveau
        addGold(player, 50 * level.Value)
        print(player.Name .. " est monté au niveau " .. level.Value .. "!")
    end
    -- notifier le client des leaderstats mis à jour
    if uiEvent then
        uiEvent:FireClient(player, { type = "Leaderstats", gold = player.leaderstats.Gold.Value, xp = xp.Value, level = level.Value })
    end
end

Players.PlayerAdded:Connect(function(player)
    createLeaderstats(player)
    print(player.Name .. " a rejoint: leaderstats créés")
end)

Players.PlayerRemoving:Connect(function(player)
    -- leaderstats partira automatiquement avec le joueur
    print(player.Name .. " a quitté le jeu")
end)

print("Système de score (leaderstats) chargé!")

-- Exposer les fonctions globalement si besoin (autres scripts peuvent les appeler)
_G.AddGold = addGold
_G.AddXP = addXP
