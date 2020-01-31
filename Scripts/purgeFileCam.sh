#!/usr/bin/env bash
#creation fichier log
# echo "***** $(date) RasPi Purge File Cam  *****" > /home/pi/Scripts/PurgeCam/purge$(date +%Y%m%d).$
#date
# Purge les fichiers de Cam trop vieux : 30 jours
sudo find /home/pi/liveboxShare/Reolink/* -ctime +30 -exec rm -fr "{}" \;
# envoie de SMS
echo "successful purge File Cam (purgeFileCam.sh)" | /home/pi/Scripts/Telegram/tg.sh