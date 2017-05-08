
package ui.menu;

import flixel.*;

import nf4.ui.menu.*;

import ui.*;

typedef MenuItemData = {
    var text: String;
    @:optional var callback: Void->Void;
    @:optional var disabled: Bool;
}

class SBNFMenuState extends FlxState {

    private var menuGroup:NFMenuItemGroup = new NFMenuItemGroup();
    private var menuWidth:Float = 240;
    private var menuItems:Array<MenuItemData> = new Array<MenuItemData>();
    private var menuItemTextSize:Int = 24;

    public override function create() {
        // bind and create menu

        for (itemData in menuItems) {
            var menuItem = new NFMenuItem(
                new SBNFText(0, 0, null, itemData.text, menuItemTextSize),
                menuWidth,
                itemData.callback
            );
            if (itemData.disabled != null && itemData.disabled) {
                menuItem.disable();
            }
            menuGroup.addItem(menuItem);
        }

        add(menuGroup);

        super.create();
    }

}