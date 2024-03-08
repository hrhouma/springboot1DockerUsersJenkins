pipeline {
  agent any
  stages {
    stage('Setup Environment') {
      steps {
        script {
          sh 'sudo apt-get install -y openjdk-17-jdk'
          sh 'java -version'

          // Install Maven
          sh 'sudo apt-get install -y maven'
          sh 'mvn -v'

          // Prepare Docker repository and install Docker
          sh 'sudo apt-get install -y ca-certificates curl gnupg lsb-release'
          sh 'sudo mkdir -p /etc/apt/keyrings'
          sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
          sh 'sudo chmod a+r /etc/apt/keyrings/docker.gpg'
          sh 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
          // sh 'sudo apt-get update' // Ensure the APT package list is updated after adding new repository
          sh 'sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
          sh 'docker --version'

          // Add the Jenkins user to the Docker group
          sh 'sudo usermod -aG docker jenkins'
          // Restart and enable Docker service to apply user group changes
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

    stage('Test') {
      steps {
        echo 'Running Tests...'
      }
    }

  }
}