-- Module de configuration pour le jeu
-- Placez ce ModuleScript dans ReplicatedStorage et nommez-le `GameConfig`

local Config = {
    -- Joueur
    moveSpeed = 16,
    jumpPower = 50,

    -- Combat
    baseDamage = 25,
    damagePerLevel = 5,

    -- Ennemis
    enemyHealth = 50,
    enemySpeed = 8,

    -- Collectibles / récompenses
    goldPerCoin = 10,
    goldPerGem = 50,
    goldPerPowerUp = 100,
    goldPerEnemy = 20,

    xpPerCoin = 5,
    xpPerGem = 25,
    xpPerPowerUp = 50,
    xpPerEnemy = 40,

    -- XP / level
    xpPerLevelBase = 100, -- XP nécessaire = xpPerLevelBase * level
}

return Config
