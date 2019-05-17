#!/bin/bash
######
###
# Example: echo "Hello" | telegram.sh
#

message=$( cat )
apiToken=XXXXXXXXXX
chatId=XXXXXXX

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
