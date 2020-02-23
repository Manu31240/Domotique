#!/bin/bash
#Creation du fichier log
echo "***** $(date) RasPi ping monitor *****" > /home/pi/Scripts/Monitor/monitor-ping$(date +%Y%m%d).log 2>&1
date
#Commande ping pour keealive LAN
sudo ping 192.168.1.1 -c 1 > /home/pi/Scripts/Monitor/ping.log
# recherche de la chaine errors
retval=$(grep "errors" /home/pi/Scripts/Monitor/ping.log)
if [ "$retval" != '' ]
then
	echo "ping gateway failed (ping-monitor.sh)" | /home/pi/Scripts/Telegram/tg.sh
	echo "*** $(date) ping gateway failed ***" >> /home/pi/Scripts/Monitor/monitor-ping$(date +%Y%m%d).log
else
	echo "*** $(date) ping gateway successfull ***" >> /home/pi/Scripts/Monitor/monitor-ping$(date +%Y%m%d).log
fi
#Commande ping pour keealive WAN
sudo ping manu31.ddns.net -c 1 > /home/pi/Scripts/Monitor/ping.log
# recherche de la chaine errors
retval=$(grep "errors" /home/pi/Scripts/Monitor/ping.log)
if [ "$retval" != '' ]
then
        echo "ping ddns failed (ping-monitor.sh)" | /home/pi/Scripts/Telegram/tg.sh
        echo "*** $(date) ping ddns failed ***" >> /home/pi/Scripts/Monitor/monitor-ping$(date +%Y%m%d).log
else
	echo "*** $(date) ping ddns successfull ***" >> /home/pi/Scripts/Monitor/monitor-ping$(date +%Y%m%d).log
fi
# Purge les fichiers log trop vieux : 05 jours
sudo find /home/pi/Scripts/Monitor/monitor-ping* -ctime +5 -exec rm -fr "{}" \;
# Suppression du fichier de travail
sudo rm ping.log

