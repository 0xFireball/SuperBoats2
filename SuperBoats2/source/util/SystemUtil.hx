package util;

class SystemUtil {
    public static function gc() {
        #if cpp
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.compact();
        #end
    }
}
