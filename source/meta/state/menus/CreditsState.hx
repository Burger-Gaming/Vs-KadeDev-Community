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
            nameSpr.y = nextY;
        }
    }
    
}

class CreditsState extends MusicBeatState {
    var credits:Array<Array<Dynamic>> = [
        // name, icon name, cool quote, what they did ("1, 2, 3"), link, color (int)
        ['uwu', 'bf-pixel', 'this mod sucks', 'thing one, thing 2, thing 3', 'https://github.com/skellypupper', FlxColor.RED],
        ['owo', 'bf-pixel', 'uwu', 'thing one, thing two, thing three', 'https://github.com', FlxColor.BLUE],
		['xwx', 'bf-pixel', 'OwO', 'thing a, thing b, thing c', 'https://github.com', FlxColor.GREEN],
        ['pwp', 'bf-pixel', 'this mod sucks', 'insulted team, failed to contribute, inserted name in credits, made waddle cry, hissed at children, slapped my mother', 'https://twitter.com', FlxColor.LIME],
        ['amogus', 'bf-pixel', 'i\'m not sus', 'did tasks, voted out red', 'https://amongus.com', FlxColor.ORANGE]

    ];
    var bg:FlxSprite; 
    var creditSections = ["KDC TEAM", "KDC TEAM"]; // the idea is that this gets paginated every 5 credit members
    var coolCredits:FlxTypedGroup<CreditsName>;
    var quoteBox:FlxSprite;
    var quoteTxt:FlxText;
    var activeCred:Int = 0;
    var curCredName:Alphabet;
    var curCredIcon:CreditIcon;
    var iconDanced:Bool = false;
    var didWhatTxts:Array<FlxText> = [];
    var sectTitle:Alphabet;
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
        quoteBox.alpha = .65;
        add(quoteBox);
        
        curCredName = new Alphabet(quoteBox.x + 90, quoteBox.y - 150, "owo", true);
        add(curCredName);


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
            coolCredits.add(coolNewCreditItem); 
        }
        changeCred();

        var firstCred = coolCredits.members[0];
		sectTitle = new Alphabet(80, firstCred.y - 100, creditSections[0], true);
        add(sectTitle);

    }

    override function update(elapsed:Float) {
		super.update(elapsed);
        if (FlxG.keys.justPressed.ESCAPE) { 
            if (colorTween != null) colorTween.cancel();
            Main.switchState(this, new MainMenuState()); 
        }
        if (FlxG.keys.justPressed.UP) changeCred(-1);
        if (FlxG.keys.justPressed.DOWN) changeCred(1);
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

		var aaaa:Array<String> = credits[activeCred][3].split(", ");
		var uwu = quoteBox.y + 70;
        for (x in 0...aaaa.length) {
			var coolTxt = new FlxText(quoteTxt.x, uwu + x * 30);
			coolTxt.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            coolTxt.text = "-" + aaaa[x];
			coolTxt.borderSize = 2;
            didWhatTxts.push(coolTxt);
            add(coolTxt);
        }

        if (lastColor != credits[activeCred][5]) {
            if (colorTween != null) colorTween.cancel();
			lastColor = credits[activeCred][5];
			colorTween = FlxTween.color(bg, .5, bg.color, credits[activeCred][5], {
				onComplete: t -> colorTween = null
			});
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