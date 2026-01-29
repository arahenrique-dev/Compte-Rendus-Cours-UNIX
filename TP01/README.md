# Compte-rendu – TP 01 Installation Serveurs
Henrique Pires Aragão - 21304445
Sorbonne Université

## 0. Introduction
L'objectif de ce TP est d'installer un serveur Linux Debian dans une machine virtuelle pour se familiariser avec le processus d'installation et la configuration initiale du système

Ce TP permet également de pratiquer les commandes du système Linux et de plus configurer le réseau et ssh.


## 1. Installation
Pour créer une machine virtuelle sur um Macbook équipé d'un chip M1, on utilisera le software UTM pour la virtualisation.

Depuis le lien de mirroir suivant on récupère l'image iso necessaire pour créer notre Machine Virtuelle : 

http://ftp.fr.debian.org/debian/dists/trixie/main/installer-arm64/current/images/netboot/

Étant donné que le Mac utilise un chip M1, on choisit une version arm64. On prendra le support trixie en version stable de type NetBoot et on la lance sur UTM pour créer la VM et commencer l'installation.

L'installation est faite avec le mirror suivant : deb.debian.org

## 1. Post-Installation

Après l'installation on se retrouve avec une machine qui contient 323 paquets (vérifié avec dpkg -l | wc -l). On se connecte à la machine et on configure le ssh avec : apt install ssh

## 2. CommandesLocales

**Locales :**
```bash
echo $LANG
en_US.UTF-8
```

Cette commande affiche la langue et encodage du système. Dans ce cas là, le système est configuré en Anglais avec un encodage UTF-8 $LANG fait partie des variables d'environnement. Avec la commande "env", on peut trouver une liste des autres variables.
 
**Nom machine :**
```bash
hostname
debian
```

Cette commande affiche le nom de la machine sur le réseau dont pour cet example est equivalent à "debian".

**Domaine :**
```bash
man hostname
```

Avec cette commande, on trouve un manuel de hostname qui nous donne les instructions pour trouver le domaine. On s'interessera à utiliser la commande : 

```bash
domainname
(none)
```

Le résultat nous indique que le domaine n'a pas été configuré sur la machine.

**Vérification emplacement depots :**
```bash
cat /etc/apt/sources.list | grep -v -E ’^#|^$’
deb http://deb.debian.org/debian/ trixie main
deb http://security.debian.org/debian-security trixie-security main
deb http://deb.debian.org/debian trixie-updates main
```
La commande affiche les fichiers de depot qui sont actifs en formatant l'affichage. Le résultat dit que les dépôts utilisés principaux, de mise-à-jour et de sécurité sont les dépôts officiels Debian.

**Passwd/shadow :**
```bash
cat /etc/shadow | grep -vE ’:\*:|:!\*:’
root:$y$j9T$c0BtBRdaNsgE11tcWLSOG.$xpniyYZLsbRvMQgSZf2jX.iCtYP8RtCRz79Wgf0sh2:20482:0:99999:7:::dhcpcd:!:20482::::::
```

La commande affiche les comptes qui ont un mot de passe valide. Ici root a un mot de passe valide et dhcpcd n'a pas de mot de passe utilisable.

**Compte utilisateurs :**
```bash
cat /etc/passwd | grep -vE ’nologin|sync’
root:x:0:0:root:/root:/bin/bash
dhcpcd:x:100:65534:DHCP Client Daemon:/usr/lib/dhcpcd:/bin/false
```

La commande affiche les comptes qui ont un shell valide. On a root qui est le compte administrateur et dhcpcd qui est un compte système.

**Expliquer le retour des commandes :**
```bash
fdisk -l
Disk /dev/vda: 64 GiB, 68719476736 bytes, 134217728 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 03592FB5-B2DA-4C20-911D-4BBAE6768155

Device       Start        End    Sectors  Size Type
/dev/vda1    2048     9764863   9762816  4.7G Linux filesystem
/dev/vda2  9764864    17577983  7813120  3.7G Linux filesystem
/dev/vda3 17577984    19531775  1953792  954M Linux filesystem
/dev/vda4 19531776    19566591    34816   17M Linux filesystem
/dev/vda5 19566592    21567487  2000896  977M EFI System
/dev/vda6 21567488   126504959 104937472   50G Linux filesystem
/dev/vda7 126504960  134215679   7710720  3.7G Linux swap
```

Cette commande affiche des informations sur les disques comme les partitions. On voit que le disque virtuel a 64GB et la plus grande partition a 50GB.

```bash
fdisk -x
Disk /dev/vda: 64 GiB, 68719476736 bytes, 134217728 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 03592FB5-B2DA-4C20-911D-4BBAE6768155
First usable LBA: 34
Last usable LBA: 134217694
Alternative LBA: 134217727
Partition entries starting LBA: 2
Allocated partition entries: 128
Partition entries ending LBA: 33

Device       Start        End    Sectors Type-UUID                             UUID                                   Name        Attrs
/dev/vda1    2048     9764863   9762816 0FC63DAF-8483-4772-8E79-3D69D8477DE4 FB1C804E-C4A3-41BF-9C54-40BB4BBFE45C racine      LegacyBIOSBootable
/dev/vda2  9764864    17577983  7813120 0FC63DAF-8483-4772-8E79-3D69D8477DE4 1DDAE8C1-D47A-4675-BCBB-CB63EE137E0D espace tempo
/dev/vda3 17577984    19531775  1953792 0FC63DAF-8483-4772-8E79-3D69D8477DE4 F7619EF2-62C8-4F84-B389-CDDB2D69C771 les logs
/dev/vda4 19531776    19566591    34816 0FC63DAF-8483-4772-8E79-3D69D8477DE4 33CF71C3-7F9F-40E5-BF27-2A52F6C4DD15
/dev/vda5 19566592    21567487  2000896 C12A7328-F81F-11D2-BA4B-00A0C93EC93B 22D88202-FB16-4DD4-A3F4-F32E8921F103
/dev/vda6 21567488   126504959 104937472 0FC63DAF-8483-4772-8E79-3D69D8477DE4 17F8C16F-3635-4F7E-9D5F-6766C921CC50
/dev/vda7 126504960  134215679   7710720 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F 8F6C1691-EE2E-497E-8C85-DB22D6C702BD
```

Ça nous affiche les metadonnées du disque. Donc on voit que chaque secteur a 512 bytes.

```bash
df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.9G     0  1.9G   0% /dev
tmpfs           392M  828K  391M   1% /run
/dev/vda6        49G  1.1G   46G   3% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
efivarfs        256K   14K  243K   6% /sys/firmware/efi/efivars
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           2.0G     0  2.0G   0% /tmp
/dev/vda5       977M  9.4M  968M   1% /boot/efi
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs           1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyAMA0.service
tmpfs           392M  8.0K  392M   1% /run/user/0
```

Avec cette commande on a des informations de l'usage des partitions. Le retour nous dit que la partition principale dy système est /dev/vda6, avec 46 G et seulement 1.1G est en train d'être utilisé, c'est à dire que le disque est presque vide.

## Conclusion

Le TP s'est déroulé tranquillement avec des adaptations pour la réussite avec le hardware disponible. La machine Debian a été installée, ce qui nous met en disponibilité un système léger et fonctionnel.

## Sources
1. Debian Project. *Debian GNU/Linux installation guide*. [https://www.debian.org/releases/stable/amd64/index.fr.html](https://www.debian.org/releases/stable/amd64/index.fr.html) 
2. UTM. *Virtualize Linux on Apple Silicon*. [https://mac.getutm.app/](https://mac.getutm.app/)  
3. Fdisk. *Utilisation*. [https://doc.ubuntu-fr.org/fdisk](https://doc.ubuntu-fr.org/fdisk)  