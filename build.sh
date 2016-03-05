#!/bin/bash
# NetHunter kernel for Samsung Galaxy S4 Active build script by jcadduono

################### BEFORE STARTING ################
#
# download a working toolchain and extract it somewhere and configure this
# file to point to the toolchain's root directory.
#
# once you've set up the config section how you like it, you can simply run
# ./build.sh [DEVICE]
#
##################### DEVICES #####################
#
# jactivelte = GT-I9295
#
###################### CONFIG ######################

# root directory of jactivelte git repo (default is this script's location)
RDIR=$(pwd)

[ $VER ] || \
# version number
VER=$(cat $RDIR/VERSION)

# directory containing cross-compile arm toolchain
TOOLCHAIN=$HOME/build/toolchain/arm-cortex_a15-linux-gnueabihf-linaro_4.9.4-2015.06

# amount of cpu threads to use in kernel make process
THREADS=5

############## SCARY NO-TOUCHY STUFF ###############

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-eabi-

[ "$1" ] && {
	DEVICE=$1
} || {
	DEVICE=jactivelte
}

[ "$TARGET" ] || TARGET=nethunter

DEFCONFIG=${TARGET}_${DEVICE}_defconfig

[ -f "$RDIR/arch/$ARCH/configs/${DEFCONFIG}" ] || {
	echo "Config $DEFCONFIG not found in $ARCH configs!"
	exit 1
}

export LOCALVERSION=$VER

KDIR=$RDIR/arch/$ARCH/boot

CLEAN_BUILD()
{
	echo "Cleaning build..."
	cd $RDIR
	rm -rf build
}

BUILD_KERNEL()
{
	echo "Creating kernel config..."
	cd $RDIR
	mkdir -p build
	make -C $RDIR O=build $DEFCONFIG
	echo "Starting build for $DEVICE..."
	make -C $RDIR O=build -j"$THREADS"
}

CLEAN_BUILD && BUILD_KERNEL && echo "Finished building $DEVICE for $TARGET!"
