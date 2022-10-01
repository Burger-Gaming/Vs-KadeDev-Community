package meta.state.menus;

import flixel.util.FlxTimer;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import meta.MusicBeat.MusicBeatState;


// 0 = active, 1 = hovered, 2 = normal
class ChannelButton extends FlxSprite {
    public var isActive = false;
    public override function new(optionKey: String, index: Int, callback: () -> Void) {
        super();
        ID = index;
        scale.set(.6, .6);
        x = 20;
        /*screenCenter(X);
        x -= 270;*/
        y = 180;
        y += index * 80;
        antialiasing = true;
		frames = Paths.getSparrowAtlas('menus/base/buttons/$optionKey');
		animation.addByPrefix("idle", '$optionKey idle', 0, true);
		animation.play("idle");
		animation.curAnim.curFrame = 2;
		FlxMouseEventManager.add(this, t -> {
			t.animation.curAnim.curFrame = 0;
			FlxG.mouse.useSystemCursor = false;
			FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.sound('confirmMenu'));
            new FlxTimer().start(2, timer -> callback());

		}, null,
			t -> t.animation.curAnim.curFrame = 1, 
            t -> t.animation.curAnim.curFrame = 2
        );
        updateHitbox();
    }
    
}

class TEST_MainMenuState extends MusicBeatState {
	var channelBG: FlxSprite;
    var channelSide: FlxSprite;
    var channelTop: FlxSprite;
    var funniDiscordTV: FlxSprite;
    var selectables = ["story-mode", "freeplay", "credits", "shop", "options"];
    var selectableMenus = [new StoryMenu()];
    var curSelected = 0;
    var menuItems = new FlxTypedGroup<ChannelButton>();
    override function create() {
        super.create();
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
		channelBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString("#2f3136"));
        add(channelBG);
        for (x in 0...selectables.length) { 
			var button = new ChannelButton(selectables[x], x, () -> switchStates(selectables[x]));
            menuItems.add(button); 
        }
        add(menuItems);
    } 

    function switchStates(optionKey:String) {
        switch (optionKey) {
            case "story-mode": Main.switchState(this, new StoryMenuState());
            case "freeplay": Main.switchState(this, new FreeplayState());
            case "credits": Main.switchState(this, new CreditsState());
            case "shop": Main.switchState(this, new CreditsState()); // todo
            case "options": Main.switchState(this, new OptionsMenuState());
        }
    }

}