package states.game;

import flixel.*;
import flixel.util.*;

import nf4.ui.*;

class PauseSubState extends FlxSubState {

    public override function create() {
        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

        var levelText = new NFText(0, 160, "level " + Registry.gameLevel, 48);
        levelText.screenCenter(FlxAxes.X);
        add(levelText);

        var menuBtn = new NFButton(0, 600, "Exit to Menu", onReturnToMenu);
		menuBtn.screenCenter(FlxAxes.X);
		add(menuBtn);

        var returnBtn = new NFButton(0, 700, "Return", onReturnToGame);
		returnBtn.screenCenter(FlxAxes.X);
		add(returnBtn);

        super.create();
    }

    public override function update(dt:Float) {
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            // dismiss menu
			onReturnToGame();
		}

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
        // return to game
        this.close();
    }

}