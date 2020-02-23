#!/bin/bash
#Montage lecteur airport
echo "***** $(date) RasPi backup *****" > /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log 2>&1
date
sudo mount -t cifs //192.168.1.11/Data/PI_Backups /home/pi/airportShare -o credentials=/home/pi/.smbcred,auto,sec=ntlm,vers=1.0 >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log 2>&1
sudo mkdir /home/pi/airportShare/test
### Script Sauvegarde du SSD
##arret des services
sudo systemctl stop cron.service
sudo systemctl stop apache2.service
sudo systemctl stop mysql.service
#Backup du SSD
sudo dd if=/dev/sda1 of=/home/pi/airportShare/bck-SSDrspi$(date +%Y%m%d).img bs=1M count=15194 iflag=fullblock 2> /home/pi/Scripts/Backup/erreurs.log
#start des services
sudo systemctl start cron.service
sudo systemctl start apache2.service
sudo systemctl start mysql.service
# Purge les fichiers de sauvegarde trop vieux : 30 jours
sudo find /home/pi/airportShare/bck-SSD* -ctime +30 -exec rm -fr "{}" \;
# Purge les fichiers de log trop vieux : 30 jours
sudo find /home/pi/Scripts/Backup/img-backup*.log -ctime +30 -exec rm -fr "{}" \;
# test que le script arrive à la fin
sudo rmdir /home/pi/airportShare/test
# envoie de SMS
retval=$(grep copied /home/pi/Scripts/Backup/erreurs.log)
if [ "$retval" = '' ]
then
	echo "backup.img failed (img-backup.sh)" | /home/pi/Scripts/Telegram/tg.sh
	echo "*** $(date) backup.img failed ***" >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log
else
	echo "successful backup.img (img-backup.sh)" | /home/pi/Scripts/Telegram/tg.sh
	echo $retval >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log
	echo "*** $(date) successful backup.img ***" >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).l$
fi
# Demontage du lecteur airport
sudo umount /home/pi/airportShare
# Supression du fichier de travail
sudo rm /home/pi/Scripts/Backup/erreurs.log

