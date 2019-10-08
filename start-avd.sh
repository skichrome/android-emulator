#!/bin/sh

echo ""
echo "            ╔═════════════════════════════════════════════════════╗"
echo "            ║                                                     ║"
echo "            ║         Android Emulator launch script v1.1         ║"
echo "            ║                                                     ║"
echo "            ║      Use -h or --help to see available commands     ║"
echo "            ║                                                     ║"
echo "            ╚═════════════════════════════════════════════════════╝"
echo ""

show_help()
{
	echo "This script will launch a previously created emulator. if the emulator does not exist, the script will do nothing."
	echo ""
	echo "Available option for this script."
	echo "If an option is not provided, default value is used."
	echo "[-n=VALUE | --name=VALUE] 		: Emulator name, default to emulateur-29"
	echo "[-h | --help]				: Show this help utility."
}

# Variables
EMULATOR_NAME="emulateur-29"

for i in "$@"; do
	case $i in
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

echo "┌──────────────────────────────┬─────────────────────────────────────────────────"
echo "│- Emulator name               │ $EMULATOR_NAME "
echo "└──────────────────────────────┴─────────────────────────────────────────────────"
echo ""

# Start previously created emulator from create-avd.sh
$ANDROID_HOME/emulator/emulator-headless -avd $EMULATOR_NAME -wipe-data -noaudio -no-boot-anim -gpu off -no-snapshot -memory 1024 & EMULATOR_PID=$!

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
