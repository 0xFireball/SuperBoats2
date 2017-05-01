package states.game;

import flixel.*;
import flixel.util.*;

import nf4.ui.*;

import ui.*;

class PauseSubState extends FlxSubState {

    private var previousZoom:Float;

    public override function create() {
        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

        var levelText = new SBNFText(0, FlxG.camera.scroll.y + 160, "level " + Registry.gameLevel, 48);
        levelText.screenCenter(FlxAxes.X);
        levelText.x += FlxG.camera.scroll.x;
        add(levelText);

        var menuBtn = new SBNFButton(0, 640, "Exit to Menu", onReturnToMenu);
		menuBtn.screenCenter(FlxAxes.X);
		add(menuBtn);

        var returnBtn = new SBNFButton(0, 700, "Return", onReturnToGame);
		returnBtn.screenCenter(FlxAxes.X);
		add(returnBtn);

        previousZoom = FlxG.camera.zoom;
        FlxG.camera.zoom = FlxG.camera.initialZoom;

        super.create();
    }

    public override function update(dt:Float) {
        #if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            // dismiss menu
			onReturnToGame();
		}
        #end

        super.update(dt);
    }

    private function onReturnToMenu() {
        // return to menu
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new MenuState());
        });
        this.close();
    }

    private function onReturnToGame() {
        FlxG.camera.zoom = previousZoom;
        // return to game
        this.close();
    }

}