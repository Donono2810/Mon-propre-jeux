# Activer la protection de la branche `main`

Ce document décrit comment exiger que le workflow `CI` réussisse avant de permettre le merge sur la branche `main`.

Important : ces étapes doivent être exécutées par un administrateur du dépôt.

## Option A — Commande `curl` (automatique)

Exécute cette commande localement (ou sur une machine de confiance) en remplaçant `YOUR_PERSONAL_ACCESS_TOKEN`
par un Personal Access Token GitHub possédant le scope `repo` et droits d'admin sur le dépôt :

```bash
curl -X PUT -H "Accept: application/vnd.github+json" \
  -H "Authorization: token YOUR_PERSONAL_ACCESS_TOKEN" \
  https://api.github.com/repos/Donono2810/Mon-propre-jeux/branches/main/protection \
  -d '{
    "required_status_checks": { "strict": true, "contexts": ["CI"] },
    "enforce_admins": false,
    "required_pull_request_reviews": null,
    "restrictions": null
  }'
```

Notes :
- `contexts`: nom du check attendu (ici `CI`). Adapte si le nom du statut diffère dans ton workflow.
- `strict: true` force la synchronisation avant le merge.

## Option B — Interface GitHub (manuelle)

1. Ouvre le dépôt sur GitHub → `Settings` → `Branches` → `Branch protection rules`.
2. Clique sur `Add rule` et renseigne `main` comme pattern.
3. Coche `Require status checks to pass before merging`.
4. Dans la liste `Status checks found in the last week for this repository`, sélectionne `CI`.
5. Active `Require branches to be up to date before merging` si tu veux forcer la mise à jour.
6. Sauvegarde la règle.

## Vérification

- Après application, ouvre une PR de test et vérifie que l'option `Merge` est bloquée tant que le job `CI` n'est pas vert.
- Les administrateurs peuvent, selon la configuration, toujours forcer le merge si `enforce_admins` est `false`.

Si tu veux, j'exécute la commande `curl` pour toi — il me faudra un token admin, ou tu peux l'exécuter localement.
