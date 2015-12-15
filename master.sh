#!/bin/bash
# kernel build script by thehacker911
KERNEL_DIR=$(pwd)

while true; do
    read -p "Do you wish to build with sound mod? y/N = " yn
    case $yn in
        [Yy]* )
        echo ""
        echo "Build with sound mod"
        sleep 2
        rm -rf $KERNEL_DIR/sound_mod/sound/soc/codecs/arizona-control.c;
        rm -rf $KERNEL_DIR/sound_mod/sound/soc/codecs/clearwater.c;
        rm -rf $KERNEL_DIR/sound_mod/include/linux/mfd/arizona/control.h;
        rm -rf $KERNEL_DIR/sound_mod/sound/soc/codecs/Makefile;
        rm -rf $KERNEL_DIR/sound_mod/drivers/base/regmap/regmap.c;
        sleep 2
        cp $KERNEL_DIR/sound_mod/build_with_sound_mod/arizona-control.c $KERNEL_DIR/sound/soc/codecs/arizona-control.c;
        cp $KERNEL_DIR/sound_mod/build_with_sound_mod/clearwater.c $KERNEL_DIR/sound/soc/codecs/clearwater.c;
        cp $KERNEL_DIR/sound_mod/build_with_sound_mod/control.h $KERNEL_DIR/include/linux/mfd/arizona/control.h;
        cp $KERNEL_DIR/sound_mod/build_with_sound_mod/Makefile $KERNEL_DIR/sound/soc/codecs/Makefile;
        cp $KERNEL_DIR/sound_mod/build_with_sound_mod/regmap.c $KERNEL_DIR/drivers/base/regmap/regmap.c;
        sleep 1
        ./build_kernel.sh && exit 0;;
        
        [Nn]* )
        echo ""
        echo "Build without sound mod"
        sleep 2
        rm -rf $KERNEL_DIR/sound_mod/sound/soc/codecs/arizona-control.c;
        rm -rf $KERNEL_DIR/sound_mod/sound/soc/codecs/clearwater.c;
        rm -rf $KERNEL_DIR/sound_mod/include/linux/mfd/arizona/control.h;
        rm -rf $KERNEL_DIR/sound_mod/sound/soc/codecs/Makefile;
        rm -rf $KERNEL_DIR/sound_mod/drivers/base/regmap/regmap.c;
        sleep 2
        cp $KERNEL_DIR/sound_mod/build_without_sound_mod/clearwater.c $KERNEL_DIR/sound/soc/codecs/clearwater.c;
        cp $KERNEL_DIR/sound_mod/build_without_sound_mod/Makefile $KERNEL_DIR/sound/soc/codecs/Makefile;
        cp $KERNEL_DIR/sound_mod/build_without_sound_mod/regmap.c $KERNEL_DIR/drivers/base/regmap/regmap.c;
        sleep 1
        ./build_kernel_without_sound_mod.sh && exit 0;;
        
        * ) echo "Please answer yes or no.";;

    esac
done