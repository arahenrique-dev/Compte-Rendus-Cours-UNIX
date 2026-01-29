# Compte-rendu – TP 02 : Services, processus signaux
Henrique Pires Aragão - 21304445
Sorbonne Université

## 0. Introduction


## 1. Secure Shell : SSH

### 1.1 Exercice : Connection ssh root (reprise fin tp-01) 
```bash
man sshd_config
```

Avec cette commande on peut trouver une list des éléments de configuration ssh et c'est possible de voir : 

"PermitRootLogin prohibit-password" est activé, c'est à dire que root peut se connect uniquement avec une clé ssh au lieu d'un mot de passe. Cela represente un niveau de sécurité plus sûre, mais il y a besoin d'une configuration de clé publique. 

On trouve des autres options comme "PermitRootLogin yes"  qui autorise la connection ssh directe avec root mais expose le compte root et donc a une sécurité faible. 

De plus, c'est listé "PermitRootLogin no" qui est très sécurisé mais bloque le login de root et "PermitRootLogin forced-commands-only" qui oblige la spécification d'une commande pour réaliser l'authentification et sécurise bien.

### 1.2 Exercice : Authentification par clef / G´en´eration de clefs
On va mettre en place un authentification ssh par clef pour se connecter sans utiliser un mot de passe sans passer par passphrase. 

 
```bash
ssh-keygen -t rsa
```
Avec la commande ci-dessus dans le terminal de la machine hôte, on genère la clé privée et la clé publique, dont on copiera vers le serveur. On utilisera "rsa" au lieu de "dsa" comme c'est un format plus recent. Les outils utilisés sont le terminal de macOS pour génerer la clé.

### 1.3 Exercice : Authentification par clef / Connection serveur
Pour se connecter au serveur en utilisant la clef publique crée au exercice précedent, on la placera dans un dossier .ssh crée avec la commande suivante : 

```bash
mkdir -p /root/.ssh
```

Puis, on tape : 
```bash
cd /root/.ssh
touch authorized_keys
```
Ces commandes vont entrer dans le dossier .ssh etcréer notre fichier authorized_keys. 

```bash
cat /Users/Henrique/.ssh/id_rsa.pub 
```
On lance cette commande sur le terminal de la machine hote pour prendre la clé publique et puis pour écrire sur authorized_keys on lance dans la console de la VM :

```bash
nano authorized_keys
```
On colle notre cléf publique et puis pour mettre à jour les droits de lecture et écriture au propriétaire :

```bash
chmod 700 .
chmod 600 authorized_keys
```

### 1.4 Exercice : Authentification par clef : depuis la machine hote
Pour réaliser la connection, on reprend l'IP de la VM avec :

```bash
ip a
```

Ensuite, on tape pour realiser la connection : ssh -i id_rsa.pub root@ipserveur
```bash
ssh -i /Users/Henrique/.ssh/id_rsa.pub root@192.168.64.6
```

Ici un problème a été rencontré. À cause de la manque de copier et coller dans la machine virtuelle, la clé a été mise dans authorized_keys à la main, et une difference a bloqué l'acces mais cette divergence n'a pas été retrouvé. L'instalation des outils pour permettre cette fonctionnalité des a échoué.

### 1.5 Exercice : Sécurisez
À corriger. Cet exercice depend de la connection de l'exercice precedent.

## 2. Conclusion
Au cours de ce TP, on a exploré l’mise en place de connection de la machine hôte avec une machine virtuelle Debian.  

Malgré plusieurs tentatives, la connexion ssh avec authentification par clé n’a pas pu être établie, et conséquemment la sécurisation du compte root par clé seule n’a pas pu être réalisée. Cette dificulté est liée principalement aux contraintes de typage qui ont bloqué la fiabilité de la clé publique.

Néanmoins, ce TP nous a permis de comprendre le rôle des clés ssh, ainsi que le fonctionnement des fichiers `.ssh/authorized_keys` et l'importance de la sécurisation ssh.

## 3. Sources
https://man7.org/linux/man-pages/man5/sshd_config.5.html
https://github.com/utmapp/UTM/discussions/6833
