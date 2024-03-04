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
