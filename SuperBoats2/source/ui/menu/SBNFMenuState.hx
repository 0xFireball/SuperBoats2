
package ui.menu;

import flixel.*;

import nf4.ui.menu.*;
import nf4.ui.menu.items.*;

import ui.*;

enum MenuItemType {
    Button;
    Switch;
    Input;
    Other;
}

interface IMenuItemData {
    public var disabled:Bool;
    public var type:MenuItemType;
}

class MenuButtonData implements IMenuItemData {
    
    public var disabled:Bool;
    public var type:MenuItemType = MenuItemType.Button;

    public var text:String;
    public var callback:Void->Void;

    public function new(Text:String, ?Callback:Void->Void, Disabled:Bool = false) {
        text = Text;
        callback = Callback;
        disabled = Disabled;
    }
}

class MenuSwitchData implements IMenuItemData {

    public var disabled:Bool;
    public var type:MenuItemType = MenuItemType.Switch;

    public var items:Array<String>;
    public var callback:Void->Void;
    public var selectionChanged:Int->Void;
    public var selectedIndex:Int;

    public function new(Items:Array<String>, ?SelectedIndex:Int = 0, ?Callback:Void->Void, ?SelectionChanged:Int->Void, Disabled:Bool = false) {
        items = Items;
        selectedIndex = SelectedIndex;
        callback = Callback;
        selectionChanged = SelectionChanged;
        disabled = Disabled;
    }
}

class MenuInputData implements IMenuItemData {
    
    public var disabled:Bool;
    public var type:MenuItemType = MenuItemType.Input;

    public var value:String;
    public var callback:Void->Void;
    public var textChanged:String->Void;
    public var maxLength:Int;

    public function new(?Value:String, ?MaxLength:Int = 0, ?Callback:Void->Void, ?TextChanged:String->Void) {
        value = Value;
        maxLength = MaxLength;
        callback = Callback;
        textChanged = TextChanged;
    }
}

class SBNFMenuState extends FlxState {

    private var menuGroup:NFMenuItemGroup = new NFMenuItemGroup();
    private var menuWidth:Float = 240;
    private var menuItems:Array<IMenuItemData> = new Array<IMenuItemData>();
    private var menuItemTextSize:Int = 24;

    public override function create() {
        // bind and create menu

        var createText = function (?Text:String) {
            return new SBNFText(0, 0, null, Text, menuItemTextSize);
        };

        for (itemData in menuItems) {
            var uiItem:NFMenuItem = null;
            switch (itemData.type) {
                case MenuItemType.Button:
                    var buttonData:MenuButtonData = cast itemData;
                    var buttonItem = new NFMenuItem(
                        createText(buttonData.text),
                        menuWidth,
                        buttonData.callback
                    );
                    uiItem = buttonItem;
                case MenuItemType.Switch:
                    var switchData:MenuSwitchData = cast itemData;
                    var switchItem = new NFMenuSwitch(
                        createText(null),
                        switchData.items,
                        menuWidth,
                        switchData.selectedIndex,
                        switchData.callback,
                        switchData.selectionChanged
                    );
                    uiItem = switchItem;
                case MenuItemType.Input:
                    var inputData:MenuInputData = cast itemData;
                    var inputItem = new NFMenuInput(
                        createText(null),
                        inputData.value,
                        menuWidth,
                        inputData.maxLength,
                        inputData.callback,
                        inputData.textChanged
                    );
                    uiItem = inputItem;
                default:
            }
            
            if (itemData.disabled) {
                uiItem.disable();
            }

            menuGroup.addItem(uiItem);
        }

        add(menuGroup);

        super.create();
    }

}