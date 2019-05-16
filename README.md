# Domotique
Voici un 'tuto' pour realiser un système domotique sur une base Jeedom.
Après plusieurs tentative sur Domoticz pas assez satisfaisante, je tente l'experience sur Jeedom.
Voici le détail de ma 3ème installation fait à base de note lorsque j'ai contruit la machine et surtout de commandes, de manips que j'ai pu trouver içi ou là sur le web et qui fonctionnent.
Ces notes me permettent aussi de garder une trace de tout ce que j'ai pu faire, les longues soirées a comprendre pourquoi ça ne marche pas :-(, de servir de backup si je dois reconstruire une machine.
Car oui, le problème de la disponibilité pour un tel systeme est important.
J'ai fait le choix du Raspberry pour sa facilité de reeinstallation (avec mes sauvegardes, je peux avoir un systeme opérationnel en 30min)
3 ème reinstall Jeedom le 07/11/2018 sur Raspberry PI3 Model B+  
_Les raisons : bcp de problème de page corrompu sur la base de donnée (sur RaspberryPi 1)- obligé de demarrer en recovery_  
_Le homebridge ne fonctionne qu'a partir du raspberry model 2_  
_La capacité de la SDCard(32Go) est trop grosse pour permettre des temps de sauvegarde disque acceptable (15Go maintenant)_  
_La roue cranté apparait à chaque clic sur jeedom : pb de perf_

[Installation de Raspbian](https://github.com/Manu31240/Domotique.git/installationRaspbian.mk)   



## Installation de Raspbian
_image dispo : 2018-06-27-raspbian-stretch-lite_  [source Raspbian](https://www.raspberrypi.org/downloads/raspbian/)   
Utiliser ApplePi Baker pour enregistrer l'image sur la SD card (prévoir une carte de 16Go)   
Fixer l'adresse sur la livebox : 192.168.1.XXX   
Ouvrir les ports 8083(jeedom), 80(accès interne), 443(accès externe)   
Créer un nom DNS : name      
```
ssh pi@name (Par défaut user=pi password=raspberry)
sudo raspi-config
```
_Change User Password: Modifier le mot de passe de Pi : XXXXX_   
_Internationalisation Options :Change Timezone : Europe\Paris -Change Locale : [*] en_US.UTF-8 UTF-8 / fr_FR.UTF-8_   
_Interface Options : Enable SSH_   
_Advanced Option : Expand Filesystem_   
_Update_   
_Finish_   
```
sudo apt-get update (=au moins 30min sur PI1)
sudo apt-get upgrade (= env 5min)
sudo passwd root (même pwd que pi)
sudo nano /etc/sudoers (pour mettre pi en sudo)
sudo nano /etc/dphys-swapfile changer la valeur CONF_SWAPSIZE=1024
sudo halt
mkdir airportShare
mkdir liveboxShare
mkdir /home/pi/Scripts
mkdir /home/pi/Scripts/Backup
```
## Installation de Jeedom
Jeedom : 1ere connexion - login: admin pwd: admin   
Jeedom : changer mot de passe - Profil\Admin\Sécurité\ XXXXXX   
Jeedom : associer  compte market - Configuration\Misesàjour\Market user: XXXXX pwd: XXXXX   
### Jeedom : sauvegarde serveur Samba   
Sauvegarde de la base de donnée jeedom sur serveur Samba : utiliser le DD de la Livebox   
Ajout d'un serveur Samba dans Configuration/mises à jour:     
[Backup]IP: 192.168.1.XXX   
[Backup] Utilisateur: XXXXX   
[Backup] Mot de passe: XXXXX   
[Backup] Partage: //192.168.1.XXX/XXXXX   
[Backup] Chemin: /JeedomBkp   
Pour se connecter sur un partage Samba:   
`smbclient \\\\192.168.1.1\\[sharename] -U [username]`   
Jeedom : sauvegarde locale - Sauvegardes\nombre de sauvegarde 7 taile max : 5000   

## Installation de Let's Encrypt
necessaire pour avoir un accès externe sécurisé avec certificat
```
sudo systemctl stop cron.service
sudo systemctl stop apache2.service
sudo systemctl stop mysql.service
sudo a2enmod ssl
````
modop :   
https://backports.debian.org/Instructions/     
https://certbot.eff.org/lets-encrypt/debianstretch-apache   
```
sudo apt-get install python-certbot-apache -t stretch-backports
sudo certbot --apache
Enter email address (used for urgent renewal and security notices) (Enter 'c' to cancel): 
(A)gree/(C)ancel: A
(Y)es/(N)o: N
No names were found in your configuration files. Please enter in your domain
name(s) (comma and/or space separated)  (Enter 'c' to cancel): xxxxx.ddns.net

sudo systemctl start cron.service
sudo systemctl start apache2.service
sudo systemctl start mysql.service
```
Jeedom : activer HTTPS - Configuration\Réseaux\activer Https :xxxxx.ddns.net Port:443   

Pour vérifier son certificat :https://www.ssllabs.com/ssltest/analyze.html?d=xxxxx.ddns.net   



