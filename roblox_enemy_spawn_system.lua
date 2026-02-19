-- ============================================
-- SYSTÈME DE SPAWN D'ENNEMIS
-- ============================================
-- Place ce script dans ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))

local spawnPositions = {
    Vector3.new(0, 5, 0),
    Vector3.new(10, 5, 0),
    Vector3.new(-10, 5, 0),
    Vector3.new(0, 5, 10),
    Vector3.new(0, 5, -10),
}

local Debris = game:GetService("Debris")

local function createEnemy(position)
    -- Créer un model ennemi simple
    local enemyModel = Instance.new("Model")
    enemyModel.Name = "Enemy"

    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 2)
    torso.Position = position
    torso.CanCollide = true
    torso.Parent = enemyModel

    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = Config.enemyHealth or 50
    humanoid.Health = humanoid.MaxHealth
    humanoid.Parent = enemyModel

    enemyModel.PrimaryPart = torso
    enemyModel.Parent = workspace

    humanoid.Died:Connect(function()
        -- Si un tag 'creator' existe, donner XP/Gold au joueur
        local creatorTag = humanoid:FindFirstChild("creator")
        local killer = nil
        if creatorTag and creatorTag.Value and creatorTag.Value:IsA("Player") then
            killer = creatorTag.Value
        end

        if killer then
            if _G.AddXP then _G.AddXP(killer, Config.xpPerEnemy or 40) end
            if killer:FindFirstChild("leaderstats") and killer.leaderstats:FindFirstChild("Gold") then
                killer.leaderstats.Gold.Value = killer.leaderstats.Gold.Value + (Config.goldPerEnemy or 20)
            end
            if _G.ReportEvent then _G.ReportEvent("Kill", killer, { amount = 1 }) end
            print(killer.Name .. " a tué un ennemi et gagne des récompenses")
        end

        -- Drop un petit collectible
        local dropPos = torso.Position + Vector3.new(0, 2, 0)
        local coin = Instance.new("Part")
        coin.Name = "Collectible_Coin"
        coin.Shape = Enum.PartType.Ball
        coin.Size = Vector3.new(0.5, 0.5, 0.5)
        coin.Position = dropPos
        coin.Material = Enum.Material.Neon
        coin.BrickColor = BrickColor.new("Bright yellow")
        coin.Parent = workspace
        Debris:AddItem(coin, 10)

        wait(0.5)
        enemyModel:Destroy()
    end)

    -- IA simple: suivre un joueur aléatoire
    spawn(function()
        while humanoid.Health > 0 do
            local players = game.Players:GetPlayers()
            if #players > 0 then
                local target = players[math.random(1, #players)]
                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local dir = (target.Character.HumanoidRootPart.Position - torso.Position)
                    if dir.Magnitude > 1 then
                        local velocity = dir.Unit * (Config.enemySpeed or 8)
                        torso.Velocity = Vector3.new(velocity.X, torso.Velocity.Y, velocity.Z)
                    end
                end
            end
            wait(0.2)
        end
    end)
end

-- Spawner les ennemis toutes les 5 secondes
while true do
    wait(5)
    local randomSpawn = spawnPositions[math.random(1, #spawnPositions)]
    createEnemy(randomSpawn)
    print("Un nouvel ennemi a été spawné!")
end
