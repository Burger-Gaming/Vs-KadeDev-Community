package meta.state.menus;

import flixel.text.FlxText;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;


class StoryMenu extends FlxTypedGroup<FlxBasic> {
    public override function new() {
        super();
        var testSprite = new FlxText();
        testSprite.text = "hi this is a test";
        testSprite.size = 40;
        add(testSprite);
    }
    public inline function positionSprites() this.forEach(t -> {
        var item = cast t;
        item.x = 400;
        item.y += 40;
    });


}