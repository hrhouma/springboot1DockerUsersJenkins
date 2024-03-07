#!/bin/bash

RESOURCE_GROUP="jenkins-rg"
VM_NAME="jenkins-vm"
LOG_FILE="vm_setup.log"

# Rediriger la sortie standard et la sortie d'erreur vers le fichier de log
exec &> >(tee "$LOG_FILE")

# Tentative de récupération de l'adresse IP de la VM avec des réessais
MAX_RETRIES=10
for (( i=1; i<=MAX_RETRIES; i++ )); do
    IP_ADDRESS=$(az vm show --show-details --resource-group $RESOURCE_GROUP --name $VM_NAME --query publicIps -o tsv)

    if [ ! -z "$IP_ADDRESS" ]; then
        echo "Adresse IP trouvée : $IP_ADDRESS"
        break
    else
        echo "En attente de l'adresse IP de la VM... Tentative $i"
        sleep 30
    fi
done

if [ -z "$IP_ADDRESS" ]; then
    echo "Erreur : Impossible de récupérer l'adresse IP de la VM après plusieurs tentatives."
    exit 1
fi

# Afficher et enregistrer la commande SSH
SSH_COMMAND="ssh -o StrictHostKeyChecking=no azureuser@$IP_ADDRESS"
echo "Pour se connecter à la VM, utilisez : $SSH_COMMAND"

# Connexion à la VM via SSH
$SSH_COMMAND << 'EOF'
    echo "Connecté à la VM."

    # Vérifier si Java est installé
    if java -version; then
        echo "Java est installé."
    else
        echo "Java n'est pas installé."
        exit 1
    fi

    # Vérifier si Jenkins est en cours d'exécution
    if systemctl status jenkins; then
        echo "Jenkins est en cours d'exécution."
    else
        echo "Jenkins n'est pas en cours d'exécution."
        exit 1
    fi
EOF

echo "Script 3 terminé : Statut de la VM vérifié et connexion SSH établie."
