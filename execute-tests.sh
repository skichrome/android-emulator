#!/bin/bash

echo ""
echo "            ╔═════════════════════════════════════════════════════╗"
echo "            ║                                                     ║"
echo "            ║    Android connected tests execution script v1.1    ║"
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
	echo "[-a=VALUE | --apk=VALUE] 		: Specify a path to debug apk to install on emulator"
	echo "[-at=VALUE | --apk-tests=VALUE]	: Specify a path to connect android tests to install on emulator"
	echo "[-c=VALUE | --class=VALUE]		: Specify the class of tests : 'myTestClass' testPackage/testRunner"
	echo "[-h | --help]				: Show this help utility."
}

APK_DEBUG="/application/app-demoProduction-debug.apk"
APK_CONNECTED_TESTS="/application/app-demoProduction-debug-androidTest.apk"
TEST_CLASS="'com.example.mytestapp.ExampleInstrumentedTest' com.example.mytestapp.demoproduction.test/androidx.test.runner.AndroidJUnitRunner"

for i in "$@"; do
	case $i in
		-a=*|--apk=*) APK_DEBUG="${i#*=}"
		shift
		;;
		-at=*|--apk-tests=*) APK_CONNECTED_TESTS="${i#*=}"
		shift
		;;
		-c=*|--class=*) TEST_CLASS="${i#*=}"
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
echo "│- Debug APK path              │ $APK_DEBUG"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Android Tests APK path      │ $APK_CONNECTED_TESTS"
echo "├──────────────────────────────┼────────────────────────────────────────────────"
echo "│- Test class                  │ $TEST_CLASS"
echo "└──────────────────────────────┴────────────────────────────────────────────────"
echo ""

adb devices
adb install -t ${APK_DEBUG}
adb install -t ${APK_CONNECTED_TESTS}
sleep 5
adb shell am instrument -w -r   -e debug false -e class ${TEST_CLASS}
sleep 5
adb emu kill
