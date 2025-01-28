# 🏢 Sirene as API

## Description

API REST pour accéder aux données de SIRENE (Système Informatique pour le Répertoire des ENtreprises et des Établissements).

## Essayer l'API

Vous pouvez essayer l'API en utilisant une instance hébergée chez OVHcloud :

    curl 'https://sirene.searchd.fr/api/v1/unites_legales/?q=Doctolib'

Si celle-ci ne répond pas, merci de bien vouloir nous écrire par mail à equipe+sirene-as-api@dilolabs.fr

## Installation en environnement de développement

Pré-requis :

- Ruby 3.3
- PostgreSQL

Cloner le dépôt :

    git clone git@github.com/dilolabs/sirene-as-api.git

Se déplacer dans le répertoire du projet :

    cd sirene-as-api

Installer les dépendances et créer la base de données :

    bin/setup

Peupler la base de données avec les données de SIRENE :

⚠️  Cela peut prendre un certain temps.

    bin/rails sirene:import_stock

Lancer le serveur :

    bin/dev

Requêter l'API avec le nom d'une entreprise :

    curl 'localhost:3000/api/v1/unites_legales/?q=Doctolib'

Requêter l'API avec le SIREN d'une entreprise :

    curl 'localhost:3000/api/v1/unites_legales/794598813'

## Déploiement en production

En production, le job d'import des données de SIRENE est automatiquement exécuté tous les mois.

Si vous souhaitez déployer Sirene as API en production et avez besoin d'assistance, merci de bien vouloir nous écrire par mail à equipe+sirene-as-api@dilolabs.fr

## Licence

Fair Source 10 (voir [LICENSE.md](LICENSE.md)).

