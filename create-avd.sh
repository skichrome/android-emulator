#!/bin/bash

echo ""
echo "            ╔═════════════════════════════════════════════════════╗"
echo "            ║                                                     ║"
echo "            ║        Android Emulator creation script v1.1        ║"
echo "            ║                                                     ║"
echo "            ║      Use -h or --help to see available commands     ║"
echo "            ║                                                     ║"
echo "            ╚═════════════════════════════════════════════════════╝"
echo ""

show_help()
{
	echo "This script will create an android emulator from a previously installed android sdk, after updated it and accepted all licences."
	echo ""
	echo "Available option for this script."
	echo "If an option is not provided, default value is used."
	echo "[-bv=VALUE | --build=VALUE] 		: Android build version, used to download Android system image. Default to 29."
	echo "[-btv=VALUE | --build-tools=VALUE]	: Android build tools version, used to compile your android project. Default to 29.0.2."
	echo "[-i=VALUE | --image-type=VALUE]		: Android image type, default to google_apis"
	echo "[-a=VALUE | --arch=VALUE] 		: Architecture; default to x86"
	echo "[-n=VALUE | --name=VALUE] 		: Emulator name, default to emulateur-29"
	echo "[-h | --help]				: Show this help utility."
}

# Variables, default or from arguments
ANDROID_BUILD_VERSION="29"
ANDROID_BUILD_TOOLS_VERSION="29.0.2"
ANDROID_EMULATOR_IMG_TYPE="google_apis"
ANDROID_EMULATOR_ARCH="x86"
EMULATOR_NAME="emulateur-29"

for i in "$@"; do
	case $i in
		-bv=*|--build=*) ANDROID_BUILD_VERSION="${i#*=}"
		shift
		;;
		-btv=*|--build-tools=*) ANDROID_BUILD_TOOLS_VERSION="${i#*=}"
		shift
		;;
		-i=*|--image-type=*) ANDROID_EMULATOR_IMG_TYPE="${i#*=}"
		shift
		;;
		-a=*|--arch=*) ANDROID_EMULATOR_ARCH="${i#*=}"
		shift
		;;
		-n=*|--name=*) EMULATOR_NAME="${i#*=}"
		shift
		;;
		-h|--help) 
			show_help
			exit 0
		;;
		*) 
			echo "unknown option, use -h or --help for a list of available options"
			exit 0
		;;
	esac
done

# Android Emulator System Image
SYSTEM_IMAGE="system-images;android-${ANDROID_BUILD_VERSION};${ANDROID_EMULATOR_IMG_TYPE};${ANDROID_EMULATOR_ARCH}"

echo "┌──────────────────────────────┬────────────────────────────────────────────────"
echo "│- Android build version       │ $ANDROID_BUILD_VERSION"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Android build tools version │ $ANDROID_BUILD_TOOLS_VERSION"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Emulator image type         │ $ANDROID_EMULATOR_IMG_TYPE"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Emulator architecture       │ $ANDROID_EMULATOR_ARCH"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Emulator name               │ $EMULATOR_NAME"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Emulator system image       │ $SYSTEM_IMAGE"
echo "└──────────────────────────────┴────────────────────────────────────────────────"

exit 0

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
cd $ANDROID_HOME/tools/bin/ && echo "no" | ./avdmanager create avd -n $EMULATOR_NAME -k $SYSTEM_IMAGE --force

# List all avd available
./avdmanager list avd