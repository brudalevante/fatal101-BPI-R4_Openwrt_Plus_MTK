# **BPI-R4 - Openwrt + Kernel 6.6.94 + MTK-Feeds**

I finally found some time to finish reworking the 6.6.94.Build script to make it a bit more user friendly for those users that aren't as familiar with linux based systems.

The new script handles everything from cloning the source code and applying custom patches to configuring the build and preparing user-specific files.

## **Features**

* **Automated Build Process**: Clones the correct versions of OpenWrt and the MediaTek feeds from scratch for a clean, reproducible build every time.  
* **Customizable Patches**: Easily apply or disable patches for hardware fixes (e.g., SFP, EEPROM), software improvements, and UI enhancements.  
* **Flexible Configuration**:  
  * Place your custom configuration files (`like wireless, network, firewall, or shadow`) in the `files/` directory to have them included in the final image.  
  * Use a custom `.config` file (`defconfig`) to define the exact packages and kernel modules for your build.  
* **First-Boot Setup Scripts**: Add setup scripts to the `scripts/` directory, which will run on the device's first boot to automate initial configuration (e.g., setting up a dumb AP).  
* **Safety Checks**: The script automatically converts file line endings with `dos2unix` to prevent issues when editing files on Windows.

## **How to Use**

1. **Prerequisites**: Ensure you have a compatible build environment, such as **Ubuntu 24.04 LTS**. You will also need to install `dos2unix`:  
   `sudo apt update`
   
   `sudo apt install build-essential clang flex bison g++ gawk gcc-multilib g++-multilib \\`
   
   `gettext git libncurses5-dev libssl-dev python3-distutils rsync unzip zlib1g-dev \\`
   
   `file wget dos2unix`

2. **Clone repo**:

   `git clone https://github.com/Gilly1970/BPI-R4_Openwrt_Plus_MTK.git`
   
   `sudo chmod 776 -R BPI-R4_Openwrt_Plus_MTK`

3. **Prepare Your Custom Files**:  
   * Place any custom patches you want to apply into the patches/ directory.  
   * Place your final configuration files (e.g., shadow, network) into the files/etc/ or files/config/ directories.  
   * If you have a first-boot script, place it in the scripts/ directory.  
4. **Configure the Build Script**:  
   * Open the build script (e.g., 6.6.94.Build.sh) in a text editor.  
   * At the top of the file, set the `SETUP\_SCRIPT\_NAME` variable to the name of your first-boot script, or leave it as "" to disable it.  
   * Review the apply\_patches function to enable or disable any patches by commenting or uncommenting the cp commands.  
5. **Run the Script**:  
   * Make the script executable:  
     `chmod \+x 6.6.94.Build.sh`

   * Execute the script:  
     `./6.6.94.Build.sh`

The build process will begin and may take a significant amount of time, depending on your system's performance. Once complete, the firmware images will be located in the `openwrt/bin/targets/mediatek/filogic/ directory`.
## **Customization**

This build is designed to be highly customizable. Here are the key directories you can modify:

* `patches/`: Contains all `.patch` files and Makefiles that modify the source code. The defconfig file, which defines the build's package selection, is also located here.  
* `files/`: This directory mirrors the root filesystem of the final image.  
  * `files/etc/`: For general configuration files like `shadow`.  
  * `files/config/`: For UCI-specific configuration files like `network, wireless, and firewall`.  
* `scripts/`: Contains shell scripts that can be run on the first boot via the `uci-defaults` mechanism.

By adding or removing files in these directories, you can tailor the final firmware to your exact needs without having to modify the main build script logic.

### **For latest compiled bpi-r4 sysupgradeb/sdcard images can be downloaded from mediafire..**

Images for BE14 without the eeprom issue - https://www.mediafire.com/file/m3hu1j4op8asa29/BPI_R4_Images_without_TX_Power_patches_15.08.2025.zip

### **Update - I've added a new patch for those with the BE14 with the eeprom issue..**

Images for BE14 with the eeprom issue - https://www.mediafire.com/file/n5pmpdqxqq9t78a/BPI-R4_Images_with_TX_Power_patches_15.08.2025.zip

### **Updated with new patchs to remove the duplicating lan ports issue showing in Luci..**

If your using my build or any openwrt-24.10 commits pre-kernel 6.6.11 use - 3703-Gillys-Remove-duplicated-ports.patch

`cp "$SOURCE_PATCH_DIR/3703-Gillys-Remove-duplicated-ports.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/24.10/patches-base/"`

If your using openwrt-24.10 commit with kernel 6.6.11 use this patch instead - 3703-remove-02_network.orig.patch

`cp "$SOURCE_PATCH_DIR/3703-remove-02_network.orig.patch" "$MTK_FEEDS_DIR/autobuild/unified/filogic/24.10/patches-base/"`

### **Update Notes..**

* I've added a new patch that was posted by "moi_eric11" for the faulty BE14 (`999-mt7988a-bananapi-bpi-r4-BE14000-binmode.patch`) if you want to test it out?
*    - I compiled the new patch on its own without the other patches but on my test BE14 I lost the options to change the Maximum transmit power: ?
*    - I compiled again and inculded the 9997-use-tx_power-from-default-fw-if-EEPROM-contains-0s.patch like I do with the 99999_tx_power_check.patch but still no change.
*    - Went back to using both the 99999_tx_power_check.patch & 9997-use-tx_power-from-default-fw-if-EEPROM-contains-0s.patch for my test BE14 to work correctly again.
