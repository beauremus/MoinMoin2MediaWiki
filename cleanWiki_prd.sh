#!/bin/bash

TABLES=$(mysql -u wiki_admin -h fnalmysqlprd -D opswiki_prd -P 3320 -padm4wiki -e 'show tables' | awk '{ print $1}' | grep -v '^Tables' )
 
for t in $TABLES
do
  echo "Deleting $t table from $MDB database..."
  mysql -u wiki_admin -h fnalmysqlprd -D opswiki_prd -P 3320 -padm4wiki -e "drop table $t"
done