LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := norxdemo

# Makes a list of all local src files
FILE_LIST := $(wildcard $(LOCAL_PATH)/*.c*)
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

# This will also pick upp all dependencies of liborx
LOCAL_STATIC_LIBRARIES := orx

# Use for cpp, to get Exceptions support needed by Nim
# LOCAL_CPP_FEATURES += exceptions

# Improves performance? Instead of "thumb"
LOCAL_ARM_MODE := arm

include $(BUILD_SHARED_LIBRARY)
$(call import-add-path,$(ORX))
$(call import-module,lib/static/android-native)