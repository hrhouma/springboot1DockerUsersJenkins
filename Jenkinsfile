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
                // Ici vous pouvez ajouter des étapes pour exécuter vos tests.
                // Par exemple, si vous avez des tests d'intégration ou d'API, vous les exécuteriez ici.
                // sh 'mvn test'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing Image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker-compose -f docker-compose.yml down'
            // Nettoyage des images Docker non taggées
            sh 'docker rmi $(docker images -f "dangling=true" -q) || true'
        }
    }
}
