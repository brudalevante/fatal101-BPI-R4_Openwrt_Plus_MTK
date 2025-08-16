### BPI-R4 - Openwrt + Kernel 6.6.94 + MTK-Feeds (Very stable build)

For other build platforms please see openwrt documentation at: https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem

Run on Ubuntu 24.04 or later

`sudo apt update`

`sudo apt install build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev python3-setuptools rsync swig unzip zlib1g-dev file wget`

`git clone https://github.com/Gilly1970/BPI-R4_Openwrt_Plus_MTK.git`

`sudo chmod 776 -R BPI-R4_Openwrt_Plus_MTK`

`cd BPI-R4_Openwrt_Plus_MTK`

`sudo chmod +x ./6.6.94.Build.sh`

`./6.6.94.Build.sh`

### For latest compiled bpi-r4 sysupgradeb/sdcard images can be downloaded from mediafire.. All new images from 10.08.2025 already have the duplicated "eth & lan ports" fix in the built images.

Images for BE14 without the eeprom issue - https://www.mediafire.com/file/m3hu1j4op8asa29/BPI_R4_Images_without_TX_Power_patches_15.08.2025.zip

Images for BE14 with the eeprom issue - https://www.mediafire.com/file/n5pmpdqxqq9t78a/BPI-R4_Images_with_TX_Power_patches_15.08.2025.zip

### Updated with new patchs to remove the duplicating lan ports issue showing in Luci..

If your using my build use this patch for the earlier openwrt-24.10 commits - 3703-Gillys-Remove-duplicated-ports.patch

`cp -f my_files/3703-Gillys-Remove-duplicated-ports.patch mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-base/`

For the newer openwrt-24.10 commit builds use this patch instead - 3703-remove-02_network.orig.patch

`cp -f my_files/3703-remove-02_network.orig.patch mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-base/`
