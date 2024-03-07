#!/bin/bash

DIRECTORY="jenkins/"
cd $DIRECTORY

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
  --custom-data cloud-init-jenkins.txt

# Open port 8080 for Jenkins
az vm open-port \
  --resource-group jenkins-rg \
  --name jenkins-vm \
  --port 8080 \
  --priority 1010

echo "Script 2 completed: Azure VM created and port opened."
