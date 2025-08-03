##!/bin/bash

### Clean any old builds
rm -rf openwrt
rm -rf mtk-openwrt-feeds

### clone openwrt repo
git clone --branch openwrt-24.10 https://git.openwrt.org/openwrt/openwrt.git openwrt || true
cd openwrt; git checkout 4a18bb1056c78e1224ae3444f5862f6265f9d91c; cd -;		### - kernel 6.6.94 (Last Stable SnapShot)

### clone MTK feeds
git clone --branch master https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds || true
cd mtk-openwrt-feeds; git checkout 05615a80ed680b93c3c8337c209d42a2e00db99b; cd -;	### - Platform identify by parsing .config 01.07.2025
echo "05615a8" > mtk-openwrt-feeds/autobuild/unified/feed_revision

### wireless-regdb modification - this remove all regdb wireless countries restrictions
rm -rf openwrt/package/firmware/wireless-regdb/patches/*.*
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches/*.*
\cp -r my_files/500-tx_power.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches
\cp -r my_files/regdb.Makefile openwrt/package/firmware/wireless-regdb/Makefile

### remove mtk strongswan uci support patch
rm -rf mtk-openwrt-feeds/24.10/patches-feeds/108-strongswan-add-uci-support.patch

### Add patches - fix noise reading
\cp -r my_files/200-v.kosikhin-libiwinfo-fix_noise_reading_for_radios.patch openwrt/package/network/utils/iwinfo/patches/

### - TX_Power patches - I have to use both patches to fix the tx_power issue with one of my BE14 eeprom's
\cp -r my_files/99999_tx_power_check.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/
\cp -r my_files/9997-use-tx_power-from-default-fw-if-EEPROM-contains-0s.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/kernel/mt76/patches/

### MTK_Patches - Fixes build fail with older Cryptsetup patches
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-feeds/cryptsetup-01-add-host-build.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-feeds/cryptsetup-03-enable-veritysetup.patch
\cp -r my_files/cryptsetup-01-add-host-build.patch  mtk-openwrt-feeds/autobuild/unified/filogic/24.10/patches-feeds/

### - MTK_Patches - Fix kernel panic when bridger is enabled] 01.07.2025
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3002-net-ethernet-mtk_ppe-keep-sp-in-the-info1.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3003-net-ethernet-mtk_ppe-change-to-internal-QoS-mode.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3010-net-ethernet-mtk_ppe-dispatch-short-packets-a-high-p.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3019-net-ethernet-mtk_ppe-add-adaptive-PPPQ-mode.patch
\cp -r my_files/999-3002-net-ethernet-mtk_ppe-keep-sp-in-the-info1.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-3003-net-ethernet-mtk_ppe-change-to-internal-QoS-mode.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-3010-net-ethernet-mtk_ppe-dispatch-short-packets-a-high-p.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-3019-net-ethernet-mtk_ppe-add-adaptive-PPPQ-mode.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/

### MTK_Patches - Replace patches to add tport_idx for QoS on MT7988 15.07.2025
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3020-mtk-wed-add-dma-mask-limitation-and-GFP_DMA32-for-bo.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3021-fix-SER-case-call-trace-due-to-double-free-hwrro-buf.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3022-refactor-mtk_wed_assgin-not-base-on-pci-domain.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3023-fix-wdma-rx-hang-on-wed1-after-SER.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3024-Fix-reinsert-wifi-module-cause-memory-leak-issue.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3025-Fix-Eagle-mlo-tx-T.P-too-low-issue.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3026-mtk-wed-add-mt7992-hw-path-support.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3027-dts-88d-option-type-2-support.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3028-mtk-wed-add-hwpath-wmm-support.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3029-extended-wed-debugfs.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3030-Refactor-RRO_RX_D_DRV-init-flow.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3031-add-mt7987-hwpath-support.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3032-net-ethernet-mtk_wed-add-ppe-drop.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3033-dts-mt7987-wed-changes.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3034-net-ethernet-mtk_wed-add-WDMA-disable-flow-to-WiFi-L.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3034-refactor-mtk_wed_irq_get-to-avoid-wed-status-false-a.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3035-flow-offload-add-mtkhnat-macvlan-support.patch
\cp -r my_files/QoSMT7988/999-3020-flow-offload-add-mtkhnat-macvlan-support.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3050-mtk-wed-add-dma-mask-limitation-and-GFP_DMA32-for-bo.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3051-fix-SER-case-call-trace-due-to-double-free-hwrro-buf.patch  mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3052-refactor-mtk_wed_assgin-not-base-on-pci-domain.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3053-fix-wdma-rx-hang-on-wed1-after-SER.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3054-Fix-reinsert-wifi-module-cause-memory-leak-issue.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3055-Fix-Eagle-mlo-tx-T.P-too-low-issue.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3056-mtk-wed-add-mt7992-hw-path-support.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3057-dts-88d-option-type-2-support.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3058-mtk-wed-add-hwpath-wmm-support.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3059-extended-wed-debugfs.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3060-Refactor-RRO_RX_D_DRV-init-flow.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3061-add-mt7987-hwpath-support.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3062-net-ethernet-mtk_wed-add-ppe-drop.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3063-dts-mt7987-wed-changes.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3064-net-ethernet-mtk_wed-add-WDMA-disable-flow-to-WiFi-L.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/QoSMT7988/999-3065-refactor-mtk_wed_irq_get-to-avoid-wed-status-false-a.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/

### MTK_Patches - Add mt7988a-rfb 4pcie overlays support 21.07.2025
rm -rf mtk-openwrt-feeds/24.10/files/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek/mt7988a-rfb-4pcie.dtso
rm -rf mtk-openwrt-feeds/24.10/patches-base/1120-image-mediatek-filogic-mt7988a-rfb-05-add-4pcie-overlays.patch
\cp -r my_files/mt7988a-rfb-4pcie.dtso mtk-openwrt-feeds/24.10/files/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek/
\cp -r my_files/1120-image-mediatek-filogic-mt7988a-rfb-05-add-4pcie-overlays.patch mtk-openwrt-feeds/24.10/patches-base/

### MTK_Patches - fix library searching path for veritysetup 21.07.2025
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/scripts/make-squashfs-hashed.sh
\cp -r my_files/make-squashfs-hashed.sh mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/scripts/

### MTK_Patches - Enhance the Tx throughput in WiFi7 MLO 22.07.2025
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_reset.c
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_reset.h
\cp -r my_files/mtk_eth_reset.c  mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/
\cp -r my_files/mtk_eth_reset.h  mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/

### MTK_Patches - Refactor inside-secure interrupt handler to avoid rcu stall with IPSec 24.07.2025
\cp -r my_files/999-2702-crypto-avoid-rcu-stall.patch mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/

### MTK_Patches -  Adjust cpufreq related patches and add support for mt798* cpufreqc 24.07.2025
rm -rf mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/999-cpufreq-02-mediatek-enable-using-efuse-cali-data-for-mt7988-cpu-volt.patch
\cp -r my_files/999-cpufreq-01-cpufreq-add-support-to-adjust-cpu-volt-by-efuse-cali.patch mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-cpufreq-02-cpufreq-add-cpu-volt-correction-support-for-mt7988.patch mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-cpufreq-03-mediatek-enable-using-efuse-cali-data-for-mt7988-cpu-volt.patch mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-cpufreq-04-cpufreq-add-support-to-fix-voltage-cpu.patch mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-cpufreq-05-cpufreq-mediatek-Add-support-for-MT7987.patch mtk-openwrt-feeds/24.10/files/target/linux/mediatek/patches-6.6/

### MTK_Patches - Replace patches to add Fix IPSec traffic not entering SW fast path issue 24.07.2025
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3004-netfilter-add-DSCP-learning-flow-to-xt_FLOWOFFLOAD.patch
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3016-netfilter-add-DSCP-learning-flow-to-nft_flow_offload.patch
\cp -r my_files/999-3004-netfilter-add-DSCP-learning-flow-to-xt_FLOWOFFLOAD.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-3016-netfilter-add-DSCP-learning-flow-to-nft_flow_offload.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/

### MTK_Patches - mt7988][crypto][Fix ring handler and SA register for inline mode 24.07.2025
rm -rf mtk-openwrt-feeds/feed/kernel/crypto-eip/src/ddk-wrapper.c
\cp -r my_files/ddk-wrapper.c mtk-openwrt-feeds/feed/kernel/crypto-eip/src/

### MTK_Patches - add mt7987 emmc flash mode support for mt76 29.07.2025
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek/mt7987-emmc.dtso
\cp -r my_files/mt7987-emmc.dtso mtk-openwrt-feeds/autobuild/unified/filogic/24.10/files/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek/

### MTK_Patches - Convert input param to u8  30.07.2025
rm -rf mtk-openwrt-feeds/feed/app/regs/src/regs.c
\cp -r my_files/regs.c mtk-openwrt-feeds/feed/app/regs/src/

### Openwrt_Patches etc - ipkg-remove: fix source name / package confusion
rm -rf openwrt/scripts/ipkg-remove
\cp -r my_files/ipkg-remove openwrt/scripts/

### Add my config
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/24.10/defconfig
\cp -r my_files/defconfig mtk-openwrt-feeds/autobuild/unified/filogic/24.10/

### - MTK_Patches - fix netfilter-add-DSCP-learning-flow-to-xt_FLOWOFFLOAD patch
rm -rf rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3004-netfilter-add-DSCP-learning-flow-to-xt_FLOWOFFLOAD.patch
\cp -r my_files/999-3004-netfilter-add-DSCP-learning-flow-to-xt_FLOWOFFLOAD.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/

### - MTK_Patches - Update remove upstream patches
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/remove_list.txt
\cp -r my_files/remove_list.txt mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/

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


