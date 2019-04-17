package top.bogeys.utils;

import android.os.Environment;

import java.io.File;
import java.io.IOException;

public final class FileUtils {

    /**
     * 根据路径获取文件
     * @param filePath
     * @return
     */
    public static File getFileByPath(final String filePath){
        return "".equals(filePath) ? null : new File(filePath);
    }

    /**
     * 判断文件是否存在
     * @param filePath
     * @return
     */
    public static boolean isFileExists(final String filePath){
        return isFileExists(getFileByPath(filePath));
    }

    public static boolean isFileExists(final File file){
        return file != null && file.exists();
    }

    /**
     * 检测或创建文件夹
     * @param filePath
     * @return
     */
    public static boolean createOrExistsDir(final String filePath){
        return createOrExistsDir(getFileByPath(filePath));
    }

    public static boolean createOrExistsDir(final File file){
        return file != null && (file.exists() ? file.isDirectory() : file.mkdirs());
    }

    /**
     * 检测或创建文件
     * @param filePath
     * @return
     */
    public static boolean createOrExistsFile(final String filePath) {
        return createOrExistsFile(getFileByPath(filePath));
    }

    public static boolean createOrExistsFile(final File file) {
        if (file == null) return false;
        if (file.exists()) return file.isFile();
        if (!createOrExistsDir(file.getParentFile())) return false;
        try {
            return file.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 判断sd卡是否启用
     * @return
     */
    public static boolean isSDCardEnabled(){
        return Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState());
    }

    /**
     * 获取sd卡根目录
     * @return
     */
    public static String getSDCardPath(){
        if (isSDCardEnabled()){
            return Environment.getExternalStorageDirectory().getAbsolutePath();
        }
        return "";
    }
}
