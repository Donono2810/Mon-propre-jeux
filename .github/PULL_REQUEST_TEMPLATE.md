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

## Required before merge (Obligatoire)

Ces éléments DOIVENT être cochés avant de merger la PR. Si un élément n'est pas applicable, indiquez-le et expliquez pourquoi.

- [ ] CI: toutes les vérifications passent (workflow `.github/workflows/ci.yml`)
- [ ] Licence: un fichier `LICENSE` présent et valide
- [ ] Documentation: `README.md` et `CHANGELOG.md` mis à jour si nécessaire
- [ ] Tests manuels: checklist QA remplie et vérifiée
- [ ] Pas de code de debug/test non-intentionnel (prints, toggles de simulation activés)
- [ ] Data persistence: sauvegarde/restore (DataStore) testée si la PR modifie la persistance
- [ ] Approval: au moins un mainteneur ou le propriétaire a approuvé

Ne pas merger tant que tous les éléments obligatoires ne sont pas cochés.
