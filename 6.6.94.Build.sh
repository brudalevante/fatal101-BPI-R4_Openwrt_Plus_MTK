#!/bin/bash
# ==================================================================================
# BPI-R4 - OpenWrt with MTK-Feeds Build Script
# ==================================================================================
# Please Note - IF you use the custom setup scripts for 'uci-defaults'.. As a precaution
#               they will be auto convert with the dos2unix tool to correct any DOS line 
#               endings that may be present. Some users edit in windows and pass the 
#               files across to the build system, which can causes errors in unix based
#               systems.           
# Build system Install Note  - Run on Ubuntu 24.04 or later
#                            - sudo apt update
#                            - sudo apt install dos2unix
# Usage:
#   
#   ./6.6.94.Build.sh
# 
# ==================================================================================

set -eu

# --- uci-defaults Scripts Selectable Options ---
# Change this variable to select a different setup script from the 'scripts' directory.
# To use - SETUP_SCRIPT_NAME="999-simple-dumb_AP-wifi-Setup.sh" or "" (an empty string) to skip this step entirely.

readonly SETUP_SCRIPT_NAME=""

# --- Variables ---
# Define openwrt repository URL and specific commits hashes here.
readonly OPENWRT_REPO="https://git.openwrt.org/openwrt/openwrt.git"
readonly OPENWRT_BRANCH="openwrt-24.10"
readonly OPENWRT_COMMIT="4a18bb1056c78e1224ae3444f5862f6265f9d91c"    # - kernel 6.6.94 (Last Stable SnapShot)
# Define mtk-openwrt-feeds repository URL and specific commits hashes here.
readonly MTK_FEEDS_REPO="https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds"
readonly MTK_FEEDS_BRANCH="master"
readonly MTK_FEEDS_COMMIT="1705eb8f024fde39047d1be1c9fd9c335162adff"    # - Updated to latest commit

# Define local directory names.
readonly SOURCE_PATCH_DIR="patches"
readonly SOURCE_FILES_DIR="files"
readonly SETUP_SCRIPT_SOURCE_DIR="scripts"

# Default build directories for openwrt and mtk-feeds 
readonly OPENWRT_DIR="openwrt"
readonly MTK_FEEDS_DIR="mtk-openwrt-feeds"

# --- Functions ---

log() {
    echo "$1"
}

git_clone() {
    local repo_url=$1
    local branch=$2
    local commit_hash=$3
    local target_dir=$4

    if [ -d "$target_dir" ]; then
        log "Directory '$target_dir' already exists. Skipping clone."
        return
    fi

    log "Cloning $branch branch from $repo_url..."
    git clone --branch "$branch" "$repo_url" "$target_dir"
    log "Checking out specific commit: $commit_hash"
    (cd "$target_dir" && git checkout "$commit_hash")
}

# --- Applies all patches from the patches directory to the build tree ---
#           - You can edit add, delete or "" any of the below patches to your liking...
apply_patches() {
    log "Applying custom patches..."

    # Wireless regulatory database modifications (removes country restrictions)
    log "Patching wireless-regdb..."
    rm -f "$OPENWRT_DIR/package/firmware/wireless-regdb/patches/"*
    rm -f "$MTK_FEEDS_DIR/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches/"*
    cp "$SOURCE_PATCH_DIR/500-tx_power.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches/"
    cp "$SOURCE_PATCH_DIR/regdb.Makefile" "$OPENWRT_DIR/package/firmware/wireless-regdb/Makefile"

    # Remove conflicting MTK strongswan patch
    rm -f "$MTK_FEEDS_DIR/24.10/patches-feeds/108-strongswan-add-uci-support.patch"

    # Various hardware and software patchs
    log "Applying hardware and software patchs..."
    cp "$SOURCE_PATCH_DIR/999-2764-net-phy-sfp-add-some-FS-copper-SFP-fixes.patch" "$OPENWRT_DIR/target/linux/mediatek/patches-6.6/"
	cp "$SOURCE_PATCH_DIR/1007-mt7988a.dtsi.patch" "$MTK_FEEDS_DIR/24.10/patches-base/"
    cp "$SOURCE_PATCH_DIR/200-v.kosikhin-libiwinfo-fix_noise_reading_for_radios.patch" "$OPENWRT_DIR/package/network/utils/iwinfo/patches/"
    cp -f "$SOURCE_PATCH_DIR/0001-mt76-package-makefile.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/mac80211/24.10/patches-base/"
	
	# BPI-R4 - BE14 pathces - fix EEPROM issues with the faulty BE14 cards.. (Comment out the below patches, if your card doesn't have EEPROM issues)
    log "Applying patches for the faulty BE14 EEPROM cards..."
	#cp "$SOURCE_PATCH_DIR/999-mt7988a-bananapi-bpi-r4-BE14000-binmode.patch" "$OPENWRT_DIR/target/linux/mediatek/patches-6.6/"  # -- New Patch
	cp "$SOURCE_PATCH_DIR/99999_tx_power_check.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/"
	cp "$SOURCE_PATCH_DIR/9997-use-tx_power-from-default-fw-if-EEPROM-contains-0s.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/"

    # Luci UI fixes
    log "Applying Luci patch to remove duplicated ports..."
    cp "$SOURCE_PATCH_DIR/3703-Gillys-Remove-duplicated-ports.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/24.10/patches-base/"

    # System script fixes
    log "Applying ipkg-remove script fix..."
    cp "$SOURCE_PATCH_DIR/ipkg-remove" "$OPENWRT_DIR/scripts/"
}

# --- Prepares custom configuration files, scripts, and permissions.
#           - Do not change any thing below this point.. (unless you know what your doing of course ;) 
prepare_custom_files() {
    log "Preparing custom files and scripts..."
    log "Checking for general /etc files..."
    local etc_source_dir="$SOURCE_FILES_DIR/etc"
    local etc_target_path="$OPENWRT_DIR/files/etc"
    if [ -d "$etc_source_dir" ] && [ -n "$(ls -A "$etc_source_dir")" ]; then
        log "Removing .gitkeep placeholder files from '$etc_source_dir'..."
        find "$etc_source_dir" -type f -name ".gitkeep" -delete
        log "Found files in '$etc_source_dir'. Copying to target..."
        mkdir -p "$etc_target_path"
        cp -r "$etc_source_dir"/. "$etc_target_path/"
        find "$etc_target_path" -type f -exec dos2unix {} +
    else
        log "No general /etc files found. Skipping."
    fi

    log "Checking for config files..."
    local config_source_dir="$SOURCE_FILES_DIR/config"
    local config_target_path="$OPENWRT_DIR/files/etc/config"
    if [ -d "$config_source_dir" ] && [ -n "$(ls -A "$config_source_dir")" ]; then
        log "Found files in '$config_source_dir'. Copying to target..."
        mkdir -p "$config_target_path"
        cp -r "$config_source_dir"/. "$config_target_path/"
        log "Running dos2unix on all copied UCI config files..."
        find "$config_target_path" -type f -exec dos2unix {} +
    else
        log "No custom config files found. Skipping."
    fi

    local uci_defaults_path="$OPENWRT_DIR/files/etc/uci-defaults"
    if [ -n "$SETUP_SCRIPT_NAME" ]; then
        local script_source_path="$SETUP_SCRIPT_SOURCE_DIR/$SETUP_SCRIPT_NAME"

        if [ ! -f "$script_source_path" ]; then
            echo "==================================================================="
            echo "  ERROR: Setup script not found at: $script_source_path"
            echo "==================================================================="
            exit 1
        fi

        log "Adding setup script: $SETUP_SCRIPT_NAME"
        mkdir -p "$uci_defaults_path"
        cp "$script_source_path" "$uci_defaults_path/"
        dos2unix "$uci_defaults_path/$SETUP_SCRIPT_NAME"
    else
        log "No setup script selected. Skipping uci-defaults."
    fi

    log "Setting final file permissions..."
    if [ -d "$OPENWRT_DIR/files" ]; then
        chmod -R u=rwX,go=rX "$OPENWRT_DIR/files"
    fi

    if [ -n "$SETUP_SCRIPT_NAME" ] && [ -f "$uci_defaults_path/$SETUP_SCRIPT_NAME" ]; then
        log "Making setup script executable..."
        chmod 755 "$uci_defaults_path/$SETUP_SCRIPT_NAME"
    fi
}

# --- Configures the build ---
configure_build() {
    log "Configuring the build..."

    cp "$SOURCE_PATCH_DIR/defconfig" "$MTK_FEEDS_DIR/autobuild/unified/filogic/24.10/"

    log "Disabling 'perf' package in configs..."
    sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' "$MTK_FEEDS_DIR/autobuild/unified/filogic/mac80211/24.10/defconfig"
    sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' "$MTK_FEEDS_DIR/autobuild/autobuild_5.4_mac80211_release/mt7988_wifi7_mac80211_mlo/.config"
    sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' "$MTK_FEEDS_DIR/autobuild/autobuild_5.4_mac80211_release/mt7986_mac80211/.config"
}


# --- Main Script Execution ---
main() {
    log "Starting OpenWrt build process..."
    log "Cleaning up previous build directories..."
    rm -rf "$OPENWRT_DIR" "$MTK_FEEDS_DIR"

    git_clone "$OPENWRT_REPO" "$OPENWRT_BRANCH" "$OPENWRT_COMMIT" "$OPENWRT_DIR"
    git_clone "$MTK_FEEDS_REPO" "$MTK_FEEDS_BRANCH" "$MTK_FEEDS_COMMIT" "$MTK_FEEDS_DIR"
    
    echo "${MTK_FEEDS_COMMIT:0:7}" > "$MTK_FEEDS_DIR/autobuild/unified/feed_revision"

    apply_patches

    prepare_custom_files

    configure_build

    log "Starting the MediaTek autobuild script..."
    (cd "$OPENWRT_DIR" && bash "../$MTK_FEEDS_DIR/autobuild/unified/autobuild.sh" filogic-mac80211-mt7988_rfb-mt7996 log_file=make)

    log "Build process finished successfully!"
    log "You can find the output images in '$OPENWRT_DIR/bin/targets/mediatek/filogic/'"
}

main

exit 0
