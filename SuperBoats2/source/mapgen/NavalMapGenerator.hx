package mapgen;

import nf4.util.*;

class NavalMapGenerator {

    public function new() {

    }

    public function generateMap(Width:Int, Height:Int):Array<Int> {
        var mapMatrix = WallMapUtil.generateWallMap(Width, Height);
        return mapMatrix;
    }

}