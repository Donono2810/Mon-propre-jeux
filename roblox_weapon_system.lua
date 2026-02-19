-- ============================================
-- SYSTÈME D'ÉPÉE/ARME SIMPLE
-- ============================================
-- Place ce script dans une épée ou arme (Part dans le jeu)

local weapon = script.Parent
local humanoidOwner = nil
local ownerPlayer = nil
local lastAttackTime = 0
local attackCooldown = 1 -- 1 seconde entre les attaques
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))
local baseDamage = Config.baseDamage or 25
local damagePerLevel = Config.damagePerLevel or 5
local Debris = game:GetService("Debris")

-- Détecter qui tient l'arme
local function onTouched(hit)
    if not ownerPlayer then return end
    if hit.Parent == ownerPlayer.Character then return end -- Ne pas se frapper soi-même

    local targetHumanoid = hit.Parent:FindFirstChild("Humanoid")
    if not targetHumanoid then return end

    local currentTime = tick()
    if currentTime - lastAttackTime < attackCooldown then return end
    lastAttackTime = currentTime

    -- Calculer dégâts selon niveau du joueur
    local damage = baseDamage
    if ownerPlayer and ownerPlayer:FindFirstChild("leaderstats") and ownerPlayer.leaderstats:FindFirstChild("Level") then
        damage = damage + (ownerPlayer.leaderstats.Level.Value - 1) * damagePerLevel
    end

    -- Taguer le humanoid avec le 'creator' pour attribution de récompense
    local creatorTag = Instance.new("ObjectValue")
    creatorTag.Name = "creator"
    creatorTag.Value = ownerPlayer
    creatorTag.Parent = targetHumanoid
    Debris:AddItem(creatorTag, 3)

    targetHumanoid:TakeDamage(damage)
    print("Coup porté par " .. ownerPlayer.Name .. "! Dégâts: " .. damage .. " | HP restant: " .. targetHumanoid.Health)
end

-- Détecter quand l'arme est equipée
local function onEquipped()
    local player = game.Players:GetPlayerFromCharacter(script.Parent.Parent)
    if player then
        ownerPlayer = player
        humanoidOwner = script.Parent.Parent:FindFirstChild("Humanoid")
        print("Arme équipée par " .. player.Name)
    end
end

local function onUnequipped()
    print("Arme déséquipée!")
    humanoidOwner = nil
    ownerPlayer = nil
    lastAttackTime = 0
end

if weapon:FindFirstChild("Handle") then
    weapon.Handle.Touched:Connect(onTouched)
elseif weapon:IsA("BasePart") then
    weapon.Touched:Connect(onTouched)
end

-- Optionnel: si c'est une Tool
if weapon:IsA("Tool") then
    weapon.Equipped:Connect(onEquipped)
    weapon.Unequipped:Connect(onUnequipped)
end

print("Script d'arme chargé (amélioré)!")
