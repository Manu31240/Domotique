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
