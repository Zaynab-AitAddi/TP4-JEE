# TP4 – Application de Gestion de Produits (MVC1 Complet)

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apache-maven&logoColor=white)
![JSP/Servlet](https://img.shields.io/badge/JSP%2FServlet-007396?style=for-the-badge)
![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)

> **Module :** Java EE – Développement Web Entreprise  
> **Étudiante :** Zaynab Ait Addi | **Encadrant :** Prof. Mohamed CHERRADI  
> **ENSAH – TDIA2 S4 | Année 2025-2026**

---

## 📋 Description

Application web complète de **gestion de produits** avec authentification, contrôle d'accès basé sur les rôles (RBAC) et opérations CRUD. Implémente une **architecture MVC1 à 3 tiers** avec le pattern **DAO** (Data Access Object), hachage des mots de passe SHA-256, et gestion des erreurs avancée.

---

## 🎯 Objectifs

- Implémenter une architecture MVC1 à 3 tiers complète (DAO + Métier + Web)
- Appliquer le pattern DAO avec interfaces et implémentations
- Gérer les rôles utilisateurs (ADMIN, MANAGER, USER) avec contrôle d'accès
- Implémenter le CRUD complet pour les produits (Ajouter, Lire, Modifier, Supprimer)
- Hacher les mots de passe avec SHA-256
- Configurer et déployer avec Maven

---

## 🏗️ Architecture 3 Tiers

```
TP4/
├── pom.xml
└── src/main/java/
    ├── dao/
    │   ├── interfaces/
    │   │   ├── IProduitDAO.java        # Interface CRUD produit
    │   │   └── IUserDAO.java           # Interface CRUD utilisateur
    │   ├── impl/
    │   │   ├── ProduitDAOImpl.java     # Implémentation stockage mémoire
    │   │   └── UserDAOImpl.java        # Implémentation stockage mémoire
    │   └── model/
    │       ├── Produit.java            # Entité produit
    │       ├── User.java               # Entité utilisateur
    │       └── Role.java               # Enum ADMIN / MANAGER / USER
    ├── metier/
    │   ├── ProduitMetier.java          # Service métier produits (Singleton)
    │   └── UserMetier.java             # Service métier utilisateurs (Singleton)
    ├── util/
    │   ├── PasswordUtil.java           # Hachage SHA-256
    │   └── ValidationUtil.java         # Validation email, prix, champs
    └── web/
        ├── filter/
        │   ├── AuthenticationFilter.java     # Auth + contrôle rôles
        │   └── CharacterEncodingFilter.java  # UTF-8 global
        └── servlet/
            ├── LoginServlet.java
            ├── SignupServlet.java
            ├── LogoutServlet.java
            ├── DashboardServlet.java
            ├── AddProduitServlet.java
            ├── EditProduitServlet.java
            ├── UpdateProduitServlet.java
            └── DeleteProduitServlet.java
```

---

## 🔐 Gestion des Rôles (RBAC)

| Rôle | Dashboard | Ajouter | Modifier | Supprimer |
|------|-----------|---------|----------|-----------|
| `ADMIN` | ✅ | ✅ | ✅ | ✅ |
| `MANAGER` | ✅ | ✅ | ✅ | ✅ |
| `USER` | ✅ | ❌ | ❌ | ❌ |

**Filtre AuthenticationFilter :**
- URLs publiques : `/login`, `/signup`, ressources statiques
- Ressources protégées : toutes les autres URLs
- Accès insuffisant → page d'erreur `403.jsp`

---

## 🔄 Flux CRUD Produit

**Ajout d'un produit :**
```
/dashboard → clic "Ajouter"
    → GET /addProduit → addProduit.jsp (formulaire vide)
    → POST /addProduit → AddProduitServlet
         → validation champs
         → ProduitMetier.addProduit()
         → ProduitDAOImpl.addProduit()
         → redirect /dashboard?success=...
```

**Modification :**
```
GET /editProduit?id=X → formulaire pré-rempli
POST /updateProduit → UpdateProduitServlet → redirect /dashboard
```

**Suppression :**
```
GET /deleteProduit?id=X → DeleteProduitServlet → redirect /dashboard
```

---

## 🌐 URLs de l'Application

| URL | Rôle requis | Description |
|-----|-------------|-------------|
| `/login` | Public | Connexion |
| `/signup` | Public | Inscription |
| `/logout` | Authentifié | Déconnexion |
| `/dashboard` | Tout rôle | Liste des produits |
| `/addProduit` | ADMIN, MANAGER | Ajouter un produit |
| `/editProduit?id=X` | ADMIN, MANAGER | Formulaire modification |
| `/updateProduit` | ADMIN, MANAGER | Traitement modification |
| `/deleteProduit?id=X` | ADMIN, MANAGER | Suppression produit |

---

## 🚀 Installation et Exécution

### Prérequis

| Outil | Version |
|-------|---------|
| Java JDK | 11 |
| Apache Maven | 3.8.1 ou supérieur |
| Apache Tomcat | 9.x |
| IDE | Eclipse / IntelliJ / VS Code |

### Déploiement avec Maven

```powershell
# Configuration environnement (PowerShell)
$env:JAVA_HOME   = "C:\Program Files\Java\jdk-11"
$env:Path        = "$env:Path;C:\Program Files\Java\jdk-11\bin"
$env:Path        = "$env:Path;C:\apache-maven-3.9.x\bin"
$env:CATALINA_HOME = "C:\Tomcat"

# Compilation et packaging
cd C:\...\TP4
mvn clean package

# Déploiement
Copy-Item "target\gestion-produits.war" "C:\Tomcat\webapps\" -Force
C:\Tomcat\bin\shutdown.bat
Start-Sleep -Seconds 3
C:\Tomcat\bin\startup.bat

# Accès
Start-Process "http://localhost:8080/gestion-produits/login"
```

---

## 🔑 Concepts Clés

- **Pattern DAO** : séparation de la logique d'accès aux données (`IProduitDAO` / `ProduitDAOImpl`)
- **Singleton** : `ProduitMetier.getInstance()` pour le service métier
- **Hachage SHA-256** : `PasswordUtil.hashPassword()` – mots de passe non réversibles
- **RBAC** : `Role.ADMIN`, `Role.MANAGER`, `Role.USER` dans l'entité `User`
- **CharacterEncodingFilter** : UTF-8 global pour tous les formulaires
- **Pages d'erreur** : `403.jsp`, `404.jsp`, `500.jsp` configurées dans `web.xml`

---

## 🐛 Problèmes Courants et Solutions

| # | Problème | Cause | Solution |
|---|----------|-------|----------|
| 1 | `mvn : commande introuvable` | Maven pas dans le PATH | `$env:Path += ";C:\apache-maven-...\bin"` |
| 2 | `CATALINA_HOME non définie` | Variable manquante | `$env:CATALINA_HOME = "C:\Tomcat"` |
| 3 | `JAVA_HOME pointe vers JRE` | Mauvaise configuration | Redéfinir vers JDK 11 |
| 4 | Caractères français mal affichés | Encodage | Ajouter `CharacterEncodingFilter` |
| 5 | Erreur 403 pour rôle USER | `hasPermission()` trop restrictif | Vérifier la logique de rôle |

---

## ⚠️ Notes Importantes

- Données stockées en **mémoire** (volatiles) – réinitialisées au redémarrage
- Mots de passe hachés en **SHA-256** (non réversibles)
- Pour la production : remplacer le stockage mémoire par une base de données (JPA/Hibernate)

---

*TP4 – Java EE | ENSAH | TDIA2 S4 | © 2026 Zaynab AIT ADDI*
