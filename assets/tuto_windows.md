
# 🚀 Tutoriel : Créer votre Application Flutter pour Windows

Ce guide vous accompagne de l'installation des outils jusqu'à la génération de votre premier fichier `.exe`.

---

## 1. Prérequis Système (Indispensable)
Contrairement au Web ou à Android, Windows nécessite des outils de compilation natifs (C++).

* **Système d'exploitation :** Windows 10 ou 11 (64-bit).
* **Espace disque :** Environ 5 à 10 Go pour les outils Visual Studio.
* **Outil de build :** Téléchargez [Visual Studio Community 2022](https://visualstudio.microsoft.com/fr/vs/community/).

### 🛠 Configuration de Visual Studio
Lors de l'installation, vous **devez** cocher la case suivante :
* **Développement Desktop en C++** (Desktop development with C++)

> [!IMPORTANT]
> Ne confondez pas **Visual Studio** (le gros IDE) avec **VS Code**. Vous avez besoin du premier pour que le second puisse compiler votre application.

---

## 2. Configuration de Flutter
Une fois Visual Studio installé, ouvrez votre terminal (PowerShell ou celui d'Android Studio) et suivez ces étapes :

### A. Activer le support Windows
Par défaut, le support desktop peut être désactivé. Activez-le avec :
```powershell
flutter config --enable-windows-desktop
```

### B. Vérification avec Flutter Doctor
Lancez la commande magique pour vérifier que tout est au vert :
```powershell
flutter doctor
```
Recherchez la ligne : `[✓] Visual Studio - development for Windows`. Si elle est là, vous êtes prêt !

---

## 3. Ajouter Windows à votre projet existant
Si vous avez déjà créé votre projet pour Android/iOS, le dossier `windows` n'existe pas encore. Pour le générer proprement :

1.  Placez-vous à la racine de votre projet.
2.  Exécutez :
    ```powershell
    flutter create --platforms=windows .
    ```
    *(Le point à la fin est crucial !)*

---

## 4. Personnaliser l'icône Windows
L'icône que nous avons configurée pour Android ne s'applique pas automatiquement à Windows.

1.  Convertissez votre image en fichier **`.ico`** (via un site comme *cloudconvert* ou *favicon-generator*).
2.  Renommez votre fichier en `app_icon.ico`.
3.  Allez dans le dossier : `windows/runner/resources/`.
4.  Remplacez le fichier `app_icon.ico` existant par le vôtre.

---

## 5. Exécuter et Compiler

### Mode Debug (Tester)
Pour lancer l'application directement depuis Android Studio ou VS Code :
* Sélectionnez **Windows (desktop)** dans la liste des appareils.
* Appuyez sur **F5**.

### Mode Release (Distribuer)
Pour générer le dossier contenant votre exécutable final :
```powershell
flutter build windows
```
Votre application se trouvera ici :
`build/windows/x64/runner/Release/`

> [!TIP]
> **Attention :** Pour donner votre application à un ami, vous devez envoyer **tout le contenu** du dossier `Release` (le .exe et les fichiers .dll qui l'accompagnent), pas seulement le fichier .exe !

---

### Résumé des commandes utiles
| Action | Commande |
| :--- | :--- |
| **Vérifier l'état** | `flutter doctor` |
| **Ajouter Windows** | `flutter create --platforms=windows .` |
| **Nettoyer le projet** | `flutter clean` |
| **Compiler le .exe** | `flutter build windows` |

---

Pour distribuer une application Windows proprement, on ne donne pas un dossier rempli de fichiers `.dll` ; on crée un **Installeur (Setup)**.
La solution la plus standard et gratuite pour Flutter est **Inno Setup**.

---

# 📦 Partie 2 : Créer un Installeur Windows (.exe)

Une fois que votre commande `flutter build windows` est terminée, vous obtenez un dossier `build\windows\x64\runner\Release`. Voici comment transformer ce dossier en un seul fichier d'installation professionnel.

---

## 1. Télécharger Inno Setup
C'est l'outil de référence pour créer des installeurs Windows.
* Allez sur [jrsoftware.org](https://jrsoftware.org/isdl.php).
* Téléchargez et installez la version **Stable** (ex: Inno Setup 6).

---

## 2. Créer le Script d'Installation
Lancez **Inno Setup Compiler** et suivez l'assistant (**Script Wizard**) :

1.  **File > New** : Cliquez sur "Next".
2.  **Application Information** : Entrez le nom de votre app, la version et votre nom/entreprise.
3.  **Application Folder** : Laissez par défaut (`{autopf}\NomDeVotreApp`).
4.  **Application Files** :
    * **Main executable file** : Cliquez sur "Browse" et allez chercher votre `.exe` dans `build\windows\x64\runner\Release\votre_app.exe`.
    * **Other application files** : Cliquez sur **"Add folder"**. Sélectionnez tout le dossier `Release`.
    * *Important :* Quand il demande s'il faut inclure les sous-dossiers, répondez **OUI**.
5.  **Application Shortcuts** : Laissez les options par défaut pour créer une icône sur le bureau.
6.  **Application Documentation** : Vous pouvez passer cette étape (Next).
7.  **Setup Languages** : Choisissez "French" (et "English" si besoin).
8.  **Compiler Settings** :
    * **Custom SDK output directory** : Choisissez où vous voulez que le fichier `setup.exe` final soit enregistré (par exemple votre Bureau).
    * **Setup icon file** : Sélectionnez votre fichier `.ico` pour que l'installeur ait aussi votre logo.
9.  **Finish** : Cliquez sur "Finish", puis acceptez de compiler le script.

---

## 3. Le résultat final
Inno Setup va mouliner quelques secondes et générer un fichier nommé **`mysetup.exe`** (ou le nom que vous avez choisi).

> [!TIP]
> **Test de déploiement :** Prenez ce fichier `setup.exe`, envoyez-le sur un autre PC Windows (qui n'a pas Flutter ni Visual Studio). Si l'installation réussit et que l'app se lance, votre déploiement est parfait !

---

# 📝 Récapitulatif du Workflow Complet

Voici le "Chemin de Fer" pour chaque mise à jour de votre application :

1.  **Code :** Modifiez votre application Flutter dans VS Code ou Android Studio.
2.  **Build :** Tapez `flutter build windows` dans le terminal.
3.  **Package :** Ouvrez votre script Inno Setup (fichier `.iss` sauvegardé précédemment) et cliquez sur **"Run"** (le bouton lecture vert).
4.  **Distribuez :** Envoyez le nouvel installeur à vos utilisateurs.

---

### Une dernière chose ?
Certains développeurs préfèrent utiliser le format **MSIX** (le format moderne de Microsoft utilisé sur le Windows Store). C'est plus simple car il existe un package Flutter dédié (`msix`), mais cela nécessite parfois des certificats de signature payants.

Souhaitez-vous que je vous montre cette **alternative via la ligne de commande** ou la méthode Inno Setup vous convient-elle ?