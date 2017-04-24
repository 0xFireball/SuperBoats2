package nf4.util;

import flixel.util.FlxColor;

class NFColorUtil {

    public static function randCol(R:Float, G:Float, B:Float, Variation:Float):FlxColor {
        var colDiff = Math.random() * Variation * 2 - Variation;
		return FlxColor.fromRGBFloat(R + colDiff, G + colDiff, B + colDiff);
    }

}