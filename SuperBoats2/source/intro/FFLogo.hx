package intro;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class FFLogo extends FlxSprite
{
	
	public var scaleFactor:Float = 1;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.petaphaser__png);
	}
	
	override public function update(elapsed:Float)
	{
		scale = FlxPoint.get(scaleFactor, scaleFactor);
		super.update(elapsed);
	}
}