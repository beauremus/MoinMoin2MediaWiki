#!/bin/bash
dateTime=$(date +"%Y_%m_%d_%H%M")
mysqldump --single-transaction -u wiki_admin -h fnalmysqlprd -padm4wiki opswiki_prd -P 3320 --skip-add-locks > /web/sites/o/operations.fnal.gov/wikiBackups/wikiBackupPRD$dateTime.sql
echo "Prd DB backup successful: $dateTime" >> /web/sites/o/operations.fnal.gov/wikiBackups/dbBackup.log
