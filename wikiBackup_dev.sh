#!/bin/bash
dateTime=$(date +"%Y_%m_%d_%H%M")
mysqldump --single-transaction -u wiki_admin -h fnalmysqldev -padm4wiki opswiki_dev -P 3320 --skip-add-locks > /web/sites/o/operations.fnal.gov/beau_convert/backups/wikiBackupDEV$dateTime.sql
echo "Dev DB backup successful: $dateTime" >> /web/sites/o/operations.fnal.gov/beau_convert/dbBackup.log
