<!-- Décris brièvement ce que fait cette PR -->
## Résumé

Décris brièvement ce que fait cette PR (ex: "Release v1.0.0 — Ajout du changelog et notes").

## Checklist QA (exemples)
- [ ] Placer les scripts dans Roblox Studio conformément au README
- [ ] Vérifier l'apparition de leaderstats (Gold/XP/Level)
- [ ] Ramasser un collectible -> Gold/XP augmentent et UI se met à jour
- [ ] Tuer un ennemi -> XP/Gold attribués si le creator est présent
- [ ] Tester la sauvegarde/restore (DataStore) en Play Solo
- [ ] Vérifier ServerStorage/Logs pour les entrées du logger
- [ ] Tester le bouton "Run DataStore Test" si tu es game.CreatorId

## Notes de déploiement
- `GameConfig` (ModuleScript) doit être placé dans `ReplicatedStorage`.
- Les scripts de test/logger sont conçus pour Play Solo et debug.

Merci de vérifier les éléments ci‑dessous avant de merger. Ajoute des éléments spécifiques si nécessaire.
