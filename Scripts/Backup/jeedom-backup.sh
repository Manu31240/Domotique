#!/bin/bash
# Montage lecteur airport
echo "***** $(date) RasPi backup *****" > /home/pi/Scripts/Backup/backup-Jeedom$(date +%Y%m%d).log 2>&1
date
sudo mount -t cifs //192.168.1.11/Data/Jeedom /home/pi/airportShare -o credentials=/home/pi/.smbcred,auto,sec=ntlm,vers=1.0 >> /home/pi/Scripts/Backup/backup-Jeedom$(date +%Y%m%d).log 2>&1
sudo mkdir /home/pi/airportShare/test
# Script copie des sauvegardes /var/www/html/backup
sudo cp /var/www/html/backup/* /home/pi/airportShare/ 2> /home/pi/Scripts/Backup/erreursJeedom.log
## purge les fichiers de sauvegarde trop vieux : 10 jours
sudo find /home/pi/airportShare/backup-Jeedom* -ctime +10 -exec rm -fr "{}" \;
## purge les fichiers de log trop vieux : 10 jours
sudo find /home/pi/Scripts/Backup/backup-Jeedom*.log -ctime +10 -exec rm -fr "{}" \;
## test que le script arrive à la fin
sudo rmdir /home/pi/airportShare/test
retval=$(grep copied /home/pi/Scripts/Backup/erreursJeedom.log)
if [ "$retval" = '' ]
then
	echo "successful copy jeedom.tar.gz (jeedom-backup.sh)" | /home/pi/Scripts/Telegram/tg.sh
        echo "*** $(date) successful copy jeedom.tar.gz ***" >> /home/pi/Scripts/Backup/backup-Jeedom$(date +%Y%m%d).log
else
	echo "copy failed jeedom.tar.gz (jeedom-backup.sh)" | /home/pi/Scripts/Telegram/tg.sh
	echo $retval >> /home/pi/Scripts/Backup/backup-Jeedom$(date +%Y%m%d).log
        echo "*** $(date) copy failed jeedom.tar.gz ***" >> /home/pi/Scripts/Backup/backup-Jeedom$(date +%Y%m%d).log
fi
# Demontage du lecteur airport
sudo umount /home/pi/airportShare
# Suppression fichier de travail
sudo rm /home/pi/Scripts/Backup/erreursJeedom.log

