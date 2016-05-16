#!/bin/bash

#LastVer=`curl -s https://github.com/easysoft/zentaopms/releases | grep zentaopms | grep tar.gz | head -n 1 | awk -F '"' '{print $2}'| awk -F '/' '{print $NF}'`
# curl  -sSL https://api.github.com/repos/easysoft/zentaopms/git/refs/tags | jq  -r  '.[].ref'| tail -n 1
LAST_RELEASE_URL=`curl -s http://www.zentao.net/download/79925.html | grep "zip\"" | awk -F '"' '{print $2}'`
LAST_RELEASE_FILENAME=`echo $LAST_RELEASE_URL | awk -F '/' '{print $NF}' | sed 's/.zip//'`
