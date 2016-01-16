#!/bin/bash
# kernel build script by thehacker911
BUILD_WHERE=$(pwd)
BUILD_KERNEL_DIR=$BUILD_WHERE
BOOTIMG=$BUILD_KERNEL_DIR/build_image/boot.img
ZIP_VER=`sed -n '8p' thehacker911`
DEVICE_VER=`sed -n '4p' thehacker911`
VER=`sed -n '6p' thehacker911`
VER_WSM=`sed -n '10p' thehacker911`
KERNEL_NAME="$ZIP_VER$DEVICE_VER$VER"
KERNEL_NAME_WSM="$ZIP_VER$DEVICE_VER$VER_WSM"
FLASH_ZIP_FILES=zip_files
OUTPUT_DIR=$BUILD_KERNEL_DIR/build_image/output_kernel
SU_VER=`sed -n '14p' thehacker911`

while true; do
    read -p "Please select repack option! = a (normal) or b (WSM)? E = Exit " abe
    case $abe in
        [Aa]* )
        echo ""
        echo "repack with sound mod"
        sleep 2
        echo ""
        echo "repack normal version"
        cd build_image 
	cp backup_image/dt.img boot/dt.img
	cp backup_image/zImage boot/zImage
	./mkboot boot boot.img
	cp $BOOTIMG $FLASH_ZIP_FILES/kernel/boot.img
	cd $FLASH_ZIP_FILES
	zip -r $KERNEL_NAME.zip META-INF system kernel data
	mv $KERNEL_NAME.zip $OUTPUT_DIR
	cd ..
	rm boot.img
	rm zip_files/kernel/boot.img
	rm boot/zImage
	rm boot/dt.img
	sleep 2
	echo ""
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
	echo ""
	echo "All Done!"
	echo ""
	;;
        
        [Bb]* )
        echo ""
        echo "repack  without sound mod"
        sleep 2
        echo ""
        echo "repack with sound mod"
        sleep 2
        echo ""
        echo "repack wsm version"
        cd build_image
	cp backup_image_wsm/dt.img boot/dt.img
	cp backup_image_wsm/zImage boot/zImage
	./mkboot boot boot.img
	cp $BOOTIMG $FLASH_ZIP_FILES/kernel/boot.img
	cd $FLASH_ZIP_FILES
	zip -r $KERNEL_NAME_WSM.zip META-INF system kernel data
	mv $KERNEL_NAME_WSM.zip $OUTPUT_DIR
	cd ..
	rm boot.img
	rm zip_files/kernel/boot.img
	rm boot/zImage
	rm boot/dt.img
	sleep 2
	echo ""
	echo "repack wsm version + su systemless"
	cp backup_image_wsm/dt.img boot_su_266/dt.img
	cp backup_image_wsm/zImage boot_su_266/zImage
	./mkboot boot_su_266 boot.img
	cp $BOOTIMG $FLASH_ZIP_FILES/kernel/boot.img
	cd $FLASH_ZIP_FILES
	zip -r $KERNEL_NAME_WSM$SU_VER.zip META-INF system kernel data
	mv $KERNEL_NAME_WSM$SU_VER.zip $OUTPUT_DIR
	cd ..
	rm boot.img
	rm zip_files/kernel/boot.img
	rm boot_su_266/zImage
	rm boot_su_266/dt.img
	echo ""
	echo "All Done!"
	echo ""
	;;
        
        [Ee]* )
	exit 0;;
        
        * ) 
        echo ""
        echo "Please answer a or b or e.";;

    esac
done