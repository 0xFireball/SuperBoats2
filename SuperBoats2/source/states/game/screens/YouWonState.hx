package states.game.screens;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import states.game.*;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

import ui.*;
import ui.menu.*;
import ui.menu.SBNFMenuState;

class YouWonState extends SBNFMenuState {

    public var effectEmitter:NFParticleEmitter;

    private var nextLevel:Int;

    public override function create() {
        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

        var titleTx = new SBNFText(0, 180, "SuperBoats 2", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
        add(titleTx);

        effectEmitter = new NFParticleEmitter(200);
        add(effectEmitter);

        var tt2 = new SBNFText(0, 340, "you won. level " + Registry.gameLevel + " complete.", 32);
		tt2.screenCenter(FlxAxes.X);
		add(tt2);

        // set up menu
		menuGroup.updatePosition(FlxG.width / 2, 500);
        menuGroup.itemMargin = 12;
        menuWidth = 240;
        menuItemTextSize = 32;

		menuItems.push(
            new MenuButtonData("Menu", onReturnToMenu)
        );

        menuItems.push(
            new MenuButtonData("Next Level", onClickNextLv)
        );

        super.create();
    }

    public override function update(dt:Float) {
        // bright fire
		for (i in 0...12) {
			effectEmitter.emitSquare(FlxG.width / 2, FlxG.height / 2, Std.int(Math.random() * 6 + 3),
				NFParticleEmitter.velocitySpread(220),
			NFColorUtil.randCol(0.2, 0.9, 0.2, 0.1), 1.1);
		}

        // hotkeys
        #if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ENTER ])) {
			onClickNextLv();
		}
        if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			onReturnToMenu();
		}
        #end

        super.update(dt);
    }

    private function onClickNextLv() {
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new ClassicPlayState());
        });
    }

    private function onReturnToMenu() {
        // return to menu
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new MenuState());
        });
    }

}