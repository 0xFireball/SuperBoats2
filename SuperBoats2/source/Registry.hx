
package;

import flixel.util.FlxSave;

class Registry {
    // constants

    public static var gameVersion:String = "v0.2.0.0 alpha";

    // vars

    public static var gameLevel:Int = 0;

    private static var defaultSaveName:String = "0";

    public static var saveSlot:FlxSave;

    public static function loadSave() {
        saveSlot = new FlxSave();
        saveSlot.bind(defaultSaveName);
        reloadSave();
    }

    public static function reloadSave() {
        gameLevel = saveSlot.data.level;
        #if (!cpp)
        if (gameLevel == null) {
            gameLevel = 0;
        }
        #end
    }
}