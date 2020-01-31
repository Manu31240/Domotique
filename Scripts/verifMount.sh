#!/bin/bash
if [ -e /home/pi/liveboxShare/jesuisla ]
then
	# envoie de Message
	echo "successful Mount SMB for Cam (verifMount.sh)" | /home/pi/Scripts/Telegram/tg.sh
else
	# envoie de Message
	echo "Failed Mount SMS for Cam (verifMount.sh)" | /home/pi/Scripts/Telegram/tg.sh
	sudo mount -a
fi
