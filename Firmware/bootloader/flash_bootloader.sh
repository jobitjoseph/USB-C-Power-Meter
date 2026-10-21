#!/bin/bash

# Flash script for SAMD21 UF2 Bootloader
# This script uses OpenOCD to unlock the BOOTPROT fuse and flash the bootloader binary.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
BIN_FILE="$SCRIPT_DIR/bootloader-usbcm-v4.0.0+.bin"

if [ ! -f "$BIN_FILE" ]; then
    echo "Error: Bootloader binary not found at $BIN_FILE"
    exit 1
fi

echo "Flashing $BIN_FILE to SAMD21 via SWD (J-Link)..."

openocd -f interface/jlink.cfg -c "transport select swd" -f target/at91samdXX.cfg -c "init; reset halt; at91samd bootloader 0; program $BIN_FILE verify reset exit 0x00000000"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Flashing complete! BOOTPROT fuse reset and bootloader installed successfully."
else
    echo ""
    echo "❌ Error during flashing. Please check your J-Link connection."
    exit 1
fi
