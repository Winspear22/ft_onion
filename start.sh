#!/bin/bash

# 1. Démarrer le serveur SSH en arrière-plan
echo "[*] Démarrage du serveur SSH sur le port 4242..."
/usr/sbin/sshd

# 2. Démarrer Nginx en arrière-plan
echo "[*] Démarrage de Nginx sur le port 80..."
nginx &

# 3. Démarrer Tor en tant qu'utilisateur debian-tor (nécessaire pour les permissions)
echo "[*] Démarrage de Tor..."
echo "[*] Génération de l'adresse .onion en cours (soyez patient)..."
su -s /bin/bash -c "tor -f /etc/tor/torrc" debian-tor &

# 4. Attendre l'adresse .onion
while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
    sleep 1
done

echo ""
echo "=========================================================="
echo "    ✅ TON SERVICE CACHÉ EST PRÊT !"
echo "=========================================================="
echo "  🧅 ADRESSE : $(cat /var/lib/tor/hidden_service/hostname)"
echo "  🌐 HTTP    : PORT 80"
echo "  🔑 SSH     : PORT 4242 (User: adaloui / Pass: password42)"
echo "=========================================================="
echo ""

# Garder le script en vie
wait