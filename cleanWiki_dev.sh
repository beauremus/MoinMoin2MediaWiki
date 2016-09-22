#!/bin/bash

TABLES=$(mysql -u wiki_admin -h fnalmysqldev -D opswiki_dev -P 3320 -padm4wiki -e 'show tables' | awk '{ print $1}' | grep -v '^Tables' )
 
for t in $TABLES
do
  echo "Deleting $t table from $MDB database..."
  mysql -u wiki_admin -h fnalmysqldev -D opswiki_dev -P 3320 -padm4wiki -e "drop table $t"
done


##Database query for list of Mediawiki pages
#mysql -u wiki_admin -h fnalmysqldev -D opswiki_dev -P 3320 -p adm4wiki -e "SELECT page_namespace, page_title FROM page FIELDS TERMINATED BY ':' LINES TERMINATED BY '\n'"


