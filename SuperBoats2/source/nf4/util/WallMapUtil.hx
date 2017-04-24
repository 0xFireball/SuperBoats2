package nf4.util;

class WallMapUtil {

    public static function generateWallMap(Width:Int, Height:Int):Array<Int> {
        var map = [];
        for (r in 0...Height) {
            for (c in 0...Width) {
                if (r == 0 || r == Height - 1) {
                    map.push(1);
                } else {
                    if (c == 0 || c == (Width - 1)) {
                        map.push(1);
                    } else {
                        map.push(0);
                    }
                }
            }
        }
        return map;
    }

}