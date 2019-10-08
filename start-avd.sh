#!/bin/sh

# =================================================
#       Android emulator launch script V1.0
# =================================================

echo "------   Android Emulator start script V1.0   ------\n"

# Variables
EMULATOR_NAME="emulateur-29"

# Start previously created emulator from create-avd.sh
$ANDROID_HOME/emulator/emulator-headless -avd $EMULATOR_NAME -wipe-data -noaudio -no-boot-anim -gpu off -no-snapshot -memory 1024 $

# Wait for emulator to come online
WAIT_CMD="$ANDROID_HOME/platform-tools/adb wait-for-device shell getprop init.svc.bootanim"

until $WAIT_CMD | grep -m 1 stopped; do
    echo "Waiting for device to come online..."
    sleep 1
done

# Lock screen unlock
$ANDROID_HOME/platform-tools/adb shell input keyevent 82

# Logcat
$ANDROID_HOME/platform-tools/adb logcat -c
$ANDROID_HOME/platform-tools/adb logcat > /home/server/temp-android.log & LOGCAT_PID=$!

# print pid
echo "Emulator : $EMULATOR_PID"
echo "Logcat : $LOGCAT_PID"
