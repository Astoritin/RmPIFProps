#!/system/bin/sh
SKIPUNZIP=1

MOD_PROP="${TMPDIR}/module.prop"
MOD_NAME="$(grep_prop name "$MOD_PROP")"
MOD_VER="$(grep_prop version "$MOD_PROP") ($(grep_prop versionCode "$MOD_PROP"))"

is_magisk() {

    if ! command -v magisk >/dev/null 2>&1; then
        return 1
    fi

    MAGISK_V_VER_NAME="$(magisk -v)"
    MAGISK_V_VER_CODE="$(magisk -V)"
    case "$MAGISK_V_VER_NAME" in
        *"-alpha"*) MAGISK_BRANCH_NAME="Alpha" ;;
        *"-lite"*)  MAGISK_BRANCH_NAME="Magisk Lite" ;;
        *"-kitsune"*) MAGISK_BRANCH_NAME="Kitsune Mask" ;;
        *"-delta"*) MAGISK_BRANCH_NAME="Magisk Delta" ;;
        *) MAGISK_BRANCH_NAME="Magisk" ;;
    esac
    DETECT_MAGISK="true"
    return 0

}

is_kernelsu() {
    if [ -n "$KSU" ]; then
        DETECT_KSU="true"
        ROOT_SOL="KernelSU"
        return 0
    fi
    return 1
}

is_apatch() {
    if [ -n "$APATCH" ]; then
        DETECT_APATCH="true"
        ROOT_SOL="APatch"
        return 0
    fi
    return 1
}

install_env_check() {

    MAGISK_BRANCH_NAME="Official"
    ROOT_SOL="Magisk"
    ROOT_SOL_COUNT=0

    is_kernelsu && ROOT_SOL_COUNT=$((ROOT_SOL_COUNT + 1))
    is_apatch && ROOT_SOL_COUNT=$((ROOT_SOL_COUNT + 1))
    is_magisk && ROOT_SOL_COUNT=$((ROOT_SOL_COUNT + 1))

    if [ "$DETECT_KSU" = "true" ]; then
        ROOT_SOL="KernelSU"
        ROOT_SOL_DETAIL="KernelSU (kernel:$KSU_KERNEL_VER_CODE, ksud:$KSU_VER_CODE)"
    elif [ "$DETECT_APATCH" = "true" ]; then
        ROOT_SOL="APatch"
        ROOT_SOL_DETAIL="APatch ($APATCH_VER_CODE)"
    elif [ "$DETECT_MAGISK" = "true" ]; then
        ROOT_SOL="Magisk"
        ROOT_SOL_DETAIL="$MAGISK_BRANCH_NAME (${MAGISK_VER_CODE:-$MAGISK_V_VER_CODE})"
    fi

    if [ "$ROOT_SOL_COUNT" -gt 1 ]; then
        ROOT_SOL="Multiple"
        ROOT_SOL_DETAIL="Multiple"
    elif [ "$ROOT_SOL_COUNT" -lt 1 ]; then
        ROOT_SOL="Unknown"
        ROOT_SOL_DETAIL="Unknown"
    fi

}

show_system_info() {

    ui_print "- Device: $(getprop ro.product.brand) $(getprop ro.product.model) ($(getprop ro.product.device))"
    ui_print "- OS: Android $(getprop ro.build.version.release) (API $(getprop ro.build.version.sdk)), $(getprop ro.product.cpu.abi | cut -d '-' -f1)"
    ui_print "- Kernel: $(uname -r)"

}

print_line() {

    length=${1:-39}
    symbol=${2:-*}

    line=$(printf "%-${length}s" | tr ' ' "$symbol")
    ui_print "$line"

}

rmprops() {

    props_list=$1

    [ -z "$props_list" ] && return 1

    for prop in $props_list; do
        prop_value="$(resetprop "$prop")"
        if [ -n "$prop_value" ]; then
            resetprop -p -d "$prop"
            result_resetprop=$?
            ui_print "- Process $prop=$prop_value (${result_resetprop})"
        fi
    done

}

ui_print "- Setting up $MOD_NAME"
ui_print "- Version: $MOD_VER"
install_env_check
show_system_info
ui_print "- Installing from $ROOT_SOL app"
ui_print "- Root: $ROOT_SOL_DETAIL"
ui_print "- Welcome to use $MOD_NAME!"
print_line
ui_print " "
ui_print "  $MOD_NAME"
ui_print "  will start removing properties of"
ui_print "  PiHooks/PixelProps/PlayIntegrityFix"
ui_print "  inbuilt by insane custom AOSP based ROM"
ui_print "  after 3 seconds."
ui_print " "
print_line
sleep 3
pi_props_to_remove=$(resetprop | grep -E "(pihook|pixelprops|spoof|entryhooks)" | sed -r "s/^\[([^]]+)\].*/\1/")
count_result=$(echo "$pi_props_to_remove" | grep -vE '^[[:space:]]*(#|$)' | wc -l)
ui_print "- Found ${count_result} properties to remove"
ui_print "- Starting removing..."
rmprops "$pi_props_to_remove"
ui_print "- Done"
print_line
ui_print " "
ui_print "- Please reboot your device to avoid"
ui_print "- Property Modified (10) in Native Test"
ui_print " "
print_line
ui_print " "
ui_print "- $MOD_NAME"
ui_print "- has finished its job"
ui_print "- It won't be installed in your system"
ui_print " "
print_line
abort "- Bye bye!"