#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://gitlab.com/OrangeFox/sync.git"
DEVICE=CD6
DT_LINK="https://github.com/mastersenpai05/twrp_device_TECNO_CD6 -b orangefox"
DT_PATH=device/TECNO/$DEVICE

USE_SSH="0";

echo " ===+++ Setting up Build Environment +++==="
cd ~ && git clone https://github.com/akhilnarang/scripts && bash scripts/setup/android_build_env.sh

echo " ===+++ Syncing Recovery Sources +++==="
git clone $MANIFEST
cd ~/OrangeFox_10/sync
./get_fox_10.sh ~/OrangeFox_10/fox_10.0
cd ~/OrangeFox_10/fox_10.0
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
rm -rf out
source build/envsetup.sh

version=$(cat bootable/recovery/variables.h | grep "define FOX_MAIN_VERSION_STR" | cut -d \" -f2)
wget -O ~/OrangeFox_10/Magisk.zip https://github.com/topjohnwu/Magisk/releases/download/v23.0/Magisk-v23.0.apk
export FOX_VERSION="${version}_0"
export FOX_USE_SPECIFIC_MAGISK_ZIP="$HOME/OrangeFox_10/Magisk.zip"
export ALLOW_MISSING_DEPENDENCIES=true 
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1 
export LC_ALL="C"
lunch omni_${DEVICE}-eng && mka recoveryimage

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
cd out/target/product/$DEVICE
ofoxzip="$(ls *.zip)"
curl -sL $ofoxzip https://git.io/file-transfer | sh
./transfer wet *.zip
