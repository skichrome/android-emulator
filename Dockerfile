# skichrome/android-sdk:1.0.1
# Command to start : sh -c "$@"

# Base image
FROM debian:9

# Working directory
RUN mkdir /application
WORKDIR /application

#Required environment variables
ENV ANDROID_HOME /opt/android-sdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Update and install required libraries
RUN dpkg --add-architecture i386 && \
        apt-get update && \
		apt-get upgrade -y --no-install-recommends && \
		apt-get install -y --no-install-recommends libncurses5:i386 \
        libc6:i386 \
        libstdc++6:i386 \
        lib32gcc1 \
        lib32ncurses5 \
        lib32z1 \
        zlib1g:i386 \
		qt5-default && \
		apt-get autoremove -y --no-install-recommends && \
		apt-get autoclean && \
		apt-get install -y --no-install-recommends default-jdk \
			wget \
			nano \
			git \
			unzip

# Download Android SDK and create symlinks
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
	wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip && \
	ln -s $ANDROID_HOME/platform-tools/adb /usr/bin/adb && \
	ln -s $ANDROID_HOME/tools/bin/sdkmanager /usr/bin/sdkmanager 

# Expose adb port
EXPOSE 5037

RUN git clone https://github.com/skichrome/android-emulator.git

# NFS Server for android SDK
RUN apt-get install -y --no-install-recommends nfs-kernel-server && \
	echo "/opt/android-sdk    172.22.0.0/24(rw,sync,no_subtree_check)" >> /etc/exports

EXPOSE 2049

# -------------------------------------------------------------------------------------

#// Todo remove if emulator can be launched without these libraries.
# Required Emulator libraries
#RUN dpkg --add-architecture i386 && \
#        apt-get update && \
 #       apt-get install -y --no-install-recommends libx11-6 \
 #               pulseaudio \
 #               libpulse0 \
 #               libgl1 \
 #               libxcursor-dev \
 #               libasound2 \
 #               libudev1