#!/bin/bash

/opt/rh/php55/root/usr/bin/php /web/sites/o/operations.fnal.gov/htdocs/w/maintenance/showJobs.php
/opt/rh/php55/root/usr/bin/php /web/sites/o/operations.fnal.gov/htdocs/w/maintenance/runJobs.php --maxtime 30
