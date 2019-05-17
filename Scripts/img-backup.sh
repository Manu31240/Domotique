#!/bin/bash
#Montage lecteur airport
echo "***** $(date) RasPi backup *****" > /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log 2>&1
date
sudo mount -t cifs //192.168.1.XXX/Data/PI_Backups /home/pi/airportShare -o credentials=/home/pi/.smbcred,auto,sec=ntlm,vers=1.0 >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log 2>&1
sudo mkdir /home/pi/airportShare/test
### Script Sauvegarde le carte SD
##arret des services
sudo systemctl stop cron.service
sudo systemctl stop apache2.service
sudo systemctl stop mysql.service
#Backup de la SD
sudo dd if=/dev/mmcblk0 of=/home/pi/airportShare/bck-SDrspi$(date +%Y%m%d).img bs=1M count=15194 iflag=fullblock 2> /home/pi/Scripts/Backup/erreurs.log 
#start des services
sudo systemctl start cron.service
sudo systemctl start apache2.service
sudo systemctl start mysql.service
# Purge les fichiers de sauvegarde trop vieux : 30 jours
sudo find /home/pi/airportShare/bck-SD* -ctime +30 -exec rm -fr "{}" \;
# Purge les fichiers de log trop vieux : 30 jours
sudo find /home/pi/Scripts/Backup/img-backup*.log -ctime +30 -exec rm -fr "{}" \;
# test que le script arrive à la fin
sudo rmdir /home/pi/airportShare/test
retval=$(grep copied /home/pi/Scripts/Backup/erreurs.log)
if [ "$retval" = '' ]
then
	 echo "backup failed" | /home/pi/Scripts/Telegram/tg.sh 
	 echo "*** $(date) backup failed ***" >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log
else
	echo "successful backup" | /home/pi/Scripts/Telegram/tg.sh
	echo $retval >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log
	echo "*** $(date) successful backup ***" >> /home/pi/Scripts/Backup/backup$(date +%Y%m%d).log
fi
#demontage du lecteur airport
sudo umount /home/pi/airportShare
