#!/bin/bash

# On parcourit les fichiers du dossier
rep=$1
for f in $rep/*
do

# Verifie si c'est un fichier texte
type=$(file $f)

if echo $type | grep -q "text" ; then

echo -n "voulez vous visualiser le fichier $f ? (o/n) : "
read rep

if [ "$rep" = "o" ] ; then
more $f
fi

fi

done

#Quitter more → q
#Avancer d’une ligne → Entrée
#Avancer d’une page → Espace
#Remonter d’une page → b
#Chercher une chaîne → /mot
#Occurrence suivante → n