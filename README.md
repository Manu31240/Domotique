# Domotique
Voici un 'tuto' pour realiser un système domotique sur une base Jeedom.   
Après plusieurs tentatives sur Domoticz pas assez satisfaisantes à mon goût, je tente l'expérience sur Jeedom.   
Voici le détail de ma 3ème installation fait à partir de mes notes, de commandes utilisées lors de mes installations trouvées içi ou là sur le web et qui fonctionnent.   
Ces notes me permettent aussi de garder une trace de ce que j'ai pu faire, les longues soirées à comprendre pourquoi ça ne marche pas :-(, de servir de backup si je dois reconstruire un Raspberry.    
Car oui, le problème de la disponibilité pour un tel systeme est important. Imaginez un arrosage qui ne s'arrête plus, des volets qui ne s'ouvrent plus...          
Pour mon systeme je me suis fixé 2 regles:   
* Ne pas mettre des commandes critiques pour les biens et les personnes   
* Garder toujours les commandes 'nominales' des systèmes et mettre le systeme domotisé en doublon (possibilité de débrancher)     
   
J'ai fait le choix du Raspberry pour sa façilité de rééinstallation (avec mes sauvegardes, mes images de SD Card, je peux avoir un système opérationnel en 30min)      

Ce repo possède un wiki qui detaille les installations.     
les fichiers deposés sont utilisés lors des étapes.      

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



