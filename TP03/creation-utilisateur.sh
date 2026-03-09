#!/bin/bash

# Verifie que l'utilisateur est root
if [ "$USER" != "root" ] ; then
echo "Vous devez etre root"
exit
fi

# Demande des informations
echo -n "login : "
read login

echo -n "Nom : "
read nom

echo -n "Prenom : "
read prenom

echo -n "UID : "
read uid

echo -n "GID : "
read gid

echo -n "Commentaires : "
read com

# Vérifie si l'utilisateur existe
existe=$(grep "^$login:" /etc/passwd)

if [ "$existe" != "" ] ; then
echo "Utilisateur deja existant"
exit
fi

# Vérifier si le home existe
if [ -d "/home/$login" ] ; then
echo "Le repertoire /home/$login existe deja"
exit
fi

# On cree l'utilisateur
useradd -u $uid -g $gid -c "$nom $prenom $com" -m $login

echo "Utilisateur cree"