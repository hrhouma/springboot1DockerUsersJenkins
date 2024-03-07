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

# Create the cloud-init file for setup with Docker installation and other configurations
cat <<EOF > cloud-init-config.txt
#cloud-config
package_upgrade: true
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - software-properties-common
runcmd:
  # Install Docker
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable"
  - apt-get update
  - apt-get install -y docker-ce docker-ce-cli containerd.io
  - systemctl start docker
  - systemctl enable docker
  # Install Java
  - apt-get install -y openjdk-11-jdk
EOF

echo "Script 1 completed: Directory setup and cloud-init file created."
