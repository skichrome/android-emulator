# Android emulator utilities
All scripts were tested on a debian system, and in a debian container in Docker environment.

## Android emulator creation : `create-avd.sh`
This script is used to create an avd using a previously installed android SDK. To be able to use this script you have 
to setup the environment variable `ANDROID_HOME`, the way to do that may vary on your Linux distributions.

### List of available options
..* `-bv=VALUE | --build=VALUE` : override android image build level.
..* `-btv=VALUE | --build-tools=VALUE` : override android build tools.
..* `-i=VALUE | --image-type=VALUE` : override android image type.
..* `-a=VALUE | --arch=VALUE` : override image architecture value.
..* `-n=VALUE | --name=VALUE` : override android emulator name.
..* `-h | --help` : show help

## Android emulator running tool : `start-avd.sh`
This script can launch an avd and wait until it has started. It print logcat and emulator PID on screen.
It also unlock the screen after.

### List of available options
..* `-n=VALUE | --name=VALUE` : override android emulator name.
..* `-h | --help` : show help

## Docker file : `android-sdk`
This file is used to build a docker image, that have an Android SDK installed in /opt/android-sdk and can run emulators.