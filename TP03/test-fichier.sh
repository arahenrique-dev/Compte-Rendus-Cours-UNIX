#!/bin/bash

# Vérifie si l'argument est un répertoire
if [ -d "$1" ] ; then fichier="repertoire"
# Vérifie si c'est un fichier ordinaire
else if [ -f "$1" ] ; then fichier="fichier ordinaire"
else fichier="" ; fi
fi

# Vérifie si le fichier ou répertoire existe
if [ "$fichier" = "" ] ; then echo "Le fichier $1 n'existe pas"
else echo "Le fichier $1 est un $fichier"
fi

droits=""
# Vérifie si les droits d'utilisation
if [ -w "$1" ] ; then droits="$droits ecriture" ; fi
if [ -r "$1" ] ; then droits="$droits lecture" ; fi
if [ -x "$1" ] ; then droits="$droits execution" ; fi

if [ "$fichier" != "" ] ; then echo "$1 est acessible par X en $droits" ; fi