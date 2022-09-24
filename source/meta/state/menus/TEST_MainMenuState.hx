package meta.state.menus;

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
        scale.set(.4, .4);
        x = 20;
        y = 50;
        y += index * 50;
        antialiasing = true;
		frames = Paths.getSparrowAtlas('menus/base/buttons/$optionKey');
		animation.addByPrefix("idle", '$optionKey idle', 0, true);
		animation.play("idle");
		animation.curAnim.curFrame = 2;
		FlxMouseEventManager.add(this, t -> {
			if (!isActive) {
				t.animation.curAnim.curFrame = 0;
				isActive = true;
			}
			callback();
		}, null,
			t -> if (!isActive) t.animation.curAnim.curFrame = 1, 
            t -> if (!isActive) t.animation.curAnim.curFrame = 2
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
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
		channelBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString("#373a3f"));
        add(channelBG);
		channelSide = new FlxSprite().makeGraphic(350, FlxG.height, FlxColor.fromString("#2f3136"));
        add(channelSide);
        funniDiscordTV = new FlxSprite(700).loadGraphic(Paths.image("menus/base/funnidiscordtv"));
        funniDiscordTV.scale.set(2.5, 2.5);
        funniDiscordTV.antialiasing = true;
        funniDiscordTV.screenCenter(Y);
        add(funniDiscordTV);
        for (x in 0...selectables.length) { 
			var button = new ChannelButton(selectables[x], x, () -> { 
                showContent();
				// menuItems.forEach(t -> t.isActive = t.ID != x);
            });
            menuItems.add(button); 
        }
        add(menuItems);
    } 

    function showContent() {
        funniDiscordTV.visible = false;
        var testMenu = new StoryMenu();
        testMenu.positionSprites();
        add(testMenu);
    }
}