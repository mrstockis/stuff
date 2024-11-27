#!/bin/bash

# cron entry:
# 	crontab -e
# 	0 12 * * * bash ~/CronJobs/ObsidianPush.sh

push_date=`date +%y_%m_%d`

git -C ~/NAS/gitVault add .
git -C ~/NAS/gitVault commit -m "daily sync $push_date"
git -C ~/NAS/gitVault push


