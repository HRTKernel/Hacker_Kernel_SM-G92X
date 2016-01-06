#!/bin/bash
# kernel build script by thehacker911

KERNEL_DIR=$(pwd)
BUILD_USER="$USER"
TOOLCHAIN_DIR=/home/$BUILD_USER/android/toolchains
BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`
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
SU_VER=`sed -n '14p' thehacker911`
KERNEL_NAME="$ZIP_VER$DEVICE_VER$VER"
TOOLCHAIN=`sed -n '12p' thehacker911`
BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/$TOOLCHAIN


#vars
KERNEL_DEFCONFIG=hacker_defconfig
BASE_VER=`sed -n '2p' thehacker911`
DEVICE_VER=`sed -n '4p' thehacker911`
VER=`sed -n '6p' thehacker911`
HACKER_VER="$BASE_VER$DEVICE_VER$VER"


BUILD_KERNEL()
{	
	echo ""
	echo "=============================================="
	echo "START: MAKE CLEAN"
	echo "=============================================="
	echo ""
	

	make clean
	find . -name "*.dtb" -exec rm {} \;

	echo ""
	echo "=============================================="
	echo "END: MAKE CLEAN"
	echo "=============================================="
	echo ""

	echo ""
	echo "=============================================="
	echo "START: BUILD_KERNEL"
	echo "=============================================="
	echo ""
	echo "$HACKER_VER" 
	
	export LOCALVERSION=-`echo $HACKER_VER`
	export ARCH=arm64
        export SUBARCH=arm64
	export KBUILD_BUILD_USER=thehacker911
	export KBUILD_BUILD_HOST=smartlounge.eu
        #export USE_CCACHE=1
        export USE_SEC_FIPS_MODE=true
        export ENABLE_GRAPHITE=true
	export CROSS_COMPILE=$BUILD_CROSS_COMPILE
	make ARCH=arm64 $KERNEL_DEFCONFIG
	make ARCH=arm64 -j$BUILD_JOB_NUMBER
	

	echo ""
	echo "================================="
	echo "END: BUILD_KERNEL"
	echo "================================="
	echo ""
}

REPACK_KERNEL()
{	
	echo ""
	echo "=============================================="
	echo "START: REPACK_KERNEL"
	echo "=============================================="
	echo ""
	      echo "$KERNEL_NAME" 
	if [ -e $BUILD_KERNEL_DIR/arch/arm64/boot/Image ]; then
	      cp -r $KERNEL_ZIMG $BOOTIMG_DIR_2/Image

	      find . -name "*.ko" -exec cp {} $BUILD_KERNEL_DIR/build_image/zip_files/system/lib/modules/ \;

	      rm $BUILD_KERNEL_DIR/build_image/zip_files/system/lib/modules/placeholder

	      cd build_image
	      mkdir backup_image
	      cp -r Image backup_image/zImage
	      rm output_kernel/*.zip

	      echo "Making boot.img ..."
	      $DTBTOOL -o dt.img -s $BOARD_KERNEL_PAGESIZE -p ../scripts/dtc/ ../arch/arm64/boot/dts/ | sleep 1

	      cp -r Image boot/zImage
	      chmod a+r dt.img
	      cp dt.img boot/dt.img
	      cp dt.img backup_image/dt.img

	      ./mkboot boot boot.img
	      #./mkboot boot.img boot

	      echo "Making zip ..."
	      cp $BOOTIMG $FLASH_ZIP_FILES/kernel/boot.img
	      cd $FLASH_ZIP_FILES
	      zip -r $KERNEL_NAME.zip META-INF system kernel data
	      mv $KERNEL_NAME.zip $OUTPUT_DIR

	      echo "Making cleaning ..."
	      find . -name "*.ko" -exec rm {} \;
	      cd ..
	      rm dt.img
	      rm boot.img
	      rm Image
	      rm zip_files/kernel/boot.img
	      rm boot/zImage
	      rm boot/dt.img
	      
	      echo "repack normal version + su systemless"
	      cp backup_image/dt.img boot_su_266/dt.img
	      cp backup_image/zImage boot_su_266/zImage
	      ./mkboot boot_su_266 boot.img
	      cp $BOOTIMG $FLASH_ZIP_FILES/kernel/boot.img
	      cd $FLASH_ZIP_FILES
	      zip -r $KERNEL_NAME$SU_VER.zip META-INF system kernel data
	      mv $KERNEL_NAME$SU_VER.zip $OUTPUT_DIR
	      cd ..
	      rm boot.img
	      rm zip_files/kernel/boot.img
	      rm boot_su_266/zImage
	      rm boot_su_266/dt.img
	      
	      cd ..
	      rm -rf /arch/arm64/boot/dts/.*.tmp
	      rm -rf /arch/arm64/boot/dts/.*.cmd
	      rm -rf /arch/arm64/boot/dts/*.dtb

	      echo "All Done!"
	
	      echo ""
	      echo "================================="
	      echo "END: REPACK_KERNEL"
	      echo "================================="
	      echo ""
	      
	else
	
	      echo ""
	      echo "================================="
	      echo "END: FAIL KERNEL BUILD!"
	      echo "================================="
	      echo ""
	      exit 0;
	fi;
	
}




# MAIN FUNCTION
rm -rf ./build.log
(
	START_TIME=`date +%s`
	BUILD_DATE=`date +%m-%d-%Y`
	BUILD_KERNEL
	REPACK_KERNEL


	END_TIME=`date +%s`
	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1	 | tee -a ./build.log

# Credits:
# Samsung
# google
# osm0sis
# cyanogenmod
# kylon 
