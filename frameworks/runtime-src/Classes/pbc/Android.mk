
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := pbc
LOCAL_MODULE_FILENAME := libpbc

LOCAL_SRC_FILES := $(LOCAL_PATH)/alloc.c \
	$(LOCAL_PATH)/array.c \
	$(LOCAL_PATH)/bootstrap.c \
	$(LOCAL_PATH)/context.c \
	$(LOCAL_PATH)/decode.c \
	$(LOCAL_PATH)/map.c \
	$(LOCAL_PATH)/pattern.c \
	$(LOCAL_PATH)/proto.c \
	$(LOCAL_PATH)/register.c \
	$(LOCAL_PATH)/rmessage.c \
	$(LOCAL_PATH)/stringpool.c \
	$(LOCAL_PATH)/varint.c \
	$(LOCAL_PATH)/wmessage.c \
	$(LOCAL_PATH)/pbc-lua.c \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/ \
	$(COCOS2DX_ROOT)/external/lua/luajit/include


include $(BUILD_STATIC_LIBRARY)