#!/system/xbin/busybox sh
#
# UNIVERSAL DUMPER
# <zip-modem.sh>
# Copyright (c) 2016 thehacker911 <maikdiebenkorn@gmail.com>
#
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#

BB=/system/xbin/busybox;
ZIP=/system/xbin/zip;
DUMP=`sed -n '3p' /res/dumping/vars` # Found at /res/dumping/vars Line 3
P=/sdcard
MODEM=`getprop gsm.version.baseband`
MAKEZIP=/res/dumping/make_zip
US=/res/dumping/make_zip/META-INF/com/google/android/updater-script
US1=`sed -n '6p' /res/dumping/vars_us` # Found at /res/dumping/vars_us Line 6 What you flash???
US2=`sed -n '2p' /res/dumping/vars_us` # Found at /res/dumping/vars_us Line 2
US3=`sed -n '3p' /res/dumping/vars_us` # Found at /res/dumping/vars_us Line 3
US4=`sed -n '7p' /res/dumping/vars_us` # Found at /res/dumping/vars_us Line 7 !!!!!FLASHPATH!!!!!
US5=`sed -n '4p' /res/dumping/vars_us` # Found at /res/dumping/vars_us Line 4 

ROOTFS_MOUNT=$(mount | grep rootfs | cut -c26-27 | grep -c rw)
if [ "$ROOTFS_MOUNT" -eq "0" ]; then
	$BB mount -o remount,rw /;
fi;

echo "$US1" > $US
echo "$US2" >> $US
echo "$US3" >> $US
echo "$US4" >> $US
echo "$US5" >> $US

dd if=$DUMP of=$MAKEZIP/modem.bin
$BB chmod -R 0755 $MAKEZIP
cd $MAKEZIP
$ZIP -r $MODEM.zip META-INF modem.bin
cd
mv $MAKEZIP/$MODEM.zip $P/$MODEM.zip
rm $MAKEZIP/modem.bin

$BB mount -t rootfs -o remount,ro rootfs;
