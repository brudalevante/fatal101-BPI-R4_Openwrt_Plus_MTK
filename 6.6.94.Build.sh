#!/bin/bash

### Clean any old builds
rm -rf openwrt
rm -rf mtk-openwrt-feeds

### clone openwrt repo
git clone --branch openwrt-24.10 https://git.openwrt.org/openwrt/openwrt.git openwrt || true
cd openwrt; git checkout 4a18bb1056c78e1224ae3444f5862f6265f9d91c; cd -;		### - kernel 6.6.94 (Last Stable SnapShot)

### clone MTK feeds
git clone --branch master https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds || true
cd mtk-openwrt-feeds; git checkout d062be2140d6c4317b339bfc28e02e8092036d87; cd -;	### - Fix kernel panic when bridger is enabled (Stable MTK feed)
echo "d062be" > mtk-openwrt-feeds/autobuild/unified/feed_revision

### wireless-regdb modification - this remove all regdb wireless countries restrictions
#rm -rf openwrt/package/firmware/wireless-regdb/patches/*.*
#rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches/*.*
#\cp -r my_files/500-tx_power.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches
#\cp -r my_files/regdb.Makefile openwrt/package/firmware/wireless-regdb/Makefile

### remove mtk strongswan uci support patch
rm -rf mtk-openwrt-feeds/24.10/patches-feeds/108-strongswan-add-uci-support.patch

### Add patches - fix noise reading 
\cp -r my_files/200-v.kosikhin-libiwinfo-fix_noise_reading_for_radios.patch openwrt/package/network/utils/iwinfo/patches/

### - TX_Power patches - I have to use both patches to fix the tx_power issue with the BE14 2.4g & 5g eeprom's
#\cp -r my_files/99999_tx_power_check.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/
#\cp -r my_files/9997-use-tx_power-from-default-fw-if-EEPROM-contains-0s.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/

### MTK_Patches - Enhance the Tx throughput in WiFi7 MLO
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_reset.c
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_reset.h
\cp -r my_files/mtk_eth_reset.c  mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/
\cp -r my_files/mtk_eth_reset.h  mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/

### Fixes build fail with older Cryptsetup patches
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-feeds/cryptsetup-01-add-host-build.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-feeds/cryptsetup-03-enable-veritysetup.patch
\cp -r my_files/cryptsetup-01-add-host-build.patch  mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-feeds/

## adjust some config
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/defconfig
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7988_wifi7_mac80211_mlo/.config
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7986_mac80211/.config

cd openwrt
bash ../mtk-openwrt-feeds/autobuild/unified/autobuild.sh filogic-mac80211-mt7988_rfb-mt7996 log_file=make

####### Further Builds (After 1st full build) to add the extra packages you need #######

# cd openwrt

# rm -rf openwrt/bin/targets/mediatek/filogic/*

# ./scripts/feeds update -a \
# ./scripts/feeds install -a

# make menuconfig
# make -j$(nproc)

exit 0


