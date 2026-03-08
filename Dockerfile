# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adnen <adnen@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/08 20:47:32 by adnen             #+#    #+#              #
#    Updated: 2026/03/08 20:53:02 by adnen            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    tor \
    nginx \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/tor/hidden_service && \
    chown -R debian-tor:debian-tor /var/lib/tor/hidden_service && \
    chmod 700 /var/lib/tor/hidden_service

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN useradd -m -s /bin/bash adaloui && \
    echo "adaloui:password42" | chpasswd