# Outil de Monitoring Système

## Présentation

Dans le cadre du TP2, l'objectif était de développer un outil de monitoring en Shell capable d'observer l'état d'une machine Linux, d'analyser différents journaux système et applicatifs, puis de générer automatiquement un rapport d'exécution.

L'outil collecte plusieurs informations relatives au système :

* État des services applicatifs.
* Analyse des journaux systemd.
* Observation des processus consommateurs de CPU.
* Analyse du fichier `app.log`.
* Analyse du fichier `metrics.csv`.
* Recherche de fichiers spécifiques dans une arborescence.
* Génération automatique de rapports horodatés.

Chaque exécution produit un nouveau dossier de rapport afin de conserver l'historique des analyses.

---

# Objectif de l'outil

L'objectif principal est d'automatiser les tâches de supervision d'une machine Linux afin de :

* Vérifier la disponibilité des services critiques.
* Identifier rapidement les erreurs présentes dans les journaux.
* Détecter les processus consommateurs de ressources.
* Produire des statistiques exploitables à partir de fichiers de logs.
* Générer un rapport facilement consultable par un administrateur système.

Cette approche se rapproche des outils de monitoring utilisés en entreprise tels que Nagios, Centreon ou Zabbix, mais sous une forme simplifiée adaptée à un script Shell.

---

# Choix d'architecture

## Pourquoi utiliser un main.sh ?

L'application repose sur un fichier principal nommé `main.sh`.

Son rôle est de :

* Charger les différents modules.
* Initialiser l'environnement d'exécution.
* Exécuter les différentes étapes dans le bon ordre.
* Centraliser le point d'entrée du programme.

Cette approche permet d'obtenir un script principal simple à lire et à maintenir.

Exemple :

```bash
source modules/init.sh
source modules/services.sh
source modules/journald.sh
```

Le fichier principal agit comme un orchestrateur.

---

## Pourquoi utiliser des modules ?

Plutôt qu'un unique script de plusieurs centaines de lignes, le projet a été découpé en plusieurs modules spécialisés.

Avantages :

* Meilleure lisibilité du code.
* Maintenance simplifiée.
* Réutilisation plus facile.
* Débogage plus rapide.
* Séparation claire des responsabilités.

Chaque module réalise une seule tâche.

Exemple :

| Module       | Fonction                       |
| ------------ | ------------------------------ |
| init.sh      | Initialisation                 |
| services.sh  | Vérification des services      |
| journald.sh  | Analyse des logs systemd       |
| processes.sh | Analyse des processus          |
| app_log.sh   | Analyse du fichier app.log     |
| metrics.sh   | Analyse du fichier metrics.csv |
| tree_scan.sh | Recherche dans l'arborescence  |
| checks.sh    | Vérifications finales          |

Cette architecture suit le principe de responsabilité unique (Single Responsibility Principle).

---

# Prérequis et environnement

## Système d'exploitation

Le projet a été développé et testé sous :

* Ubuntu 22.04 LTS
* Ubuntu 24.04 LTS

---

# Structure du projet

```text
monitoring-lab/
│
├── main.sh
│
├── modules/
│   ├── init.sh
│   ├── services.sh
│   ├── journald.sh
│   ├── processes.sh
│   ├── app_log.sh
│   ├── metrics.sh
│   ├── tree_scan.sh
│   └── checks.sh
│
└── reports/
```

---

# Description détaillée des scripts

## main.sh

Le fichier `main.sh` constitue le point d'entrée du programme.

Il réalise les actions suivantes :

1. Création des variables globales.
2. Chargement des modules via `source`.
3. Appel des différentes fonctions.
4. Affichage de l'état d'avancement.

### Pourquoi utiliser source ?

La commande :

```bash
source modules/init.sh
```

permet d'importer les fonctions du fichier dans le shell courant.

Les fonctions deviennent alors directement accessibles :

```bash
create_report_dir
```

Sans `source`, il faudrait exécuter chaque script séparément, ce qui compliquerait le partage des variables.

### Pourquoi utiliser des fonctions ?

Les fonctions permettent :

* d'éviter la duplication de code ;
* d'organiser les traitements ;
* de rendre le code plus lisible ;
* de faciliter les évolutions futures.

---

## init.sh

Ce module prépare l'environnement d'exécution.

Fonctions :

* Affichage du contexte d'exécution.
* Affichage de l'utilisateur courant.
* Affichage du nom de la machine.
* Affichage de la date de lancement.
* Création du dossier de rapport.

Exemple :

```text
reports/run-20260624-150000/
```

Chaque exécution crée un nouveau dossier afin de conserver l'historique.

---

## services.sh

Ce module vérifie l'état des services :

* fake-api
* log-generator
* noisy-workers

Pour chaque service :

```bash
systemctl is-active
```

est utilisé afin de déterminer si le service est actif.

Le résultat est enregistré dans :

```text
services.txt
```

---

## journald.sh

Ce module collecte les journaux systemd.

Les 30 dernières lignes des services sont récupérées :

* fake-api
* log-generator

Deux fichiers sont générés :

```text
journald.txt
journald_errors.txt
```

Le second contient uniquement :

```text
ERROR
CRITICAL
```

---

## processes.sh

Ce module surveille les processus système.

Deux rapports sont produits :

### top_cpu.txt

Liste des 10 processus utilisant le plus de CPU.

Commande utilisée :

```bash
ps aux --sort=-%cpu
```

### hogs.txt

Recherche du processus :

```text
cpu-hog.sh
```

afin d'identifier les consommateurs artificiels de CPU.

---

## app_log.sh

Ce module analyse :

```text
/var/log/monitoring-lab/data/app.log
```

Informations calculées :

* Nombre total de lignes.
* Nombre d'ERROR.
* Nombre de CRITICAL.
* Top 5 des serveurs les plus présents.

Les résultats sont enregistrés dans :

```text
app_summary.txt
```

Une version anonymisée du journal est également produite :

```text
app_redacted.log
```

---

## metrics.sh

Ce module analyse :

```text
metrics.csv
```

Informations extraites :

* Nombre total de lignes.
* Nombre de lignes avec CPU supérieur ou égal à 95%.
* Cinq premières anomalies détectées.

Résultat :

```text
metrics_summary.txt
```

---

## tree_scan.sh

Ce module exploite les commandes :

```bash
find
```

et

```bash
xargs
```

afin de rechercher :

* Les fichiers `.bak`
* Les fichiers contenant `SECRET=`

Rapports générés :

```text
tree_bak.txt
tree_secret.txt
```

---

## checks.sh

Ce module réalise une vérification finale.

Chaque fichier attendu est contrôlé :

* services.txt
* journald.txt
* journald_errors.txt
* top_cpu.txt
* hogs.txt
* app_summary.txt
* app_redacted.log
* metrics_summary.txt
* tree_bak.txt
* tree_secret.txt

L'objectif est de détecter immédiatement une erreur de génération.

---

# Conclusion

Ce projet met en œuvre plusieurs concepts importants de l'administration système Linux :

* Shell scripting.
* Gestion des processus.
* Utilisation de systemd.
* Analyse de journaux.
* Manipulation de fichiers texte.
* Utilisation de find, grep, awk et xargs.
* Organisation modulaire d'un projet.

L'approche modulaire retenue permet d'obtenir un outil clair, évolutif et facilement maintenable.
