LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := bugly_native_prebuilt

LOACL_SRC_FILES := probuilt/$(TARGET_ARCH_ABI)/libBugly.so

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := hellolua/main.cpp \
../../../Classes/VisibleRect.cpp \
../../../Classes/AppDelegate.cpp

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../../Classes \
$(COCOS2DX_ROOT)/external \
$(COCOS2DX_ROOT)/quick/lib/quick-src \
$(COCOS2DX_ROOT)/quick/lib/quick-src/extra

LOCAL_STATIC_LIBRARIES := extra_static
LOCAL_STATIC_LIBRARIES += cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += lua_extensions_static
LOCAL_STATIC_LIBRARIES += bugly_crashreport_cocos_static
LOCAL_STATIC_LIBRARIES += bugly_agent_cocos_static_lua

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)

$(call import-module, quick-src/lua_extensions)
$(call import-module, quick-src/extra)
$(call import-module, external/bugly)
$(call import-module, external/bugly/lua)
