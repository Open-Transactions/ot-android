#!/bin/sh
#uses openssl sha1, curl, tar/gzip/bz2

VERSION=2.5.0
PACKAGE_NAME=protobuf
ARCHIVE_TYPE=tar.bz2
ARCHIVE=$PACKAGE_NAME-$VERSION.$ARCHIVE_TYPE
ARCHIVE_URL=https://protobuf.googlecode.com/files/$ARCHIVE
SHA1=62c10dcdac4b69cc8c6bb19f73db40c264cb2726
SRCROOT=./ot
TEST_FILE_PATH=src/google/protobuf/descriptor.cc
CONFIG_TEST_FILE_PATH=config.h

cd $SRCROOT

#echo "Creating symbolic link"
[ -L ./$PACKAGE_NAME ] || ( rm -rf ./$PACKAGE_NAME && ln -s ./$PACKAGE_NAME-$VERSION ./$PACKAGE_NAME )

#echo "Downloading and Verifying"
([ -f ./$ARCHIVE ] && openssl sha1 ./$ARCHIVE | grep $SHA1) || \
(rm -f ./$ARCHIVE && curl -sSO $ARCHIVE_URL && \
openssl sha1 ./$ARCHIVE | grep $SHA1)

#echo "Unpacking"
[ -f ./$PACKAGE_NAME/$TEST_FILE_PATH ] || tar -xjf $ARCHIVE


if [ -z "${ANDROID_NDK}" ] ; then
   echo "please set ANDROID_NDK"
   exit 1
fi


export CROSS_COMPILE=i686-linux-android
export TOOLCHAIN_CPU=x86
export TOOLCHAIN_VERSION=4.9
export TARGET_PLATFORM_VER=9
export BUILD_PLATFORM=linux-x86_64
export ANDROID_SDK=/Users/au/android-sdk-macosx
export PREBUILT=$ANDROID_NDK/toolchains/$TOOLCHAIN_CPU-$TOOLCHAIN_VERSION
export PLATFORM=$ANDROID_NDK/platforms/android-$TARGET_PLATFORM_VER/arch-$TOOLCHAIN_CPU/
export CC="$ANDROID_NDK/toolchains/$TOOLCHAIN_CPU-$TOOLCHAIN_VERSION/prebuilt/$BUILD_PLATFORM/bin/$CROSS_COMPILE-gcc"
export CXX="$ANDROID_NDK/toolchains/$TOOLCHAIN_CPU-$TOOLCHAIN_VERSION/prebuilt/$BUILD_PLATFORM/bin/$CROSS_COMPILE-g++"
export CFLAGS="-fPIC -DANDROID -nostdlib"
export ANDROID_ROOT="$ANDROID_NDK"
export ANDROID_ANDROID_NDK_ROOT=$ANDROID_ROOT
export LDFLAGS="-Wl,-rpath-link=$ANDROID_ROOT/platforms/android-$TARGET_PLATFORM_VER/arch-$TOOLCHAIN_CPU/usr/lib/ -L$ANDROID_ROOT/platforms/android-$TARGET_PLATFORM_VER/arch-$TOOLCHAIN_CPU/usr/lib/"
export CPPFLAGS="-I$ANDROID_ROOT/platforms/android-$TARGET_PLATFORM_VER/arch-$TOOLCHAIN_CPU/usr/include/"
export LIBS="-lc "
export PATH=$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$ANDROID_NDK/toolchains/$TOOLCHAIN_CPU-$TOOLCHAIN_VERSION/prebuilt/$BUILD_PLATFORM/bin:$PATH


#echo "Configuring"
[ -f ./$PACKAGE_NAME/$CONFIG_TEST_FILE_PATH ] || (cd ./$PACKAGE_NAME && ./autogen.sh && ./configure --host=x86-i686-linux-android --with-sysroot=$PLATFORM CC=$CC CXX=$CXX --enable-cross-compile --with-protoc=protoc LIBS=$LIBS)

