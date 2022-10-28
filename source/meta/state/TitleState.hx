package meta.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import meta.state.menus.*;
import openfl.Assets;
import meta.state.menus.MainMenuState;

using StringTools;


class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
    var serverSideSprite:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var spinner:FlxSprite;
	var disStartText:FlxText;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var introIcons:Map<String, FlxSprite> = new Map();

	override public function create():Void
	{
		controls.setKeyboardScheme(None, false);
		curWacky = FlxG.random.getObject(getIntroTextShit());
		super.create();

		startIntro();
		
		// because you can't read a directory in flixel?? wtf
		for (x in ["beekies", "burger", "fabi", "indefin8", "lem", "multihand", "nater", "red", "skullbite", "soulslimm", "tomi", "tostper", "vander", "waddle", "xg"]) {
			var spr = new FlxSprite(50, 50).loadGraphic(Paths.image('intro-icons/$x'));
			spr.visible = false;
			spr.scale.set(.4, .4);
			introIcons[x] = spr;
			add(spr);
		}

	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			///*
			#if !html5
			Discord.changePresence('TITLE SCREEN', 'Main Menu');
			#end
			
			ForeverTools.resetMenuMusic(true);
		}

		persistentUpdate = true;

        var debugText = new FlxText();
        debugText.text = "DEBUG";
        debugText.size = 20;
        debugText.screenCenter();
        add(debugText);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString("#373a3f"));
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);
		
		/*var checkers = new FlxBackdrop(FlxGraphic.fromRectangle(50, 50, FlxColor.WHITE));
        add(checkers);*/

		serverSideSprite = new FlxSprite(380, FlxG.height - 90).makeGraphic(FlxG.width + 80, 260, FlxColor.fromString("#2f3237"));
		serverSideSprite.angle = -20;
        add(serverSideSprite);

		var kdcLogo = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/base/title/KDCLogo"));
		kdcLogo.setGraphicSize(Std.int(kdcLogo.width * .6));
		kdcLogo.antialiasing = true;
		add(kdcLogo);

	    disStartText = new FlxText(905, 610);
		disStartText.antialiasing = true;
		disStartText.angle = -20;
		disStartText.text = "Press Enter To Start!";
		disStartText.font = Paths.font("whitneybold.otf");
		disStartText.size = 42;
		FlxTween.tween(disStartText, { alpha: 0 }, { type: PINGPONG });
		add(disStartText);
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		spinner = new FlxSprite(disStartText.getMidpoint().x, disStartText.getMidpoint().y);
		spinner.frames = Paths.getSparrowAtlas("menus/base/title/spinner");
		spinner.animation.addByPrefix("spin", "spinner idle", 30, true);
		spinner.animation.play("spin");
		spinner.visible = false;
		add(spinner);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var swagGoodArray:Array<Array<String>> = [];
		if (Assets.exists(Paths.txt('introText')))
		{
			var fullText:String = Assets.getText(Paths.txt('introText'));
			var firstArray:Array<String> = fullText.split('\n');

			for (i in firstArray)
				swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			disStartText.visible = false;
			spinner.visible = true;

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Check if version is outdated

				var version:String = "v" + Application.current.meta.get('version');
				/*
					if (version.trim() != NGio.GAME_VER_NUMS.trim() && !OutdatedSubState.leftState)
					{
						FlxG.switchState(new OutdatedSubState());
						trace('OLD VERSION!');
						trace('old ver');
						trace(version.trim());
						trace('cur ver');
						trace(NGio.GAME_VER_NUMS.trim());
					}
					else
					{ */
				Main.switchState(this, new MainMenuState());
				// }
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		// hi game, please stop crashing its kinda annoyin, thanks!
		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
		return textGroup.members[0];
	}
	inline function hideIcons(targets: Array<String>) for (x in targets) introIcons[x].visible = false;
	function adjustAndShowIcon(target: String, targetTxt, ?onLeft=true) {
		var targetSpr = introIcons[target];
		var _targetTxt = cast(targetTxt, Alphabet);

		targetSpr.x = onLeft ? _targetTxt.x - 300 : _targetTxt.width + 220;
		targetSpr.y = _targetTxt.y - 105;
		switch (_targetTxt.text) {
			case "fabi": targetSpr.x += 110;
			case "xg": targetSpr.x += 210;
			case "red": targetSpr.x += 160;
			case "tostper": targetSpr.x += 80;
			case "nater marson": targetSpr.x -= 40;
			case "skullbite": targetSpr.x += 40;
		}

		targetSpr.visible = !skippedIntro;
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
		return coolText;
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		switch (curBeat)
		{
			case 1: adjustAndShowIcon('waddle', createCoolText(['waddle']));
			case 2: adjustAndShowIcon('fabi', addMoreText('fabi'), false);
			case 3: adjustAndShowIcon('tomi', addMoreText('tomi'));
			case 4:
				deleteCoolText();
				hideIcons(["waddle", "fabi", "tomi"]);

			case 5: adjustAndShowIcon('xg', createCoolText(['xg']), false);	
			case 7: adjustAndShowIcon('indefin8', addMoreText('indefin-eight'));
			case 8:
				hideIcons(["xg", "indefin8"]);
				deleteCoolText();

			case 9: adjustAndShowIcon('beekies', createCoolText(['beekies']));
			case 10: adjustAndShowIcon('multihand', addMoreText('multi-hand'), false);
			case 11: adjustAndShowIcon('lem', addMoreText('lemlom'));
			case 12:
				hideIcons(["beekies", "multihand", "lem"]);
				deleteCoolText();

			case 13: adjustAndShowIcon('red', createCoolText(['red']), false);
			case 14: adjustAndShowIcon('soulslimm', addMoreText('soulslimm'));
			case 15: adjustAndShowIcon('tostper', addMoreText('tostper'), false);
			case 16:
				hideIcons(["soulslimm", "red", "tostper"]);
				deleteCoolText();

			case 17: adjustAndShowIcon('vander', createCoolText(['vander']));
			case 18: adjustAndShowIcon('nater', addMoreText('nater marson'), false);
			case 19: adjustAndShowIcon('burger', addMoreText('burger'));
			case 20: adjustAndShowIcon('skullbite', addMoreText('skullbite'), false);

			case 21:
				hideIcons(["vander", "nater", "burger", "skullbite"]);
				deleteCoolText();
				createCoolText(['we need more']);
			case 23: addMoreText('text here');

			case 25:
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 27: addMoreText(curWacky[1]);

			case 29:
				deleteCoolText();
				createCoolText(['vs']);
			case 30: addMoreText('kadedev');
			case 31: addMoreText('community');
			case 32: skipIntro();

		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			for (_ => value in introIcons) remove(value);
			skippedIntro = true;
		}
		//
	}
}
