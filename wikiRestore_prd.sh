#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 {mysql-Database-Backup}"
	echo "Restores to production DB from selected backup"
else
	mysql -u wiki_admin -h fnalmysqlprd -D opswiki_prd -P 3320 -padm4wiki < $1
fi