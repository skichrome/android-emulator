#!/bin/sh

echo ""
echo "            ╔══════════════════════════════════════════════════════╗"
echo "            ║                                                      ║"
echo "            ║           Android SDK Download script v1.1           ║"
echo "            ║                                                      ║"
echo "            ║      Use -h or --help to see available commands      ║"
echo "            ║                                                      ║"
echo "            ║    Warning ! This script will reboot the server !    ║"
echo "            ║                                                      ║"
echo "            ║           Please run this script with sudo           ║"
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
	echo "[-p=VALUE | --path=VALUE]              : Path that will be used for the SDK installation"
	echo "[-h | --help]				: Show this help utility."
}

# Variables
ANDROID_SDK_VERSION="4333796"
ANDROID_PATH="/opt/android-sdk"

for i in "$@"; do
	case $i in
		-v=*|--version=*) ANDROID_SDK_VERSION="${i#*=}"
		shift
		;;
		-p=*|--path=*) ANDROID_PATH="${i#*=}"
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

sudo echo "" >> /etc/bashrc
sudo echo "" >> /etc/bashrc
sudo echo "export ANDROID_HOME=$ANDROID_PATH" >> /etc/bashrc
source /etc/bashrc
echo "$ANDROID_HOME"

if [ -z $ANDROID_HOME ]; then
        echo "Please set ANDROID_HOME variable in your system before running this script."
        exit 0
fi

echo "┌──────────────────────────────┬────────────────────────────────────────────────"
echo "│- ANDROID_HOME                │ $ANDROID_HOME"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Android SDK Location        │ $ANDROID_PATH"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Android SDK Version         │ $ANDROID_SDK_VERSION"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- SDK Owner                   │ $SUDO_USER"
echo "└──────────────────────────────┴────────────────────────────────────────────────"
echo ""

# Required packages
sudo yum update && \
	sudo yum upgrade -y && \
	sudo yum install -y qemu-kvm \
	libvirt \
	libvirt-python \
	libguestfs-tools \
	virt-install && \
#	sudo yum -y libx11-6 \
#        	pulseaudio \
#        	libgl1 \
#        	libxcursor-dev \
#        	#libasound2 \
#        	libudev1 \
#        	qt5-default && \
	sudo yum autoremove -y

#sudo systemctl enable libvirtd
#sudo systemctl start libvirtd

sudo yum install -y java-1.8.0-openjdk-headless.x86_64 \
	wget \
	unzip

sudo echo "export JAVA_HOME=/usr/lib/jvm/jre-openjdk" >> /etc/bashrc
source /etc/bashrc
echo "$JAVA_HOME"

# Download Android SDK
sudo mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME}
sudo chown -R $SUDO_USER:$SUDO_USER $ANDROID_HOME

wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip

# Avoid repositories.cfg error
mkdir /home/$SUDO_USER/.android && touch /home/$SUDO_USER/.android/repositories.cfg

# Create symlinks for adb and sdkmanager
ln -s $ANDROID_HOME/platform-tools/adb /usr/bin/adb
ln -s $ANDROID_HOME/tools/bin/sdkmanager /usr/bin/sdkmanager

sudo reboot
