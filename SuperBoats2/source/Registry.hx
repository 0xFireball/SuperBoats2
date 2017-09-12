
package;

import flixel.util.*;

import states.game.*;

class Registry {
    // constants

    public static var gameVersion:String = "v0.5.5";

    public static function updateMetadata() {
        #if (neko)
        gameVersion += " ~neko";
        #end

        #if (mobile)
        gameVersion += " ~mobile";
        #end

        #if (debug)
        gameVersion += " ~dbg";
        #end

        #if (experimental)
        gameVersion += " ~exp";
        #end
    }

    // vars

    public static var gameLevel:Int = 0;

    public static var gameMode:GameMode = GameMode.Classic;

    private static var defaultSaveName:String = "superboats2_slot0";

    public static var saveSlot:FlxSave;

    public static function loadSave() {
        saveSlot = new FlxSave();
        saveSlot.bind(defaultSaveName);
        reloadSave();
    }

    public static function reloadSave() {
        prepareSave();
        gameLevel = saveSlot.data.level;
    }

    public static function prepareSave() {
        // make sure save is set to defaults
        if (saveSlot.data.f == null || !saveSlot.data.f) {
            saveSlot.data.f = true;

            // set defaults
            saveSlot.data.level = 0;
            saveSlot.data.autosave = true;
        }
    }

    // color constants
    public static var backgroundColor:FlxColor = FlxColor.fromInt(0xFF0B2B36);

    public static var dimBackgroundColor:FlxColor = FlxColor.fromInt(0xFF51512E);

    public static var foregroundColor:FlxColor = FlxColor.fromInt(0xFFE8E676);

    public static var foregroundAccentColor:FlxColor = FlxColor.fromInt(0xFFFFFEB0);

    public static var washoutColor:FlxColor = FlxColor.fromInt(0xFFFFFEDE);

    public static var unfocusColor:FlxColor = FlxColor.fromRGBFloat(0.7, 0.7, 0.7, 0.8);
}