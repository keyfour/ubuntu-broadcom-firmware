#!/bin/bash
#
# Copyright (c) Aleksandr Karpov <keyfour13@gmail.com>
#
DRIVER_ARCHIVE=68560_Bluetooth_Broadcom_Win81_64_VER12009840.zip
TMP_DIR=/tmp/bluetooth_brc_drv
INFO_FILE=Win64/bcbtums-win8x64-brcm.inf
OUTPUT_FILE="$TMP_DIR/firmware.hcd"

DEVICE=$(lsusb | grep Broadcom)

if [ "$DEVICE" ]; then

    mkdir -v $TMP_DIR

    unzip  -q -d $TMP_DIR $DRIVER_ARCHIVE

    num=$(echo $DEVICE | awk '{ print $6 }')
    firmwares=$(cat $TMP_DIR/$INFO_FILE | grep  "VID_$(echo $num | \
        awk -F ":" '{ print toupper($1) }')&PID_$(echo $num | \
        awk -F ":" '{ print toupper($2) }')" | \
        awk -F "[=,]" 'NF>2 { print $2 }';)
    
    for firmware in $firmwares; do
        echo "Find firmware $firmware"
        file_found=false
        firmware_file=$(cat $TMP_DIR/$INFO_FILE | \
            grep -A 4 "\[$firmware.CopyList\]" | grep .hex)

        if [ "$firmware_file" ]; then
            file_found=true
            echo "Firmware file found $firmware_file"
        else
            echo "Firmware file not found"
        fi;

        if [ $file_found == true ]; then
            git clone git://github.com/jessesung/hex2hcd.git $TMP_DIR/hex2hcd
            make -C $TMP_DIR/hex2hcd
            $TMP_DIR/hex2hcd/hex2hcd $TMP_DIR/Win64/$firmware_file $OUTPUT_FILE 

            if [ $(uname -r | awk -F "." ' { print $1$2 }') -gt 47 ]; then
                mv -v $OUTPUT_FILE $TMP_DIR/BCM-$(echo $num | \
                    awk -F ":" '{ print $1 }')-$(echo $num | \
                    awk -F ":" '{ print $2 }').hcd
            elif [ $(uname -r | awk -F "." ' { print $1$2 }') -gt 41 ]; then
                mv -v $OUTPUT_FILE $TMP_DIR/BCM.hcd
            else
                echo "Probably unsupported kernel version $(uname -r)"
            fi;
            sudo cp -rvf $TMP_DIR/*.hcd /lib/firmware/brcm
        fi;
    done;

    rm -rf $TMP_DIR
    echo Done!
fi;
