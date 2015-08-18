#!/bin/bash
# This is a fork of http://kaneda.bohater.net/files/asterisk_csv2mysql_converter.sh
# updated for my csv file structure and DB
# This script will insert data from asterisk cdr Master.csv file to mysql database

source "$( dirname "${BASH_SOURCE[0]}" )/db.config"

if [ -z "$1" ] ; then
  echo "Error: Choose csv file"
  echo "Example: $0 ./Master.csv"
  exit
fi

export IFS='
'

for linia in `cat $1|sed s/'",,"'/'","","'/g` ; do

  src=`echo $linia|awk -F ',' '{print $2}'| sed s/'"'//g`
  clid=`echo $linia|awk -F ',' '{print $5}'| sed s/'"'//g`
  dst=`echo $linia|awk -F ',' '{print $3}'| sed s/'"'//g|awk '{print $1}'`
  dcontext=`echo $linia|awk -F ',"' '{print $4}'| sed s/'"'//g`
  channel=`echo $linia|awk -F ',"' '{print $6}'| sed s/'"'//g`
  dstchannel=`echo $linia|awk -F ',"' '{print $7}'| sed s/'"'//g`
  lastapp=`echo $linia|awk -F ',"' '{print $8}'| sed s/'"'//g`
  lastdata=`echo $linia|awk -F ',"' '{print $9}'| sed s/'"'//g`
  start=`echo $linia|awk -F ',"' '{print $10}'| sed s/'"'//g`
  answer=`echo $linia|awk -F ',"' '{print $11}'| sed s/'"'//g`
  end=`echo $linia|awk -F "," '{print $(NF-6)}'| sed s/'"'//g`
  duration=`echo $linia|awk -F "," '{print $(NF-5)}'`
  billsec=`echo $linia|awk -F "," '{print $(NF-4)}'| sed s/'"'//g`
  disposition=`echo $linia|awk -F "," '{print $(NF-3)}'| sed s/'"'//g`
  #DOCUMENTATION == 3
  amaflags=3
  accountcode=`echo $linia|awk -F "," '{print $1}'| sed s/'"'//g`
  userfield=""
  phone=""

  #echo "insert into $DB_TABLE values ('$start','$clid','$src','$dst','$dcontext','$channel','$dstchannel','$lastapp','$lastdata','$duration','$billsec','$disposition','$amaflags','$accountcode','$userfield');"
  
  echo "insert into $DB_TABLE values ('$start','$clid','$src','$dst','$dcontext','$channel','$dstchannel','$lastapp','$lastdata','$duration','$billsec','$disposition','$amaflags','$accountcode','$userfield','$phone');" | mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD  -D $DB_NAME
  
done