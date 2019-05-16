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
