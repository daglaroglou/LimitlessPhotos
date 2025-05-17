# /bin/bash
# Initial method: @cuynu
# https://gitlab.com/cuynu/gphotos-unlimited-zygisk
# Modified by: @daglaroglou

ui_print ""
ui_print "» Checking device compatibility..."
sleep 0.5
if [ "$(getprop ro.build.version.sdk)" -lt "30" ]; then
  ui_print "! Warning: This module works best on Android 11+ (SDK 30+)"
  ui_print "  Your device is running $(getprop ro.build.version.release)"
  ui_print "  Some features may not work properly"
  sleep 1
else
  ui_print "✓ Android version: $(getprop ro.build.version.release)"
fi
ui_print ""
ui_print "» Patching Google Photos..."
sleep 1

PIXEL_PATTERNS="PIXEL_2017_PRELOAD\|PIXEL_2018_PRELOAD\|PIXEL_2019_PRELOAD\|PIXEL_2020_\|PIXEL_2021_\|PIXEL_2022_"

process_sysconfig() {
    local src_dir="$1"
    local dest_dir="$2"
    
    mkdir -p "$MODPATH/$dest_dir"
    
    for file in "$src_dir"/*; do
        [ -f "$file" ] || continue
        local filename=$(basename "$file")
        local dest_file="$MODPATH/$dest_dir/$filename"
        if grep -q "$PIXEL_PATTERNS" "$file"; then
            [ ! -f "$dest_file" ] && grep -v "$PIXEL_PATTERNS" "$file" > "$dest_file"
        fi
    done
}

process_sysconfig "/system/product/etc/sysconfig" "system/product/etc/sysconfig"
process_sysconfig "/system/etc/sysconfig" "system/etc/sysconfig"

OLD_MODULE="/data/adb/modules/LimitlessPhotos"
if [ -d "$OLD_MODULE" ]; then
    for dir in "system/product/etc/sysconfig" "system/etc/sysconfig"; do
        if [ -d "$OLD_MODULE/$dir" ]; then
            mkdir -p "$MODPATH/$dir"
            for file in "$OLD_MODULE/$dir"/*; do
                [ -f "$file" ] || continue
                filename=$(basename "$file")
                [ ! -f "$MODPATH/$dir/$filename" ] && cp -f "$file" "$MODPATH/$dir/$filename"
            done
        fi
    done
fi

ui_print ""
ui_print "✓ Module installed successfully!"
ui_print ""
ui_print "********************************"
