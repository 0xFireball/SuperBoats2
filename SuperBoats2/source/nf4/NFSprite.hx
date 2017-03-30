
package nf4;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class NFSprite extends FlxSprite {
    public var damage(get, set):Float;
	public var center(get, null):FlxPoint;

    /**
	 * Utility for storing maximum health
	 */
	public var maxHealth:Float = 1;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
        damage = 0;
    }

    private function get_damage():Float {
		var mHealth = health < 0 ? 0 : health;
		return 1 - (mHealth / maxHealth);
	}

	private function set_damage(f:Float):Float {
		health = (1 - f) * maxHealth;
		return damage;
	}

	private function get_center():FlxPoint {
		return FlxPoint.get(x + width / 2, y + height / 2);
	}
}