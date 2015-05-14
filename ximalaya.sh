#!/bin/bash

JSON_PREFIX="http://www.ximalaya.com/tracks"
BASE="http://fdfs.xmcdn.com"
SIGN="play_path_64"

if [ $# -ne 1 ]
then
	echo "$0 link"
	echo "eg. $0 http://www.ximalaya.com/tracks/6795804"
	exit
fi

PAGE_URL=$1
TMP_JSON=$(mktemp)
TRACK_NUM=${PAGE_URL##*/}
wget -c ${JSON_PREFIX}/${TRACK_NUM}".json" -O $TMP_JSON
SUFFIX=$(awk -F',' '{print $2}' $TMP_JSON | grep $SIGN | awk -F':' '{print $2}' | tr -d '"')

OUT_FILE=${TRACK_NUM}".mp3"
DL_LINK=${BASE}/${SUFFIX}
echo $DL_LINK

wget -c $DL_LINK -O $OUT_FILE

rm $TMP_JSON
