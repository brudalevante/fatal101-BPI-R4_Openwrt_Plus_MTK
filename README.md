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

### For latest compiled bpi-r4 sysupgradeb/sdcard images can be downloaded from mediafire..

Images for BE14 without the eeprom issue - https://www.mediafire.com/file/dwplag3crenif6a/BPI_R4_Images_without_TX_Power_patches_09.08.2025.zip

Images for BE14 with the eeprom issue - https://www.mediafire.com/file/jm28xdumiui4idq/BPI-R4_Images_with_TX_Power_patches_09.08.2025.zip

### Duplicating lanes showing under Port Status in Luci...
You will see it in the Luci interface Status/Overview under Port Status. This is only a cosmetic issue and doesn't impact functionality or performanceissue in any way. To fix the duplicated Ports showing in Luci, SSH into your router and run the below SED... 

`sed -i '42d;43d;44d;45d;53d;54d' /etc/board.json`

Please Note - If your not running one of my images then manually edit /etc/board.json instead.. The board.json file from a different build might be formated differently to my build and you could delete the wrong lines of code.
