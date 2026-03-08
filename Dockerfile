# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adnen <adnen@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/08 20:47:32 by adnen             #+#    #+#              #
#    Updated: 2026/03/08 21:18:16 by adnen            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    tor \
    nginx \
    openssh-server \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/tor/hidden_service && \
    chown -R debian-tor:debian-tor /var/lib/tor/hidden_service && \
    chmod 700 /var/lib/tor/hidden_service

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN useradd -m -s /bin/bash adaloui && \
    echo "adaloui:password42" | chpasswd

# Copier les configs
COPY index.html /var/www/html/index.html
COPY style.css /var/www/html/style.css
COPY nginx.conf /etc/nginx/nginx.conf
COPY sshd_config /etc/ssh/sshd_config
COPY torrc /etc/tor/torrc

# Copier le script de démarrage et lui donner les droits d'exécution
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Étape E : Lancer le script au démarrage du container
ENTRYPOINT ["/start.sh"]