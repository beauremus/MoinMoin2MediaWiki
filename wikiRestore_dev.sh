#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 {mysql-Database-Backup}"
	echo "Restores to development DB from selected backup"
else
	mysql -u wiki_admin -h fnalmysqldev -D opswiki_dev -P 3320 -padm4wiki < $1
fi