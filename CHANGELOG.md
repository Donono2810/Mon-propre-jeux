# Changelog

## v1.0.0 - Initial release

Dates: 2026-02-19

Included features:

- Inventory system (server-side folder per player)
- Leaderstats: Gold / XP / Level with level-up rewards
- Collectibles (Coins, Gems, PowerUps)
- Enemy spawn system and simple AI
- Weapon system with creator tagging for kills
- Client UI: Gold, Level, XP bar, Health, Inventory, Quest display
- Quest system (collect & kill quests) with notifications
- GameConfig module to centralize parameters
- DataStore save/load with exponential backoff retries
- Server logger and DataStore test utilities
- RemoteEvents for UI and test control

Notes:

- Place scripts as documented in README.md. The `GameConfig` ModuleScript should be put in `ReplicatedStorage`.
- The PR for this changelog is intended to provide a visible diff for the release process.
