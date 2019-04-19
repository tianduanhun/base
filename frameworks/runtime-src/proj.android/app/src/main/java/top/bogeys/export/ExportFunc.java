package top.bogeys.export;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import top.bogeys.utils.UUIDUtils;


public final class ExportFunc {
    private static void callLuaFuncBack(final int luaFuncId, final String result){
        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId, result);
        Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFuncId);
    }

    public static String getUUID(){
        return UUIDUtils.getUUID();
    }

    public static void saveUUID(final String uuid){
        UUIDUtils.saveUUID(uuid);
    }
}
