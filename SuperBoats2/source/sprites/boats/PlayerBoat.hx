
package sprites.boats;

import flixel.*;

class PlayerBoat extends GreenBoat {
    public var allyCount:Int = 0;
	public var maxAllyCount:Int = 6;

	private var allySpawnFrequency:Int = 400;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:GameStateData) {
		
		super(X, Y, StateData);

		maxHealth = health = 220000;
		hullShieldMax = hullShieldIntegrity = 72000;
		hullShieldRegen = 100;
		attackTime = 0.7;
		angularThrust = 0.05 * Math.PI;
		thrust = 3.5;
		wrapBounds = false;
		mass = 28000;
		sprayAmount = 8;
        loadGraphic(AssetPaths.player_boat__png);
		// renderGraphic(16, 36, function (gpx) {
		// 	var ctx = gpx.g2;
		// 	ctx.begin();
		// 	ctx.color = FlxColor.fromRGBFloat(0.1, 0.3, 0.9);
		// 	ctx.fillRect(0, 0, width, height);
		// 	ctx.color = FlxColor.fromRGBFloat(0.1, 0.5, 0.9);
		// 	ctx.fillRect(width / 3, height * (3 / 4), width / 3, height / 4);
		// 	ctx.end();
		// }, "playerboat");
	}
}