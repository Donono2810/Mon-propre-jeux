-- Système d'inventaire simple
-- Place ce script dans ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uiEvent = ReplicatedStorage:FindFirstChild("UIUpdate")

local function createInventory(player)
    if player:FindFirstChild("Inventory") then return end
    local inv = Instance.new("Folder")
    inv.Name = "Inventory"
    inv.Parent = player
end

local function addItem(player, itemName)
    if not player then return end
    createInventory(player)
    local inv = player:FindFirstChild("Inventory")
    local item = Instance.new("StringValue")
    item.Name = itemName
    item.Value = itemName
    item.Parent = inv
    print(player.Name .. " a reçu l'item: " .. itemName)
    -- notifier le client
    if uiEvent then
        uiEvent:FireClient(player, { type = "Inventory", action = "Add", item = itemName })
    end
end

Players.PlayerAdded:Connect(function(player)
    createInventory(player)
end)

-- exposer une fonction globale pour d'autres scripts
_G.AddItemToInventory = addItem

print("Système d'inventaire chargé!")