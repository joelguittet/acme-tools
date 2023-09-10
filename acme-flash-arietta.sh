#!/bin/bash

# Disk
DISK=$1
echo "Disk: /dev/${DISK}"
if [ ! -b /dev/$DISK ]; then
  echo "ERROR: disk /dev/${DISK} not found"
  exit 1
fi

# Images directory
IMAGES_DIR=$2
echo "Images directory: $IMAGES_DIR"

# Expected files
AT91BOOTSTRAP="$IMAGES_DIR/BOOT.BIN"
UBOOT="$IMAGES_DIR/u-boot.bin"
UBOOT_ENV="$IMAGES_DIR/uboot.env"
DTB="$IMAGES_DIR/at91-ariettag25.dtb"
KERNEL="$IMAGES_DIR/zImage"
ROOTFS="$IMAGES_DIR/rootfs.tar.gz"

if [[ ! -e "${AT91BOOTSTRAP}" ]]; then
  echo "ERROR: file ${AT91BOOTSTRAP} not found"
  exit 1
fi
if [[ ! -e "${UBOOT}" ]]; then
  echo "ERROR: file ${UBOOT} not found"
  exit 1
fi
if [[ ! -e "${UBOOT_ENV}" ]]; then
  echo "ERROR: file ${UBOOT_ENV} not found"
  exit 1
fi
if [[ ! -e "${DTB}" ]]; then
  echo "ERROR: file ${DTB} not found"
  exit 1
fi
if [[ ! -e "${KERNEL}" ]]; then
  echo "ERROR: file ${KERNEL} not found"
  exit 1
fi
if [[ ! -e "${ROOTFS}" ]]; then
  echo "ERROR: file ${ROOTFS} not found"
  exit 1
fi

# Create temporary directory
TMPDIR=`mktemp -d -t arietta-flash-XXXXXX`

# Step 1: Create partitions (64MB reserved boot + rootfs)

echo == Create partitions ==
for device in /dev/$DISK[0-9]; do umount -f $device; done
BLOCKS=$((64*1024*1024/$(cat "/sys/block/$DISK/queue/hw_sector_size")))
sfdisk "/dev/""$DISK" << EOF
1,"$BLOCKS",6
;
EOF
mkfs.msdos -n boot "/dev/""$DISK""1"
mkfs.ext4 -L rootfs -F "/dev/""$DISK""2"
echo OK

# Step 2: Flash image

echo == Copy image to SD card ==
mkdir "$TMPDIR/boot"
mkdir "$TMPDIR/rootfs"
mount "/dev/""$DISK""1" "$TMPDIR/boot"
mount "/dev/""$DISK""2" "$TMPDIR/rootfs"
cp "$AT91BOOTSTRAP" "$TMPDIR/boot"
cp "$UBOOT" "$TMPDIR/boot"
cp "$UBOOT_ENV" "$TMPDIR/boot"
cp "$DTB" "$TMPDIR/boot"
cp "$KERNEL" "$TMPDIR/boot"
tar -xf "$ROOTFS" -C "$TMPDIR/rootfs"
sync
for device in /dev/$DISK[0-9]; do umount -f $device; done
echo OK

echo == Flashing completed successfully ==
rm -rf $TMPDIR
