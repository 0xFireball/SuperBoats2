
package nf4.math;

import flixel.math.*;

class NFMathExt {
    public static function toVector(p:FlxPoint) {
        return FlxVector.get(p.x, p.y);
    }
}