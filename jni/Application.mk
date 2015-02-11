APP_PROJECT_PATH := $(shell pwd)

APP_PLATFORM := android-9

#APP_ABI := x86
APP_ABI := all

NDK_TOOLCHAIN_VERSION=4.9

APP_STL := gnustl_shared

APP_MODULES = libcryptoot libssl libprotobuf

APP_CFLAGS := --std=c++11

# turn on C++ exceptions and run-time-type-identification (dynamic_cast)
APP_CPPFLAGS += -fexceptions -frtti


APP_BUILD_SCRIPT := $(APP_PROJECT_PATH)/Android.mk

