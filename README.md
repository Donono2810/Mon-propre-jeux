Mon-propre-jeux — Guide rapide d'installation et de test

But: Ce dépôt contient des scripts Lua pour Roblox (prototype RPG simple).

Placement des scripts dans Roblox Studio
- ServerScriptService:
  - `roblox_score_system.lua` (leaderstats: Gold / XP / Level)
  - `roblox_collectibles_system.lua` (spawns de collectibles)
  - `roblox_enemy_spawn_system.lua` (spawns ennemis et récompenses)
  - `roblox_inventory_system.lua` (gestion serveur de l'inventaire)
  - `roblox_quest_system.lua` (logique des quêtes, notifications)
  - `roblox_network_events.lua` (crée RemoteEvents `QuestUpdate` et `UIUpdate`)
  - `GameConfig` (ModuleScript dans `ReplicatedStorage` — paramètres du jeu)

- StarterPlayer > StarterCharacterScripts:
  - `roblox_game_player_controller.lua` (contrôles et mouvement du joueur)

- StarterGui (LocalScript) ou StarterPlayer > StarterCharacterScripts:
  - `roblox_ui_system.lua` (UI client: Gold/Level/XP/Inventaire/Quêtes)

- Tools / armes (ex: Tool ou Part attachée à une arme):
  - `roblox_weapon_system.lua` (gestion des attaques, tag `creator` pour rewards)

Notes importantes
- `roblox_network_events.lua` crée automatiquement deux RemoteEvents dans `ReplicatedStorage`: `QuestUpdate` et `UIUpdate`.
- Les fonctions globales exposées côté serveur que d'autres scripts peuvent appeler :
  - `_G.AddXP(player, amount)`
  - `_G.AddGold(player, amount)`
  - `_G.AddItemToInventory(player, itemName)`
  - `_G.ReportEvent(eventType, player, data)` (utilisé par collectibles/ennemis pour quêtes)

Test rapide dans Roblox Studio
1. Ouvrir Roblox Studio et charger la place.
2. Placer chaque script aux emplacements indiqués ci-dessus.
3. Lancer `Play` (Solo).
4. Ouvrir la fenêtre `Output` pour voir les prints.
5. Vérifier que `leaderstats` apparaît pour le joueur (Gold/XP/Level).
6. Ramasser un collectible : observe Gold/XP augmentés et UI mis à jour.
7. Tuer un ennemi : si ton attaque a tagué le humanoid, tu dois recevoir XP/Gold.
8. Observer les notifications de quêtes dans l'UI (assignation / progression / complétion).

Débogage rapide
- Si l'UI ne réagit pas, vérifier que `QuestUpdate` et `UIUpdate` existent dans `ReplicatedStorage`.
- Assure-toi que les scripts côté client sont LocalScripts placés sous `StarterGui` ou `StarterCharacterScripts`.

Prochaines améliorations suggérées
- Balancer XP/gold/dégâts et rendre les valeurs paramétrables (ModuleConfig).
- Sauvegarde des leaderstats/inventaire (DataStore).
- Ajout d'une interface de quêtes détaillée et multiples quêtes simultanées.

Si tu veux, j'ajoute maintenant un petit ModuleConfig pour centraliser les paramètres (XP, gold, vitesses).

## ℹ️ DataStore et écran de chargement

- Le script `roblox_data_store.lua` utilise `DataStoreService` pour sauvegarder `leaderstats` et `Inventory`.
- Il implémente un mécanisme de retry avec "exponential backoff" (`MAX_RETRIES`, `BASE_DELAY`) pour réduire les erreurs intermittentes lors des appels `GetAsync`/`SetAsync`.
- Le serveur notifie le client via le RemoteEvent `UIUpdate` pendant le restore :
  - `{ type = "Loading", state = "Start" }` envoyé avant le chargement des données
  - `{ type = "Loading", state = "Done" }` envoyé après
  - `{ type = "Loading", state = "Error", message = "..." }` en cas d'échec
- Côté client, `roblox_ui_system.lua` affiche une overlay de chargement (`LoadingOverlay`) pendant ces étapes.

## 🧾 Logging et test DataStore

- Un logger serveur simple est inclus: `roblox_logger.lua`. Il crée un dossier `Logs` dans `ServerStorage` et expose `_G.Log(level, message)` pour écrire des entrées.
- Un script de test `roblox_datastore_tester.lua` permet de simuler des échecs DataStore (active `_G.SimulateDataStoreFailure`) et d'appeler `_G.ForceSaveAll()` pour observer le comportement du retry/backoff.

Conseil: place `roblox_logger.lua` et `roblox_datastore_tester.lua` dans `ServerScriptService`. Le tester effectue une simulation automatique au démarrage (utile en Play Solo pour vérifier les logs et retries).

Bouton de test DataStore (UI)

- Le client contient un bouton `Run DataStore Test` visible uniquement pour `game.CreatorId` (le créateur du jeu). Il déclenche le RemoteEvent `RunDataStoreTest` côté serveur.
- Côté serveur, `roblox_datastore_test_handler.lua` vérifie l'autorisation, active la simulation (`_G.SimulateDataStoreFailure = true`), appelle `_G.ForceSaveAll()`, puis désactive la simulation et retente. Les logs et l'overlay UI reflètent l'état.
- Utilisation sûre : garde ce bouton désactivé/public uniquement pour le créateur (le script le masque automatiquement pour les autres joueurs).

Conseil de test : en Play (Solo) l'overlay devrait apparaître brièvement au spawn. En Studio, DataStore n'est pas toujours disponible — regarde la console pour les warnings et vérifie que l'overlay affiche une erreur si le chargement échoue.

## Licence

Ce projet est distribué sous la licence MIT — voir le fichier [LICENSE](LICENSE) pour le texte complet. En ajoutant cette licence, tu autorises l'utilisation, la modification et la redistribution du code selon les termes de la MIT.

Si tu préfères une autre licence (Apache-2.0, GPL-3.0, etc.), dis-moi laquelle et je la remplacerai.