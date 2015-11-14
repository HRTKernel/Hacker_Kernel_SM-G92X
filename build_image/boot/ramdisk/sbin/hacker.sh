#!/system/bin/sh
# thanks to mythos234 for the script

# VARS

BB=/system/xbin/busybox
PROP=/system/kernel.prop
GOVLITTLE=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
GOVBIG=/sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
FREQMINLITTLE1=/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
FREQMINLITTLE2=/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
FREQMINLITTLE3=/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
FREQMINLITTLE4=/sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
FREQMAXLITTLE1=/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
FREQMAXLITTLE2=/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
FREQMAXLITTLE3=/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
FREQMAXLITTLE4=/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
FREQMINBIG1=/sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
FREQMINBIG2=/sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
FREQMINBIG3=/sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
FREQMINBIG4=/sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
FREQMAXBIG1=/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
FREQMAXBIG2=/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
FREQMAXBIG3=/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
FREQMAXBIG4=/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
LOGS=/data/media/0/hackerkernel/Logs;
VALUES=/data/media/0/hackerkernel/values;

mount -o remount,rw /system
mount -o remount,rw /data

sync

/system/xbin/daemonsu --auto-daemon &

# Make internal storage directory.
if [ ! -d /data/.hackerkernel ]; then
	mkdir /data/.hackerkernel
fi;

# Synapse
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/synapse
busybox ln -fs /res/synapse/uci /sbin/uci
/sbin/uci
busybox mount -t rootfs -o remount,ro rootfs

# kernel custom test

if [ -e /data/hackertest.log ]; then
rm /data/hackertest.log
fi

#Set default values on boot
echo "temporary none" > /sys/class/scsi_disk/0:0:0:1/cache_type
echo "temporary none" > /sys/class/scsi_disk/0:0:0:2/cache_type
echo "Set deepsleep values on boot successful." >> /data/hackertest.log

echo  Kernel script is working !!! >> /data/hackertest.log
echo "excecuted on $(date +"%d-%m-%Y %r" )" >> /data/hackertest.log
echo  Done ! >> /data/hackertest.log


#Synapse profile
if [ ! -f /data/.hackerkernel/bck_prof ]; then
	cp -f /res/synapse/files/bck_prof /data/.hackerkernel/bck_prof
fi

chmod 777 /data/.hackerkernel/bck_prof

sleep 20;

echo "0x0FF3 0x041E 0x0034 0x1FC8 0xF035 0x040D 0x00D2 0x1F6B 0xF084 0x0409 0x020B 0x1EB8 0xF104 0x0409 0x0406 0x0E08 0x0782 0x2ED8" > /sys/class/misc/arizona_control/eq_A_freqs
echo "0x0C47 0x03F5 0x0EE4 0x1D04 0xF1F7 0x040B 0x07C8 0x187D 0xF3B9 0x040A 0x0EBE 0x0C9E 0xF6C3 0x040A 0x1AC7 0xFBB6 0x0400 0x2ED8" > /sys/class/misc/arizona_control/eq_B_freqs

echo "Set default sound values on boot successful." >> /data/hackertest.log

#Setup Mhz Min/Max Cluster 0
echo 1500000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
echo 1500000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
echo 1500000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
echo 1500000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;

#Setup Mhz Min/Max Cluster 1
echo 2100000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq;
echo 2100000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq;
echo 2100000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq;
echo 2100000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq;

echo "Set default Min/Max Clusters values on boot successful." >> /data/hackertest.log

if [ ! -d $LOGS ]; then
	$BB mkdir /data/media/0/hackerkernel/Logs
fi;

$BB chmod -R 0777 $LOGS

if [ ! -d $VALUES ]; then
	$BB mkdir /data/media/0/hackerkernel/values
fi;
$BB chmod -R 0777 $VALUES

echo "Interactive" > /data/media/0/hackerkernel/values/gpu_gov

$BB chmod -R 0777 /data/media/0/hackerkernel/values/gpu_gov

echo "Set default folder successful." >> /data/hackertest.log

$BB chown -R system:system /data/anr
$BB chown -R root:root /tmp
$BB chown -R root:root /res
$BB chown -R root:root /sbin
$BB chown -R root:root /lib
$BB chmod -R 777 /tmp/
$BB chmod -R 775 /res/
$BB chmod -R 0777 /data/anr/
$BB chmod -R 0400 /data/tombstones
$BB chown -R root:root /data/property
$BB chmod -R 0700 /data/property
$BB chmod 06755 /sbin/busybox
echo "- Critical Permissions fixed successful." >> /data/hackertest.log

# Parse init/d support from prop. If AUTO mode check to see if support has been added to the rom
if [ "`grep "kernel.initd=true" $PROP`" != "" ]; then
	if [ "`grep "init.d" /system/etc/init.sec.boot.sh`" = "" ]; then
		mount -t rootfs -o remount,rw rootfs
	fi
fi

# Parse Mode Enforcement from prop
if [ "`grep "kernel.turbo=true" $PROP`" != "" ]; then
	echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enforced_mode
	echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enforced_mode
fi

if [ "`grep "kernel.turbo=false" $PROP`" != "" ]; then
	echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enforced_mode
	echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enforced_mode
fi

# Wait for 5 second so we pass out of init before starting the rest of the script
sleep 5

# Parse IO Scheduler from prop
if [ "`grep "kernel.scheduler=noop" $PROP`" != "" ]; then
	echo "noop" > /sys/block/mmcblk0/queue/scheduler
    	echo "noop" > /sys/block/sda/queue/scheduler
    	echo "noop" > /sys/block/sdb/queue/scheduler
    	echo "noop" > /sys/block/sdc/queue/scheduler
    	echo "noop" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=sioplus" $PROP`" != "" ]; then
	echo "sioplus" > /sys/block/mmcblk0/queue/scheduler
    	echo "sioplus" > /sys/block/sda/queue/scheduler
    	echo "sioplus" > /sys/block/sdb/queue/scheduler
    	echo "sioplus" > /sys/block/sdc/queue/scheduler
    	echo "sioplus" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=bfq" $PROP`" != "" ]; then
	echo "bfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "bfq" > /sys/block/sda/queue/scheduler
    	echo "bfq" > /sys/block/sdb/queue/scheduler
    	echo "bfq" > /sys/block/sdc/queue/scheduler
    	echo "bfq" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=tripndroid" $PROP`" != "" ]; then
	echo "tripndroid" > /sys/block/mmcblk0/queue/scheduler
    	echo "tripndroid" > /sys/block/sda/queue/scheduler
    	echo "tripndroid" > /sys/block/sdb/queue/scheduler
    	echo "tripndroid" > /sys/block/sdc/queue/scheduler
    	echo "tripndroid" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=cfg" $PROP`" != "" ]; then
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "cfq" > /sys/block/sda/queue/scheduler
    	echo "cfq" > /sys/block/sdb/queue/scheduler
    	echo "cfq" > /sys/block/sdc/queue/scheduler
    	echo "cfq" > /sys/block/vnswap0/queue/scheduler
else
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "cfq" > /sys/block/sda/queue/scheduler
    	echo "cfq" > /sys/block/sdb/queue/scheduler
    	echo "cfq" > /sys/block/sdc/queue/scheduler
    	echo "cfq" > /sys/block/vnswap0/queue/scheduler
fi

# Parse Governor from prop
if [ "`grep "kernel.governor=alucard" $PROP`" != "" ]; then
	echo "alucard" > $GOVLITTLE
	echo "alucard" > $GOVBIG
elif [ "`grep "kernel.governor=bioshock" $PROP`" != "" ]; then
	echo "bioshock" > $GOVLITTLE
	echo "bioshock" > $GOVBIG
elif [ "`grep "kernel.governor=conservative" $PROP`" != "" ]; then
	echo "conservative" > $GOVLITTLE
	echo "conservative" > $GOVBIG
elif [ "`grep "kernel.governor=conservativex" $PROP`" != "" ]; then
	echo "conservativex" > $GOVLITTLE
	echo "conservativex" > $GOVBIG
elif [ "`grep "kernel.governor=dancedance" $PROP`" != "" ]; then
	echo "dancedance" > $GOVLITTLE
	echo "dancedance" > $GOVBIG
elif [ "`grep "kernel.governor=darkness" $PROP`" != "" ]; then
	echo "darkness" > $GOVLITTLE
	echo "darkness" > $GOVBIG
elif [ "`grep "kernel.governor=hyper" $PROP`" != "" ]; then
	echo "hyper" > $GOVLITTLE
	echo "hyper" > $GOVBIG
elif [ "`grep "kernel.governor=interactive" $PROP`" != "" ]; then
	echo "interactive" > $GOVLITTLE
	echo "interactive" > $GOVBIG
elif [ "`grep "kernel.governor=lionheart" $PROP`" != "" ]; then
	echo "Lionheart" > $GOVLITTLE
	echo "Lionheart" > $GOVBIG
elif [ "`grep "kernel.governor=nightmare" $PROP`" != "" ]; then
	echo "nightmare" > $GOVLITTLE
	echo "nightmare" > $GOVBIG
elif [ "`grep "kernel.governor=ondemand" $PROP`" != "" ]; then
	echo "ondemand" > $GOVLITTLE
	echo "ondemand" > $GOVBIG
elif [ "`grep "kernel.governor=ondemandplus" $PROP`" != "" ]; then
	echo "ondemandplus" > $GOVLITTLE
	echo "ondemandplus" > $GOVBIG
elif [ "`grep "kernel.governor=performance" $PROP`" != "" ]; then
	echo "performance" > $GOVLITTLE
	echo "performance" > $GOVBIG
elif [ "`grep "kernel.governor=preservative" $PROP`" != "" ]; then
	echo "preservative" > $GOVLITTLE
	echo "preservative" > $GOVBIG
elif [ "`grep "kernel.governor=smartass2" $PROP`" != "" ]; then
	echo "smartassV2" > $GOVLITTLE
	echo "smartassV2" > $GOVBIG
elif [ "`grep "kernel.governor=userspace" $PROP`" != "" ]; then
	echo "userspace" > $GOVLITTLE
	echo "userspace" > $GOVBIG
elif [ "`grep "kernel.governor=wheatley" $PROP`" != "" ]; then
	echo "wheatley" > $GOVLITTLE
	echo "wheatley" > $GOVBIG
else 
	echo "interactive" > $GOVLITTLE
	echo "interactive" > $GOVBIG
fi

sleep 1;

# Parse CPU CLOCK from prop
if [ "`grep "kernel.cpu.a53.min=200000" $PROP`" != "" ]; then
	echo "200000" > $FREQMINLITTLE1
	echo "200000" > $FREQMINLITTLE2
	echo "200000" > $FREQMINLITTLE3
	echo "200000" > $FREQMINLITTLE4
elif [ "`grep "kernel.cpu.a53.min=300000" $PROP`" != "" ]; then
	echo "300000" > $FREQMINLITTLE1
	echo "300000" > $FREQMINLITTLE2
	echo "300000" > $FREQMINLITTLE3
	echo "300000" > $FREQMINLITTLE4
elif [ "`grep "kernel.cpu.a53.min=400000" $PROP`" != "" ]; then
	echo "400000" > $FREQMINLITTLE1
	echo "400000" > $FREQMINLITTLE2
	echo "400000" > $FREQMINLITTLE3
	echo "400000" > $FREQMINLITTLE4
else
	echo "400000" > $FREQMINLITTLE1
	echo "400000" > $FREQMINLITTLE2
	echo "400000" > $FREQMINLITTLE3
	echo "400000" > $FREQMINLITTLE4
fi

sleep 1;

if [ "`grep "kernel.cpu.a53.max=1200000" $PROP`" != "" ]; then
	echo "1200000" > $FREQMAXLITTLE1
	echo "1200000" > $FREQMAXLITTLE2
	echo "1200000" > $FREQMAXLITTLE3
	echo "1200000" > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1296000" $PROP`" != "" ]; then
	echo "1296000" > $FREQMAXLITTLE1
	echo "1296000" > $FREQMAXLITTLE2
	echo "1296000" > $FREQMAXLITTLE3
	echo "1296000" > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1400000" $PROP`" != "" ]; then
	echo "1400000" > $FREQMAXLITTLE1
	echo "1400000" > $FREQMAXLITTLE2
	echo "1400000" > $FREQMAXLITTLE3
	echo "1400000" > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1500000" $PROP`" != "" ]; then
	echo "1500000" > $FREQMAXLITTLE1
	echo "1500000" > $FREQMAXLITTLE2
	echo "1500000" > $FREQMAXLITTLE3
	echo "1500000" > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1600000" $PROP`" != "" ]; then
	echo "1600000" > $FREQMAXLITTLE1
	echo "1600000" > $FREQMAXLITTLE2
	echo "1600000" > $FREQMAXLITTLE3
	echo "1600000" > $FREQMAXLITTLE4
else
	echo "1500000" > $FREQMAXLITTLE1
	echo "1500000" > $FREQMAXLITTLE2
	echo "1500000" > $FREQMAXLITTLE3
	echo "1500000" > $FREQMAXLITTLE4
fi

sleep 1;

if [ "`grep "kernel.cpu.a57.min=200000" $PROP`" != "" ]; then
	echo "200000" > $FREQMINBIG1
	echo "200000" > $FREQMINBIG2
	echo "200000" > $FREQMINBIG3
	echo "200000" > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=300000" $PROP`" != "" ]; then
	echo "300000" > $FREQMINBIG1
	echo "300000" > $FREQMINBIG2
	echo "300000" > $FREQMINBIG3
	echo "300000" > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=400000" $PROP`" != "" ]; then
	echo "400000" > $FREQMINBIG1
	echo "400000" > $FREQMINBIG2
	echo "400000" > $FREQMINBIG3
	echo "400000" > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=500000" $PROP`" != "" ]; then
	echo "500000" > $FREQMINBIG1
	echo "500000" > $FREQMINBIG2
	echo "500000" > $FREQMINBIG3
	echo "500000" > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=600000" $PROP`" != "" ]; then
	echo "600000" > $FREQMINBIG1
	echo "600000" > $FREQMINBIG2
	echo "600000" > $FREQMINBIG3
	echo "600000" > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=700000" $PROP`" != "" ]; then
	echo "700000" > $FREQMINBIG1
	echo "700000" > $FREQMINBIG2
	echo "700000" > $FREQMINBIG3
	echo "700000" > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=800000" $PROP`" != "" ]; then
	echo "800000" > $FREQMINBIG1
	echo "800000" > $FREQMINBIG2
	echo "800000" > $FREQMINBIG3
	echo "800000" > $FREQMINBIG4
else
	echo "800000" > $FREQMINBIG1
	echo "800000" > $FREQMINBIG2
	echo "800000" > $FREQMINBIG3
	echo "800000" > $FREQMINBIG4
fi

sleep 1;

if [ "`grep "kernel.cpu.a57.max=1704000" $PROP`" != "" ]; then
	echo "1704000" > $FREQMAXBIG1
	echo "1704000" > $FREQMAXBIG2
	echo "1704000" > $FREQMAXBIG3
	echo "1704000" > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=1800000" $PROP`" != "" ]; then
	echo "1800000" > $FREQMAXBIG1
	echo "1800000" > $FREQMAXBIG2
	echo "1800000" > $FREQMAXBIG3
	echo "1800000" > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=1896000" $PROP`" != "" ]; then
	echo "1896000" > $FREQMAXBIG1
	echo "1896000" > $FREQMAXBIG2
	echo "1896000" > $FREQMAXBIG3
	echo "1896000" > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2000000" $PROP`" != "" ]; then
	echo "2000000" > $FREQMAXBIG1
	echo "2000000" > $FREQMAXBIG2
	echo "2000000" > $FREQMAXBIG3
	echo "2000000" > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2100000" $PROP`" != "" ]; then
	echo "2100000" > $FREQMAXBIG1
	echo "2100000" > $FREQMAXBIG2
	echo "2100000" > $FREQMAXBIG3
	echo "2100000" > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2200000" $PROP`" != "" ]; then
	echo "2200000" > $FREQMAXBIG1
	echo "2200000" > $FREQMAXBIG2
	echo "2200000" > $FREQMAXBIG3
	echo "2200000" > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2304000" $PROP`" != "" ]; then
	echo "2304000" > $FREQMAXBIG1
	echo "2304000" > $FREQMAXBIG2
	echo "2304000" > $FREQMAXBIG3
	echo "2304000" > $FREQMAXBIG4
else
	echo "2100000" > $FREQMAXBIG1
	echo "2100000" > $FREQMAXBIG2
	echo "2100000" > $FREQMAXBIG3
	echo "2100000" > $FREQMAXBIG4
fi

sleep 1;

# Parse GApps wakelock fix from prop
if [ "`grep "kernel.gapps=true" $PROP`" != "" ]; then
	sleep 60
	su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"
fi

# Execute init.d if Auto or ROM control
if [ "`grep "kernel.initd=true" $PROP`" != "" ]; then
	#enforce init.d script perms on any post-root added files
	chmod 755 /system/etc/init.d
	chmod 755 /system/etc/init.d/*
	if [ "`grep "init.d" /system/etc/init.sec.boot.sh`" = "" ]; then
		# run init.d scripts
		if [ -d /system/etc/init.d ]; then
		  run-parts /system/etc/init.d
		fi
	fi
fi
