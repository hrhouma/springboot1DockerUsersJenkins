# Partie 1 - Java CRUD REST API avec Spring Boot, Hibernate, PostgreSQL, Docker, et Docker Compose

Ce projet illustre la mise en place d'une API REST en Java utilisant Spring Boot, Hibernate, PostgreSQL, Docker, et Docker Compose.
https://www.freecodecamp.org/news/automate-mern-app-deployment-with-jenkins/

## Ressources

- Article de référence sur le développement de l'API : [DEV.TO](https://dev.to/francescoxx/java-crud-rest-api-using-spring-boot-hibernate-postgres-docker-and-docker-compose-5cln)
- Code source sur GitHub : [FrancescoXX/java-live-api](https://github.com/FrancescoXX/java-live-api), [hrhouma/springboot1DockerUsers](https://github.com/hrhouma/springboot1DockerUsers.git)

## Les instructions de la première machine 
```shell

git clone https://github.com/hrhouma/springboot1DockerUsersJenkins.git
cd ./springboot1DockerUsersJenkins/
chmod 777 ./script1.sh ./script2.sh ./script3.sh ./script4.sh
./script1.sh
./script2.sh
./script3.sh 
./script4.sh
ssh azureuser@IP
sudo -s
sudo visudo
jenkins ALL=(ALL) NOPASSWD: ALL
// eleve ALL=(ALL) NOPASSWD: ALL
// eleve ALL=(ALL) NOPASSWD: /usr/bin/apt-get install -y openjdk-17-jdk, /usr/bin/apt-get install -y maven

```


## Les instructions de la deuxième machine (à ignorer)
```shell

git clone https://github.com/hrhouma/springboot1DockerUsersJenkins.git
cd ./springboot1DockerUsersJenkins/
cd './Shell VM + Installer JENKINS AZURE/'
chmod 777 ./script1.sh ./script2.sh ./script3.sh ./script4.sh
./script4.sh
```
## En cas de difficultés

### À l'extérieur de la VM: Open port 8080 for Jenkins
```shell
az vm open-port --resource-group jenkins-rg --name jenkins-vm --port 8080 --priority 1010
```
### À l'intérieur de la VM ( à ignorer): 

```shell
#!/bin/bash

# Mise à jour des paquets
sudo apt update
# Installation des paquets nécessaires pour Jenkins
sudo apt install -y fontconfig openjdk-17-jre
# Téléchargement et ajout de la clé GPG Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# Mise à jour des sources apt pour Jenkins
sudo apt-get update
# Installation de Jenkins
sudo apt-get install -y jenkins
# Activation et démarrage du service Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Installation de Docker
# Mise à jour des paquets
sudo apt-get update
# Installation des paquets nécessaires pour Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
# Ajout de la clé GPG Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Ajout du dépôt Docker à sources.list
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Mise à jour des sources apt pour Docker
sudo apt-get update
# Installation de Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Ajout de l'utilisateur au groupe docker pour exécuter des commandes Docker sans sudo
sudo usermod -aG docker azureuser
# Activation et démarrage du service Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status jenkins
```


## 1. Installation

Suivez ces étapes pour installer et démarrer le projet :

```bash
mvn clean -DskipTests
mvn install -DskipTests # création de target/*.jar
docker-compose build
docker images
docker-compose up -d
docker ps
curl http://localhost/api/users
```

## 2. Vérification PostgreSQL

Pour interagir avec PostgreSQL dans un conteneur Docker :

```bash
docker exec -it nom_du_conteneur bash # Ou 'sh' si 'bash' n'est pas disponible
```

Dans le shell PostgreSQL :

```sql
psql -U postgres -d postgres
\l # Lister toutes les bases de données
\c postgres # Se connecter à la base de données 'postgres'
\dt # Lister toutes les tables
\d users # Afficher la structure de la table 'users'
SELECT * FROM users; # Sélectionner tous les enregistrements de 'users'
\h # Aide sur les commandes SQL
\h SELECT # Aide sur la commande SELECT
\q # Quitter
```

## 3. CRUD

Pour interagir avec l'API REST :

```http
### Obtenir tous les utilisateurs
GET http://localhost:8080/api/users
Content-Type: application/json

### Obtenir un utilisateur par ID
GET http://localhost:8080/api/users/1
Content-Type: application/json

### Créer un nouvel utilisateur
POST http://localhost:8080/api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "johndoe@example.com"
}

### Mettre à jour un utilisateur
PUT http://localhost:8080/api/users/1
Content-Type: application/json

{
  "name": "Jane Doe",
  "email": "janedoe@example.com"
}

### Supprimer un utilisateur
DELETE http://localhost:8080/api/users/1
Content-Type: application/json
```

Utilisez l'extension REST Client de VS Code pour envoyer ces requêtes : [REST Client on Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=humao.rest-client).


## Autres commandes 

mvn -version
mvn clean install 
(ou en cas d'erreurs) 	mvn clean package -DskipTests
mvn clean install -DskipTests
mvn spring-boot:run
  
## 4. Aller Plus Loin Avec PostgreSQL

Pour approfondir vos connaissances sur PostgreSQL, consultez [ce tutoriel sur Tutorialspoint](https://www.tutorialspoint.com/postgresql/postgresql_select_query.htm).


# Partie 2 - Intégration Continue avec Jenkins, Docker, et Docker Hub

Ce guide exhaustif vous expliquera comment configurer un pipeline de CI (Intégration Continue) dans Jenkins pour construire une application Java avec Docker, l'exécuter avec PostgreSQL dans un environnement Dockerisé, et pousser l'image Docker construite vers Docker Hub.

## Prérequis

- Jenkins avec le plugin Docker Pipeline installé.
- Docker installé sur la machine Jenkins.
- Un compte Docker Hub (utilisez `hrhouma1` pour cet exemple).
- Accès au code source de votre application Java et au fichier `docker-compose.yml`.

## Configuration de Jenkins

### 1. Configuration des Credentials Docker Hub

Pour pousser des images vers votre compte Docker Hub (`hrhouma1`), commencez par configurer les credentials dans Jenkins :

1. Allez à **Jenkins Dashboard > Manage Jenkins > Manage Credentials**.
2. Sous **(global)**, cliquez sur **Add Credentials** à gauche.
3. Choisissez **Kind: Username with password**.
   - **Username**: `hrhouma1`
   - **Password**: `Abd$dseg1234E#` (mot de passe fictif pour cet exemple)
   - **ID**: `docker-hub-credentials` (utilisé dans le Jenkinsfile)
   - **Description**: Docker Hub Credentials for hrhouma1
4. Cliquez sur **OK** pour sauvegarder.

### 2. Création d'un Pipeline Jenkins

1. Créez un nouveau job en sélectionnant **New Item**, nommez-le (par exemple, `Java-Docker-Pipeline`), et choisissez **Pipeline** comme type.
2. Dans **SCM**, configurez la source du code en sélectionnant **Git** et entrez l'URL de votre repository. Si privé, ajoutez les credentials.
3. (Optionnel) Configurez les déclencheurs de build dans **Build Triggers**.

### 3. Script de Pipeline

Dans la section **Pipeline**, insérez le script suivant dans le champ **Script** :

```groovy
pipeline {
    agent any
    environment {
        DOCKER_COMPOSE_VERSION = '1.29.2'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build & Run') {
            steps {
                script {
                    sh 'docker-compose up -d --build'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo "Running tests"
                    // Insérez ici les commandes pour exécuter vos tests
                }
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        def appImage = docker.build("hrhouma1/myapp:${env.BUILD_ID}", '.')
                        appImage.push()
                    }
                }
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    sh 'docker-compose down -v'
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution complete.'
        }
    }
}
```

Ce script effectue les opérations suivantes :
- **Build & Run** : Construit l'image Docker de votre application et lance les services définis dans `docker-compose.yml`.
- **Test** : Ici, vous devriez ajouter les commandes pour exécuter les tests de votre application.
- **Push Image to Docker Hub** : Construit l'image Docker de votre application et la pousse vers Docker Hub sous le compte `hrhouma1`.
- **Cleanup** : Nettoie l'environnement en arrêtant et supprimant les conteneurs et volumes créés.

### 4. La Pipeline finale

- Cliquez sur **Save** pour sauvegarder votre configuration.
- Lancez le pipeline manuellement en cliquant sur **Build Now** pour la première fois.

```groovy
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'hrhouma1/java_app:1.0.0'
        CONTAINER_NAME = 'java_app'
        DATABASE_URL = 'jdbc:postgresql://java_db:5432/postgres'
        DATABASE_USERNAME = 'postgres'
        DATABASE_PASSWORD = 'postgres'
    }
    stages {
        stage('Setup Environment') {
	    steps {
	        script {
	            // Install Java
	            //sh 'sudo apt-get update'
	            sh 'sudo apt-get install -y openjdk-17-jdk'
	            sh 'java -version'
	
	            // Install Maven
	            sh 'sudo apt-get install -y maven'
	            sh 'mvn -v'
	
	            // Install Docker
	            sh 'sudo apt-get install -y ca-certificates curl gnupg'
	            sh 'sudo install -m 0755 -d /etc/apt/keyrings'
	            //sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
		    sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg'
	            sh 'sudo chmod a+r /etc/apt/keyrings/docker.gpg'
	            sh 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
	            //sh 'sudo apt-get update'
	            sh 'sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
	            sh 'docker --version'
	
	            // Add the Jenkins user to the Docker group
	            sh 'sudo usermod -aG docker jenkins'
	            // Start and enable Docker service
	            sh 'sudo systemctl restart docker'
	            sh 'sudo systemctl enable docker'
	
	            // Install Docker Compose
	            sh 'sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
	            sh 'sudo chmod +x /usr/local/bin/docker-compose'
	            sh 'docker-compose --version'
	        }
	    }
	}
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build JAR') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building Docker Image...'
                sh 'docker-compose -f docker-compose.yml build'
            }
        }
        stage('Run') {
            steps {
                echo 'Starting Docker Compose Services...'
                sh 'docker-compose -f docker-compose.yml up -d'
            }
        }
        stage('Test') {
            steps {
                echo 'Running Tests...'
                // Placez ici les commandes pour exécuter vos tests
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing Image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login --username $DOCKERHUB_USERNAME --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker-compose -f docker-compose.yml down'
            sh 'docker rmi \$(docker images -f "dangling=true" -q) || true'
        }
    }
}
```

### 5. Exécution du Pipeline

- Cliquez sur **Save** pour sauvegarder votre configuration.
- Lancez le pipeline manuellement en cliquant sur **Build Now** pour la première fois.

## Notes Supplémentaires

- **Tests Automatisés** : Intégrez des étapes de test dans le pipeline pour garantir la qualité de votre application.
- **Sécurité** : Utilisez toujours la gestion des credentials de Jenkins pour stocker des informations sensibles.
- **Personnalisation** : Adaptez le script de pipeline en fonction de vos besoins spécifiques, comme l'ajout de notifications, de déploiements conditionnels, etc.

Ce guide vous a présenté comment configurer un pipeline d'intégration continue dans Jenkins pour travailler avec Docker et Docker Hub, en prenant en compte la construction, les tests, et le déploiement d'une application Java.

# NE PAS OUBLIER !!!!!
```shell
 az group delete --name jenkins-rg --yes --no-wait
 ```
