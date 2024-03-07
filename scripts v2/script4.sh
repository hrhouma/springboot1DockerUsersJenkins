#!/bin/bash

# Execute script1.sh
sh script1.sh
if [ $? -ne 0 ]; then
    echo "Script 1 failed to execute correctly."
    exit 1
fi

# Execute script2.sh
sh script2.sh
if [ $? -ne 0 ]; then
    echo "Script 2 failed to execute correctly."
    exit 1
fi

# Wait for a while to ensure Azure VM is up and running
echo "Waiting for VM to initialize..."
sleep 120

# Execute script3.sh
sh script3.sh
if [ $? -ne 0 ]; then
    echo "Script 3 failed to execute correctly."
    exit 1
fi

echo "All scripts executed successfully."
