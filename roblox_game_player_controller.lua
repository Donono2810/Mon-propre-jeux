-- ============================================
-- CONTRÔLEUR DE JOUEUR POUR ROBLOX
-- ============================================
-- Place ce script dans StarterPlayer > StarterCharacterScripts

local player = game.Players:GetPlayerFromCharacter(script.Parent)
local humanoid = script.Parent:WaitForChild("Humanoid")
local rootPart = script.Parent:WaitForChild("HumanoidRootPart")

-- Variables du joueur
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))
local moveSpeed = Config.moveSpeed or 16
local isJumping = false

-- Écouter les touches pressées (saut)
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        if not isJumping then
            isJumping = true
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            wait(0.15)
            isJumping = false
        end
    end
end)

-- Déplacement: mise à jour plus stable via RenderStepped
local runService = game:GetService("RunService")
runService.RenderStepped:Connect(function(dt)
    local moveDirection = Vector3.new(0, 0, 0)
    if userInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + rootPart.CFrame.LookVector
    end
    if userInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - rootPart.CFrame.LookVector
    end
    if userInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - rootPart.CFrame.RightVector
    end
    if userInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + rootPart.CFrame.RightVector
    end

    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
        -- Appliquer la vélocité horizontale, conserver la vélocité Y
        local currentVelocity = rootPart.Velocity
        rootPart.Velocity = Vector3.new(moveDirection.X * moveSpeed, currentVelocity.Y, moveDirection.Z * moveSpeed)
    end
end)

print("Contrôleur de joueur chargé (amélioré)!")
