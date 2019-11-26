#!/bin/bash

echo ""
echo "            ╔═════════════════════════════════════════════════════╗"
echo "            ║                                                     ║"
echo "            ║        Android Emulator wait for device v1.1        ║"
echo "            ║                                                     ║"
echo "            ╚═════════════════════════════════════════════════════╝"
echo ""

# Wait for emulator to come online; Original script from Travis CI here 
# https://github.com/travis-ci/travis-cookbooks/blob/master/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
# Originally written by Ralf Kistner <ralf@embarkmobile.com>, but placed in the public domain

set +e

bootanim=""
failcounter=0
timeout_in_sec=360

until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
    || "$bootanim" =~ "running" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  fi
  sleep 1
done

echo "Emulator is ready"

# Lock screen unlock
$ANDROID_HOME/platform-tools/adb shell input keyevent 82

# Logcat
$ANDROID_HOME/platform-tools/adb logcat -c
$ANDROID_HOME/platform-tools/adb logcat > $HOME/temp-android.log &