#!/bin/bash
#creation du fichier log
echo "***** $(date) Jeedom Monitor *****" > /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log 2>&1
date
# supervision du service cron
sudo systemctl status cron.service | sed -n '3,3 p' >>/home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log 2>&1
sudo sed -i -e "s/Active:/cron:/g" /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
# supervision du service apache2
sudo systemctl status apache2.service | sed -n '5,5 p' >>/home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log 2>&1
sudo sed -i -e "s/Active:/apache:/g" /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
# supervision du service mysql
sudo systemctl status mysql.service | sed -n '5,5 p' >>/home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log 2>&1
sudo sed -i -e "s/Active:/mysql:/g" /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
# recherche de la chaine cron: active (running)
retval=$(grep "cron: active (running)" /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log)
if [ "$retval" = '' ]
then
	echo "service cron failed (jeedom-monitor.sh)" | /home/pi/Scripts/Telegram/tg.sh
	echo "*** $(date) service cron failed ***" >> /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
else
	echo "*** $(date) service cron active ***" >> /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
fi
# recherche de la chaine apache: active (running)
retval=$(grep "apache: active (running)" /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log)
if [ "$retval" = '' ]
then
        echo "service apache failed (jeedom-monitor.sh)" | /home/pi/Scripts/Telegram/tg.sh
        echo "*** $(date) service apache failed ***" >> /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
else
	echo "*** $(date) service apache active ***" >> /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
fi
# recherche de la chaine mysql: active (running)
retval=$(grep "mysql: active (running)" /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log)
if [ "$retval" = '' ]
then
        echo "service mysql failed (jeedom-monitor.sh)" | /home/pi/Scripts/Telegram/tg.sh
        echo "*** $(date) service mysql failed ***" >> /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
else
	echo "*** $(date) service mysql active ***" >> /home/pi/Scripts/Monitor/monitor-jeedom$(date +%Y%m%d).log
fi
# Purge les fichiers log trop vieux : 10 jours
sudo find /home/pi/Scripts/Monitor/monitor-jeedom* -ctime +10 -exec rm -fr "{}" \;

