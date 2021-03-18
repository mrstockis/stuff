
#!/bin/bash


sudo modprobe zram num_devices=4

totalmem=` free | grep Mem | awk '{print $2}' `
mem=$(( ($totalmem/8)*1024 ))

sudo echo $mem > /sys/block/zram0/disksize
sudo echo $mem > /sys/block/zram1/disksize
sudo echo $mem > /sys/block/zram2/disksize
sudo echo $mem > /sys/block/zram3/disksize


sudo mkswap /dev/zram0 #$(( $mem/1024 ))
sudo mkswap /dev/zram1 #$(( $mem/1024 ))
sudo mkswap /dev/zram2 #$(( $mem/1024 ))
sudo mkswap /dev/zram3 #$(( $mem/1024 ))


sudo swapon -p 5 /dev/zram0
sudo swapon -p 5 /dev/zram1
sudo swapon -p 5 /dev/zram2
sudo swapon -p 5 /dev/zram3

