#!/bin/bash
# Script de test de proxies
# 
# v1.0 - EthelHub SL 


FILE=proxy-list.txt
INDICE=0
CORRECTOS=0
VERSION=1.0

# MAIN
echo "$0 - Proxy connection test tool v$VERSION"
echo "EthelHub - Cybersecurity && Research."
echo
echo "Reading file $FILE..." 
echo "Starting Date : `date`"
sed '/^$/d' $FILE > $FILE.tmp
NUM_PROXY=`cat $FILE.tmp | wc -l | tr -s ' ' | cut -d' ' -f 2`
echo "$NUM_PROXY to test."
echo

for sLine in $(< $FILE.tmp); do
  export http_proxy="http://$sLine"
  echo "[$INDICE/$NUM_PROXY] Testing $sLine"
  wget --spider --timeout=5 --tries=1 http://www.example.com >> log.txt 2>&1
  if [ $? == 0 ] 
  then
    ((CORRECTOS+=1))
    echo "-OK! Adding $sLine to the database... $CORRECTOS"
    echo $sLine >> validos.txt
  fi
  ((INDICE+=1))
done
rm $FILE.tmp

echo "Ending date : `date`"
echo "Process ended."
