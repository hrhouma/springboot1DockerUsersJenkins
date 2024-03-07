#!/bin/bash

DIRECTORY="jenkins/"
# Assuming this script is run from the same directory as Script 1
# Construct the full path to the cloud-init file
CLOUD_INIT_FILE="$(pwd)/$DIRECTORY/cloud-init-config.txt"

# Create a resource group in Azure
az group create --name jenkins-rg --location westus

# Create a virtual machine in the resource group with Ubuntu 22.04
az vm create \
  --resource-group jenkins-rg \
  --name jenkins-vm \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  --custom-data "$CLOUD_INIT_FILE"

# Open ports 8080 to 8082 for Jenkins and other services
priority=1000  # Starting priority
for port in $(seq 8080 8082); do
    az network nsg rule create \
      --resource-group jenkins-rg \
      --nsg-name jenkins-vmNSG \
      --name jenkinsPort$port \
      --protocol tcp \
      --priority $priority \
      --destination-port-range $port \
      --access allow \
      --description "Allow port $port"
    let priority+=100  # Increment priority for the next rule
done

echo "Script 2 completed: Azure VM created and ports opened."
