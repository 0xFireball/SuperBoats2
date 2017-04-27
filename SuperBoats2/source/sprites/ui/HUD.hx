package sprites.ui;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

import nf4.*;
import nf4.ui.*;

import states.game.data.*;

class HUD extends FlxSpriteGroup {

    public var shieldIntText:NFText;
    public var hullIntText:NFText;

    public var backing:NFSprite;

    public var stateData:GameStateData;

    public function new(StateData:GameStateData) {
        super();

        stateData = StateData;

        backing = new NFSprite();
        backing.makeGraphic(FlxG.width, 24, FlxColor.fromRGBFloat(0.3, 0.3, 0.3, 0.6));
        add(backing);

        shieldIntText = new NFText(40, 4, "Shield Integrity", 16);
        add(shieldIntText);

        hullIntText = new NFText(60 + shieldIntText.x + shieldIntText.width, 4, "Hull Integrity", 16);
        add(hullIntText);

        scrollFactor.set(0, 0);
    }

    public override function update(dt:Float) {

        shieldIntText.text = "Shield Integrity: " + Std.int(stateData.player.shieldPercentage) + "%";

        hullIntText.text = "Hull Integrity: " + Std.int(stateData.player.healthPercentage) + "%";

        super.update(dt);
    }

}