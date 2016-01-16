#!/system/xbin/busybox sh

# Created By Dorimanx and Dairinin
# Modified by UpInTheAir for SkyHigh kernel & Synapse

BB=/system/xbin/busybox;

ROOTFS_MOUNT=$(mount | grep rootfs | cut -c26-27 | grep -c rw)
if [ "$ROOTFS_MOUNT" -eq "0" ]; then
	$BB mount -o remount,rw /;
fi;

if [ ! -e /data/crontab/ ]; then
	$BB mkdir /data/crontab/;
fi;

$BB cp -a /res/crontab_service/cron-root /data/crontab/root;
chown 0:0 /data/crontab/root;
chmod 777 /data/crontab/root;
if [ ! -d /var/spool/cron/crontabs ]; then
	mkdir -p /var/spool/cron/crontabs/;
fi;
$BB cp -a /data/crontab/root /var/spool/cron/crontabs/;

chown 0:0 /var/spool/cron/crontabs/*;
chmod 777 /var/spool/cron/crontabs/*;

# set timezone
TZ=UTC

# set cron timezone
export TZ

#Set Permissions to scripts
chown 0:0 /data/crontab/cron-scripts/*;
chmod 777 /data/crontab/cron-scripts/*;

# use /var/spool/cron/crontabs/ call the crontab file "root"
if [ "$(pidof crond | wc -l)" -eq "0" ]; then
	$BB nohup /system/xbin/crond -c /var/spool/cron/crontabs/ > /data/.hackerkernel/cron.txt &
	sleep 1;
	PIDOFCRON=$(pidof crond);
	echo "-900" > /proc/"$PIDOFCRON"/oom_score_adj;
fi;

$BB mount -t rootfs -o remount,ro rootfs;
