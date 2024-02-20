# 🏢 Sirene as API

## Description

API REST pour accéder aux données de SIRENE (Système Informatique pour le Répertoire des ENtreprises et des Établissements).

## Essayer l'API

Vous pouvez essayer l'API en utilisant une instance hébergée chez OVHcloud :

    curl 'https://sirene.searchd.fr/api/v1/unites_legales/?q=Doctolib'

## Installation en environnement de développement

Pré-requis :

- Ruby 3.3.0
- PostgreSQL

Cloner le dépôt :

    git clone git@github.com/dilolabs/sirene-as-api.git

Se déplacer dans le répertoire du projet :

    cd sirene-as-api

Installer les dépendances et créer la base de données :

    bin/setup

Peupler la base de données avec les données de SIRENE :

⚠️  Cela peut prendre un certain temps.

    bundle exec sirene:import_stock

Lancer le serveur :

    bin/dev

Requêter l'API avec le nom d'une entreprise :

    curl 'localhost:3000/api/v1/unites_legales/?q=Doctolib'

Requêter l'API avec le SIREN d'une entreprise :

    curl 'localhost:3000/api/v1/unites_legales/794598813'

## Licence

Fair Source 10 (voir [LICENSE.md](LICENSE.md)).

