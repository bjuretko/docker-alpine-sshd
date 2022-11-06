#!/bin/sh

# Add user with uid matching to the hosts to support correct uid/gid handling on volume mounted files
USER=benedict
USERID=1027
GROUP=users
AUTHORIZED_KEYS_URL=https://github.com/bjuretko.keys
adduser -h /home/${USER} -G ${GROUP} -u ${USERID} -D ${USER} && \
   passwd -u ${USER} && \
   cd /home/${USER} && \
   mkdir .ssh && \
   wget -O .ssh/authorized_keys ${AUTHORIZED_KEYS_URL} && \
   chown -R ${USER}:${GROUP} .ssh
