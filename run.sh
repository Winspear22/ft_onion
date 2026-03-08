#!/bin/bash

# Variables
IMAGE_NAME="ft_onion"
CONTAINER_NAME="my_onion"

# Déterminer si on a besoin de sudo
DOCKER_CMD="docker"
if ! docker ps >/dev/null 2>&1; then
    if sudo -n true 2>/dev/null; then
        DOCKER_CMD="sudo docker"
    else
        echo "⚠️ Erreur: Tu n'as pas les droits docker et sudo -n a échoué."
        echo "Si tu es à 42, utilise le script 'docker-for-42' ou vérifie ta session."
        exit 1
    fi
fi

# 1. Nettoyage des anciens conteneurs
echo "[*] Nettoyage des anciens conteneurs..."
$DOCKER_CMD stop $CONTAINER_NAME 2>/dev/null
$DOCKER_CMD rm $CONTAINER_NAME 2>/dev/null

# 2. Construction de l'image
echo "[*] Construction de l'image Docker ($IMAGE_NAME)..."
$DOCKER_CMD build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du build !"
    exit 1
fi

# 3. Lancement du conteneur
echo "[*] Lancement du conteneur ($CONTAINER_NAME)..."
echo "--- Appuie sur Ctrl+C pour arrêter ---"
$DOCKER_CMD run -it --name $CONTAINER_NAME $IMAGE_NAME
