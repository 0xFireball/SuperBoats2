package ui;

import nf4.ui.NFText;

class SBNFText extends NFText {
    public function new(X:Float = 0, Y:Float = 0, ?FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);

        color = Registry.foregroundColor;
        font = AssetPaths.disposable_droid__ttf;
    }
}