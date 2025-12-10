# 🏠 Dashboard RShiny - Maison du Monde

## 📊 Description du Projet

Application de tableau de bord interactif développée avec **RShiny** pour l'analyse multivariée des produits Maison du Monde. Ce projet permet d'explorer en profondeur la performance commerciale des produits et d'identifier des groupes de produits similaires grâce à des techniques de classification non supervisée.

## ✨ Fonctionnalités Principales

### 📈 Statistiques Descriptives
- Analyse du chiffre d'affaires (CA) par catégorie de produits
- Visualisation des quantités vendues en magasin et sur le web
- Calcul et affichage des taux de performance :
  - Taux d'ajout au panier
  - Taux de litige
  - Taux de transactions web
  - Notes clients moyennes

### 🔍 Classification Non Supervisée (Clustering)
- **Classification Hiérarchique Ascendante (CAH)** avec méthode de Ward
- Analyse approfondie des 3 principales sous-familles :
  - 🛋️ Canapés
  - 🪑 Chaises
  - 🗄️ Buffets et Comptoirs
- Identification des produits attractifs vs moins attractifs
- Détection de produits atypiques

### 📊 Visualisations Interactives
- Graphiques dynamiques avec **ggplot2** et **plotly**
- Treemaps pour la visualisation des catégories de produits
- Dendrogrammes pour la visualisation des clusters
- Graphiques comparatifs entre groupes de produits

## 🛠️ Technologies Utilisées

- **R** (version ≥ 4.0)
- **Shiny** - Framework pour applications web interactives
- **shinydashboard** - Interface de tableau de bord
- **tidyverse** - Manipulation de données
- **ggplot2** & **plotly** - Visualisations graphiques
- **treemapify** - Visualisations en treemap

## 📦 Installation

### Prérequis
- R installé sur votre machine (version ≥ 4.0)
- RStudio (recommandé)

### Installation des packages

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "tidyverse",
  "ggplot2",
  "plotly",
  "treemapify",
  "shinythemes"
))
```

## 🚀 Utilisation

### ⚠️ Données Requises

**Important :** Ce projet nécessite un fichier de données `dataset_product.csv` qui n'est **pas inclus** dans ce repository pour des raisons de confidentialité.

Le fichier doit être placé dans un dossier `data/` à la racine du projet avec la structure suivante :

```
SAEMaisonDuMonde/
├── data/
│   └── dataset_product.csv
├── global.R
├── server.R
├── ui.R
└── README.md
```

**Format attendu du dataset :**
- Les 5 premières colonnes doivent être de type facteur
- Variables numériques incluant :
  - CA magasin et web
  - Quantités vendues
  - Notes clients
  - Sessions web
  - Ajouts au panier
  - Litiges

### Lancement de l'application

1. Clonez ce repository :
```bash
git clone https://github.com/votre-username/SAEMaisonDuMonde.git
cd SAEMaisonDuMonde
```

2. Ajoutez vos données dans le dossier `data/`

3. Ouvrez RStudio et exécutez :
```r
shiny::runApp()
```

Ou ouvrez l'un des fichiers R (`ui.R`, `server.R`, ou `global.R`) dans RStudio et cliquez sur "Run App".

## 📁 Structure du Projet

```
SAEMaisonDuMonde/
├── data/                  # Dossier contenant les données (non versionné)
├── global.R               # Chargement des packages et préparation des données
├── server.R               # Logique serveur de l'application Shiny
├── ui.R                   # Interface utilisateur de l'application
├── .gitignore            # Fichiers à exclure du versioning
└── README.md             # Documentation du projet
```

## 📊 Métriques Calculées

L'application calcule automatiquement plusieurs indicateurs clés :

- **Note produit** : Somme des notes / Nombre de notes clients
- **Quantité totale** : Ventes magasin + Ventes web
- **CA total** : Chiffre d'affaires magasin + web
- **Taux d'ajout panier** : (Ajouts panier / Sessions web) × 100
- **Taux de litige** : (Litiges / Quantité totale) × 100
- **Taux transaction web** : (Ventes web / Ventes totales) × 100

## 👥 Auteur

Projet réalisé dans le cadre de la formation STID2 - 2025

## 📝 License

Ce projet est développé à des fins éducatives.

---

**Note :** Les données utilisées dans ce projet sont confidentielles et ne sont pas partagées publiquement.
