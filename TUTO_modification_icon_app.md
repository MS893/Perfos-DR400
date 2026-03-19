
# 🎨 Tutoriel : Personnaliser l'icône de l'app Perfos DR400

Ce guide explique comment remplacer l'icône Flutter par défaut par une icône personnalisée (silhouette de DR400) sur toutes les plateformes (Android, iOS, Web, Windows).

---

## 1. Préparation de l'image
Pour un résultat professionnel en cockpit (tablette ou téléphone), ton image doit respecter quelques règles :
* **Format :** PNG (obligatoire).
* **Taille :** 1024x1024 pixels.
* **Contenu :** Évite les petits textes illisibles. Privilégie une silhouette de **Robin DR400** (profil ou dessus) bien centrée.
* **Emplacement :** Crée un dossier `assets/` à la racine de ton projet et place ton image dedans (ex: `assets/icon_dr400.png`).

---

## 2. Configuration du projet
Ouvre ton fichier `pubspec.yaml` et ajoute les configurations nécessaires.

> **Attention :** Respecte bien l'alignement des espaces (l'indentation YAML est stricte).

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  # 1. Ajoute cette dépendance
  flutter_launcher_icons: ^0.13.1

# 2. Ajoute la section de configuration à la fin du fichier
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon_dr400.png"
  min_sdk_android: 21
  adaptive_icon_background: "#FFFFFF" # Couleur de fond (blanc pour le DR400)
  adaptive_icon_foreground: "assets/icon_dr400.png" # L'image par-dessus
```

---

## 3. Génération automatique
Inutile de redimensionner l'image à la main pour chaque appareil. Lance ces deux commandes dans ton terminal :

```bash
# Récupérer l'outil de génération
flutter pub get

# Lancer la création de toutes les icônes
flutter pub run flutter_launcher_icons
```

---

## 4. Changer le nom sous l'icône
Pour que le pilote voie **"Perfos DR400"** et non "mon_app" sur son écran d'accueil, utilise le package `flutter_app_name` (ou modifie-le manuellement).

### Méthode Manuelle (La plus fiable) :
* **Android :** Va dans `android/app/src/main/AndroidManifest.xml` et change `android:label="Perfos DR400"`.
* **iOS :** Va dans `ios/Runner/Info.plist` et modifiez les valeurs de `<key>CFBundleName</key>` et `<key>CFBundleDisplayName</key>`.

---

Pourquoi c'est magique ?

* **Android :** L'outil va créer automatiquement les 5 ou 6 tailles différentes (hdpi, xhdpi, etc.) et gérer les "icônes adaptatives" (celles qui peuvent changer de forme selon le téléphone).
* **iOS :** Il va générer tout le set d'icônes pour iPhone et iPad et mettre à jour le fichier Contents.json.
* **Web/Desktop :** Il s'occupe aussi des favicons et des icônes de fenêtres.

💡 Le petit conseil "Cockpit"
Une fois l'icône changée, n'oubliez pas de modifier aussi le nom affiché sous l'icône sur l'écran d'accueil.
Dans votre pubspec.yaml, vous pouvez aussi changer la description, mais pour le nom sur le téléphone :

* **Android :** Modifiez android/app/src/main/AndroidManifest.xml -> android:label="Perfos DR400".
* **iOS :** Modifiez ios/Runner/Info.plist -> CFBundleName et CFBundleDisplayName.

---

## 💡 Conseils de "Pilote-Développeur"

* **L'icône Adaptative (Android) :** Sur Android, les icônes peuvent être rondes, carrées ou en forme de goutte d'eau. Utilise `adaptive_icon_background` pour définir une couleur de fond et assure-toi que ta silhouette de DR400 ne touche pas les bords (laisse une marge de sécurité de 10% environ) pour qu'elle ne soit pas rognée.
* **Mode Sombre :** Teste ton icône sur un fond d'écran de téléphone noir et blanc pour vérifier que le contraste est bon.
* **Test de visibilité :** Une fois générée, lance l'app sur ton téléphone. Si l'icône est trop petite, augmente la taille de la silhouette dans ton fichier source de 1024x1024.

---

## 5. Sauvegarde sur GitHub
Une fois que l'icône te convient, n'oublie pas de synchroniser ton travail :

```bash
git add .
git commit -m "🎨 Nouvelle icône DR400 et nom de l'application"
git push
```

---

## **Script pour automatiser aussi la version Web (le favicon qui apparaît dans l'onglet du navigateur)**

Lorsqu'un pilote l'utilise sur un navigateur (Chrome, Safari) ou l'installe comme une **PWA** (Progressive Web App) sur son ordinateur.
L'outil `flutter_launcher_icons` que nous avons configuré s'occupe déjà d'une partie du travail, mais pour le Web, il existe une méthode encore plus complète pour gérer le **favicon** (l'icône dans l'onglet) et l'icône de chargement.

---

### 1. Mettre à jour la configuration
Modifiez la section `flutter_launcher_icons` dans votre fichier `pubspec.yaml` pour inclure la partie Web :

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
    image_path: "assets/icon_dr400.png"
    background_color: "#FFFFFF"
    theme_color: "#005596" # Une couleur bleue "aéro" par exemple
  image_path: "assets/icon_dr400.png"
```

### 2. Lancer la génération
Exécutez à nouveau la commande de génération :
```bash
flutter pub run flutter_launcher_icons
```
*L'outil va maintenant créer un dossier `web/icons/` avec toutes les tailles nécessaires et mettre à jour le fichier `web/manifest.json`.*

---

### 3. Le script d'automatisation (Bonus)
Si vous voulez aller plus vite et ne pas taper 3 commandes à chaque fois que vous changez d'icône ou que vous compilez, créez un fichier nommé `deploy.bat` (sur Windows) à la racine de votre projet :

```batch
@echo off
echo [1/3] Nettoyage et recuperation des paquets...
call flutter pub get

echo [2/3] Generation des icones (Mobile et Web)...
call flutter pub run flutter_launcher_icons

echo [3/3] Compilation de la version Web...
call flutter build web --release

echo.
echo Termine ! Votre application DR400 est prete dans build/web/
pause
```

---

### 💡 Le conseil "Check-list" avant le Push
Une fois que vous avez généré vos icônes Web :
1. **Testez localement :** Tapez `flutter run -d chrome`.
2. **Vérifiez l'onglet :** Votre silhouette de DR400 doit apparaître à côté du titre "Perfos DR400".
3. **Poussez sur GitHub :**
```bash
   git add .
   git commit -m "🌐 Finalisation des icones Web et Mobile"
   git push
   ```

---

## ✈️ Héberger gratuitement la version Web de votre application sur "GitHub Pages"

Cela permet aux pilotes d'accéder à votre calculateur via une adresse du type `https://ms893.github.io/Perfos-DR400/` sans rien installer.

En activant **GitHub Pages**, votre dépôt GitHub ne servira plus seulement à stocker votre code, mais il deviendra un véritable **serveur web gratuit. A CONDITION QUE LE DEPOT SOIT PUBLIC**.

Tout pilote possédant le lien pourra ouvrir votre calculateur de DR400 depuis son navigateur, sans rien installer.

Voici la procédure simplifiée pour automatiser ce déploiement.

-----

## 1\. Installer l'outil de déploiement

Il existe un package génial qui s'occupe de tout le travail complexe (créer une branche spéciale `gh-pages` et y envoyer les fichiers compilés).

### 1\. Installer l'outil `peanut`

Tapez cette commande :

```bash
flutter pub global activate peanut
```

### 2\. Générer le contenu Web

Lancez la compilation de votre calculateur DR400. N'oubliez pas l'argument `--base-href` qui est indispensable pour que GitHub trouve vos fichiers :

```bash
flutter pub global run peanut --web-renderer canvaskit --base-href="/Perfos-DR400/"
```

*Cette commande va compiler votre app et créer automatiquement une branche nommée `gh-pages` sur votre ordinateur, contenant uniquement les fichiers prêts pour le Web.*

### 3\. Envoyer vers GitHub

Maintenant, il ne reste plus qu'à "pousser" cette branche spécifique vers votre dépôt en ligne :

```bash
git push origin gh-pages
```

-----

### 4\. Vérification finale sur GitHub

1.  Allez sur [https://github.com/MS893/Perfos-DR400/settings/pages](https://www.google.com/search?q=https://github.com/MS893/Perfos-DR400/settings/pages).
2.  Dans **Branch**, assurez-vous que c'est bien **`gh-pages`** qui est sélectionnée (et non `main`).
3.  Cliquez sur **Save**.

D'ici une minute, votre application sera accessible à l'adresse :
`https://ms893.github.io/Perfos-DR400/`

-----

### 💡 Le petit "Truc de Pilote"

Si après le déploiement vous voyez une page blanche ou une erreur 404 :

* Vérifiez bien que le nom du dépôt dans l'URL (`Perfos-DR400`) respecte exactement les majuscules/minuscules de votre projet GitHub.
* Parfois, il faut vider le cache de votre navigateur (Ctrl + F5) pour voir l'application apparaître.

-----

## 2\. Préparer le projet pour le Web

Comme votre projet s'appelle `Perfos-DR400`, l'URL sera `https://ms893.github.io/Perfos-DR400/`. Il faut prévenir Flutter que le "chemin de base" n'est pas la racine du domaine.

Lancez la compilation avec cet argument crucial :

```bash
flutter build web --release --base-href "/Perfos-DR400/"
```

-----

## 3\. Déployer sur GitHub

Une fois la compilation terminée, envoyez le contenu du dossier `build/web` vers GitHub :

```bash
flutter pub global run ghpages -d build/web
```

-----

## 4\. Activer l'option sur GitHub

1.  Allez sur votre dépôt : [https://github.com/MS893/Perfos-DR400](https://www.google.com/search?q=https://github.com/MS893/Perfos-DR400).
2.  Cliquez sur l'onglet **Settings** (en haut).
3.  Dans le menu à gauche, cliquez sur **Pages**.
4.  Sous **Build and deployment**, vérifiez que :
    * Source est sur : **Deploy from a branch**.
    * Branch est sur : **gh-pages** (et le dossier `/ (root)`).
5.  Cliquez sur **Save**.

> **Note :** Attendez 2 ou 3 minutes. Un bandeau apparaîtra en haut de cette page avec le lien : *"Your site is live at..."*.

-----

## 💡 Le conseil du "Chef de Piste"

Désormais, dès que vous faites une modification importante sur vos formules de calcul :

1.  Faites votre `git push` habituel pour le code.
2.  Relancez la commande `flutter build web ...` suivie du déploiement `ghpages`.
3.  Votre application web sera mise à jour instantanément pour tous les utilisateurs.

---
