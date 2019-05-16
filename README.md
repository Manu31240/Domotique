# Domotique
3ème Installation Jeedom le 07/11/2018 sur Raspberry PI3 Model B+  
_Les raisons : bcp de problème de page corrompu sur la base de donnée - obligé de demarrer en recovery_  
_Le homebridge ne fonctionne qu'a partir du raspberry model 2_  
_La capacité de la SDCard est trop grosse pour permettre des temps de sauvegarde disque acceptable_  
_La roue cranté apparait à chaque clic sur jeedom : pb de perf_

## Installation de Raspbian
_image dispo : 2018-06-27-raspbian-stretch-lite_  
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
sudo passwd root même pwd que pi
sudo nano /etc/sudoers pour mettre pi en sudo
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
