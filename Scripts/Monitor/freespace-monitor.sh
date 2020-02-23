#!/bin/bash
#Creation du fichier log
echo "***** $(date) RasPi freespace *****" > /home/pi/Scripts/Monitor/monitor-freespace$(date +%Y%m%d).log 2>&1
date
#Commande pour la capacité utilisée en %
var=$(sudo df /home | awk '{ print $5 }' | tail -n 1)
declare -i retval=${var:0:2}
if [ "$retval" -gt "70" ]
then
	echo "disk full (freespace-monitor.sh)" | /home/pi/Scripts/Telegram/tg.sh
	echo "*** $(date) disk full ***" >> /home/pi/Scripts/Monitor/monitor-freespace$(date +%Y%m%d).log
else
	echo "*** $(date) space used "$retval"% ***" >> /home/pi/Scripts/Monitor/monitor-freespace$(date +%Y%m%d).log
fi
# Purge les fichiers log trop vieux : 05 jours
sudo find /home/pi/Scripts/Monitor/monitor-freespace* -ctime +5 -exec rm -fr "{}" \;
