# https://developer.android.com/ndk/guides/android_mk
# LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  LOCAL_PATH := $(call my-dir)/arm32
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  LOCAL_PATH := $(call my-dir)/arm64
endif

include $(CLEAR_VARS)

LOCAL_MODULE := norxdemo

# Makes a list of all local src files
FILE_LIST := $(wildcard $(LOCAL_PATH)/*.c*)
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

# This will also pick upp all dependencies of liborx
ifeq ($(APP_OPTIM),debug)
  LOCAL_STATIC_LIBRARIES := orxd
else
  LOCAL_STATIC_LIBRARIES := orx
endif

# Use for cpp, to get Exceptions support needed by Nim
# LOCAL_CPP_FEATURES += exceptions

# Improves performance? Instead of "thumb"
LOCAL_ARM_MODE := arm

include $(BUILD_SHARED_LIBRARY)
$(call import-add-path,$(ORX))
$(call import-module,lib/static/android-native)
