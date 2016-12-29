#!/bin/bash
APP_ID='5858c369959d69348e0043e6'
API_TOKEN='9dfc5a5d8f044017027a35fddb2f0962'
DOWN_TOKEN=$(curl http://api.fir.im/apps/${APP_ID}/download_token?api_token=${API_TOKEN} -s | jq '.download_token' | sed 's/\"//g')
DOWN_URL="https://download.fir.im/v2/app/install/${APP_ID}?download_token=${DOWN_TOKEN}"
DOWN_URL="itms-services://?action=download-manifest&url=$DOWN_URL"
#上述url在iOS应用中打开时记得进行URL Encode,否则打开无效果
echo "finally url:$DOWN_URL"