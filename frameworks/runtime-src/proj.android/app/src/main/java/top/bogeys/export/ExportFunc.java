package top.bogeys.export;

import top.bogeys.utils.UUIDUtils;


public final class ExportFunc {
    public static String getUUID(){
        return UUIDUtils.getUUID();
    }

    public static void saveUUID(final String uuid){
        UUIDUtils.saveUUID(uuid);
    }
}
