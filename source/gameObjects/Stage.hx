package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;
	public var bump:Array<FNFSprite> = []; // put sprites here with a "bump" animation
	public var publicSprites:Map<String, FNFSprite> = []; // publicizes sprites so you can interact with them from the playstate

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'highway';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'yoder' | 'baby-yoda-real' | 'swagswag':
					curStage = 'yoda';
				case 'onions' | 'garlico' | 'food-fight':
					curStage = 'onion';
				case 'ancient-clown' | 'from-hell' | 'clownstace':
					curStage = 'ACFH';
				case 'dasher' | 'fabicoolest' | 'fabilicious':
					curStage = 'fabiworld';
				case 'rom-hack':
					curStage = 'nater';
				case 'fresh' | 'poor-emulation' | 'savestated':
					curStage = 'naterdark';
				case 'battle-of-the-century':
					curStage = 'botc';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'fabiworld':
				PlayState.defaultCamZoom = 0.8;

				var bg:FNFSprite = new FNFSprite(-320, -120).loadGraphic(Paths.image('backgrounds/$curStage/fabiworld')); // $ means money therefore i will use $ instead :Dave:
				bg.scale.set(1.2, 1.2);
				add(bg);
			case 'botc':
				PlayState.defaultCamZoom = 0.7;

				var bg:FNFSprite = new FNFSprite(240, 135);
				bg.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/battleOfTheBackground');
				bg.animation.addByPrefix('idle', 'bg speen', 30, true);
				bg.animation.play('idle');
				bg.scale.set(6, 6);
				add(bg);
			case 'ACFH':
				PlayState.defaultCamZoom = 0.9;
				var imgName:String = 'shid-noballs';
				if(meta.subState.GameOverSubstate.deathCount > 0){
					imgName = 'shid';
				}

				var bg:FNFSprite = new FNFSprite(-320, -125).loadGraphic(Paths.image('backgrounds/' + curStage + '/$imgName'));
				bg.antialiasing = true;
				add(bg);
			case 'onion':
				var bg:FNFSprite = new FNFSprite(-320, -125).loadGraphic(Paths.image('backgrounds/' + curStage + '/fard 2 electric boogaloo'));
				bg.antialiasing = true;
				bg.scale.set(0.8, 0.8);
				add(bg);

				var table:FNFSprite = new FNFSprite(-320, -125).loadGraphic(Paths.image('backgrounds/' + curStage + '/table'));
				table.antialiasing = true;
				table.scale.set(0.8, 0.8);
				add(table);
			case 'yoda':
				PlayState.defaultCamZoom = 0.92;

				var timeOfDay:String = '';
				var skyTime:String = 's';
				switch(PlayState.SONG.song){
					case 'Yoder' | 'Swagswag':
						skyTime = 'leanS';
					case 'Baby Yoda Real':
						skyTime = 's';
					default:
						skyTime = 's';
				}
				var skyName:String = skyTime + 'ky';
				if (PlayState.storyDifficulty == 3){ //erect shit
					timeOfDay = '-night';
					skyName = 'sky-night';
				}

				var bg:FNFSprite = new FNFSprite(-320, -320).loadGraphic(Paths.image('backgrounds/' + curStage + '/' + skyName));
				bg.antialiasing = true;
				add(bg);

				var offSpring:FNFSprite = new FNFSprite(-320, -280).loadGraphic(Paths.image('backgrounds/' + curStage + '/offspring' + timeOfDay));
				offSpring.scrollFactor.set(0.2 / 1.5, 0.2);
				offSpring.antialiasing = true;
				add(offSpring);

				var montana:FNFSprite = new FNFSprite(-320, -280).loadGraphic(Paths.image('backgrounds/' + curStage + '/las montanas' + timeOfDay));
				montana.scrollFactor.set(0.9 / 1.5, 1);
				montana.antialiasing = true;
				add(montana);

				var desert:FNFSprite = new FNFSprite(-320, -280).loadGraphic(Paths.image('backgrounds/' + curStage + '/desert' + timeOfDay));
				desert.scrollFactor.set(0.95 / 1.5, 1);
				desert.antialiasing = true;
				add(desert);

				var food:FNFSprite = new FNFSprite(-320, -280).loadGraphic(Paths.image('backgrounds/' + curStage + '/borgarKeng' + timeOfDay));
				food.scrollFactor.set(1, 1);
				food.antialiasing = true;
				add(food);

				if(skyTime == 's'){
					offSpring.visible = false;
				}
				if(skyTime == 'leanS'){
					if (PlayState.SONG.song == 'Swagswag'){ // sunset stuff
						offSpring.x = 1920 - 300;
					}
				}
			case 'nater':
				curStage = 'nater';
				PlayState.defaultCamZoom = 0.9;

				var raise = new FNFSprite();
				raise.frames = Paths.getSparrowAtlas("backgrounds/naterplat/Platform-Raise");
				raise.animation.addByPrefix('up', 'ANIM', false);
				raise.playAnim('up');
				raise.scrollFactor.set(1, 1);
				raise.screenCenter();
				raise.setGraphicSize(Std.int(raise.width * 2.5));
				add(raise);
				publicSprites["raise"] = raise;

				var BG:FNFSprite = new FNFSprite(0, -100);
				BG.frames = Paths.getSparrowAtlas('backgrounds/naterplat/Platform-Stage');
				BG.animation.addByPrefix('bump', 'ANIM', 24, false);
				BG.scrollFactor.set(1, 1);
				BG.screenCenter(X);
				// BG.playAnim('bump');
				BG.setGraphicSize(Std.int(BG.width * 2.5));
				bump.push(BG);
				add(BG);

			case 'naterdark':
				curStage = 'nater';
				var dark = new FNFSprite(0, 50);
				dark.frames = Paths.getSparrowAtlas('backgrounds/naterdark/dark');
				dark.animation.addByPrefix('flash', 'ANIM', 24, true);
				dark.playAnim('flash');
				dark.scrollFactor.set(1, 1);
				dark.screenCenter(X);
				dark.setGraphicSize(Std.int(dark.width * 1.7));
				publicSprites["dark"] = dark;
				add(dark);

				var superdark = new FNFSprite(0, 50);
				superdark.frames = Paths.getSparrowAtlas('backgrounds/naterdark/superdark');
				superdark.animation.addByPrefix('flash', 'ANIM', 24, true);
				superdark.playAnim('flash');
				superdark.scrollFactor.set(1, 1);
				superdark.screenCenter(X);
				superdark.setGraphicSize(Std.int(dark.width * 1.7));
				superdark.visible = false;
				publicSprites["superdark"] = superdark;
				add(superdark);

				var spotlight = new FNFSprite(0, 50);
				spotlight.frames = Paths.getSparrowAtlas('backgrounds/naterdark/spotlight');
				spotlight.animation.addByPrefix('flash', 'ANIM', 24, true);
				spotlight.playAnim('flash');
				spotlight.scrollFactor.set(1, 1);
				spotlight.screenCenter(X);
				spotlight.setGraphicSize(Std.int(dark.width * 1.7));
				spotlight.visible = false;
				publicSprites["spotlight"] = spotlight;
				add(spotlight);


			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
				case 'spirit':
					var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
					evilTrail.changeValuesEnabled(false, false, false, false);
					add(evilTrail);
					*/
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		PlayState.uiTint = 0xffffff;
		switch (curStage)
		{
			case 'naterdark':
				gf.visible = false;
				// boyfriend.scale.set(0.75, 0.75);
				boyfriend.y -= 130;
				boyfriend.x -= 100;
				dad.x -= 40;
				dad.y -= 25;
				if (["SaveStated", "Poor Emulation"].contains(PlayState.SONG.song)) { 
					publicSprites["dark"].visible = false;
					publicSprites["superdark"].visible = true;
					boyfriend.setColorTransform(0.07, 0.07, 0.07);
					PlayState.uiTint = 0x747171;
				}
			case 'nater':
				// boyfriend.scale.set(0.75, 0.75);
				/*gf.scale.set(0.55, 0.55);
				gf.adjustPos = false;*/
				gf.visible = false;
				dad.x -= 120;
				dad.y -= 120;
				boyfriend.y -= 225;
				boyfriend.x -= 75;
            case 'botc':
				gf.visible = false;
			case 'onion':
				gf.x += 600;
				gf.y += 300;
				gf.scrollFactor.set(1, 1);
			case 'yoda':
				if (PlayState.storyDifficulty == 3) { 
					for (x in [dad, boyfriend, gf]) x.color = 0xFFD3D8FF; 
					PlayState.uiTint = 0xFFD3D8FF;
				}
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		for (x in bump) x.playAnim('bump');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
