package sprites.ui;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

import nf4.ui.*;

import states.game.data.*;

class HUD extends FlxSpriteGroup {

    public var shieldIntText:NFText;
    public var hullIntText:NFText;

    public var stateData:GameStateData;

    public function new(StateData:GameStateData) {
        super();

        stateData = GameStateData;

        shieldIntText = new NFText(4, 4, "Shield Integrity");
        add(shieldIntText);

        hullIntText = new NFText(4 + shieldIntText.x + shieldIntText.width, 4, "Hull Integrity");
        add(hullIntText);

        scrollFactor.set(0, 0);
    }

    public override function update(dt:Float) {

        shieldIntText.text = "Shield Integrity: " + Std.int(stateData.player.shieldPercentage) + "%";

        hullIntText.text = "Hull Integrity: " + Std.int(stateData.player.healthPercentage) + "%";

        super.update(dt);
    }

}