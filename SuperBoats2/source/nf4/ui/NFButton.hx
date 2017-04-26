package nf4.ui;

import flixel.*;
import flixel.util.*;
import flixel.text.FlxText;
import flixel.ui.*;

class NFButton extends FlxButton {

    public function new(X:Float = 0, Y:Float = 0, ?Text:String, ?OnClick:Void->Void) {
        super(X, Y, Text, OnClick);

        loadGraphic(AssetPaths.button__png, true, 142, 37);
        label.setFormat(AssetPaths.champagneLimousines__ttf, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
    }

}