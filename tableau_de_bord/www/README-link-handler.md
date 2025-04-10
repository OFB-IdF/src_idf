# Gestionnaire de liens pour FichesSRC

Ce dossier contient un script JavaScript (`link-handler.js`) qui améliore la gestion des liens dans les fiches SRC, particulièrement pour les liens locaux (commençant par `file:`). 

## Fonctionnalités

- **Détection automatique** des liens locaux et externes
- **Boutons d'action directe** pour les liens locaux avec options pour :
  - Copier l'adresse dans le presse-papier
  - Tenter d'ouvrir le fichier dans l'explorateur Windows
- **Ouverture automatique** des liens externes dans un nouvel onglet
- **Notifications visuelles** pour confirmer les actions

## Intégration dans vos documents Quarto

Pour intégrer ce script dans vos documents Quarto, modifiez l'en-tête YAML de votre fichier `page.qmd.brew` comme suit :

```yaml
---
title: "<%= infos$intitule %>"
include-in-header:
  - text: |
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
      <script src="www/link-handler.js" defer></script>
---
```

## Comment ça fonctionne

1. Le script s'initialise automatiquement lorsque la page est chargée
2. Il détecte tous les liens dans le document
3. Pour les liens locaux (commençant par `file:`), il ajoute des boutons d'action directe à côté du lien
4. Pour les liens externes, il s'assure qu'ils s'ouvrent dans un nouvel onglet
5. Un observateur de mutations surveille les changements du DOM pour traiter les liens ajoutés dynamiquement

## Exemple d'utilisation

Un fichier d'exemple `link-handler-example.html` est inclus pour démontrer le fonctionnement du script. Ouvrez ce fichier dans votre navigateur pour voir le gestionnaire de liens en action.

## Limitations

- L'ouverture directe de fichiers locaux depuis le navigateur est soumise à des restrictions de sécurité
- La fonctionnalité "Ouvrir dans l'explorateur" peut ne pas fonctionner dans tous les environnements
- Une configuration supplémentaire du système peut être nécessaire pour certaines fonctionnalités

## Personnalisation

Vous pouvez personnaliser le comportement du script en modifiant les fonctions dans `link-handler.js`. Par exemple :

- Changer le texte des options du menu
- Modifier l'apparence des notifications
- Ajouter des options supplémentaires pour les liens

## Comparaison avec l'implémentation R actuelle

L'implémentation actuelle en R dans `formater_liens.r` utilise :

```r
paste0(
  "<a href='javascript:void(0)' ",
  "onclick=\"navigator.clipboard.writeText('", infos_lien$link, "').then(() => { alert('Adresse copiée dans le presse-papier!'); })\" ",
  "style='cursor:pointer;'>", 
  infos_lien$text, 
  " <span style='font-size:0.8em;color:#666;'>(cliquer pour copier l'adresse)</span></a>"
)
```

La nouvelle implémentation JavaScript offre :
- Une interface utilisateur plus riche avec un menu contextuel
- Des notifications plus élégantes que les alertes standard
- La possibilité d'ouvrir les fichiers dans l'explorateur (avec certaines limitations)
- Une meilleure séparation entre le contenu et le comportement