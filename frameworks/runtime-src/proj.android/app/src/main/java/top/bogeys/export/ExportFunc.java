package top.bogeys.export;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

public final class ExportFunc {
    private static void callLuaFuncBack(final int luaFuncId, final String result){
        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId, result);
        Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFuncId);
    }
}
