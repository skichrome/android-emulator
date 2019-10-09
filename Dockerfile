# skichrome/android-sdk:1.0
# Command to start : sh -c "$@"

# Base image
FROM debian:9

# Working directory
RUN mkdir /application
WORKDIR /application

ADD sdkmanager-download-debian.sh /application/
RUN chmod +x /application/sdkmanager-download-debian.sh && /application/sdkmanager-download-debian.sh

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
 #               libudev1 \
 #               qt5-default

# Expose adb port
EXPOSE 5037