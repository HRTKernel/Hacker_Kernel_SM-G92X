#!/system/bin/sh

# VARS

BB=/system/xbin/busybox
PROP=/system/kernel.prop
SYSTEMPROP=/system/build.prop
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
SCHEDULER1=noop
SCHEDULER2=sioplus
SCHEDULER3=fiops
SCHEDULER4=deadline
SCHEDULER5=bfq
SCHEDULER6=tripndroid
SCHEDULER7=cfq
SCHEDULER8=row
CPUGOVERNOR1=alucard
CPUGOVERNOR2=bioshock
CPUGOVERNOR3=conservative
CPUGOVERNOR4=conservativex
CPUGOVERNOR5=dancedance
CPUGOVERNOR6=darkness
CPUGOVERNOR7=hyper
CPUGOVERNOR8=interactive
CPUGOVERNOR9=interextrem
CPUGOVERNOR10=Lionheart
CPUGOVERNOR11=nightmare
CPUGOVERNOR12=ondemand
CPUGOVERNOR13=ondemandplus
CPUGOVERNOR14=performance
CPUGOVERNOR15=preservative
CPUGOVERNOR16=smartassV2
CPUGOVERNOR17=userspace
CPUGOVERNOR18=wheatley
CPUFREQ1=200000
CPUFREQ2=300000
CPUFREQ3=400000
CPUFREQ4=500000
CPUFREQ5=600000
CPUFREQ6=700000
CPUFREQ7=800000
CPUFREQ8=900000
CPUFREQ9=1000000
CPUFREQ10=1100000
CPUFREQ11=1104000 #only A53 Cluster!
CPUFREQ12=1200000
CPUFREQ13=1296000 #only A53 Cluster!
CPUFREQ14=1300000 #only A57 Cluster!
CPUFREQ15=1400000
CPUFREQ16=1500000
CPUFREQ17=1600000
CPUFREQ18=1704000 #only A57 Cluster!
CPUFREQ19=1800000 #only A57 Cluster!
CPUFREQ20=1896000 #only A57 Cluster!
CPUFREQ21=2000000 #only A57 Cluster!
CPUFREQ22=2100000 #only A57 Cluster!
CPUFREQ23=2200000 #only A57 Cluster!
CPUFREQ24=2304000 #only A57 Cluster!

mount -o remount,rw /system
mount -o remount,rw /data

sync

/system/xbin/daemonsu --auto-daemon &

# Make internal storage directory.
busybox mount -t rootfs -o remount,rw rootfs
if [ ! -d /data/.hackerkernel ]; then
	mkdir /data/.hackerkernel
	$BB chmod -R 0777 /.hackerkernel/
fi
busybox mount -t rootfs -o remount,ro rootfs

# Synapse
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/synapse
busybox ln -fs /res/synapse/uci /sbin/uci
/sbin/uci
busybox mount -t rootfs -o remount,ro rootfs

# Dumping
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/dumping
busybox mount -t rootfs -o remount,ro rootfs

# Setup for Cron Task
# Copy Cron files
$BB cp -a /res/crontab/ /data/
if [ ! -e /data/crontab/custom_jobs ]; then
	$BB touch /data/crontab/custom_jobs;
	$BB chmod 777 /data/crontab/custom_jobs;
fi

# kernel custom test

if [ -e /data/hackertest.log ]; then
rm /data/hackertest.log
fi

# Stop Google Service and restart it on boot (dorimanx)
#if [ "$($BB pidof com.google.android.gms | wc -l)" -eq "1" ]; then
#	$BB kill $($BB pidof com.google.android.gms);
#fi
#if [ "$($BB pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
#	$BB kill $($BB pidof com.google.android.gms.unstable);
#fi
#if [ "$($BB pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
#	$BB kill $($BB pidof com.google.android.gms.persistent);
#fi
#if [ "$($BB pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
#	$BB kill $($BB pidof com.google.android.gms.wearable);
#fi
#echo "Stop Google Service successful." >> /data/hackertest.log

#Set default values on boot
if [ "`grep "ro.build.version.release=5.1.1" $SYSTEMPROP`" != "" ]; then
	mkdir /system/su.d
	chmod 0700 /system/su.d
	echo "#!/tmp-mksh/tmp-mksh" > /system/su.d/000000deepsleep
	echo "echo "temporary none" > /sys/class/scsi_disk/0:0:0:1/cache_type" >>  /system/su.d/000000deepsleep
	echo "echo "temporary none" > /sys/class/scsi_disk/0:0:0:2/cache_type" >> /system/su.d/000000deepsleep
	chmod 0700 /system/su.d/000000deepsleep
	echo "Set deepsleep values on boot successful." >> /data/hackertest.log
fi

# Assume SMP uses shared cpufreq policy for all CPUs
chown root system $FREQMAXLITTLE1
chmod 0644 $FREQMAXLITTLE1
chown root system $FREQMINLITTLE1
chmod 0644 $FREQMINLITTLE1
chown root system $FREQMAXLITTLE2
chmod 0644 $FREQMAXLITTLE2
chown root system $FREQMINLITTLE2
chmod 0644 $FREQMINLITTLE2
chown root system $FREQMAXLITTLE3
chmod 0644 $FREQMAXLITTLE3
chown root system $FREQMINLITTLE3
chmod 0644 $FREQMINLITTLE3
chown root system $FREQMAXLITTLE4
chmod 0644 $FREQMAXLITTLE4
chown root system $FREQMINLITTLE4
chmod 0644 $FREQMINLITTLE4
chown root system $FREQMAXBIG1
chmod 0644 $FREQMAXBIG1
chown root system $FREQMINBIG1
chmod 0644 $FREQMINBIG1
chown root system $FREQMAXBIG2
chmod 0644 $FREQMAXBIG2
chown root system $FREQMINBIG2
chmod 0644 $FREQMINBIG2
chown root system $FREQMAXBIG3
chmod 0644 $FREQMAXBIG3
chown root system $FREQMINBIG3
chmod 0644 $FREQMINBIG3
chown root system $FREQMAXBIG4
chmod 0644 $FREQMAXBIG4
chown root system $FREQMINBIG4
chmod 0644 $FREQMINBIG4
echo "Scaling_min_freq Permissions fixed successful." >> /data/hackertest.log

#Synapse profile
if [ ! -f /data/.hackerkernel/bck_prof ]; then
	cp -f /res/synapse/files/bck_prof /data/.hackerkernel/bck_prof
fi

chmod 777 /data/.hackerkernel/bck_prof

sleep 20;
if [ -d "/sys/class/misc/arizona_control" ]; then
	echo "0x0FF3 0x041E 0x0034 0x1FC8 0xF035 0x040D 0x00D2 0x1F6B 0xF084 0x0409 0x020B 0x1EB8 0xF104 0x0409 0x0406 0x0E08 0x0782 0x2ED8" > /sys/class/misc/arizona_control/eq_A_freqs
	echo "0x0C47 0x03F5 0x0EE4 0x1D04 0xF1F7 0x040B 0x07C8 0x187D 0xF3B9 0x040A 0x0EBE 0x0C9E 0xF6C3 0x040A 0x1AC7 0xFBB6 0x0400 0x2ED8" > /sys/class/misc/arizona_control/eq_B_freqs
	echo "1" >/sys/class/misc/arizona_control/switch_eq_hp
	echo "Set default sound values on boot successful." >> /data/hackertest.log
fi

#Setup Mhz Min/Max Cluster A53
#echo $CPUFREQ16 > $FREQMAXLITTLE1
#echo $CPUFREQ16 > $FREQMAXLITTLE2
#echo $CPUFREQ16 > $FREQMAXLITTLE3
#echo $CPUFREQ16 > $FREQMAXLITTLE4
#Setup Mhz Min/Max Cluster A57
#echo $CPUFREQ22 > $FREQMAXBIG1
#echo $CPUFREQ22 > $FREQMAXBIG2
#echo $CPUFREQ22 > $FREQMAXBIG3
#echo $CPUFREQ22 > $FREQMAXBIG4
#echo "Set default Min/Max Clusters values on boot successful." >> /data/hackertest.log

if [ ! -d $LOGS ]; then
	$BB mkdir /data/media/0/hackerkernel/Logs
fi

$BB chmod -R 0777 $LOGS

if [ ! -d $VALUES ]; then
	$BB mkdir /data/media/0/hackerkernel/values
fi
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
echo "Critical Permissions fixed successful." >> /data/hackertest.log

# Tweak interextrem
echo "19000 960000:39000 1248000:29000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/above_hispeed_delay
echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/align_windows
echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/boost
echo "" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/boostpulse
echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/boostpulse_duration
echo "80" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/go_hispeed_load
echo "1344000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/hispeed_freq
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/io_is_busy
echo "30000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/max_freq_hysteresis
echo "30000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/min_sample_time
echo "80 1344000:95 1478400:99" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/target_loads
echo "7000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/timer_rate
echo "80000" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/timer_slack
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/use_migration_notif
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interextrem/use_sched_load
echo "19000 960000:39000 1248000:29000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/above_hispeed_delay
echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/align_windows
echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/boost
echo "" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/boostpulse
echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/boostpulse_duration
echo "80" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/go_hispeed_load
echo "1344000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/hispeed_freq
echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/io_is_busy
echo "30000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/max_freq_hysteresis
echo "30000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/min_sample_time
echo "80 1344000:95 1478400:99" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/target_loads
echo "7000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/timer_rate
echo "80000" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/timer_slack
echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/use_migration_notif
echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interextrem/use_sched_load


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
    	echo $SCHEDULER1 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=sioplus" $PROP`" != "" ]; then
    	echo $SCHEDULER2 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=fiops" $PROP`" != "" ]; then
    	echo $SCHEDULER3 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=deadline" $PROP`" != "" ]; then
    	echo $SCHEDULER4 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=bfq" $PROP`" != "" ]; then
    	echo $SCHEDULER5 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=tripndroid" $PROP`" != "" ]; then
    	echo $SCHEDULER6 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=cfg" $PROP`" != "" ]; then
    	echo $SCHEDULER7 > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=row" $PROP`" != "" ]; then
    	echo $SCHEDULER8 > /sys/block/sda/queue/scheduler
else
    	echo $SCHEDULER7 > /sys/block/sda/queue/scheduler
fi

# Parse Governor from prop
if [ "`grep "kernel.governor=alucard" $PROP`" != "" ]; then
	echo $CPUGOVERNOR1 > $GOVLITTLE
	echo $CPUGOVERNOR1 > $GOVBIG
elif [ "`grep "kernel.governor=bioshock" $PROP`" != "" ]; then
	echo $CPUGOVERNOR2 > $GOVLITTLE
	echo $CPUGOVERNOR2 > $GOVBIG
elif [ "`grep "kernel.governor=conservative" $PROP`" != "" ]; then
	echo $CPUGOVERNOR3 > $GOVLITTLE
	echo $CPUGOVERNOR3 > $GOVBIG
elif [ "`grep "kernel.governor=conservativex" $PROP`" != "" ]; then
	echo $CPUGOVERNOR4 > $GOVLITTLE
	echo $CPUGOVERNOR4 > $GOVBIG
elif [ "`grep "kernel.governor=dancedance" $PROP`" != "" ]; then
	echo $CPUGOVERNOR5 > $GOVLITTLE
	echo $CPUGOVERNOR5 > $GOVBIG
elif [ "`grep "kernel.governor=darkness" $PROP`" != "" ]; then
	echo $CPUGOVERNOR6 > $GOVLITTLE
	echo $CPUGOVERNOR6 > $GOVBIG
elif [ "`grep "kernel.governor=hyper" $PROP`" != "" ]; then
	echo $CPUGOVERNOR7 > $GOVLITTLE
	echo $CPUGOVERNOR7 > $GOVBIG
elif [ "`grep "kernel.governor=interactive" $PROP`" != "" ]; then
	echo $CPUGOVERNOR8 > $GOVLITTLE
	echo $CPUGOVERNOR8 > $GOVBIG
elif [ "`grep "kernel.governor=interextrem" $PROP`" != "" ]; then
	echo $CPUGOVERNOR9 > $GOVLITTLE
	echo $CPUGOVERNOR9 > $GOVBIG
elif [ "`grep "kernel.governor=lionheart" $PROP`" != "" ]; then
	echo $CPUGOVERNOR10 > $GOVLITTLE
	echo $CPUGOVERNOR10 > $GOVBIG
elif [ "`grep "kernel.governor=nightmare" $PROP`" != "" ]; then
	echo $CPUGOVERNOR11 > $GOVLITTLE
	echo $CPUGOVERNOR11 > $GOVBIG
elif [ "`grep "kernel.governor=ondemand" $PROP`" != "" ]; then
	echo $CPUGOVERNOR12 > $GOVLITTLE
	echo $CPUGOVERNOR12 > $GOVBIG
elif [ "`grep "kernel.governor=ondemandplus" $PROP`" != "" ]; then
	echo $CPUGOVERNOR13 > $GOVLITTLE
	echo $CPUGOVERNOR13 > $GOVBIG
elif [ "`grep "kernel.governor=performance" $PROP`" != "" ]; then
	echo $CPUGOVERNOR14 > $GOVLITTLE
	echo $CPUGOVERNOR14 > $GOVBIG
elif [ "`grep "kernel.governor=preservative" $PROP`" != "" ]; then
	echo $CPUGOVERNOR15 > $GOVLITTLE
	echo $CPUGOVERNOR15 > $GOVBIG
elif [ "`grep "kernel.governor=smartass2" $PROP`" != "" ]; then
	echo $CPUGOVERNOR16 > $GOVLITTLE
	echo $CPUGOVERNOR16 > $GOVBIG
elif [ "`grep "kernel.governor=userspace" $PROP`" != "" ]; then
	echo $CPUGOVERNOR17 > $GOVLITTLE
	echo $CPUGOVERNOR17 > $GOVBIG
elif [ "`grep "kernel.governor=wheatley" $PROP`" != "" ]; then
	echo $CPUGOVERNOR18 > $GOVLITTLE
	echo $CPUGOVERNOR18 > $GOVBIG
else 
	echo $CPUGOVERNOR8 > $GOVLITTLE
	echo $CPUGOVERNOR8 > $GOVBIG
fi

sleep 1;

# Parse CPU CLOCK from prop
if [ "`grep "kernel.cpu.a53.min=200000" $PROP`" != "" ]; then
	echo $CPUFREQ1 > $FREQMINLITTLE1
	echo $CPUFREQ1 > $FREQMINLITTLE2
	echo $CPUFREQ1 > $FREQMINLITTLE3
	echo $CPUFREQ1 > $FREQMINLITTLE4
elif [ "`grep "kernel.cpu.a53.min=300000" $PROP`" != "" ]; then
	echo $CPUFREQ2 > $FREQMINLITTLE1
	echo $CPUFREQ2 > $FREQMINLITTLE2
	echo $CPUFREQ2 > $FREQMINLITTLE3
	echo $CPUFREQ2 > $FREQMINLITTLE4
elif [ "`grep "kernel.cpu.a53.min=400000" $PROP`" != "" ]; then
	echo $CPUFREQ3 > $FREQMINLITTLE1
	echo $CPUFREQ3 > $FREQMINLITTLE2
	echo $CPUFREQ3 > $FREQMINLITTLE3
	echo $CPUFREQ3 > $FREQMINLITTLE4
else
	echo $CPUFREQ3 > $FREQMINLITTLE1
	echo $CPUFREQ3 > $FREQMINLITTLE2
	echo $CPUFREQ3 > $FREQMINLITTLE3
	echo $CPUFREQ3 > $FREQMINLITTLE4
fi

sleep 1;

if [ "`grep "kernel.cpu.a53.max=1200000" $PROP`" != "" ]; then
	echo $CPUFREQ12 > $FREQMAXLITTLE1
	echo $CPUFREQ12 > $FREQMAXLITTLE2
	echo $CPUFREQ12 > $FREQMAXLITTLE3
	echo $CPUFREQ12 > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1296000" $PROP`" != "" ]; then
	echo $CPUFREQ13 > $FREQMAXLITTLE1
	echo $CPUFREQ13 > $FREQMAXLITTLE2
	echo $CPUFREQ13 > $FREQMAXLITTLE3
	echo $CPUFREQ13 > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1400000" $PROP`" != "" ]; then
	echo $CPUFREQ15 > $FREQMAXLITTLE1
	echo $CPUFREQ15 > $FREQMAXLITTLE2
	echo $CPUFREQ15 > $FREQMAXLITTLE3
	echo $CPUFREQ15 > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1500000" $PROP`" != "" ]; then
	echo $CPUFREQ16 > $FREQMAXLITTLE1
	echo $CPUFREQ16 > $FREQMAXLITTLE2
	echo $CPUFREQ16 > $FREQMAXLITTLE3
	echo $CPUFREQ16 > $FREQMAXLITTLE4
elif [ "`grep "kernel.cpu.a53.min=1600000" $PROP`" != "" ]; then
	echo $CPUFREQ17 > $FREQMAXLITTLE1
	echo $CPUFREQ17 > $FREQMAXLITTLE2
	echo $CPUFREQ17 > $FREQMAXLITTLE3
	echo $CPUFREQ17 > $FREQMAXLITTLE4
else
	echo $CPUFREQ16 > $FREQMAXLITTLE1
	echo $CPUFREQ16 > $FREQMAXLITTLE2
	echo $CPUFREQ16 > $FREQMAXLITTLE3
	echo $CPUFREQ16 > $FREQMAXLITTLE4
fi

sleep 1;

if [ "`grep "kernel.cpu.a57.min=200000" $PROP`" != "" ]; then
	echo $CPUFREQ1 > $FREQMINBIG1
	echo $CPUFREQ1 > $FREQMINBIG2
	echo $CPUFREQ1 > $FREQMINBIG3
	echo $CPUFREQ1 > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=300000" $PROP`" != "" ]; then
	echo $CPUFREQ2 > $FREQMINBIG1
	echo $CPUFREQ2 > $FREQMINBIG2
	echo $CPUFREQ2 > $FREQMINBIG3
	echo $CPUFREQ2 > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=400000" $PROP`" != "" ]; then
	echo $CPUFREQ3 > $FREQMINBIG1
	echo $CPUFREQ3 > $FREQMINBIG2
	echo $CPUFREQ3 > $FREQMINBIG3
	echo $CPUFREQ3 > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=500000" $PROP`" != "" ]; then
	echo $CPUFREQ4 > $FREQMINBIG1
	echo $CPUFREQ4 > $FREQMINBIG2
	echo $CPUFREQ4 > $FREQMINBIG3
	echo $CPUFREQ4 > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=600000" $PROP`" != "" ]; then
	echo $CPUFREQ5 > $FREQMINBIG1
	echo $CPUFREQ5 > $FREQMINBIG2
	echo $CPUFREQ5 > $FREQMINBIG3
	echo $CPUFREQ5 > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=700000" $PROP`" != "" ]; then
	echo $CPUFREQ6 > $FREQMINBIG1
	echo $CPUFREQ6 > $FREQMINBIG2
	echo $CPUFREQ6 > $FREQMINBIG3
	echo $CPUFREQ6 > $FREQMINBIG4
elif [ "`grep "kernel.cpu.a57.min=800000" $PROP`" != "" ]; then
	echo $CPUFREQ7 > $FREQMINBIG1
	echo $CPUFREQ7 > $FREQMINBIG2
	echo $CPUFREQ7 > $FREQMINBIG3
	echo $CPUFREQ7 > $FREQMINBIG4
else
	echo $CPUFREQ7 > $FREQMINBIG1
	echo $CPUFREQ7 > $FREQMINBIG2
	echo $CPUFREQ7 > $FREQMINBIG3
	echo $CPUFREQ7 > $FREQMINBIG4
fi

sleep 1;

if [ "`grep "kernel.cpu.a57.max=1704000" $PROP`" != "" ]; then
	echo $CPUFREQ18 > $FREQMAXBIG1
	echo $CPUFREQ18 > $FREQMAXBIG2
	echo $CPUFREQ18 > $FREQMAXBIG3
	echo $CPUFREQ18 > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=1800000" $PROP`" != "" ]; then
	echo $CPUFREQ19 > $FREQMAXBIG1
	echo $CPUFREQ19 > $FREQMAXBIG2
	echo $CPUFREQ19 > $FREQMAXBIG3
	echo $CPUFREQ19 > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=1896000" $PROP`" != "" ]; then
	echo $CPUFREQ20 > $FREQMAXBIG1
	echo $CPUFREQ20 > $FREQMAXBIG2
	echo $CPUFREQ20 > $FREQMAXBIG3
	echo $CPUFREQ20 > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2000000" $PROP`" != "" ]; then
	echo $CPUFREQ21 > $FREQMAXBIG1
	echo $CPUFREQ21 > $FREQMAXBIG2
	echo $CPUFREQ21 > $FREQMAXBIG3
	echo $CPUFREQ21 > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2100000" $PROP`" != "" ]; then
	echo $CPUFREQ22 > $FREQMAXBIG1
	echo $CPUFREQ22 > $FREQMAXBIG2
	echo $CPUFREQ22 > $FREQMAXBIG3
	echo $CPUFREQ22 > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2200000" $PROP`" != "" ]; then
	echo $CPUFREQ23 > $FREQMAXBIG1
	echo $CPUFREQ23 > $FREQMAXBIG2
	echo $CPUFREQ23 > $FREQMAXBIG3
	echo $CPUFREQ23 > $FREQMAXBIG4
elif [ "`grep "kernel.cpu.a57.max=2304000" $PROP`" != "" ]; then
	echo $CPUFREQ24 > $FREQMAXBIG1
	echo $CPUFREQ24 > $FREQMAXBIG2
	echo $CPUFREQ24 > $FREQMAXBIG3
	echo $CPUFREQ24 > $FREQMAXBIG4
else
	echo $CPUFREQ22 > $FREQMAXBIG1
	echo $CPUFREQ22 > $FREQMAXBIG2
	echo $CPUFREQ22 > $FREQMAXBIG3
	echo $CPUFREQ22 > $FREQMAXBIG4
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

sleep 1;

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

sleep 1;

# Parse Knox reomve from prop
if [ "`grep "kernel.knox=true" $PROP`" != "" ]; then
	cd /system
	rm -rf *app/BBCAgent*
	rm -rf *app/Bridge*
	rm -rf *app/ContainerAgent*
	rm -rf *app/ContainerEventsRelayManager*
	rm -rf *app/DiagMonAgent*
	rm -rf *app/ELMAgent*
	rm -rf *app/FotaClient*
	rm -rf *app/FWUpdate*
	rm -rf *app/FWUpgrade*
	rm -rf *app/HLC*
	rm -rf *app/KLMSAgent*
	rm -rf *app/*Knox*
	rm -rf *app/*KNOX*
	rm -rf *app/LocalFOTA*
	rm -rf *app/RCPComponents*
	rm -rf *app/SecKids*
	rm -rf *app/SecurityLogAgent*
	rm -rf *app/SPDClient*
	rm -rf *app/SyncmlDM*
	rm -rf *app/UniversalMDMClient*
	rm -rf container/*Knox*
	rm -rf container/*KNOX*
fi

rm -rf $PROP

sleep 1;
