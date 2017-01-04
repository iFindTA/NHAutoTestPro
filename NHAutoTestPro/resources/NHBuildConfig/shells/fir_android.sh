#!/bin/bash
APP_ID='5858c369959d69348e0043e6'
API_TOKEN='9dfc5a5d8f044017027a35fddb2f0962'
#todo: brew install jq --verbose
DOWN_TOKEN=$(curl http://api.fir.im/apps/${APP_ID}/download_token?api_token=${API_TOKEN} -s | jq '.download_token' | sed 's/\"//g')
DOWN_URL="http://download.fir.im/apps/${APP_ID}/install?download_token=${DOWN_TOKEN}"
echo "android download url is:$DOWN_URL"