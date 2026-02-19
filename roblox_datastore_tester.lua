-- Script de test DataStore (simulateur d'erreurs)
-- Placez ce script dans ServerScriptService pour exécuter un test manuel.

local Players = game:GetService("Players")
local wait = task.wait

-- Attendre que le système principal soit chargé
wait(2)

local function safeLog(level, msg)
    if _G.Log then pcall(_G.Log, level, msg) else print(level, msg) end
end

safeLog("INFO", "DataStore tester démarré")

-- Phase 1: simuler échecs et appeler ForceSaveAll
_G.SimulateDataStoreFailure = true
safeLog("INFO", "Simulation DataStore activée (les appels Set/Get échoueront)")
if _G.ForceSaveAll then
    safeLog("INFO", "Appel ForceSaveAll() en mode simulation...")
    pcall(function() _G.ForceSaveAll() end)
else
    safeLog("WARN", "_G.ForceSaveAll() introuvable")
end

wait(3)

-- Phase 2: désactiver simulation et retenter
_G.SimulateDataStoreFailure = false
safeLog("INFO", "Simulation DataStore désactivée — retentative")
if _G.ForceSaveAll then
    pcall(function() _G.ForceSaveAll() end)
end

-- Optionnel: simuler un chargement pour un joueur existant
local testPlayer = Players:GetPlayers()[1]
if testPlayer and _G.Log then
    safeLog("INFO", "Test load pour " .. testPlayer.Name)
    -- appeler manuellement la fonction de sauvegarde/chargement via pcall sur DataStore si souhaité
end

safeLog("INFO", "DataStore tester terminé")
print("roblox_datastore_tester.lua exécuté")