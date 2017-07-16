package states;

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

class MenuState extends SBNFMenuState {
    private var titleTx:NFText;

    private var emitter:FlxEmitter;
    public var effectEmitter:NFParticleEmitter;

    public var flixelEmitter:Bool = true;

    public var emitterExplosion:Bool = true;
    public var normalEmitTime:Float = 1.1;
    public var normalEmitTimer:Float = 0;

    public var hitPlay:Bool = false;
    public var canPlay:Bool = false;

    override public function create():Void
    {
        #if !FLX_NO_MOUSE
        FlxG.mouse.visible = true;
        FlxG.mouse.load(AssetPaths.mouse__png);
        #end

        bgColor = Registry.backgroundColor;

        titleTx = new SBNFText(0, 0, "SuperBoats 2", 84);
        titleTx.color = FlxColor.WHITE;
        titleTx.screenCenter(FlxAxes.X);
        titleTx.y = -titleTx.height;
        var titleFinalY = 180;
        FlxTween.tween(titleTx, { y: titleFinalY }, 0.7, { ease: FlxEase.cubeOut });

        emitter = new FlxEmitter(FlxG.width / 2, titleFinalY + titleTx.height * 1.2);
        emitter.scale.set(2, 2, 8, 8, 12, 12, 12, 12);
        emitter.makeParticles(1, 1, FlxColor.WHITE, 200);
        emitter.color.set(FlxColor.fromRGBFloat(0.0, 0.4, 0.6), FlxColor.fromRGBFloat(0.4, 0.8, 1.0));
        emitter.alpha.set(1, 1, 0, 0);
        emitter.speed.set(400, 580);
        emitter.lifespan.set(0.8);
        // start emitter
        emitter.start(true);
        add(emitter);

        add(titleTx); // add title after emitter

        var credits = new SBNFText(32, 0, "PetaPhaser", 48);
        credits.y = FlxG.height - (credits.height + 32);
        add(credits);

        var version = new SBNFText(32, 0, Registry.gameVersion, 48);
        version.y = FlxG.height - (version.height + 32);
        version.x = FlxG.width - (version.width + 32);
        add(version);

        // set up menu
        menuGroup.updatePosition(FlxG.width / 2, 340);
        menuGroup.itemMargin = 12;
        menuWidth = 240;
        menuItemTextSize = 32;

        menuItems.push(
            new MenuButtonData("Play", onClickPlay)
        );

        menuItems.push(
            new MenuButtonData("Settings", onClickSettings)
        );

        #if desktop
		menuItems.push(
            new MenuButtonData("Exit", tryExitGame)
        );
        #end

        var lvtx = new SBNFText(0, 410, "level " + Registry.gameLevel, 24);
        lvtx.screenCenter(FlxAxes.X);
        add(lvtx);

        FlxTween.color(credits, 0.9, FlxColor.fromRGBFloat(0.8, 0.1, 0.1), FlxColor.fromRGBFloat(0.98, 0.98, 0.98), { startDelay: 0.6, ease: FlxEase.cubeInOut });

        FlxG.camera.fade(FlxColor.fromInt(0xFF0B2B37), 1.1, true, function () {
            canPlay = true;
        });
        FlxG.camera.shake(0.01, 0.5);

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        normalEmitTimer += elapsed;
        if (emitterExplosion && normalEmitTimer > normalEmitTime) {
            emitterExplosion = false;
            emitter.speed.set(120, 280);
            emitter.lifespan.set(0.6);
            emitter.start(false, 0.003);
        }

        // hotkeys
        #if !FLX_NO_KEYBOARD
        if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            tryExitGame();
        }
        #end

        super.update(elapsed);
    }

    private function onClickPlay() {
        if (!canPlay || hitPlay) return;
        hitPlay = true;
        var waveFct = new FlxWaveEffect(12);
        var distortedTitle = new FlxEffectSprite(titleTx, [ waveFct ]);
        distortedTitle.setPosition(titleTx.x, titleTx.y);
        add(distortedTitle);
        FlxTween.tween(titleTx, { alpha: 0 }, 0.8, { onComplete: function (t) {
            remove(titleTx);
        }});
        FlxTween.tween(distortedTitle, { alpha: 1 }, 0.8, { ease: FlxEase.cubeIn });
        // switch
        FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function () {
            FlxG.switchState(new GameSelectState());
        });
    }

    private function onClickSettings() {
        FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function () {
            FlxG.switchState(new SettingsState());
        });
    }

    private function tryExitGame() {
		#if (desktop)
		openfl.system.System.exit(0);
		#end
	}
}
