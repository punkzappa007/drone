#!/bin/bash
# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="git clone git@gitlab.com:OrangeFox/sync.git"
DEVICE=CD6
DT_LINK="https://github.com/mastersenpai05/twrp_device_TECNO_CD6 -b orangefox"
DT_PATH=device/TECNO/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
cd ~
sudo apt install git aria2 -y
git clone https://gitlab.com/OrangeFox/misc/scripts
cd scripts
sudo bash setup/android_build_env.sh
sudo bash setup/install_android_sdk.sh

echo " ===+++ Syncing Recovery Sources +++==="
cd ~
mkdir ~/OrangeFox_10
cd ~/OrangeFox_10
git clone $MANIFEST
cd ~/OrangeFox_10/sync
./get_fox_10.sh ~/OrangeFox_10/fox_10.0
cd ~/OrangeFox_10/fox_10.0
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
rm -rf out
source build/envsetup.sh

version=$(cat bootable/recovery/variables.h | grep "define FOX_MAIN_VERSION_STR" | cut -d \" -f2)
export FOX_VERSION="${version}_0"
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
