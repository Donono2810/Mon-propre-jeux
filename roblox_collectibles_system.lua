-- ============================================
-- SYSTÈME DE COLLECTIBLES/ITEMS
-- ============================================
-- Place ce script dans ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))

local collectiblesFolder = Instance.new("Folder")
collectiblesFolder.Name = "Collectibles"
collectiblesFolder.Parent = workspace

local function createCollectible(position, pointsValue, collectibleType)
    collectibleType = collectibleType or "Coin"
    if not pointsValue then
        if collectibleType == "Coin" then
            pointsValue = Config.goldPerCoin or 10
        elseif collectibleType == "Gem" then
            pointsValue = Config.goldPerGem or 50
        else
            pointsValue = Config.goldPerPowerUp or 100
        end
    end
    
    -- Créer l'objet collectible
    local collectible = Instance.new("Part")
    collectible.Name = "Collectible_" .. collectibleType
    collectible.Shape = Enum.PartType.Ball
    collectible.Size = Vector3.new(0.5, 0.5, 0.5)
    collectible.Position = position
    collectible.CanCollide = true
    collectible.Material = Enum.Material.Neon
    collectible.Parent = collectiblesFolder
    
    -- Couleur selon le type
    if collectibleType == "Coin" then
        collectible.BrickColor = BrickColor.new("Bright yellow")
    elseif collectibleType == "Gem" then
        collectible.BrickColor = BrickColor.new("Bright red")
    elseif collectibleType == "PowerUp" then
        collectible.BrickColor = BrickColor.new("Bright light blue")
    end
    
    -- Animation de rotation
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 5, 0)
    bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngularVelocity.Parent = collectible
    
    -- Détection de la collision
    local alreadyTouched = false
    
    collectible.Touched:Connect(function(hit)
        if alreadyTouched then return end
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if not humanoid then return end

        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if not player then return end

        alreadyTouched = true

        -- Donner récompenses selon le type
        if collectibleType == "Coin" then
            if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Gold") then
                player.leaderstats.Gold.Value = player.leaderstats.Gold.Value + pointsValue
            end
            if _G.AddXP then _G.AddXP(player, Config.xpPerCoin or 5) end
            if _G.ReportEvent then _G.ReportEvent("Collect", player, { collectibleType = "Coin", amount = 1 }) end
            print(player.Name .. " a collecté une pièce (+" .. pointsValue .. " gold)")
        elseif collectibleType == "Gem" then
            if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Gold") then
                player.leaderstats.Gold.Value = player.leaderstats.Gold.Value + pointsValue
            end
            if _G.AddXP then _G.AddXP(player, Config.xpPerGem or 25) end
            if _G.ReportEvent then _G.ReportEvent("Collect", player, { collectibleType = "Gem", amount = 1 }) end
            print(player.Name .. " a collecté une gemme (+" .. pointsValue .. " gold)")
        elseif collectibleType == "PowerUp" then
            -- Ajouter un item simple à l'inventaire (Folder)
            local inv = player:FindFirstChild("Inventory")
            if not inv then
                inv = Instance.new("Folder")
                inv.Name = "Inventory"
                inv.Parent = player
            end
            local item = Instance.new("StringValue")
            item.Name = "PowerUp"
            item.Value = "PowerUp"
            item.Parent = inv
            if _G.AddXP then _G.AddXP(player, Config.xpPerPowerUp or 50) end
            if _G.ReportEvent then _G.ReportEvent("Collect", player, { collectibleType = "PowerUp", amount = 1 }) end
            print(player.Name .. " a récupéré un PowerUp !")
        end

        collectible:Destroy()
    end)
    
    return collectible
end

-- Spawner des collectibles à travers la map
local spawnZones = {
    Vector3.new(0, 3, 0),
    Vector3.new(20, 3, 0),
    Vector3.new(-20, 3, 0),
    Vector3.new(0, 3, 20),
    Vector3.new(0, 3, -20),
    Vector3.new(15, 3, 15),
    Vector3.new(-15, 3, -15),
}

-- Créer des collectibles au démarrage
for _, zone in ipairs(spawnZones) do
    createCollectible(zone, nil, "Coin")
end

-- Spawner régulièrement des nouveaux collectibles
while true do
    wait(8)
    local randomZone = spawnZones[math.random(1, #spawnZones)]
    local offsetX = math.random(-5, 5)
    local offsetZ = math.random(-5, 5)
    local spawnPos = randomZone + Vector3.new(offsetX, 0, offsetZ)
    
    local coinType = math.random(1, 3)
    if coinType == 1 then
        createCollectible(spawnPos, nil, "Coin")
    elseif coinType == 2 then
        createCollectible(spawnPos, nil, "Gem")
    else
        createCollectible(spawnPos, nil, "PowerUp")
    end
end
