#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

#MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni -b twrp-10.0"
#DEVICE=RMX2121
DT_LINK="https://github.com/draekko/AIK-Linux.git"
#DT_PATH=device/realme/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir -p cam && cd ~/cam

echo " ===+++ Syncing Recovery Sources +++==="
git clone --depth=1 $DT_LINK

echo " ===+++ Building Recovery +++==="
cd ~/cam/AIK-Linux
wget https://dumps.tadiphone.dev/dumps/poco/aresin/-/raw/ares-user-11-RP1A.200720.011-V12.5.3.0.RKJCNXM-release-keys/boot.img
./unpackimg.sh boot.img
