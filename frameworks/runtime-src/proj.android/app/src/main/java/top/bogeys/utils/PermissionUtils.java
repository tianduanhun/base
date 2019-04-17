package top.bogeys.utils;

import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import top.bogeys.constant.RequestCodeConstans;

import static org.cocos2dx.lua.AppActivity.getApp;

public final class PermissionUtils {
    private static PermissionCallback permissionCallback = null;

    /**
     * 检测权限
     *
     * @param permissions
     * @return
     */
    public static boolean isPermissionGranted(final String[] permissions) {
        for (String permission : permissions) {
            if (!isPermissionGranted(permission)) {
                return false;
            }
        }
        return true;
    }

    public static boolean isPermissionGranted(final String permission) {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(getApp(), permission);
    }

    /**
     * 请求权限
     *
     * @param permissions
     * @param callback
     */
    public static void requestPermissions(final String[] permissions, PermissionCallback callback) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            callback.onSuccess();
        } else {
            permissionCallback = callback;
            ActivityCompat.requestPermissions(getApp(), permissions, RequestCodeConstans.PERMISSION_CODE);
        }
    }

    public static void onRequestPermissionsResult(String[] permissions, int[] grantResults) {
        if (permissionCallback != null) {
            boolean isAllGranted = true;
            boolean isNotAsk = true;
            for (int i = 0; i <grantResults.length; i++) {
                if (isAllGranted && grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                    isAllGranted = false;
                }
                if (isNotAsk && !ActivityCompat.shouldShowRequestPermissionRationale(getApp(), permissions[i])){
                    isNotAsk = false;
                }
            }
            if (isAllGranted) {
                permissionCallback.onSuccess();
            } else {
                permissionCallback.onFailed();
                if (!isNotAsk){
                    permissionCallback.onNotAsk();
                }
            }
        }
    }

    public interface PermissionCallback {
        void onSuccess();

        void onFailed();

        void onNotAsk();
    }
}


