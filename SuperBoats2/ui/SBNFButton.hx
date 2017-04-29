package ui;

import nf4.ui.NFButton;

class SBNFButton extends NFButton {
    public function new(X:Float = 0, Y:Float = 0, ?Text:String, ?OnClick:Void->Void) {
        super(X, Y, Text, OnClick);

        label.font = AssetPaths.raleway__ttf;
    }
}