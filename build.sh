#!/bin/bash
### Prema Chand Alugu (premaca@gmail.com)
### Shivam Desai (shivamdesaixda@gmail.com)
### Martichou (martichou.andre@gmail.com)
### A custom build script to build zImage & DTB(Anykernel2 method)
set -e
## Copy this script inside the kernel directory

KERNEL_DIR=$PWD
KERNEL_TOOLCHAIN=$KERNEL_DIR/toolchain-4.9/bin/arm-eabi-
KERNEL_DEFCONFIG=StarCity_defconfig
DTBTOOL=$KERNEL_DIR/AnyKernel2/tools
JOBS=5
ANY_KERNEL2_DIR=$KERNEL_DIR/AnyKernel2
FINAL_KERNEL_ZIP=StarCity_ham.zip
DTBIMAGE="dtb"

# The MAIN Part
echo "**** Setting Toolchain ****"
export CROSS_COMPILE=$KERNEL_TOOLCHAIN
export ARCH=arm

# Clean build always lol
echo "**** Cleaning ****"
make clean && make mrproper

echo "**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****"
make $KERNEL_DEFCONFIG
make -j$JOBS

# Time for dtb
echo "**** Generating DT.IMG ****"
$DTBTOOL/dtbToolCM -2 -o $ANY_KERNEL2_DIR/$DTBIMAGE -s 2048 -p scripts/dtc/ arch/arm/boot/

echo "**** Verify zImage & dtb ****"
ls $KERNEL_DIR/arch/arm/boot/zImage
ls $ANY_KERNEL2_DIR/$DTBIMAGE

#Anykernel 2 time!!
echo "**** Verifying Anyernel2 Directory ****"
ls $ANY_KERNEL2_DIR

#echo "**** Removing leftovers ****"
#rm -rf $ANY_KERNEL2_DIR/$DTBIMAGE
#rm -rf $ANY_KERNEL2_DIR/zImage
#rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP

echo "**** Copying zImage ****"
cp $KERNEL_DIR/arch/arm/boot/zImage $ANY_KERNEL2_DIR/

echo "**** Time to zip up! ****"
cd $ANY_KERNEL2_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
rm -rf $KERNEL_DIR/Builds/$FINAL_KERNEL_ZIP
cp $KERNEL_DIR/AnyKernel2/$FINAL_KERNEL_ZIP $KERNEL_DIR/Builds/$FINAL_KERNEL_ZIP

echo "**** Good Bye!! ****"
cd $KERNEL_DIR
rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
rm -rf AnyKernel2/zImage
rm -rf AnyKernel2/dtb
