#!/bin/bash

# Boucle infinie qui s'arrête via la commande 'q'
while read -p "Veuillez saisir votre note : " note ; do
    # Condition de sortie
    if [ $note == "q" ] ; then exit 1 ;
    # Validation : on vérifie les notes
    elif [ $note -ge 16 ] && [ $note -le 20 ] ; then echo "Tres bien" ;
    elif [ $note -lt 16 ] && [ $note -ge 14 ] ; then echo "Bien" ;
    elif [ $note -lt 14 ] && [ $note -ge 12 ] ; then echo "Assez bien" ;
    elif [ $note -lt 12 ] && [ $note -ge 10 ] ; then echo "Moyen" ;
    elif [ $note -lt 10 ] && [ $note -ge 0 ] ; then echo "Insuffisant" ;
    else echo "Valeur invalide" ; fi ;

    echo "Pour quitter le programme, appuyez sur q" ;
done ;