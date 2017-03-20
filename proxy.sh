#!/bin/bash
# Script de test de proxies
# 
# v1.1 - EthelHub SL 
#
# Changelog
# 1.1 - Añadido formato proxychains
#

FILE_ORIGEN=proxy-list.txt
FILE_VALIDOS=proxy-ok.txt
FILE_PROXYCHAINS=proxy-chains.txt

INDICE=0
CORRECTOS=0
VERSION=1.1

# MAIN
echo "$0 - Proxy connection test tool v$VERSION"
echo "EthelHub - Cybersecurity && Research."
echo
echo "Reading file $FILE_ORIGEN..." 
echo "Starting Date : `date`"
sed '/^$/d' $FILE_ORIGEN > $FILE_ORIGEN.tmp
NUM_PROXY=`cat $FILE_ORIGEN.tmp | wc -l | tr -s ' ' | cut -d' ' -f 2`
echo "$NUM_PROXY to test."
echo

for sLine in $(< $FILE_ORIGEN.tmp); do
  export http_proxy="http://$sLine"
  echo "[$INDICE/$NUM_PROXY] Testing $sLine"
  wget --spider --timeout=5 --tries=1 http://www.example.com >> log.txt 2>&1
  if [ $? == 0 ] 
  then
    ((CORRECTOS+=1))
    echo "-OK! Adding $sLine to the database... $CORRECTOS"
    echo $sLine >> $FILE_VALIDOS
    # Formato proxychains
    IP=`echo $sLine | cut -d':' -f 1` 
    PUERTO=`echo $sLine | cut -d':' -f 2` 
    echo "http $IP $PUERTO" > $FILE_PROXYCHAINS
  fi
  ((INDICE+=1))
done
rm $FILE_ORIGEN.tmp



echo "Ending date : `date`"
echo "Process ended."
