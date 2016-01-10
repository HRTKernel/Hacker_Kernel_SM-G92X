#!/bin/bash
# kernel build script by thehacker911
KERNEL_DIR=$(pwd)

echo "cloud 9 user kernel build"
mkdir toolchain
cd toolchain 
wget http://sabermod.com/Toolchains%20%28DEV%20ONLY%29/aarch64/aarch64-kernel/GCC%205.3/aarch64-linux-gnu-5.3-01-08-16.tar.xz && tar xvf *.tar.xz

