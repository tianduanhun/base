package top.bogeys.utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.telephony.TelephonyManager;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.UUID;

import top.bogeys.constant.PermissionConstants;

import static org.cocos2dx.lua.AppActivity.getApp;

public final class UUIDUtils {
    private static File getUUIDFile(){
        boolean hasPermission = PermissionUtils.isPermissionGranted(PermissionConstants.getPermissions(PermissionConstants.STORAGE));
        if (hasPermission){
            if (FileUtils.isSDCardEnabled() && new File(FileUtils.getSDCardPath()).canWrite()){
                File uuidFile;
                String uuidFilePath = String.valueOf(FileUtils.getSDCardPath()) +
                        File.separator + ".top.bogeys" +
                        File.separator + "base" +
                        File.separator;
                if (FileUtils.createOrExistsDir(uuidFilePath)){
                    uuidFile = FileUtils.getFileByPath(uuidFilePath + "uuid");
                    if (uuidFile != null){
                        if (uuidFile.exists()) return uuidFile;
                        else {
                            try {
                                if (uuidFile.createNewFile()) return uuidFile;
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
        }
        return null;
    }

    @SuppressLint({"MissingPermission", "HardwareIds"})
    public static String getUUID(){
        String uuid = null;
        SharedPreferences sharedPreferences = getApp().getSharedPreferences("uuid", Context.MODE_PRIVATE);
        if (sharedPreferences != null){
            uuid = sharedPreferences.getString("uuid", null);
        }
        if (uuid == null || "".equals(uuid)){
            File uuidFile  = getUUIDFile();
            if (uuidFile != null){
                try {
                    InputStream inputStream = new FileInputStream(uuidFile);
                    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                    StringBuilder content = new StringBuilder();
                    String line;
                    while ((line = bufferedReader.readLine()) != null){
                        content.append(line);
                    }
                    inputStream.close();
                    uuid = String.valueOf(content);
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        // 生成一个uuid
        if (uuid == null || "".equals(uuid)){
            boolean hasPermission = PermissionUtils.isPermissionGranted(Manifest.permission.READ_PHONE_STATE);
            if (hasPermission){
                TelephonyManager tm = (TelephonyManager) getApp().getSystemService(Context.TELEPHONY_SERVICE);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                    uuid = tm.getImei();
                }else{
                    uuid = tm.getDeviceId();
                }
            }
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
        File uuidFile = getUUIDFile();
        if (uuidFile != null){
            try {
                OutputStream outputStream = new FileOutputStream(uuidFile);
                outputStream.write(uuid.getBytes());
                outputStream.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
