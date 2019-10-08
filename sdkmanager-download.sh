#!/bin/sh

echo ""
echo "            ╔══════════════════════════════════════════════════════╗"
echo "            ║                                                      ║"
echo "            ║           Android SDK Download script v1.0           ║"
echo "            ║                                                      ║"
echo "            ║      Use -h or --help to see available commands      ║"
echo "            ║                                                      ║"
echo "            ║      Please run this script as root (with sudo)      ║"
echo "            ║         otherwise it will not end correctly.         ║"
echo "            ║                                                      ║"
echo "            ╚══════════════════════════════════════════════════════╝"
echo ""

show_help()
{
	echo "This script will download the Android SDK from Google repository and install required packages for emulator. PLEASE RUN AS ROOT."
	echo "Please ensure that the environment variable ANDROID_HOME is set and usable."
	echo ""
	echo "Available option for this script."
	echo "If an option is not provided, default value is used."
	echo "[-v=VALUE | --version=VALUE] 		: Android SDK version, default to 4333796"
	echo "[-h | --help]				: Show this help utility."
}

# Variables
ANDROID_SDK_VERSION="4333796"

if [ -z $ANDROID_HOME ]; then
	echo "Please set ANDROID_HOME variable in your system before running this script."
	exit 0
fi

for i in "$@"; do
	case $i in
		-v=*|--version=*) ANDROID_SDK_VERSION="${i#*=}"
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

echo "┌──────────────────────────────┬────────────────────────────────────────────────"
echo "│- ANDROID_HOME                │ $ANDROID_HOME"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Android SDK Version         │ $ANDROID_SDK_VERSION"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- SDK Owner                   │ $USER"
echo "└──────────────────────────────┴────────────────────────────────────────────────"
echo ""

# Required packages
sudo dpkg --add-architecture i386 && \
        sudo apt-get update && \
		sudo apt-get upgrade -y --no-install-recommends && \
		sudo apt-get install -y --no-install-recommends libx11-6 \
                pulseaudio \
                libgl1 \
                libxcursor-dev \
                #libasound2 \
                libudev1 \
                qt5-default && \
		sudo apt-get autoremove -y --no-install-recommends && \
		sudo apt-get autoclean

sudo apt-get install -y --no-install-recommends default-jdk \
	wget \
	zip \
	unzip

# Download Android SDK
sudo mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME}
sudo chown -R $USER:$USER $ANDROID_HOME

wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip

# Avoid repositories.cfg error
sudo mkdir ~/.android && touch ~/.android/repositories.cfg

# Create symlinks for adb and sdkmanager
ln -s $ANDROID_HOME/platform-tools/adb /usr/bin/adb
ln -s $ANDROID_HOME/tools/bin/sdkmanager /usr/bin/sdkmanager 

# Accept licences and update Android SDK
yes | sdkmanager --licenses
sdkmanager --update