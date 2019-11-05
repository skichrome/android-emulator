#!/bin/bash

echo ""
echo "            ╔═════════════════════════════════════════════════════╗"
echo "            ║                                                     ║"
echo "            ║        Android Emulator wait for device v1.0        ║"
echo "            ║                                                     ║"
echo "            ╚═════════════════════════════════════════════════════╝"
echo ""

# Wait for emulator to come online
WAIT_CMD="$ANDROID_HOME/platform-tools/adb wait-for-device shell getprop init.svc.bootanim"

until $WAIT_CMD | grep -m 1 stopped; do
    echo "Waiting for device to come online..."
    sleep 1
done

sleep 5

# Lock screen unlock
$ANDROID_HOME/platform-tools/adb shell input keyevent 82

# Logcat
$ANDROID_HOME/platform-tools/adb logcat -c
$ANDROID_HOME/platform-tools/adb logcat > $HOME/temp-android.log &