# Android emulator utilities
All scripts were tested on a debian system, and in a debian container in Docker environment. I have also
tested on a Centos 7 machine.

## Android SDK Download script
There is two files for the sdk, one for debian (or any distribution with apt as package manager) and another 
for Centos (or any distribution with yum as package manager). Note that there is no guaranty that all required 
packages will be available on other Distributions.
A symbolic link is created for adb and sdkmanager to be able to use it from anywhere.

### List of available options
* `-v=VALUE | --version=VALUE` : override android SDK version value.
* `-p=VALUE | --path=VALUE` : override android SDK location on disk.
* `-h | --help` : show help

## Android emulator creation : `create-avd.sh`
This script is used to create an avd using a previously installed android SDK.

### List of available options
* `-bv=VALUE | --build=VALUE` : override android image build level.
* `-btv=VALUE | --build-tools=VALUE` : override android build tools.
* `-i=VALUE | --image-type=VALUE` : override android image type.
* `-a=VALUE | --arch=VALUE` : override image architecture value.
* `-n=VALUE | --name=VALUE` : override android emulator name.
* `-h | --help` : show help

## Android emulator running tool : `start-avd.sh`
This script can launch an avd and wait until it has started. It print logcat and emulator PID on screen.
It also unlock the screen after.

### List of available options
* `-n=VALUE | --name=VALUE` : override android emulator name.
* `-h | --help` : show help

## Docker file : `android-sdk` WIP
This file is used to build a docker image, that have an Android SDK installed in /opt/android-sdk and can run emulators.