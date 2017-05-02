
package;

import flixel.util.FlxSave;

import states.game.*;

class Registry {
    // constants

    public static var gameVersion:String = "v0.3.0.2 alpha";

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
        gameLevel = saveSlot.data.level;
        #if (!cpp)
        if (gameLevel == null) {
            gameLevel = 0;
        }
        #end
    }
}