package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gameObjects.userInterface.CreditIcon;
import meta.MusicBeat.MusicBeatState;
import meta.data.Conductor;
import meta.data.font.Alphabet;
import openfl.text.TextField;
import openfl.text.TextFormat;

// i didn't steal this from psych i swear
// grrr skull youre FIRED from stealing CODE.
class CreditsName extends FlxTypedGroup<FlxSprite> {
    public var isActive:Bool = false;
    var icon:CreditIcon;
    var iconPath:String;
    var name:String;
    var nameSpr:Alphabet;
    var link:String;
    public var y:Int;
    public var nextY = 0;
    public function new(x:Int, y:Int, name:String, iconPath:String, link:String) {
        super();
        this.link = link;
        this.y = y;

		icon = new CreditIcon(iconPath);
        icon.scrollFactor.set();

		nameSpr = new Alphabet(x, y, name, false);
		nameSpr.scrollFactor.set();
		icon.sprTracker = nameSpr;

		this.add(icon);
		this.add(nameSpr);

		if (!isActive) {
			nameSpr.alpha = .75;
			icon.alpha = .75;
		}
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (isActive) {
			nameSpr.alpha = 1;
			icon.alpha = 1;
            if (FlxG.keys.justPressed.ENTER) MusicBeatState.fancyOpenURL(link);
        }

        else {
			nameSpr.alpha = .75;
			icon.alpha = .75;
        }

        if (nextY != 0) {
            nameSpr.y += nextY;
        }
    }
    
}

class CreditsState extends MusicBeatState {
    var credits:Array<Array<Dynamic>> = [
        // name, icon name, cool quote, what they did ("1, 2, 3"), link, color (int)
        ['Red', 'red', 'THE OWO', 'Artist of yoda sprites', 'https://example.com/', 0xEB002D],
        ['Soulslimm', 'soulslimm', 'pending quote', 'pending actions...', 'https://example.com', 0xC0762A],
        ['Burger', 'burger', 'pending quote', 'Primarily programmed this, Charted a bunch of songs', 'https://example.com/', 0xFFFF00],
        ['Lemlom', 'lemlem', 'pending quote', 'Made fabi and own sprites', 'https://example.com/', 0xFFCC66],
        ['Multi-hand', 'multihand', 'pending quote', 'Made ACFH sprites', 'https://example.com/', 0x4391E6],
        ['KadeDev', 'kadedev', 'no quote :(', 'Composed fabilicious, Made the community', 'https://github.com/kadedev', 0x4b6448]
    ];
    var bg:FlxSprite; 
    var coolCredits:FlxTypedGroup<CreditsName>;
    var quoteBox:FlxSprite;
    var quoteTxt:FlxText;
    var activeCred:Int = 0;
    var curCredName:Alphabet;
    var curCredIcon:CreditIcon;
    var iconDanced:Bool = false;
    var didWhatTxts:Array<FlxText> = [];
    var sectTitle:Alphabet;
    var arrowStuffs:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;
    //
    var lastColor:Int = 0;
    var colorTween:Null<FlxTween> = null;
	override function create() {
        super.create();
        
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		coolCredits = new FlxTypedGroup();
		add(coolCredits);


		quoteBox = new FlxSprite(FlxG.width / 1.9, FlxG.height / 3.2).makeGraphic(575, 450, FlxColor.BLACK);
        quoteBox.screenCenter(X);
        quoteBox.alpha = .65;
        add(quoteBox);
        
        curCredName = new Alphabet(quoteBox.x + 90, quoteBox.y - 150, "owo", true);
        add(curCredName);

		add(arrowStuffs);
		var tex = Paths.getSparrowAtlas("menus/base/storymenu/campaign_menu_UI_assets");

		leftArrow = new FlxSprite(quoteBox.x - 60);
        leftArrow.screenCenter(Y);
        leftArrow.frames = tex;
		leftArrow.animation.addByPrefix("idle", 'arrow left');
        leftArrow.animation.addByPrefix("press", 'arrow push left');
        leftArrow.animation.play("idle");
        add(leftArrow);

		rightArrow = new FlxSprite(quoteBox.x + 590);
		rightArrow.screenCenter(Y);
        rightArrow.frames = tex;
		rightArrow.animation.addByPrefix("idle", 'arrow right');
		rightArrow.animation.addByPrefix("press", 'arrow push right');
		rightArrow.animation.play("idle");
		add(rightArrow);

        /*creditsBox = new TextField();
		creditsBox.x = FlxG.width / 1.9;
		creditsBox.y = FlxG.height / 3.2;
		creditsBox.width = 575;
        creditsBox.height = 400;
        creditsBox.background = true;
        creditsBox.backgroundColor = FlxColor.fromRGB(0, 0, 0, 20);
        creditsBox.text = "aaaa";
		creditsBox.defaultTextFormat = new TextFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE);*/

        
        quoteTxt = new FlxText(quoteBox.x + 20, quoteBox.y + 20);
        quoteTxt.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        quoteTxt.borderSize = 2;
        add(quoteTxt);

		curCredIcon = new CreditIcon(credits[0][1]);
        curCredIcon.yOffset = -40;
		curCredIcon.sprTracker = curCredName;
		add(curCredIcon);


        for (x in 0...credits.length) {
			var credTarget = credits[x];
			var coolNewCreditItem = new CreditsName(140, Std.int(160 + x * 105), credTarget[0], credTarget[1], credTarget[4]);
            coolNewCreditItem.visible = false;
            coolCredits.add(coolNewCreditItem);
        }
        changeCred();

        /*var firstCred = coolCredits.members[0];
		sectTitle = new Alphabet(80, firstCred.y - 100, creditSections[0], true);
        sectTitle.visible = false;
        add(sectTitle);*/

        /*var uiBG = new FlxSprite(0, FlxG.height - 16).makeGraphic(1280, 16, FlxColor.BLACK);
        uiBG.alpha = 0.5;
        add(uiBG);*/

        // idk what to call it so i just said member descriptions lmfao
        // also you bitch said to press left and right yet the controls are up and down.
        // shut up nvm
        /*var uiText = new FlxText(0, 0, 0, "Press Up and Down to switch between member descriptions.", 16);
        uiText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        uiText.y = FlxG.height - uiText.height;
        add(uiText);*/
    }

    override function update(elapsed:Float) {
		super.update(elapsed);
        if (FlxG.keys.justPressed.ESCAPE) { 
            if (colorTween != null) colorTween.cancel();
            Main.switchState(this, new MainMenuState()); 
        }
		if (controls.UI_LEFT_P) changeCred(-1);
		if (controls.UI_RIGHT_P) changeCred(1);

        if (controls.UI_LEFT) leftArrow.animation.play("press");
        else leftArrow.animation.play("idle");

        if (controls.UI_RIGHT) rightArrow.animation.play("press");
        else rightArrow.animation.play("idle");
    }

    /*override function beatHit() {
		super.beatHit();
        trace('bruh beat hit');
        if (iconDanced) curCredIcon.angle = 25;
        else curCredIcon.angle = -25;
		iconDanced = !iconDanced;
    }*/

    // literally just freeplay selection lol
    function changeCred(change=0) {
        didWhatTxts.map(d -> remove(d));
        didWhatTxts = [];
        if (change == 0) { 
            coolCredits.members[0].isActive = true;
			quoteTxt.text = '"${credits[0][2]}"';
			var aaaa = credits[0][3].split(", ");
			var uwu = quoteBox.y + 70;
            for (x in 0...aaaa.length) {
				var coolTxt = new FlxText(quoteTxt.x, uwu + x * 30);
				coolTxt.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
				coolTxt.text = "-" + aaaa[x];
				coolTxt.borderSize = 2;
                didWhatTxts.push(coolTxt);
                add(coolTxt);
            }
            curCredName.text = credits[0][0];
			lastColor = credits[0][5];
            bg.color = lastColor;
            return;
        }
        
		FlxG.sound.play(Paths.sound('scrollMenu'));
        var prev = activeCred;

        activeCred += change;
		
        if (activeCred == -1) activeCred = credits.length - 1;
        else if (activeCred == credits.length) activeCred = 0;

        coolCredits.members[prev].isActive = false;
        coolCredits.members[activeCred].isActive = true;
		quoteTxt.text = '"${credits[activeCred][2]}"';
		curCredName.text = credits[activeCred][0];

        var coolNumeral = 0;
        for (x in 0...coolCredits.members.length) {
            
            if (change == 1) {
                var nextIndex = 0;
                if (x+1 == coolCredits.members.length) nextIndex = 0;
                else nextIndex = x+1;
				coolCredits.members[x].nextY = -105;
            }
            else {
                var nextIndex = 0;
                if (x-1 == -1) nextIndex = coolCredits.members.length - 1;
                else nextIndex = x-1;
				coolCredits.members[x].nextY = 105;
            }
			// coolCredits.members[x].nextY = coolNumeral - activeCred;
            // else x.nextY -= coolNumeral * 105;
            // coolNumeral++;
        }

		curCredIcon.loadGraphic(Paths.image('credits/${credits[activeCred][1]}'));

		var aaaa:Array<String> = credits[activeCred][3].split(", ");
		var uwu = quoteBox.y + 70;
		

        for (x in 0...aaaa.length) {
			var coolTxt = new FlxText(quoteTxt.x, uwu + x * 30);
			coolTxt.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			coolTxt.text = "-" + Std.string(aaaa[x]);
			coolTxt.borderSize = 2;
            didWhatTxts.push(coolTxt);
            add(coolTxt);
        }

        if (lastColor != credits[activeCred][5]) {
            if (colorTween != null) colorTween.cancel();
			lastColor = credits[activeCred][5];
			bg.color = credits[activeCred][5];
            // FlxTween.color()

			/* colorTween = FlxTween.color(bg, .5, bg.color, color, { // turns the bg black for some reason?? TODO
				onComplete: t -> colorTween = null
			}); */
        }

		// quoteTxt.x = quoteBox.getGraphicMidpoint().x - quoteTxt.width + quoteTxt.text.length + 40;


        /*for (x in 0...coolCredits.members.length) {
            var prev = x - 2;
            if (prev == -1) prev = coolCredits.members.length - 1;
			var target = coolCredits.members[x];
			trace('changed target y (${target.y}) to ${Std.int((FlxG.height / 2.7) + x * 150)}');
			coolCredits.members[x].nextY = Std.int((FlxG.height / 2.7) + prev * 150);
        }*/

    }
}