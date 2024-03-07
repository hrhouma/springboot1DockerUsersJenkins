#!/bin/bash

echo "Starting the script execution."

# Execute script1.sh
if ! sh script1.sh; then
    echo "Script 1 failed to execute correctly."
    exit 1
fi

echo "Script 1 executed successfully."

# Execute script2.sh
if ! sh script2.sh; then
    echo "Script 2 failed to execute correctly."
    exit 1
fi

echo "Script 2 executed successfully."

# Wait for a while to ensure Azure VM is up and running
echo "Waiting for VM to initialize..."
sleep 120

# Execute script3.sh
if ! sh script3.sh; then
    echo "Script 3 failed to execute correctly."
    exit 1
fi

echo "Script 3 executed successfully."

echo "All scripts executed successfully."

# Background job for resource group deletion
(
    sleep 300 # Wait for 5 minutes
    echo "Starting the deletion process..."
    az group delete --name jenkins-rg --yes --no-wait
    echo "The deletion command has been issued."
) &

echo "Deletion of the resource group 'jenkins-rg' will occur in 5 minutes. You can continue using the shell."
