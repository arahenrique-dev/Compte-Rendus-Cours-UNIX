#!/bin/bash

# Vérifie si l'argument fourni est bien un répertoire
if [ -d "$1" ] ; then
    echo "###### fichier dans $1"
    ls -1 -f $1 # -1 : une ligne par fichier, -f : pas de triage

    for fichier in "$1" ; do
        echo "fichier : $fichier" ;
        if [ -f "$fichier" ] ; then echo "$fichier" ; fi
    done

    echo "###### repertoires dans $1"
    ls -1 -d $1
    #On boucle sur tous les éléments du repertoire
    for repertoire in "$1"/* ; do
        if [ -d "$repertoire" ] ; then echo "$repertoire" ; fi
    done
fi