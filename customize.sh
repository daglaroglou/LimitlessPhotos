#!/bin/bash

# Credits for the method to @cuynu
# Dev: @daglaroglou
# https://gitlab.com/cuynu/gphotos-unlimited-zygisk

process_sysconfig_dir() {
    local source_dir="$1"
    local target_dir="$2"
    
    mkdir -p "$MODPATH/$target_dir"
    
    for filepath in "$source_dir"/*; do
        [ -e "$filepath" ] || continue
        
        filename=$(basename "$filepath")
        
        if grep -q "PIXEL_20\(1[7-9]\|2[0-2]\)_\|PIXEL_.*PRELOAD" "$filepath"; then
            if [ ! -f "$MODPATH/$target_dir/$filename" ]; then
                grep -v "PIXEL_20\(1[7-9]\|2[0-2]\)_\|PIXEL_.*PRELOAD" "$filepath" > "$MODPATH/$target_dir/$filename"
            fi
        fi
    done
}

copy_existing_module_files() {
    local source_dir="$1"
    local target_dir="$2"
    [ -d "$source_dir" ] || return
    
    mkdir -p "$MODPATH/$target_dir"
    
    for filepath in "$source_dir"/*; do
        [ -e "$filepath" ] || continue
        
        filename=$(basename "$filepath")
        
        if [ ! -f "$MODPATH/$target_dir/$filename" ]; then
            cp -f "$filepath" "$MODPATH/$target_dir/$filename"
        fi
    done
}

process_sysconfig_dir "/system/product/etc/sysconfig" "system/product/etc/sysconfig"
process_sysconfig_dir "/system/etc/sysconfig" "system/etc/sysconfig"

copy_existing_module_files "/data/adb/modules/LimitlessPhotos/system/product/etc/sysconfig" "system/product/etc/sysconfig"
copy_existing_module_files "/data/adb/modules/LimitlessPhotos/system/etc/sysconfig" "system/etc/sysconfig"