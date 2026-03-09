#!/bin/bash

# Vérifie que le nombre de paramètres est différent de 2
if [ $# -ne 2 ] ; then
echo "Veuillez rentrer exactement 2 parametres"
else
CONCAT="$1$2" # Concatène les deux paramètres
echo $CONCAT
fi