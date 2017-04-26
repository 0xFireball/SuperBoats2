package states.game;

import flixel.*;
import flixel.util.*;

import nf4.ui.*;

class PauseSubState extends FlxSubState {

    public override function create() {
        super.create();

        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

        var menuBtn = new NFButton(0, 600, "Exit to Menu", onReturnToMenu);
		menuBtn.screenCenter(FlxAxes.X);
		add(menuBtn);

        var returnBtn = new NFButton(0, 700, "Return", onReturnToGame);
		returnBtn.screenCenter(FlxAxes.X);
		add(returnBtn);
    }

    public function onReturnToMenu() {
        // return to menu
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new MenuState());
        });
        this.close();
    }

    public function onReturnToGame() {
        // return to game
        this.close();
    }

}