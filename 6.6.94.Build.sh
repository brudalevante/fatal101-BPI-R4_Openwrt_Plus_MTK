##!/bin/bash

### Clean any old builds
rm -rf openwrt
rm -rf mtk-openwrt-feeds

### clone openwrt repo
git clone --branch openwrt-24.10 https://git.openwrt.org/openwrt/openwrt.git openwrt || true
cd openwrt; git checkout 4a18bb1056c78e1224ae3444f5862f6265f9d91c; cd -;		### - kernel 6.6.94 (Last Stable SnapShot)

### clone MTK feeds
git clone --branch master https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds || true
cd mtk-openwrt-feeds; git checkout 39d725c3e3b486405e6148c8466111ef13516808; cd -;	### - New Feed 06.08.2025
echo "39d725c" > mtk-openwrt-feeds/autobuild/unified/feed_revision

### wireless-regdb modification - this remove all regdb wireless countries restrictions
rm -rf openwrt/package/firmware/wireless-regdb/patches/*.*
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches/*.*
\cp -r my_files/500-tx_power.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches
\cp -r my_files/regdb.Makefile openwrt/package/firmware/wireless-regdb/Makefile

### remove mtk strongswan uci support patch
rm -rf mtk-openwrt-feeds/24.10/patches-feeds/108-strongswan-add-uci-support.patch

### Add patches - fix noise reading
\cp -r my_files/200-v.kosikhin-libiwinfo-fix_noise_reading_for_radios.patch openwrt/package/network/utils/iwinfo/patches/

### - TX_Power patches - I have to use both patches to fix the tx_power issue with one of my BE14 eeprom's (Otherwise # both lines out if your BE14 doesn't have the eeprom issue)
\cp -r my_files/99999_tx_power_check.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/
\cp -r my_files/9997-use-tx_power-from-default-fw-if-EEPROM-contains-0s.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/

### Openwrt_Patches etc - Update uhttpd to Git HEAD (2025-07-06)
\cp -f my_files/uhttpd/Makefile openwrt/package/network/services/uhttpd/

### Openwrt_Patches etc - ipkg-remove: fix source name / package confusion (2025-07-17)
\cp -f my_files/ipkg-remove openwrt/scripts/

### Openwrt_Patches etc - ucode: update to Git HEAD (2025-07-18)
rm -rf openwrt/package/utils/ucode/patches/020-ubus-fix-use-after-free-on-deferred-request-reply-me.patch
rm -rf openwrt/package/utils/ucode/patches/010-ubus-fix-double-registry-clear-on-disconnect.patch
\cp -f my_files/ucode/Makefile openwrt/package/utils/ucode/
\cp -f my_files/ucode/patches/100-ucode-add-padding-to-uc_resource_ext_t.patch openwrt/package/utils/ucode/patches/

### Openwrt_Patches etc - udebug: update to Git HEAD (2025-07-23)
\cp -f my_files/udebug/Makefile openwrt/package/libs/udebug/

### Openwrt_Patches etc - libubox: update to Git HEAD (2025-07-23)
\cp -f my_files/libubox/Makefile openwrt/package/libs/libubox/

### Openwrt_Patches etc - correctly set basic-rates with wpa_supplicant in wifi-scripts (2025-07-24)
\cp -f my_files/hostapd.sh openwrt/package/network/config/wifi-scripts/files/lib/netifd/

### Openwrt_Patches etc - update procd to Git HEAD (2025-08-07)
\cp -f my_files/procd/Makefile openwrt/package/system/procd/

### Openwrt_Patches etc - rpcd: backport ucode fix (2025-08-10)
\cp -r my_files/rpcd/patches openwrt/package/system/rpcd/

### Work_Around - Simple fix for the duplicating Port Status in Luci (2025-08-10)
\cp -r my_files/files openwrt/

### Add my config
\cp -f my_files/defconfig mtk-openwrt-feeds/autobuild/unified/filogic/24.10/

## adjust config
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/defconfig
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7988_wifi7_mac80211_mlo/.config
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7986_mac80211/.config

cd openwrt
bash ../mtk-openwrt-feeds/autobuild/unified/autobuild.sh filogic-mac80211-mt7988_rfb-mt7996 log_file=make

####### Further Builds (After 1st full build) to add whatever packages you need #######

# cd openwrt

# rm -rf openwrt/bin/targets/mediatek/filogic/*

# ./scripts/feeds update -a \
# ./scripts/feeds install -a

# make menuconfig
# make -j$(nproc)

exit 0
