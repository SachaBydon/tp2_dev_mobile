# TP2 dev mobile SACHA BYDON


## Utilisation:
Pour se connecter à l'application vous pouvez créer un compte ou vous connecter avec les identifiants suivants:
- Login: test@test.com
- Password: azerty

## Critères d’acceptance :

### US#1 : Interface de login

- #### #1

  Au lancement de l'application l'interface de login a bien deux champs et un bouton.  
  EN PLUS:

  - J'ai créé un widget Logo pour le nom à la place d'un headerBar.
  - J'ai ajouté un lien "Créer un compte" qui redirige vers la page de création de compte.

- #### #2

  Les champs de saisie sont Email et mot de passe, qui correspondent respectivement au login et password.

- #### #3

  Le champ mot de passe est bien obfusqué par défaut.  
  EN PLUS:

  - J'ai ajouté un bouton pour activer ou non l'obfusquage du champ.

- #### #4:

  Le label du bouton est bien se connecter.

- #### #5:

  Au clic sur le bouton de connexion je verifie bien si l'utilisateur est en base. Si c'est le cas il est redirigé vers la page d'accueil. Sinon ou s'il y a une erreur un message est affiché dans une snackbar et l'application reste fonctionelle.

- #### #6:
  Si les champs sont vides l'application reste fonctionelle et invite l'utilisateur à remplir les champs.

### US#2 : Liste de vêtements

- #### #1,2

  Une fois connecté l'utilisateur arrive sur la page d'accueil qui contient le contenu principale (la liste de vêtements)  
  EN PLUS:

  - À la place d'une BottomNavigationBar j'ai créer un widget TopBar qui continent les boutons pour naviguer vers les pages de profile et de panier.

- #### #3

  Il y a bien une liste déroulante des vêtements à l'écran.

- #### #4

  Chaque vêtement à bien un titre, une taille et un prix.  
  EN PLUS:

  - Pour les images, j'ai ajouté l'affichage (les images sont stoqué en base soit en lien soit en base64)
  - J'ai ajouté un bouton pour directement ajouter l'article au panier.

- #### #5

  Au clic sur une entrée de la liste, le détail est bien affiché.

- #### #6
  La liste de vêtements est bien récupérée de la base de données.

### US#3 : Détail d’un vêtement

- #### #1

  La page de détail est bien composée d'une image, d'un titre, d'une taille, de la marque et d'un prix.

- #### #2
  La page contient bien un bouton retour (avec une icon de flêche) qui permet de retourner à la page d'accueil. Et contient bien un bouton d'ajout au panier, qui ajoute l'article au panier.  
  EN PLUS:
  - Le bouton d'ajout au panier est désactivé si l'article est déjà dans le panier.
  - Chaque articles peut posséder une ou plusieurs images. Il est donc possible de faire défiller les images sous forme de carousel. On peut aussi appuyer sur une image pour la voir en grand et on peut zoomer.

### US#4 : Le panier

- #### #1

  Au clic sur le bouton Panier, la liste des vêtements du panier de l’utilisateur est bien affichée avec les images, titres, tailles et prix.

- #### #2

  Un total est bien affiché.

- #### #3

  À droite de chaque vetement, une poubelle (à la place de la croix) permet à l’utilisateur de retirer un
  produit. Au clic sur celle-ci, le produit est retiré de la liste et le total général mis à jour.  
  EN PLUS:  
  Il est possible de faire glisser un item vers la gauche pour le supprimer du panier.

- #### #4

  Il n'y a pas d'autres boutons.

- #### #5 (EN PLUS)

  Le nombre d'items dans le panier est affiché sur le bouton du panier.


### US#5 : Profil utilisateur

- #### #1

  Les informations de l’utilisateur récupérées en base de données sont affichées.

- #### #2

  Les informations sont : l'email, le mot de passe (obfusqué), la date de naissance, l'adresse, le code postale (nombres uniquement), la ville.  
  EN PLUS:

  - Il est possible de modifier l'addresse mail.

- #### #3

  Un bouton Valider permet bien de sauvegarder les données (en base de données)

- #### #4
  Un bouton Se déconnecter permet bien de revenir à la page de login.

### US#6 : Filtrer sur la liste des vêtements

- #### 1#

  Sur la page d'accueil une TabBar est présente, listant les différentes catégories de vêtements.

- #### 2#

  Par défaut, l’entrée "Tous" est sélectionnée et tous les vêtements sont affichés

- #### 3#

  Au clic sur une des entrées, la liste est filtrée pour afficher seulement les vêtements correspondants à la catégorie sélectionnée.

### US#7 : Laisser libre cours à votre imagination

- #### 1# Création de compte

  Comme dit précédement J'ai ajouté une page de création de compte. Cette page est similaire à la page de login avec un champ "confirmer" pour le mot de passe en plus. Et le bouton Se connecter est remplacé par le bouton s'inscrire, qui va créer un utilisateur dans la base et rediriger vers la page d'accueil.

- #### 2# Sauvegarde des informations de connexion

  Si on est connecté, lorsqu'on quitte et relance l'application on est automiquement reconecté avec les identifiants de la dernière connexion.

- #### 3# Design

  Comme expliqué dans le récap des US précédentes. J'ai pris la liberté de changer certains éléments dans le but d'améliorer le design. Mais les fonctionalitées demandé sont toujours respectées.

- #### 4# Ajout de produit

  Sur la page d'accueil il y a bouton flottant qui affiche la page d'ajout de produit. Cette page contient les champs textes pour les informations du produit (titre, marque, taille, prix, categorie, images).
  Les images récupéré depuis la gallerie de photo de l'appareil.
  Et il y a un bouton ajouter qui ajoute le produit en base, et qui redirige vers la page d'accueil.

---

## Architecture du projet

- /lib
  - /models
    - app_state.dart  
      Classe 'AppState', Gère le state global de l'application
    - auth.dart  
      Classe 'AuthActions', Gère l'authentification dans l'application
    - clothe.dart  
      Classe 'Clothe', Objet qui contient les attributs d'un vêtement
  - /screens
    - login.dart (Page de connection)
    - signin.dart (Page d'inscrption)
    - home.dart (Page d'accueil/liste de vêtement)
    - detail.dart (Page détail d'un produit)
    - basket.dart (Page du panier)
    - profil.dart (Page de profil)
    - new_product.dart (Page de création de produit)
  - /widgets
    - carousel.dart
    - grab_indicator.dart
    - image_square.dart
    - logo.dart
    - topbar.dart
  - main.dart  
    Code principal
  - utils.dart  
    Contient des fonctions utiles dans toute l'application.

---

## Bibliothèques utilisées

J'ai limité l'utilisation des bibliothèques, mais j'ai quand même décider d'en utiliser certaines (en plus des bibliothèques necessaires pour firebase) :

- `shared_preferences`: Permet d'accéder au stockage de l'appareil. Je l'ai utilisé pour enregistrer les informations de connexion pour la reconnexion automatique.
- `rxdart` et `get_it`: Permet de gérer un state global pour l'application (plus facile à utiliser que les providers de flutter).
- `image_picker`: Permet de récupérer une image depuis la gallerie de photo de l'appareil. Je l'ai utilisé pour la page de création de produit.
- `flutter_carousel_slider`: Permet de créer un carousel avec des indicateur facilement. Je l'ai utilisé pour la page détail.
- `google_fonts`: Permet d'importer les polices d'écriture de google fonts. Je l'ai utilisé pour le logo.

---

## Configuration firebase

### Authentication

Pour l'authentification j'utilise la méthode de connexion "Adresse e-mail/Mot de passe". Donc chaque utilisateur a un identifiant qui est une adresse mail, un mot de passe, et un ID unique.

### Cloud Firestore

#### **Les collections :**

- `clothes`  
  Liste de tous les vêtements.  
  Chaque item comprends les champs :

  - `category` : Number (0: Auncune, 1: Vêtement, 2: Accesoire),
  - `images` : Liste de String (lien ou base64),
  - `marque` : String,
  - `prix` : Number,
  - `taille` : String,
  - `titre` : String.

- `users`  
  Liste de tous les utilisateurs.  
  Chaque item comprends les champs :

  - `address` : String,
  - `birth` : String,
  - `city` : String,
  - `postcode` : String,

- `paniers`  
  Liste de tous les paniers des utilisateurs.  
  L'ID du panier coresspond à l'ID de l'utilisateur.  
  Chaque item comprends une seul champ `panier` qui est une liste de String d'ID de produit.

#### **Les règles de sécurité :**

```
service cloud.firestore {
  match /databases/{database}/documents {
    match /clothes/{productId} {
      allow read, write: if request.auth.uid != null;
    }
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /paniers/{panierId} {
      allow read, write: if request.auth.uid == panierId;
    }
  }
}
```

Il y a une règle pour chaque collection.  
Pour la collection `clothes`, il faut être connecté pour lire et écrire.
Pour la collection `users` et `paniers`, il faut être connecté et l'utilisateur peut récupérer et modifier uniquement ses propres données.
