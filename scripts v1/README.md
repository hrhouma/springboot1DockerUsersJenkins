# Guide d'Installation et d'Utilisation

## Introduction

Ce guide fournit les instructions pour utiliser notre nouveau script shell avancé, conçu pour optimiser les processus de travail en automatisant l'installation de Docker et Docker Compose sur une machine virtuelle Ubuntu 22.04 avec Jenkins sur Azure. Ce script facilite la configuration et la gestion de l'environnement de développement, éliminant le besoin d'exécuter manuellement les tâches répétitives.

## Prérequis

- Compte Azure avec Azure CLI installée et configurée
- Permissions suffisantes pour exécuter des scripts et créer des ressources sur Azure

## Installation

1. **Clonage du dépôt**

   Ouvrez votre terminal et clonez le dépôt en exécutant :

   ```shell
   git clone https://github.com/hrhouma/kubernetes2.git
   ```

2. **Accès au répertoire du projet**

   Changez de répertoire avec la commande :

   ```shell
   cd /kubernetes2/"A1-lancer une VM Ubuntu2204 Docker + Jenkins sur AZURE"
   ```

3. **Modification des permissions**

   Modifiez les permissions des scripts pour les rendre exécutables :

   ```shell
   chmod 777 script1.sh script2.sh script3.sh script4.sh
   ```

4. **Exécution du script principal**

   Lancez le script principal qui orchestrera l'ensemble du processus :

   ```shell
   ./script4.sh
   ```

## Utilisation

- Le script `script4.sh` exécutera automatiquement tous les scripts nécessaires pour installer Docker, Docker Compose, et vous connecter directement à la machine virtuelle.
- Pour accéder au mode administrateur, utilisez `sudo -s` une fois connecté à la machine virtuelle. Vous pourrez alors effectuer vos manipulations en toute liberté.

## Fermeture de session

- Pour terminer votre session, saisissez `exit` deux fois : la première pour quitter le mode administrateur, et la seconde pour quitter la machine virtuelle.
- Vous serez automatiquement redirigé vers l'interface CLI d'Azure.
- Toutes les ressources créées seront automatiquement détruites 5 minutes après votre déconnexion, assurant ainsi une gestion efficace et sécurisée de l'environnement.

## Contribution

Nous encourageons tous les développeurs à contribuer à l'amélioration de ce script. Pour toute suggestion, veuillez ouvrir une issue ou soumettre une pull request sur notre dépôt GitHub.

# Résumé 

```
git clone https://github.com/hrhouma/kubernetes2.git
cd /kubernetes2/
 cd './A1-lancer une VM Ubuntu2204 Docker + Jenkins sur AZURE/'
chmod 777 script1.sh script2.sh script3.sh script4.sh
./script4.sh
sudo -s
exit
exit
```
