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
	            sh 'apt-get update'
	            sh 'apt-get install -y openjdk-17-jdk'
	            sh 'java -version'
	
	            // Install Maven
	            sh 'apt-get install -y maven'
	            sh 'mvn -v'
	
	            // Install Docker
	            sh 'apt-get install -y ca-certificates curl gnupg'
	            sh 'install -m 0755 -d /etc/apt/keyrings'
	            sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg'
	            sh 'chmod a+r /etc/apt/keyrings/docker.gpg'
	            sh 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null'
	            sh 'apt-get update'
	            sh 'apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
	            sh 'docker --version'
	
	            // Add the Jenkins user to the Docker group
	            sh 'usermod -aG docker jenkins'
	            // Start and enable Docker service
	            sh 'systemctl restart docker'
	            sh 'systemctl enable docker'
	
	            // Install Docker Compose
	            sh 'curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
	            sh 'chmod +x /usr/local/bin/docker-compose'
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
