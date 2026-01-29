  GNU nano 7.2                                                                                                   convert_dng.sh                                                                                                             
#!/bin/sh
# To run from XnViewMP's 'Open with..." function via:
# Path: /home/sep2025/convert_dng.sh
# Arguments: "%f"
# Clear XnView libraries to prevent crashes
export LD_LIBRARY_PATH=""
export QT_PLUGIN_PATH=""

INPUT="$1"
# This extracts the folder and filename safely even with spaces
DIR=$(dirname "$1")
BASE=$(basename "$1" .${1##*.})
OUTPUT="$DIR/$BASE.dng"

# The '--' is crucial: it tells dnglab to stop looking for options 
# and treat everything else as a literal file path.
if /usr/bin/dnglab convert --compression lossless --embed-raw false -f -- "$INPUT" "$OUTPUT"; then
    
    # Sync ensures the external drive actually writes the data
    sync "$OUTPUT"
    sleep 1

    # Check if the file is actually a real DNG (larger than 1MB)
    if [ -s "$OUTPUT" ] && [ $(stat -c%s "$OUTPUT") -gt 1000000 ]; then
        if /usr/bin/dnglab analyze "$OUTPUT" > /dev/null 2>&1; then
            rm "$INPUT"
            notify-send "DNG Success" "Verified: $BASE.dng" --icon=image-jpeg
        else
            notify-send "DNG Error" "Integrity check failed. RAW kept." --icon=dialog-error
        fi
    else
        notify-send "DNG Failure" "File is empty. Check drive permissions." --icon=dialog-error
        [ -f "$OUTPUT" ] && rm "$OUTPUT"
    fi
else
    notify-send "DNG Failed" "Dnglab rejected the file path." --icon=dialog-error
fi

