package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.MusicBeat.MusicBeatState;

// 0 = active, 1 = hovered, 2 = normal
class ChannelButton extends FlxSprite {
    public var selected:Bool = false;
    public var otherSelected:Bool = false;
    public override function new(optionKey: String, index: Int, allButtons:FlxTypedGroup<ChannelButton>, callback: ChannelButton -> Void) {
        super();
        ID = index;
        scale.set(.6, .6);
        x = 20;
        y = 180;
        y += index * 80;
        antialiasing = true;
		frames = Paths.getSparrowAtlas('menus/base/buttons/$optionKey');
		animation.addByPrefix("idle", '$optionKey idle', 0, true);
		animation.play("idle");
		animation.curAnim.curFrame = 2;
		FlxMouseEventManager.add(this, t -> {
            selected = true;
            otherSelected = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			animation.curAnim.curFrame = 0;
            for (x in 0...allButtons.members.length) {
                allButtons.members[x].animation.stop();
                if (ID != x) FlxTween.tween(allButtons.members[x], { x: -900 }, .5, { ease: FlxEase.quadIn });
                else FlxTween.tween(allButtons.members[x], { "scale.x": .63, "scale.y": .63 }, .5, { ease: FlxEase.quadInOut, onComplete: tt -> {
					t.animation.curAnim.curFrame = 0;
					new FlxTimer().start(1, timer -> callback(this));
                } });
            }

		}, null,
			t -> { if (!selected || otherSelected) t.animation.curAnim.curFrame = 1; }, 
            t -> { if (!selected || otherSelected) t.animation.curAnim.curFrame = 2; }
        );
        updateHitbox();
    }
    
}
class MainMenuState extends MusicBeatState {
	var channelBG: FlxSprite;
    var channelSide: FlxSprite;
    var channelTop: FlxSprite;
    var funniDiscordTV: FlxSprite;
    var selectables = ["story-mode", "freeplay", "credits", "shop", "options"];
    var menuItems:FlxTypedGroup<ChannelButton> = new FlxTypedGroup<ChannelButton>();
    var versionTxt: FlxText;
    override function create() {
        super.create();
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
		channelBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString("#373a3f"));
        add(channelBG);

        
		channelSide = new FlxSprite().makeGraphic(530, FlxG.height, FlxColor.fromString("#2f3136"));
        add(channelSide);
        for (x in 0...selectables.length) { 
			var button = new ChannelButton(selectables[x], x, menuItems, b -> {
                switchStates(selectables[x]);
            });
            menuItems.add(button); 
        }
        add(menuItems);

        /*new FlxTimer().start(0.5, t -> menuItems.forEach(d -> {
            if (!d.selected || d.otherSelected) d.animation.curAnim.curFrame = 2;
        }), 0);*/
		versionTxt = new FlxText(0, FlxG.height - 30);
		versionTxt.text = 'KDC v${Main.modVersion} | FE v${Main.gameVersion}';
        versionTxt.font = Paths.font("whitneybold.otf");
        versionTxt.color = 0xA3A6AA;
        versionTxt.size = 20;
        add(versionTxt);

    }

    override function update(elapsed:Float) {
        super.update(elapsed);
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