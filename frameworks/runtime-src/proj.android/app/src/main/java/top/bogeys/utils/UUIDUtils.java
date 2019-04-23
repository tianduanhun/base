package top.bogeys.utils;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.UUID;

import static org.cocos2dx.lua.AppActivity.getApp;

public final class UUIDUtils {

    public static String getUUID(){
        String uuid = null;
        SharedPreferences sharedPreferences = getApp().getSharedPreferences("uuid", Context.MODE_PRIVATE);
        if (sharedPreferences != null){
            uuid = sharedPreferences.getString("uuid", null);
        }

        if (uuid == null || "".equals(uuid)){
            uuid = UUID.randomUUID().toString();
        }
        saveUUID(uuid);
        return uuid;
    }

    public static void saveUUID(final String uuid){
        SharedPreferences sharedPreferences = getApp().getSharedPreferences("uuid", Context.MODE_PRIVATE);
        if (sharedPreferences != null){
            sharedPreferences.edit().putString("uuid", uuid).apply();
        }
    }
}
