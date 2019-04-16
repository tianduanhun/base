package top.bogeys.utils;

import android.os.Build;

public final class PermissionUtils {
    public static boolean isPermissionGranted(){

    }

    public static boolean isPermissionGranted(){
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M;
    }

    public interface PermissionCallback {
        void doSomeThing();
    }
}


