package gameObjects;

/**
	The character class initialises any and all characters that exist within gameplay. For now, the character class will
	stay the same as it was in the original source of the game. I'll most likely make some changes afterwards though!
**/
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import gameObjects.userInterface.HealthIcon;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

typedef CharacterData = {
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;
	public var charColor:String = "#31B0D1";
	public var shouldSing:Bool = true;
	public var deadShouldBump:Bool = false;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		this.isPlayer = isPlayer;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		var tex:FlxAtlasFrames;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0, 
			camOffsetY: 0,
			camOffsetX: 0,
			quickDancer: false
		};

		switch (curCharacter)
		{
			case 'NaterMarson':
				charColor = "#CF0101";
				frames = Paths.getSparrowAtlas('characters/NaterMarson');

				animation.addByPrefix('idle', 'AnIdle', 24, false);
				animation.addByPrefix('singLEFT', 'AnLeft', 30, true);
				animation.addByPrefix('singRIGHT', 'AnRight', 30, true);
				animation.addByPrefix('singUP', 'AnUp', 30, true);
				animation.addByPrefix('singDOWN', 'AnDown', 30, true);

				scale.set(0.9, 0.9);
				//characterData.camOffsetY -= 50;
			
			case 'beeg-nater':
				charColor = "#CF0101";
				frames = Paths.getSparrowAtlas('characters/beeg-nater');

				animation.addByPrefix('idle', 'BIDLE', 24, false);
				animation.addByPrefix('laugh', 'BLAUGH', 30, false);
				animation.addByPrefix('laughis', 'ALAUGH', 30, false);
				animation.addByPrefix('singLEFT', 'BLEFT', 30, true);
				animation.addByPrefix('singRIGHT', 'BRIGHT', 30, true);
				animation.addByPrefix('singUP', 'BUP', 30, true); //"BUP" "YAHOO" "IM THE BEST" "AAAAAAAAAA"
				animation.addByPrefix('singDOWN', 'BDOWN', 30, true);

				scale.set(2.3, 2.3);
				characterData.camOffsetY -= 50;
				 
			case 'burger':
				charColor = "#FFFF33";
				frames = Paths.getSparrowAtlas('characters/burger');

				for (x in ['idle', 'singUP', 'singDOWN', 'singLEFT', 'singRIGHT']) animation.addByPrefix(x, x, 24, false); // LEM IS LOVE LEM IS LIFE
				scale.set(1.2, 1.2);
				characterData.offsetY = -20;

			case 'lemlom':
				charColor = "#FFCC66";
				frames = Paths.getSparrowAtlas('characters/lemlom');
				
				for (x in ['idle', 'singUP', 'singDOWN', 'singLEFT', 'singRIGHT']) animation.addByPrefix(x, x, 24, false); // actual ascension

			case 'naterbf-dead':
				frames = Paths.getSparrowAtlas('characters/naterBfDead');

				animation.addByPrefix('firstDeath', 'DEADSTART', 24, false);
				animation.addByPrefix('deathLoop', 'DEADLOOP', 16, true);
				animation.addByPrefix('deathConfirm', 'DEADEND', 24, false);
				deadShouldBump = true;

				//playAnim('firstDeath');

				flipX = true;
			case 'naterbf-flash':
				charColor = "#0040B5";
				frames = Paths.getSparrowAtlas('characters/naterBfFlash');

				animation.addByPrefix('look', 'LOOKINGAROUND0', 24, false);
				animation.addByPrefix('on', 'FLASHON', 24, false);
				animation.addByPrefix('idle', 'FLASHIDLE', 24, false);
				animation.addByPrefix('singDOWN', 'FLASHDOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'FLASHLEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'FLASHRIGHT0', 24, false);
				animation.addByPrefix('singUP', 'FLASHUP0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'FLASHDOWNMISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'FLASHLEFTMISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'FLASHRIGHTMISS', 24, false);
				animation.addByPrefix('singUPmiss', 'FLASHUPMISS', 24, false);

				flipX = true;

				scale.set(2, 2);
				characterData.offsetY = 240;
				flipLeftRight();

				playAnim('idle');

			case 'naterbf':
				charColor = "#0040B5";
				frames = Paths.getSparrowAtlas('characters/naterBf');

				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT0', 24, false);
				animation.addByPrefix('singUP', 'UP0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'DOWNMISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'LEFTMISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'RIGHTMISS', 24, false);
				animation.addByPrefix('singUPmiss', 'UPMISS', 24, false);

				flipX = true;

				scale.set(2, 2);
				characterData.offsetY = 240;
				flipLeftRight();

				playAnim('idle');
			
			case 'nater-dark':
				charColor = "#3E3E3E";
				frames = Paths.getSparrowAtlas('characters/nater-dark');
				animation.addByPrefix('idle', 'DARKIDLE', 24, false);
				animation.addByPrefix('singDOWN', 'DARKDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'DARKLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'DARKRIGHT', 24, false);
				animation.addByPrefix('singUP', 'DARKUP', 24, false);

				scale.set(1.5, 1.5);
				antialiasing = true;

				playAnim('idle');

			case 'nater':
				charColor = "#3E3E3E";
				frames = Paths.getSparrowAtlas('characters/nater');

				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);

				// setGraphicSize(Std.int(width * 1.5));
				scale.set(1.5, 1.5);
				antialiasing = true;

				playAnim('idle');
			case 'yoder':
				charColor = "#73e155";
				tex = Paths.getSparrowAtlas('characters/baby yoder');
				frames = tex;

				animation.addByPrefix('idle', 'BABY YODA IDLE', 24, false);
				animation.addByPrefix('singDOWN', 'BABY YODA DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BABY YODA LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'BABY YODA RIGHT', 24, false);
				animation.addByPrefix('singUP', 'BABY YODA UP', 24, false);
				animation.addByPrefix('idle-force', 'BABY YODA FORCE IDLE', 24, false);
				animation.addByPrefix('force', 'BABY YODA FORCE0', 24, false);

				characterData.offsetY = 40;
				characterData.camOffsetX = 150;

				playAnim('idle');
			case 'onion': // im not gonna change 50 charts just to add -skin to the end of onion :Dave:
				charColor = "#FAA66D";

				frames = Paths.getSparrowAtlas('characters/onion-skin');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				characterData.offsetX = 250;
				characterData.offsetY = 100;

				playAnim('idle');
			case 'ACFH':
				charColor = "#FF2D32";

				frames = Paths.getSparrowAtlas('characters/ACFH');
				animation.addByPrefix('idle', 'Idle', 12, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);

				scale.set(0.7, 0.7);

				characterData.offsetX = -650;
				characterData.offsetY = -100;
				characterData.camOffsetY = 100;
				characterData.camOffsetX = 150;

				playAnim('idle');
			case 'TankACFH': // ugh
				charColor = "#000000";
				frames = Paths.getSparrowAtlas('characters/TankACFH');
				animation.addByPrefix('idle', 'Idle', 12, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);

				scale.set(0.7, 0.7);

				characterData.offsetX = -650;
				characterData.offsetY = -100;
				characterData.camOffsetY = 100;
				characterData.camOffsetX = 150;

				playAnim('idle');
			case 'fabi':
				charColor = "#663535";

				frames = Paths.getSparrowAtlas('characters/fabiASSETS');
				animation.addByPrefix('idle', 'doofus idle', 24, false);
				animation.addByPrefix('idlePost', 'yeah uh', 24, true); //loops the tail
				animation.addByPrefix('singUP', 'doofus UP', 24, false);
				animation.addByPrefix('singDOWN', 'doofus DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'doofus LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'doofus RIGHT', 24, false);

				flipX = true;
			
				flipLeftRight();

				characterData.offsetY = -40;
				characterData.camOffsetY = -100;

				playAnim('idle');
			case 'whoppa':
				charColor = '#FF9900';
				frames = Paths.getSparrowAtlas('characters/whoppa');
				animation.addByPrefix('idle', 'kingwilliams idle', 24, false);
				animation.addByPrefix('singUP', 'kingwilliams up', 24, false);
				animation.addByPrefix('singDOWN', 'kingwilliams down', 24, false);
				animation.addByPrefix('singLEFT', 'kingwilliams left', 24, false);
				animation.addByPrefix('singRIGHT', 'king williams right', 24, false);

				//characterData.offsetY = 200;
			case 'kadeplayer':
				charColor = "#663300";
				frames = Paths.getSparrowAtlas('characters/kade_brawl');

				animation.addByPrefix('idle', 'kadecat idle', 24, false);
				animation.addByPrefix('singUP', 'kadecat up0', 24, false);
				animation.addByPrefix('singDOWN', 'kadecat down0', 24, false);
				animation.addByPrefix('singLEFT', 'kadecat right0', 24, false);
				animation.addByPrefix('singRIGHT', 'kadecat left0', 24, false);
				animation.addByPrefix('singUPmiss', 'kadecat up miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'kadecat down miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'kadecat right miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'kadecat left miss', 24, false);
				animation.addByPrefix('firstDeath', 'kadecat dies (sad)', 24, false);
				animation.addByPrefix('deathConfirm', 'kadecat dies loop', 24, false);
				animation.addByPrefix('deathLoop', 'kadecat dies loop', 24, false);

				flipX = true;

				characterData.offsetY = -20;
				characterData.offsetX = 100;

				playAnim('idle');
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');

			
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				playAnim('idle');
			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				playAnim('idle');

				flipX = true;


				characterData.offsetY = 70;

				switch(PlayState.SONG.song){ //sorry bro i didnt wanna be yandev
					case 'Onions' | 'Garlico' | 'Food Fight':
						characterData.offsetX += 600;
						characterData.offsetY += 300;
						characterData.camOffsetX += 200;
						characterData.camOffsetY -= 150;
					case 'Ancient Clown' | 'From Hell' | 'Clownstace':
						characterData.camOffsetY = -100;
						characterData.camOffsetX = 20;
					case 'Dasher' | 'Fabicoolest' | 'Fabilicious':
						characterData.camOffsetY = -50;
				}
			/*
				case 'bf-og':
					frames = Paths.getSparrowAtlas('characters/og/BOYFRIEND');

					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					animation.addByPrefix('scared', 'BF idle shaking', 24);
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

					playAnim('idle');

					flipX = true;
			 */

			case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/BF_DEATH');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				playAnim('firstDeath');

				flipX = true;

			default:
				// set up animations if they aren't already

				// fyi if you're reading this this isn't meant to be well made, it's kind of an afterthought I wanted to mess with and
				// I'm probably not gonna clean it up and make it an actual feature of the engine I just wanted to play other people's mods but not add their files to
				// the engine because that'd be stealing assets
				var fileNew = curCharacter + 'Anims';
				if (OpenFlAssets.exists(Paths.offsetTxt(fileNew)))
				{
					var characterAnims:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(fileNew));
					var characterName:String = characterAnims[0].trim();
					frames = Paths.getSparrowAtlas('characters/$characterName');
					for (i in 1...characterAnims.length)
					{
						var getterArray:Array<Array<String>> = CoolUtil.getAnimsFromTxt(Paths.offsetTxt(fileNew));
						animation.addByPrefix(getterArray[i][0], getterArray[i][1].trim(), 24, false);
					}
				}
				else 
					return setCharacter(x, y, 'bf'); 					
		}

		// set up offsets cus why not
		if (OpenFlAssets.exists(Paths.offsetTxt(curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt(curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bf'))
			flipLeftRight();

		if (adjustPos) {
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;
		
		return this;
	}

	function flipLeftRight():Void
	{
		if (animation.getByName('singRIGHT') == null) return;
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false, ?jediLol = false)
	{
		if (!debugMode)
		{
			var curCharSimplified:String = simplifyCharacter();
			var forceSuffix:String = jediLol ? "-force" : "";
			switch (curCharSimplified)
			{
				case 'gf':
					if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				default:
					// Left/right dancing, think Skid & Pump
					if (animation == null || animation.getByName == null) return; // idk why but this causes crashes sometimes???
					if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null) {
						danced = !danced;
						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
					else
						playAnim('idle$forceSuffix', forced);
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) != null) {
			if (AnimName.contains('sing')) {
				if (shouldSing) super.playAnim(AnimName, Force, Reversed, Frame);
			} 
			else super.playAnim(AnimName, Force, Reversed, Frame);
		}

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}
