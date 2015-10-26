#!/bin/bash

TMP="bd.tmp"
ADDRLISTS="bd.addrs"
UA='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36'
BDUSS="" # use your own BDUSS in cookies 

cleanTmpFiles()
{
    rm $TMP $ADDRLISTS
}

if [ $# -ne 1 ]
then
    echo "Usage: $0 link"
    echo "eg. $0 http://music.baidu.com/song/116129754"
    exit
fi

songAddr=$1
sid=$(echo ${songAddr} | grep 'song/[0-9]*' -o)
songId=${sid:5}

cleanTmpFiles

wget "http://music.baidu.com/song/${songId}/download?__o=/song/${songId}" --header="User-Agent: ${UA}" --header="Cookie: BDUSS=${BDUSS}" -O ${TMP}
cat ${TMP} | awk -F'"' '/xcode=/{if($10 ~ /http/)print $10}' | sed -e 's@/data/music/file?link=@@g;s@&amp;@\&@g' > ${ADDRLISTS}

while read link
do
    echo $link
    outname=$(echo $link | grep "[0-9]*.mp3" -o)
    wget -c "$link" -O $outname
done<${ADDRLISTS}

cleanTmpFiles
