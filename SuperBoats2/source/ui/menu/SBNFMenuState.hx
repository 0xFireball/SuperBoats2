
package ui.menu;

import flixel.*;

import nf4.ui.menu.*;

import ui.*;

enum MenuItemType {
    Button;
    Switch;
    Other;
}

interface IMenuItemData {
    public var disabled:Bool;
    public var type:MenuItemType;
}

class MenuButtonData implements IMenuItemData {
    
    public var disabled:Bool;

    public var text:String;
    public var callback:Void->Void;
    public var type:MenuItemType = MenuItemType.Button;

    public function new(Text:String, ?Callback:Void->Void, Disabled:Bool = false) {
        text = Text;
        callback = Callback;
        disabled = Disabled;
    }
}

class MenuSwitchData implements IMenuItemData {
    public var disabled:Bool;

    public var items:Array<String>;
    public var callback:Void->Void;
    public var type:MenuItemType = MenuItemType.Button;

    public function new(Items:Array<String>, ?Callback:Void->Void, Disabled:Bool = false) {
        items = Items;
        callback = Callback;
        disabled = Disabled;
    }
}

class SBNFMenuState extends FlxState {

    private var menuGroup:NFMenuItemGroup = new NFMenuItemGroup();
    private var menuWidth:Float = 240;
    private var menuItems:Array<IMenuItemData> = new Array<IMenuItemData>();
    private var menuItemTextSize:Int = 24;

    public override function create() {
        // bind and create menu

        for (itemData in menuItems) {
            switch (itemData.type) {
                case MenuItemType.Button:
                    var buttonData:MenuButtonData = cast itemData;
                    var buttonItem = new NFMenuItem(
                        new SBNFText(0, 0, null, buttonData.text, menuItemTextSize),
                        menuWidth,
                        buttonData.callback
                    );
                    if (buttonData.disabled) {
                        buttonItem.disable();
                    }
                    menuGroup.addItem(buttonItem);
                default:
                    // ?
            }
        }

        add(menuGroup);

        super.create();
    }

}