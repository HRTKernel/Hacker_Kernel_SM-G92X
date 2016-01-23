#!/system/xbin/busybox sh
#
# UNIVERSAL DEBLOAT
# <debloat.sh>
# Copyright (c) 2016 thehacker911 <maikdiebenkorn@gmail.com>
#
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#

BB=/system/xbin/busybox;
ZIP=/system/xbin/zip;
P=/sdcard
MAKEZIP=/res/dumping/make_zip
US=/res/dumping/make_zip/META-INF/com/google/android/updater-script

ROOTFS_MOUNT=$(mount | grep rootfs | cut -c26-27 | grep -c rw)
if [ "$ROOTFS_MOUNT" -eq "0" ]; then
	$BB mount -o remount,rw /;
fi;

cp /res/debloat/updater-script /res/dumping/make_zip/META-INF/com/google/android/updater-script
$BB chmod -R 0755 $MAKEZIP
cd $MAKEZIP
$ZIP -r debloat.zip META-INF
cd
mv $MAKEZIP/debloat.zip $P/debloat.zip
rm /res/dumping/make_zip/META-INF/com/google/android/updater-script

$BB mount -t rootfs -o remount,ro rootfs;
