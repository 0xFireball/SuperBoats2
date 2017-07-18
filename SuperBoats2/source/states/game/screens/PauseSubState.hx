package states.game.screens;

import flixel.*;
import flixel.util.*;

import nf4.ui.*;
import nf4.ui.menu.*;

import ui.*;
import ui.menu.SBNFMenuState;

class PauseSubState extends FlxSubState {

    public var menuItems:NFMenuItemGroup;
    private var menuWidth:Float = 300;

    private var showLevel:Bool = false;

    public function new(BGColor:FlxColor = FlxColor.TRANSPARENT, ShowLevel:Bool = false) {
        super(BGColor);
        showLevel = ShowLevel;
    }

    public override function create() {
        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

        var infoTextContent = showLevel ? 'level ${Registry.gameLevel}' : "paused";
        var infoText = new SBNFText(0, 160 + FlxG.camera.scroll.y, infoTextContent, 48);
        infoText.screenCenter(FlxAxes.X);
        infoText.x += FlxG.camera.scroll.x;
        add(infoText);

        menuItems = new NFMenuItemGroup();
        menuItems.updatePosition(FlxG.width / 2 + FlxG.camera.scroll.x, FlxG.camera.scroll.y + 440);
        add(menuItems);

        var menuBtn = new NFMenuItem(
            new SBNFText("Exit to Menu", 30),
            menuWidth,
            onReturnToMenu
        );

        var returnBtn = new NFMenuItem(
            new SBNFText("Return", 30),
            menuWidth,
            onReturnToGame
        );

        menuItems.addItem(menuBtn);
        menuItems.addItem(returnBtn);

        super.create();
    }

    public override function update(dt:Float) {
        #if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            // dismiss menu
			onReturnToGame();
		}
        #end
        #if !FLX_NO_GAMEPAD
        if (FlxG.gamepads.lastActive != null) {
            if (FlxG.gamepads.lastActive.anyJustPressed([ START ])) {
                onReturnToGame();
            }
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
        // return to game
        this.close();
    }

}