

# Application de Gestion de Tâches - # gestion_tasks HAYATAK

Ce projet est une application mobile Flutter de gestion de tâches personnelles en temps réel, connectée à Firebase. Elle a été réalisée dans le cadre d'un test technique en suivant scrupuleusement les principes de la **Clean Architecture** et de la gestion d'état avec le pattern **BLoC**.

## 🏗️ Structure du Projet (Clean Architecture)

Le code est rigoureusement séparé en 3 couches distinctes pour isoler la logique métier des frameworks externes, garantissant ainsi la testabilité et la maintenabilité du code :

- **Domain (Cœur Métier) :** Couche indépendante contenant les entités (`TaskEntity`, `UserEntity`), les contrats de dépôts abstraits (`TaskRepository`, `AuthRepository`) et les cas d'utilisation métier (`UseCases`). Elle est écrite en Dart pur et n'a aucune dépendance vers Firebase ou Flutter.
- **Data (Infrastructure) :** Implémente les contrats définis par le domaine. Elle contient les sources de données (`RemoteDataSource`) qui communiquent avec Cloud Firestore et Firebase Auth, ainsi que les modèles/DTO pour le mapping des données vers les entités du domaine.
- **Presentation (UI & État) :** Gère l'interface utilisateur et l'état réactif via **BLoC**. Cette couche appelle exclusivement les cas d'utilisation (Use Cases) et n'interagit jamais directement avec Firebase.



## ✨ Fonctionnalités implémentées

- **Authentification :** Gestion de session par email/mot de passe via Firebase Auth.
- **Isolation des données :** Chaque utilisateur possède un espace sécurisé et isolé sur Firestore, basé sur son `uid`.
- **Temps réel :** Synchronisation bidirectionnelle avec Cloud Firestore utilisant des `Streams`.
- **Gestion d'état robuste :** Utilisation de `flutter_bloc` pour une séparation claire entre logique et UI.
- **Expérience Utilisateur (UX) :**
    - Indicateurs de chargement lors des transitions réseau.
    - Gestion des cas limites (liste vide, erreurs de connexion, formulaires vides).

## 🚀 Installation et Lancement

1. **Prérequis :** Assurez-vous d'avoir installé le SDK Flutter ainsi que les outils Firebase CLI.
2. **Configuration :** Clonez le projet et placez vos fichiers de configuration Firebase (`firebase_options.dart`) générés via `flutterfire configure`.
3. **Dépendances :** Récupérez les packages nécessaires :
   ```bash
   flutter pub get