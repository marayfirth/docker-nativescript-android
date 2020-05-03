FROM ubuntu:18.04

USER root

ENV ANDROID_HOME=/android-sdk PATH=$PATH:/android-sdk/tools:/android-sdk/tools/bin:/android-sdk:/platform-tools

RUN apt-get update && apt-get install -y sudo lib32z1 lib32ncurses5 g++ unzip openjdk-8-jdk zsh-common curl gnupg2 git && \
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && \
apt-get install -y nodejs && \
curl "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" -o /tmp/sdk.zip && \
mkdir -p /android-sdk && \
unzip -q /tmp/sdk.zip -d /android-sdk && \
mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
rm -rf /tmp/* && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/lib/apt/*

RUN echo "export JAVA_OPTS=\"$JAVA_OPTS\"" >> /root/.bashrc && \
echo "export ANDROID_HOME=$ANDROID_HOME" >> /root/.bashrc && \
echo "export PATH=$PATH" >> /root/.bashrc

RUN yes | /android-sdk/tools/bin/sdkmanager --licenses && \
/android-sdk/tools/bin/sdkmanager "tools" "platform-tools" "platforms;android-28" "build-tools;28.0.3" "extras;google;m2repository" "extras;android;m2repository"

RUN yes | npm install nativescript@6.5.0 -g --unsafe-perm && \
tns extension install nativescript-cloud@1.20.1 && \
tns usage-reporting disable && \
tns error-reporting enable

RUN nativescript doctor
