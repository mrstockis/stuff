#!/bin/bash

# cron entry:
#       crontab -e
#       0 12 * * * bash ~/CronJobs/ObsidianPush.sh

#push_date=`date +%y_%m_%d`
push_date=`date +%d_%m_%y`

# Log last run
echo "$push_date" > ~/CronJobs/LogObsidianPush
cp ~/CronJobs/LogObsidianPush ~/NAS/gitVault/

git -C ~/NAS/gitVault add .
git -C ~/NAS/gitVault commit -m "daily sync $push_date"
git -C ~/NAS/gitVault push
