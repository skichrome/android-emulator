#!/bin/bash

echo ""
echo "            ╔═════════════════════════════════════════════════════╗"
echo "            ║                                                     ║"
echo "            ║         Android Emulator launch script v1.1         ║"
echo "            ║                                                     ║"
echo "            ║      Use -h or --help to see available commands     ║"
echo "            ║                                                     ║"
echo "            ║       Launch this script with sudo -E to keep       ║"
echo "            ║           environment variable available            ║"
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

$ANDROID_HOME/emulator/emulator -avd ${EMULATOR_NAME} \
	-no-window \
        -wipe-data \
        -noaudio \
        -no-boot-anim \
        -gpu off \
        -no-snapshot &
