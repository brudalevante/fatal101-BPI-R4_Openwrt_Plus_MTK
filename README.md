### BPI-R4 - Openwrt + Kernel 6.6.94 + MTK-Feeds (Very stable build)

For other build platforms please see openwrt documentation at: https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem

Run on Ubuntu 24.04 or later

`sudo apt update`

`sudo apt install build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev python3-setuptools rsync swig unzip zlib1g-dev file wget`

`git clone https://github.com/Gilly1970/BPI-R4_Openwrt_Plus_MTK.git`

`chmod 776 -R BPI-R4_Openwrt_Plus_MTK`

`cd BPI-R4_Openwrt_Plus_MTK`

`sudo chmod +x ./6.6.94.Build.sh`

`./6.6.94.Build.sh`
