## Voici les étapes à suivre (au choix) pour mettre à jour la page github-page :

---

### 1. La méthode manuelle (Rapide)
C'est la méthode la plus directe si vous n'avez pas de script automatique en place.

1.  **Générez le build Web :**
    Assurez-vous d'utiliser le bon `base-href` (le nom de votre dépôt GitHub entre deux slashs).
    ```bash
    flutter build web --release --base-href "/NOM_DE_VOTRE_REPO/"
    ```
2.  **Déployez vers GitHub :**
    Le moyen le plus simple est d'utiliser le package `gh-pages` (si vous l'avez installé en Node.js) ou de copier manuellement le contenu de `build/web` vers votre branche de déploiement.

---

### 2. La méthode recommandée : `peanut`
Si vous voulez vous simplifier la vie, je vous conseille vivement d'utiliser le package **peanut**. Il automatise la création d'une branche `gh-pages` à partir de votre build.

1.  **Installez peanut (une seule fois) :**
    ```bash
    dart pub global activate peanut
    ```
2.  **Lancez la mise à jour :**
    ```bash
    flutter pub global run peanut --extra-args "--base-href=/Perfos-DR400/"
    ```
3.  **Poussez les modifications :**
    ```bash
    git push origin gh-pages
    ```

---

### 3. Rappel sur le cache (Le piège classique)
Si vous poussez votre code et que rien ne change sur votre navigateur :
* **Attendez 2-3 minutes :** GitHub a besoin d'un peu de temps pour reconstruire la page.
* **Videz le cache :** Faites un `Ctrl + F5` (ou `Cmd + Shift + R`) car les navigateurs gardent souvent l'ancienne version du `main.dart.js` en mémoire.

---

### Résumé des commandes à enchaîner
Si vous n'utilisez pas d'outil tiers, voici votre "antisèche" :

| Étape | Commande | Note |
| :--- | :--- | :--- |
| **Nettoyage** | `flutter clean` | Optionnel, pour éviter les vieux fichiers. |
| **Build** | `flutter build web --base-href "/repo/"` | Remplacez `/repo/` par votre nom de projet. |
| **Déploiement** | `git push origin gh-pages` | Assurez-vous que votre dossier `build/web` est lié à cette branche. |

---

## NB : script pour effectuer la mise à jour automatiquement

---

Voici comment configurer un "Workflow" qui s'occupera de tout (build + déploiement) dès que vous ferez un `git push` sur votre branche principale.

### 1. Créer le fichier de configuration
Dans votre projet Flutter, créez les dossiers et le fichier suivant :
`.github/workflows/deploy.yml`

### 2. Copier-coller le script suivant
Copiez ce contenu dans le fichier `deploy.yml`. Ce script utilise une action communautaire très fiable (`JamesIves/github-pages-deploy-action`).

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main # Ou 'master' selon le nom de votre branche principale

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: 📚 Checkout code
        uses: actions/checkout@v4

      - name: ⚙️ Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'

      - name: 📦 Install dependencies
        run: flutter pub get

      - name: 🏗️ Build Web
        # REMPLACEZ 'votre-nom-de-repo' par le nom exact de votre projet GitHub
        run: flutter build web --release --base-href "/votre-nom-de-repo/"

      - name: 🚀 Deploy to GitHub Pages
        uses: JamesIves/github-pages-deploy-action@v4
        with:
          folder: build/web # Le dossier généré par Flutter
          branch: gh-pages  # La branche de destination
```

---

### 3. Activer les permissions sur GitHub
Pour que le script puisse "écrire" sur votre branche `gh-pages`, vous devez lui en donner l'autorisation :

1. Allez sur votre dépôt sur **GitHub.com**.
2. Cliquez sur **Settings** (Paramètres).
3. Dans le menu de gauche, allez dans **Actions** > **General**.
4. Faites défiler jusqu'à **Workflow permissions**.
5. Cochez **Read and write permissions**.
6. Cliquez sur **Save**.

### 4. Configurer la source des Pages
Une fois que vous aurez fait votre premier `push` avec ce fichier, GitHub créera automatiquement la branche `gh-pages`.

1. Allez dans **Settings** > **Pages**.
2. Sous **Build and deployment** > **Branch**, assurez-vous que la source est bien `gh-pages` et le dossier `/ (root)`.

---

### Comment l'utiliser désormais ?
C'est la partie magique : vous n'avez plus rien à faire manuellement.
```bash
git add .
git commit -m "Mise à jour de mon app"
git push origin main
```
Le déploiement se lancera tout seul. Vous pouvez suivre la progression dans l'onglet **Actions** de votre dépôt GitHub.
