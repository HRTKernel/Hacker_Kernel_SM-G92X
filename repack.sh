#!/bin/bash

BUILD_WHERE=$(pwd)
BUILD_KERNEL_DIR=$BUILD_WHERE
BOARD_KERNEL_PAGESIZE=2048
BOOTIMG=$BUILD_KERNEL_DIR/build_image/boot.img
BOOTIMG_DIR=build_image/boot
BOOTIMG_DIR_2=build_image
DTBTOOL=$BUILD_KERNEL_DIR/tools/dtbtool
FLASH_ZIP_FILES=zip_files
FLASH_ZIP_DIR=$FLASH_ZIP_FILES/$KERNEL_NAME
KERNEL_ZIMG=$BUILD_KERNEL_DIR/arch/arm64/boot/Image
OUTPUT_DIR=$BUILD_KERNEL_DIR/build_image/output_kernel

ZIP_VER=`sed -n '8p' thehacker911`
DEVICE_VER=`sed -n '4p' thehacker911`
VER=`sed -n '6p' thehacker911`
KERNEL_NAME="$ZIP_VER$DEVICE_VER$VER"


cp -r $KERNEL_ZIMG $BOOTIMG_DIR_2/Image

find . -name "*.ko" -exec cp {} $BUILD_KERNEL_DIR/build_image/zip_files/system/lib/modules/ \;

rm $BUILD_KERNEL_DIR/build_image/zip_files/system/lib/modules/placeholder

cd build_image
rm output_kernel/*.zip

echo "Making boot.img ..."
$DTBTOOL -o dt.img -s $BOARD_KERNEL_PAGESIZE -p ../scripts/dtc/ ../arch/arm64/boot/dts/ | sleep 1

cp -r Image boot/zImage
chmod a+r dt.img
cp dt.img boot/dt.img

./mkboot boot boot.img
#./mkboot boot.img boot

echo "Making zip ..."
cp $BOOTIMG $FLASH_ZIP_FILES/kernel/boot.img
cd $FLASH_ZIP_FILES
zip -r $KERNEL_NAME.zip META-INF system kernel
mv $KERNEL_NAME.zip $OUTPUT_DIR

echo "Making cleaning ..."
find . -name "*.ko" -exec rm {} \;
cd ..
rm dt.img
rm boot.img
rm Image
rm zip_files/boot.img
rm boot/zImage
rm boot/dt.img
cd ..
rm -rf /arch/arm64/boot/dts/.*.tmp
rm -rf /arch/arm64/boot/dts/.*.cmd
rm -rf /arch/arm64/boot/dts/*.dtb


echo "All Done!"
