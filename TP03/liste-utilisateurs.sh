#!/bin/bash

# Avec cut on extrait d' les logins avec le délimiteur ":" 
for user in $(cut -d: -f1 /etc/passwd) ; do
    # Récupère l'UID de cet utilisateur
    uid=$(id -u "$user")
    
    # On vérifie si l'UID est supérieur à 100
    if [ "$uid" -gt 100 ] ; then
        echo "$user"
    fi
done