#!/bin/bash

# --------------------------------------------
#  Android emulator creation script v1.0
# --------------------------------------------

# Variables
ANDROID_BUILD_VERSION=25
ANDROID_BUILD_TOOLS_VERSION=29.0.2

# Android Emulator System Image
SYSTEM_IMAGE="system-images;android-${ANDROID_BUILD_VERSION};google_apis;x86"
#SYSTEM_IMAGE="system-images;android-${ANDROID_BUILD_VERSION};google_apis;armeabi-v7a"

# SDK Update
$ANDROID_HOME/tools/bin/sdkmanager --update

# Accept all android licences
yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Android SDK updates
$ANDROID_HOME/tools/bin/sdkmanager --update
$ANDROID_HOME/tools/bin/sdkmanager "platform-tools" \
        "platforms;android-${ANDROID_BUILD_VERSION}" \
        "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
        "emulator" \
        "$SYSTEM_IMAGE"

touch ~/.android/repositories.cfg

# Avd Creation, name is "emulateur-29"
cd $ANDROID_HOME/tools/bin/ && echo "no" | ./avdmanager create avd -n emulateur-29 -k $SYSTEM_IMAGE --force


# List all avd available
./avdmanager list avd
