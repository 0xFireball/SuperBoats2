package util;

class SaveUtil {
    public static function saveGameLevel() {
        Registry.saveSlot.data.level = Registry.gameLevel;
		Registry.saveSlot.flush();
    }
}