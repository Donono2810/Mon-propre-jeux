-- ============================================
-- SYSTÈME D'INTERFACE UTILISATEUR (GUI)
-- ============================================
-- Place ce script dans StarterGui ou StarterPlayer > StarterCharacterScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Créer le cadre principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Label Gold/Score
local scoreLabel = Instance.new("TextLabel")
scoreLabel.Name = "ScoreLabel"
scoreLabel.Size = UDim2.new(0, 200, 0, 40)
scoreLabel.Position = UDim2.new(0, 10, 0, 10)
scoreLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
scoreLabel.BackgroundTransparency = 0.5
scoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
scoreLabel.TextSize = 20
scoreLabel.Font = Enum.Font.GothamBold
scoreLabel.Text = "Gold: 0"
scoreLabel.Parent = screenGui

-- Label Level
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(0, 200, 0, 30)
levelLabel.Position = UDim2.new(0, 10, 0, 55)
levelLabel.BackgroundTransparency = 1
levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
levelLabel.TextSize = 18
levelLabel.Font = Enum.Font.Gotham
levelLabel.Text = "Niveau: 1"
levelLabel.Parent = screenGui

-- XP bar
local xpBar = Instance.new("Frame")
xpBar.Name = "XPBar"
xpBar.Size = UDim2.new(0, 200, 0, 16)
xpBar.Position = UDim2.new(0, 10, 0, 90)
xpBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
xpBar.Parent = screenGui

local xpFill = Instance.new("Frame")
xpFill.Name = "XPFill"
xpFill.Size = UDim2.new(0, 0, 1, 0)
xpFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
xpFill.BorderSizePixel = 0
xpFill.Parent = xpBar

-- Health labels and bar
local healthLabel = Instance.new("TextLabel")
healthLabel.Name = "HealthLabel"
healthLabel.Size = UDim2.new(0, 200, 0, 30)
healthLabel.Position = UDim2.new(0, 10, 0, 115)
healthLabel.BackgroundTransparency = 1
healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
healthLabel.TextSize = 18
healthLabel.Font = Enum.Font.Gotham
healthLabel.Text = "HP: 100"
healthLabel.Parent = screenGui

-- Inventory simple
local invFrame = Instance.new("Frame")
invFrame.Name = "Inventory"
invFrame.Size = UDim2.new(0, 220, 0, 120)
invFrame.Position = UDim2.new(1, -230, 0, 10)
invFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
invFrame.BackgroundTransparency = 0.4
invFrame.Parent = screenGui

local invTitle = Instance.new("TextLabel")
invTitle.Size = UDim2.new(1, -10, 0, 24)
invTitle.Position = UDim2.new(0, 5, 0, 5)
invTitle.BackgroundTransparency = 1
invTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
invTitle.Text = "Inventaire"
invTitle.Font = Enum.Font.GothamBold
invTitle.TextSize = 18
invTitle.Parent = invFrame

local invList = Instance.new("UIListLayout")
invList.Padding = UDim.new(0, 4)
invList.Parent = invFrame

-- Zone d'affichage de quête
local questFrame = Instance.new("Frame")
questFrame.Name = "QuestFrame"
questFrame.Size = UDim2.new(0, 300, 0, 70)
questFrame.Position = UDim2.new(0.5, -150, 0, 10)
questFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
questFrame.BackgroundTransparency = 0.4
questFrame.Parent = screenGui

local questTitle = Instance.new("TextLabel")
questTitle.Size = UDim2.new(1, -10, 0, 24)
questTitle.Position = UDim2.new(0, 5, 0, 5)
questTitle.BackgroundTransparency = 1
questTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
questTitle.Text = "Aucune quête"
questTitle.Font = Enum.Font.GothamBold
questTitle.TextSize = 16
questTitle.Parent = questFrame

local questProgress = Instance.new("TextLabel")
questProgress.Size = UDim2.new(1, -10, 0, 20)
questProgress.Position = UDim2.new(0, 5, 0, 34)
questProgress.BackgroundTransparency = 1
questProgress.TextColor3 = Color3.fromRGB(200, 200, 200)
questProgress.Text = ""
questProgress.Font = Enum.Font.Gotham
questProgress.TextSize = 14
questProgress.Parent = questFrame

-- Overlay de chargement
local loadingOverlay = Instance.new("Frame")
loadingOverlay.Name = "LoadingOverlay"
loadingOverlay.Size = UDim2.new(1, 0, 1, 0)
loadingOverlay.Position = UDim2.new(0, 0, 0, 0)
loadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingOverlay.BackgroundTransparency = 0.6
loadingOverlay.Visible = false
loadingOverlay.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 400, 0, 60)
loadingText.Position = UDim2.new(0.5, -200, 0.5, -30)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 24
loadingText.Text = ""
loadingText.Parent = loadingOverlay

-- Bouton de test DataStore (visible uniquement au créateur du jeu)
local testButton = Instance.new("TextButton")
testButton.Name = "TestDataStoreButton"
testButton.Size = UDim2.new(0, 160, 0, 28)
testButton.Position = UDim2.new(1, -180, 1, -40)
testButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Text = "Run DataStore Test"
testButton.Font = Enum.Font.Gotham
testButton.TextSize = 14
testButton.Visible = false
testButton.Parent = screenGui

-- Montrer le bouton seulement si le joueur est le créateur du jeu
local okCreator, creatorId = pcall(function() return game.CreatorId end)
if okCreator and creatorId and player.UserId == creatorId then
    testButton.Visible = true
end

-- Envoyer l'événement au serveur
local runTestEvent = ReplicatedStorage:FindFirstChild("RunDataStoreTest")
if runTestEvent then
    testButton.MouseButton1Click:Connect(function()
        pcall(function() runTestEvent:FireServer() end)
    end)
end

-- Écoute du RemoteEvent QuestUpdate
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local questEvent = ReplicatedStorage:WaitForChild("QuestUpdate")
questEvent.OnClientEvent:Connect(function(payload)
    if not payload then return end
    if payload.type == "Assigned" then
        questTitle.Text = payload.name or "Quête"
        questProgress.Text = "Progress: " .. (payload.progress or 0) .. "/" .. (payload.goal or "?")
    elseif payload.type == "Progress" then
        questProgress.Text = "Progress: " .. (payload.progress or 0) .. "/" .. (payload.goal or "?")
    elseif payload.type == "Completed" then
        questTitle.Text = payload.name .. " (Complétée)"
        questProgress.Text = "Récompense reçue"
        -- courte animation: revenir à aucune quête après 3s
        delay(3, function()
            questTitle.Text = "Aucune quête"
            questProgress.Text = ""
        end)
    end
end)

-- Écoute des updates UI (leaderstats / inventaire)
local uiEvent = ReplicatedStorage:WaitForChild("UIUpdate")
uiEvent.OnClientEvent:Connect(function(payload)
    if not payload then return end
    if payload.type == "Loading" then
        -- payload.state: "Start" | "Done" | "Error"
        if payload.state == "Start" then
            -- afficher overlay
            loadingOverlay.Visible = true
            loadingText.Text = "Chargement des données..."
        elseif payload.state == "Done" then
            loadingOverlay.Visible = false
        elseif payload.state == "Error" then
            loadingText.Text = "Erreur de chargement"
            delay(3, function() loadingOverlay.Visible = false end)
        end
        return
    end
    if payload.type == "Leaderstats" then
        if payload.gold ~= nil then scoreLabel.Text = "Gold: " .. payload.gold end
        if payload.level ~= nil then levelLabel.Text = "Niveau: " .. payload.level end
        if payload.xp ~= nil and payload.level ~= nil then
            local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))
            local need = (Config.xpPerLevelBase or 100) * payload.level
            local percent = 0
            if need > 0 then percent = payload.xp / need end
            xpFill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        end
    elseif payload.type == "Inventory" then
        -- ajouter rapidement l'item à l'affichage
        if payload.action == "Add" and payload.item then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 24)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.Text = payload.item
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 16
            lbl.Parent = invFrame
        end
    end
end)

-- Mettre à jour l'interface
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function updateLeaderstats()
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local gold = ls:FindFirstChild("Gold")
        local xp = ls:FindFirstChild("XP")
        local level = ls:FindFirstChild("Level")
        if gold then scoreLabel.Text = "Gold: " .. gold.Value end
        if level then levelLabel.Text = "Niveau: " .. level.Value end
        if xp and level then
            local need = 100 * level.Value
            local percent = 0
            if need > 0 then percent = xp.Value / need end
            xpFill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        end
    end
end

local function updateHealth()
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
end

-- Surveillance des leaderstats (réactif)
player.ChildAdded:Connect(function(child)
    if child.Name == "leaderstats" then
        child.ChildAdded:Connect(function() updateLeaderstats() end)
        child.ChildChanged:Connect(function() updateLeaderstats() end)
        updateLeaderstats()
    end
end)

-- Inventory affichage
local function refreshInventory()
    -- supprimer anciens éléments (sauf le titre)
    for _, v in ipairs(invFrame:GetChildren()) do
        if v ~= invTitle and not v:IsA("UIListLayout") then
            v:Destroy()
        end
    end
    local inv = player:FindFirstChild("Inventory")
    if inv then
        for _, item in ipairs(inv:GetChildren()) do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 24)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.Text = item.Name
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 16
            lbl.Parent = invFrame
        end
    end
end

-- Mettre à jour chaque frame pour la santé et synchroniser leaderstats/inventory
game:GetService("RunService").RenderStepped:Connect(function()
    updateHealth()
    updateLeaderstats()
    refreshInventory()
end)

print("Interface utilisateur chargée (améliorée)!")
