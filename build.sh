#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

#MANIFEST="https://gitlab.com/OrangeFox/sync.git"
DEVICE=CD6
DT_LINK="https://github.com/mastersenpai05/twrp_device_TECNO_CD6.git"
DT_PATH=device/TECNO/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
mkdir ~/OrangeFox_10 && cd ~/OrangeFox_10
git clone https://gitlab.com/OrangeFox/misc/scripts
cd ~/scripts
sudo bash setup/android_build_env.sh
sudo bash setup/install_android_sdk.sh

echo " ===+++ Syncing Recovery Sources +++==="
git clone https://gitlab.com/OrangeFox/sync.git
cd sync
./get_fox_10.sh ~/OrangeFox_10/fox_10.0
cd ~/OrangeFox_10/fox_10.0
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
. build/envsetup.sh
echo " source build/envsetup.sh done"
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"
lunch omni_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
mka recoveryimage || abort " mka failed with exit status $?"
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
cd out/target/product/$DEVICE
ofoxzip="$(ls *.zip)"
curl -sL $ofoxzip https://git.io/file-transfer | sh
./transfer wet *.zip
