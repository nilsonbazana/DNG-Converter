#!/bin/sh
# Environment cleanup to prevent XnView library conflicts
export LD_LIBRARY_PATH=""
export QT_PLUGIN_PATH=""

INPUT="$1"
BASE=$(basename "$1" .${1##*.})
FINAL_DIR=$(dirname "$1")
TEMP_DNG="/tmp/$BASE.dng"

# 1. Convert to local /tmp to bypass drive permission issues
if /usr/bin/dnglab convert --compression lossless --embed-raw false -f -- "$INPUT" "$TEMP_DNG"; then
    
    # 2. Verify: Check if file exists and has data
    if [ -s "$TEMP_DNG" ] && /usr/bin/dnglab analyze "$TEMP_DNG" > /dev/null 2>&1; then
        
        # 3. Move verified file to external drive and cleanup original
        if mv "$TEMP_DNG" "$FINAL_DIR/$BASE.dng"; then
            rm "$INPUT"
            notify-send "DNG Success" "Verified and Saved: $BASE.dng" --icon=image-jpeg
        else
            notify-send "DNG Error" "Could not move file to disk. Check permissions." --icon=dialog-error
        fi
    else
        notify-send "DNG Failure" "Local conversion/verification failed." --icon=dialog-error
        rm -f "$TEMP_DNG"
    fi
else
    notify-send "DNG Failed" "Dnglab rejected the input file path." --icon=dialog-error
fi
