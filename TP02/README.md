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
ssh-keygen
```
Avec la commande ci-dessus dans le terminal de la machine hôte, on genère la clé privée et la clé publique, dont on copiera vers le serveur. On utilisera a version standard id_ed25519 comme c'est un format plus recent. Les outils utilisés sont le terminal de macOS pour génerer la clé.

### 1.3 Exercice : Authentification par clef / Connection serveur
Pour se connecter au serveur en utilisant la clef crée au exercice précedent, on la placera dans un dossier .ssh crée avec la commande suivante : 

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
cat /Users/Henrique/.ssh/id_ed25519.pub 
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

Ensuite, on tape pour realiser la connection : ssh -i clef_prive root@ipserveur
```bash
ssh -i /Users/Henrique/.ssh/id_ed root@192.168.64.6
```

ou tout simplement : 
```bash
ssh -i root@192.168.64.6
```

Et comme ça, on utilise notre clé privé de la machine hote pour faire l'authentification de root, donc on est désormais bien connecté et la connexion au serveur est bien établie.

### 1.5 Exercice : Sécurisez
Pour empêcher les tentatives d'authentification en utilisant un mot de passe, on autorise la connexion du compte root avec uniquement la clé ssh.

Sur la console de la VM, on lance :
```bash
cd /etc/ssh/
nano sshd_config
```

Puis on chage les lignes suivantes : 
```bash
PermitRootLogin prohibit-password
PasswordAuthentication yes
PubkeyAuthentication yes
```
À : 
```bash
PermitRootLogin prohibit-password
PasswordAuthentication no
PubkeyAuthentication yes
```

Et comme ça, PermitRootLogin va autoriser le compte root à se connecter seulement avec une clé ssh ; PasswordAuthentification va désactiver l'authentification par un mot de passe et PubkeyAuthentication authorise la connexion avec une clé publique.

Les attaques de type brute-force ssh consistent à faire plusieurs test de forme automatique pour essayer une grande quantité de pairs d'utilisateurs et mots de passe à fin de trouver une combinaison qui est valide. Notre sécurisation empêche ce type d'action.

Pour que l'administrateur du serveur soit capable de proteger son serveur, il y a d'autres techniques comme changer le port, ce qui réduit les scans mais n'est pas suffisant tout seul, ou installer Fil2ban, qui fait une surveillance et bloque les adresses IP de forme automatique après plusieurs tentatives échouées.

## 2. Processus
### 2.1 Exercice : Etude des processus UNIX
#### 1.
En lançant...
```bash
man ps
``` 
...on retrouve les commandes suivantes :

- user
- pid
- %cpu
- %mem
- stat
- lstart
- time
- command

Donc on lance :
```bash
ps -eo user,pid,%cpu,%mem,stat,lstart,time,command
```

- TIME correspond au temps cumulé de la CPU que le processus à utilisé.
- Le processus qui a plus utilisé e processeur pour l'instant est ps.
- Le premier processus lancé suite le démarrage est systemd
- Ici on voit que ça a lancé à 10h21. Pour voir l'heure de démarrage de la machine on peut lancer : 
```bash
who -b
```
- La machine est allumé pour 3h28 pour l'instant. Pour voir combien de temps la machine est allumé on tape ur la console :
```bash
uptime
```
- 117 processus. On peut trouver le nombre approximatif de processus créés depuis le boot avec la commande : 
```bash
ps -e | wc -l
```

#### 2.
- On peut trouver le PPID avec la commande ps et les options suivantes : 
```bash
ps -eo pid,ppid,comm
```
Où **comm** permet d'afficher le nom de la commande.
- On a systemd qui est le tout premier processus et puis bash et les commandes lances depuis le shell

#### 3.
Avec pstree on peut voir toute l'arborescence de forme complète.

#### 4.
- Après avoir lancé top, on peut trier de forme décroissante a partir de resident memory. D'abbord on tape "?" sur la console pour voir le guide des commandes de cette interface et puis on tape "m" pour trier par mémoire, avec celui qui consome le plus en hut.
- On voit que c'est "systemd" qui consome le plus de mémoire. C'est un système et un gestionnaire de service pour les systèmes operationnels de Linux.
- **z** : affichage en couleur ; **x** : mettre en avant la colonne de trie ; **>, <** : changer la colonne de trie ;
- Après avoir installé htop avec "apt install htop", on peut voir les processus à temps réel avec une interface plus lisible et une arborescence des processus, mais ça n'est pas installé par défaut et consomme plus que top. 

## 3. Exercice 2 : Arrêt d’un processus
Pour créer nos scripts, coller notre code dans le fichier et donner des droits d'accès et faire notre executable, on tape : 
```bash 
nano date.sh
chmod +x date.sh
```

Et puis 
```bash
nano date-toto.sh
chmod +x date-toto.sh
```
Pour la même chose avec date-toto.sh

Donc, on peut désormais les lancer avec :
```bash
./date.sh
./date-toto.sh
```

- Après les lancer et les mettre en arrière plan, on peut arrêter les 2 horloges avec "ps aux | grep date".
- Avec man, on peut voir que les scripts sont interprétés par shell et c'est une boucle infinie (sleep 1). On affiche le texte et lheure avec l'aide de echo et date et ses options.

## 4. Exercice 3 : les tubes
**tee :** Ça lira l'entrée standard et ça va écrire vers la sortie standard et dans un fichier. Donc ça sert à afficher et sauvegarder
**cat :** Ça affichera les contenus des fichies ou l'entrée standard vers la sortie standard. Donc ça sert à afficher

```bash
ls | cat
```
La commande ci-dessus liste les fichiers du dossier courant dans une ligne par fichier.

```bash
ls -l | cat > liste
```
La commande ci-dessus enregistre le contenu de la liste produite dans le fichier liste et n'affiche rien.

```bash
ls -l | tee liste
```
Affiche et enregistre au même temps le contenu de forme detaillée dans liste

```bash
ls -l | tee liste | wc -l
```
Affiche le nombre des lignes des fichiers listés, en enregistrant la sortie dans liste.

## 5.  Journal système rsyslog
On peut vérifier si le service rsyslog est lancé avec la commande : 
```bash
systemctl status rsyslog
```

Ici on a eu le retour : 
```bash
Unit rsyslog.service could not be found.
```

Donc le service n'est pas installé. On l'installe avec : 
```bash
apt update
apt install rsyslog
```

- On relance la première commande. Cette fois le retour nous dit que c'est bien actif et son Mai PID est 1315 (rsyslogd).

- **Rsyslog** écrit des messages des services standards sur le fichier à "**/var/log/syslog**", mais la plupart des messages sont écrites sur : "**/var/log/messages**"

- **Cron** sert à exécuter des tâches planifiées à certaines dates et heures de forme utomatique.

- La commande **tail -f** sert à fficher les nouvelles lignes du fichier de forme continue. Si on lance cette commande sur un autre terminal, on verra des nouveaux messages qui indiquent l'arrêt et le redémarrage de cron.

- Le fichier **/etc/logrotate.conf** définit les réglages pour les journaux, comme archivage, compression et suppression des logs trop vieux par example.

- **dmesg** affiche les messages du noyau qui sont liés au démarrage du système. C'est détecté le chip Apple M1 et une interface ethernet pour le réseau.


## 6. Conclusion
Au cours de ce TP, on a exploré l’mise en place de connection de la machine hôte avec une machine virtuelle Debian.  

La connexion ssh avec authentification par clé a pu être établie, et on sécurise notre serveur en utilisant juste l'authentification par la clé. Cette mesure vise a limiter l'accès de notre serveur à root.

Ce TP nous a permis aussi de comprendre le rôle des clés ssh, ainsi que le fonctionnement des fichiers `.ssh/authorized_keys` et l'importance de la sécurisation ssh.

On a vu l'utilisation des commandes ps, top, htop, etc, ainsi que la manipulation des processus, ce qui nous a permis de voi l'hiérarchie des processus sous Linux. L’étude des tubes et des scripts shell a également démontré la automatisation des tâches dans cet environnement.

Enfin, la découverte du service rsyslog et des mécanismes de journalisation a montré l’importance des logs dans la supervision et le diagnostic d’un système.


## 7. Sources
- https://man7.org/linux/man-pages/man5/sshd_config.5.html
- https://github.com/utmapp/UTM/discussions/6833
- https://doc.ubuntu-fr.org/tutoriel/script_shell
- https://www.hostinger.com/fr/tutoriels/gerer-processus-linux-ligne-commande
- https://fr.wikipedia.org/wiki/Rsyslog
