#!/bin/bash


# recherche dans le fichier /etc/passwd
param=$1
ligne=$(grep "^$param:" /etc/passwd)

# On essaye avec UID
if [ "$ligne" = "" ] ; then
ligne=$(awk -F: -v uid="$param" '$3==uid {print}' /etc/passwd)
fi

# Si on a trouvé une ligne
if [ "$ligne" != "" ] ; then
uid=$(echo $ligne | cut -d: -f3)
echo $uid
fi