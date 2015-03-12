FROM monetas/base-ot-dev

MAINTAINER Martin Hamrle "martin.hamrle@monetas.net"

RUN apt-get install -y --no-install-recommends p7zip-full automake autoconf libtool && apt-get autoremove

# Install android ndk
ENV ANDROID_NDK_VERSION r10c
ADD http://dl.google.com/android/ndk/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.bin /tmp/
RUN 7z x /tmp/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.bin -o/usr/local && \
    ln -sf /usr/local/android-ndk-$ANDROID_NDK_VERSION /usr/local/android-ndk && \
    rm -rf /tmp/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.bin
ENV ANDROID_NDK /usr/local/android-ndk

ADD .gitignore .gitmodules run-build.sh AndroidManifest.xml Android.mk default.properties genproto.sh getProtobufLibrary.sh /home/otuser/ot-android/
ADD ot /home/otuser/ot-android/ot
ADD .git /home/otuser/ot-android/.git
ADD jni /home/otuser/ot-android/jni

CMD ["bash"]
