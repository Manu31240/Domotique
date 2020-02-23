#!/bin/bash
######
###
# Example: echo "Hello" | telegram.sh
#

message=$( cat )
apiToken=611351265:AAH9zSHDUNuqPVxj1xqpclvpiSZ0nSJ7II8
chatId=654468417

send() {
	curl -s \
	-X POST \
	https://api.telegram.org/bot$apiToken/sendMessage \
	-d text="$message" \
	-d chat_id=$chatId
	}

if [[ ! -z "$message" ]]; then
	send
fi

