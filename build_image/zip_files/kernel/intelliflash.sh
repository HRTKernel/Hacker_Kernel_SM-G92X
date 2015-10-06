#!/sbin/sh
# This script created by glewarne@xda

# This script will perform a number of tasks
# 1) Detect what phone variant is being used
# 2) Detect dual sim capability
# 3) Flash the kernel
# 4) Patch in-call audio files specific to the found model
# 5) Patch GPS files
# 6) Adds init.d capability via init.sec.boot.sh in /system/etc
# 7) Adds DHA and other tweaks to build.prop cleanly on install


# get the output pipe for recovery ui
RUI=$(ps | grep -v "grep" | grep -o -E "updater(.*)" | cut -d " " -f 3);

#set feedback strings
blank=' '
start='Intelliflash Started....'
detect='Detecting Device Hardware Variant'
flash='--Flashing Kernel to boot partition'
prop='--Setting DHA Tweaks in build.prop'
patchaudio='--Patching In-Call audio'
patchgps='--Patching GPS Driver'
perms='--Setting file permissions'
initd='--Setting init.d script support'
complete='Intelliflash completed'
ktcheck='Looking for Ktweaker'
ktremove='--Removing Ktweaker'
ktnone='--Ktweaker not found'


sleep 0.5
echo "ui_print $start" >&$RUI;
echo "ui_print $blank" >&$RUI;

# Probe /proc/cmdline to detect variant
echo "ui_print $detect" >&$RUI;
if [ "`grep "G920T" /proc/cmdline`" != "" ]; then
	# found G920 T variant	
	D=T
elif [ "`grep "G920W8" /proc/cmdline`" != "" ]; then
	# found G920 W8 variant	
	D=T
elif [ "`grep "G925T" /proc/cmdline`" != "" ]; then
	# found G925 T variant	
	D=T
elif [ "`grep "G925W8" /proc/cmdline`" != "" ]; then
	# found G925 W8 variant	
	D=T
elif [ "`grep "G920P" /proc/cmdline`" != "" ]; then
	# found G920 P variant
	D=P
elif [ "`grep "G925P" /proc/cmdline`" != "" ]; then
	# found G925 P variant
	D=P
else
	# must be an international variant, assume F
	D=F
fi
sleep 1

#Decide what model is found
if [ "$D" = "F" ]; then
	if [ "`grep "920" /proc/cmdline`" != "" ]; then
		found='-Found International S6 Flat Device'
	else
		found='-Found International S6 Edge Device'
	fi		
elif [ "$D" = "T" ]; then
	if [ "`grep "920" /proc/cmdline`" != "" ]; then
		found='-Found T or W8 S6 Flat Device'
	else
		found='-Found T or W8 S6 Edge Device'
	fi		
elif [ "$D" = "P" ]; then
	#if a P device, exit now befroe doing anything else
	found='-Found P (Sprint) Device..NOT SUPPORTED..exiting!'
	echo "ui_print $found" >&$RUI;
	exit 1
fi

#report detected model to UI
echo "ui_print $found" >&$RUI;

#flash the kernel with dd
sleep 1
echo "ui_print $flash" >&$RUI;
dd if=/tmp/boot.img of=/dev/block/platform/15570000.ufs/by-name/BOOT

#force patch in-call audio files
#sleep 1
#echo "ui_print $patchaudio for $D variant" >&$RUI;
#cp -r /tmp/sys$D/* /system/

#add init.d support
#sleep 1
#echo "ui_print $initd" >&$RUI;
#cp /tmp/init/init.sec.boot.sh /system/etc/init.sec.boot.sh
#chmod 0755 system/etc/init.sec.boot.sh

#force patch gps driver
#sleep 1
#echo "ui_print $patchgps" >&$RUI;
#cp -r /tmp/sgps/* /system/

#fix permissions on newly copied files
#sleep 1
#echo "ui_print $perms" >&$RUI;
#chmod 0755 /system/bin/cellgeofenced
#chmod 0755 /system/bin/rild
#chmod 0755 /system/bin/gpsd
#chmod 0644 /system/bin/gps.cer

#remove ktweaker if found
sleep 1
echo "ui_print $blank" >&$RUI;
echo "ui_print $ktcheck" >&$RUI;
if [ -e /system/app/com.ktoonsez.KTweaker.apk ]; then
	sleep 1
	echo "ui_print $ktremove" >&$RUI;
	rm /system/app/com.ktoonsez.KTweaker.apk
	rm /system/app/com.ktoonsez.KTmonitor.apk
else
	sleep 1
	echo "ui_print $ktnone" >&$RUI;
fi

#finished
sleep 1
echo "ui_print $blank" >&$RUI;
echo "ui_print $complete" >&$RUI;
sleep 1

