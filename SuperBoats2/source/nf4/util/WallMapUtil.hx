package nf4.util;

class WallMapUtil {

    public static function generateWallMap(Width:Int, Height:Int):Array<Int> {
        var map = [];
        var wallTile = 1;
        var airTile = 0;
        for (r in 0...Height) {
            for (c in 0...Width) {
                if (r == 0 || r == Height - 1) {
                    map.push(wallTile);
                } else {
                    if (c == 0 || c == (Width - 1)) {
                        map.push(wallTile);
                    } else {
                        map.push(airTile);
                    }
                }
            }
        }
        return map;
    }

}