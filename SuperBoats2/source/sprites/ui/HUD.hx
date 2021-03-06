package sprites.ui;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

import nf4.*;
import nf4.ui.*;

import states.game.data.*;

import ui.*;

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

        shieldIntText = new SBNFText(40, 4, "Shield", 16);
        add(shieldIntText);

        hullIntText = new SBNFText(60 + shieldIntText.x + shieldIntText.width, 4, "Hull", 16);
        add(hullIntText);

        scrollFactor.set(0, 0);
    }

    public override function update(dt:Float) {

        shieldIntText.text = "Shield: " + Std.int(stateData.player.shieldPercentage) + "%";

        hullIntText.text = "Hull: " + Std.int(stateData.player.healthPercentage) + "%";

        // indicator coloring

        if (stateData.player.shieldPercentage > 92) {
            shieldIntText.color = FlxColor.fromRGBFloat(0.7, 1.0, 0.7);
        } else if (stateData.player.shieldPercentage < 25) {
            shieldIntText.color = FlxColor.fromRGBFloat(1.0, 0.7, 0.7);
        } else if (stateData.player.shieldPercentage < 60) {
            shieldIntText.color = FlxColor.fromRGBFloat(1.0, 1.0, 0.7);
        } else {
            shieldIntText.color = FlxColor.WHITE;
        }

        if (stateData.player.healthPercentage > 92) {
            hullIntText.color = FlxColor.fromRGBFloat(0.7, 1.0, 0.7);
        } else if (stateData.player.healthPercentage < 25) {
            hullIntText.color = FlxColor.fromRGBFloat(1.0, 0.7, 0.7);
        } else if (stateData.player.healthPercentage < 60) {
            hullIntText.color = FlxColor.fromRGBFloat(1.0, 1.0, 0.7);
        } else {
            hullIntText.color = FlxColor.WHITE;
        }

        super.update(dt);
    }

    public override function destroy() {
        // remove statedata reference
        stateData = null;

        super.destroy();
    }

}