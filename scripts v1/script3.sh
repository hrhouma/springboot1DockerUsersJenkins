#!/bin/bash

RESOURCE_GROUP="jenkins-rg"
VM_NAME="jenkins-vm"
LOG_FILE="vm_setup.log"

# Redirect output to log file and also display it on the screen
exec &> >(tee "$LOG_FILE")

# Retrieve VM's IP address
MAX_RETRIES=10
for (( i=1; i<=MAX_RETRIES; i++ )); do
    IP_ADDRESS=$(az vm show --show-details --resource-group $RESOURCE_GROUP --name $VM_NAME --query publicIps -o tsv)
    if [ ! -z "$IP_ADDRESS" ]; then
        echo "IP address found: $IP_ADDRESS"
        break
    else
        echo "Waiting for VM's IP address... Attempt $i"
        sleep 30
    fi
done

if [ -z "$IP_ADDRESS" ]; then
    echo "Error: Unable to retrieve VM's IP address."
    exit 1
fi

# Display the SSH connection command in the logs
echo "To manually connect via SSH, use the following command:"
echo "ssh -o StrictHostKeyChecking=no azureuser@$IP_ADDRESS"

# Execute an interactive SSH session
echo "Connecting to VM via SSH. Press Ctrl+D to exit the session."
ssh -o StrictHostKeyChecking=no azureuser@$IP_ADDRESS

echo "SSH session closed. Script 3 completed."
