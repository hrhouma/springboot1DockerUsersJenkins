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
                    // Installer Java, Docker, Docker Compose et Maven si nécessaire
                    sh 'sudo -s apt-get update && sudo -s apt-get install -y openjdk-17-jdk'
                    sh 'sudo -s apt-get install -y maven'
                    sh 'sudo -s apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common'
                    sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -s apt-key add -'
                    sh 'sudo -s add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
                    sh 'sudo -s apt-get update && sudo -s apt-get install -y docker-ce docker-ce-cli containerd.io'
                    sh 'sudo -s usermod -aG docker \$(whoami)'
                    sh 'sudo -s systemctl start docker'
                    sh 'sudo -s systemctl enable docker'
                    sh 'sudo -s curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose'
                    sh 'sudo -s chmod +x /usr/local/bin/docker-compose'
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
