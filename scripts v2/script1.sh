#!/bin/bash

DIRECTORY="jenkins/"

# Delete the directory if it exists
if [ -d "$DIRECTORY" ]; then
    rm -rf "$DIRECTORY"
    echo "Directory '$DIRECTORY' has been removed."
fi

# Create the directory and move into it
mkdir -p $DIRECTORY
cd $DIRECTORY

# Create the cloud-init file for Jenkins setup with updated commands
cat <<EOF > cloud-init-jenkins.txt
#cloud-config
package_upgrade: true
runcmd:
  - sudo apt update
  - sudo apt install fontconfig openjdk-17-jre -y
  - sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  - echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  - sudo apt-get update
  - sudo apt-get install jenkins -y
  - sudo systemctl enable jenkins
  - sudo systemctl start jenkins
  # Installation de Docker commence ici
  - sudo apt-get update
  - sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  - sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - sudo apt-get update
  - sudo apt-get install docker-ce docker-ce-cli containerd.io -y
  - sudo usermod -aG docker azureuser
  - sudo systemctl enable docker
  - sudo systemctl start docker
EOF

echo "Script 1 completed: Directory setup and cloud-init file created."
