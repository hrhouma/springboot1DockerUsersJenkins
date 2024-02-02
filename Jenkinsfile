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
					// Commands to install Java
					sh 'sudo apt-get update'
					sh 'sudo apt-get install -y openjdk-17-jdk'
					// Verify Java installation
					sh 'java -version'

					// Commands to install Maven
					sh 'sudo apt-get install -y maven'
					// Verify Maven installation
					sh 'mvn -v'

					// Commands to install Docker
					sh 'sudo apt-get install -y ca-certificates curl gnupg lsb-release'
					sh 'sudo mkdir -p /etc/apt/keyrings'
					sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
					sh 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
					sh 'sudo apt-get update'
					sh 'sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin'
					// Verify Docker installation
					sh 'docker --version'
					// Add Jenkins user to Docker group
					sh 'sudo usermod -aG docker $USER'
					// Start and enable Docker service
					sh 'sudo systemctl start docker'
					sh 'sudo systemctl enable docker'
					
					// Install Docker Compose
					sh 'sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
					sh 'sudo chmod +x /usr/local/bin/docker-compose'
					// Verify Docker Compose installation
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
