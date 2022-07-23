package gameObjects.userInterface.menu;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String = '';

	var curCharacterMap:Map<String, Array<Dynamic>> = [
		// the format is currently
		// name of character => id in atlas, fps, loop, scale, offsetx, offsety
		'bf' => ["BF idle dance white", 24, true, 0.9, 100, 100],
		'bfConfirm' => ['BF HEY!!', 24, false, 0.9, 100, 100],
		'gf' => ["GF Dancing Beat WHITE", 24, true, 1, 100, 100],
		'dad' => ["Dad idle dance BLACK LINE", 24, true, 1 * 0.5, 0, 0],
		'spooky' => ["spooky dance idle BLACK LINES", 24, true, 1 * 0.5, 0, 90],
		'pico' => ["Pico Idle Dance", 24, true, 1 * 0.5, 0, 100],
		'mom' => ["Mom Idle BLACK LINES", 24, true, 1 * 0.5, 0, -20],
		'parents-christmas' => ["Parent Christmas Idle", 24, true, 0.8, -100, 50],
		'senpai' => ["SENPAI idle Black Lines", 24, true, 1.4 * 0.5, -50, 100],
		'yoder' => ['BABY YODA IDLE', 24, true, 1, -150, 0],
		'acfh' => ['Idle', 12, true, .4, -300, -200],
		'onion' => ['idle', 24, true, .6, -100, 70],
		'fabi' => ['doofus idle', 24, true, 1, -150, 0],
		'nater' => ['STORY', 24, true, .75, -325, -50]
	];

	var baseX:Float = 0;
	var baseY:Float = 0;

	public function new(x:Float, newCharacter:String = 'bf')
	{
		super(x);
		y += 70;

		baseX = x;
		baseY = y;

		createCharacter(newCharacter);
		updateHitbox();
	}

	public function createCharacter(newCharacter:String, canChange:Bool = false)
	{
		var textureString:String;
		switch (newCharacter) {
			case 'yoder': textureString = 'Menu_Yoder';
			case 'acfh': textureString = 'Menu_ACFH';
			case 'onion': textureString = 'Menu_Onion';
			case 'fabi': textureString = 'Menu_Fabi';
			case 'nater': textureString = 'Menu_Nater';
			default: textureString = 'campaign_menu_UI_characters';
		}
		var tex = Paths.getSparrowAtlas('menus/base/storymenu/$textureString');
		frames = tex;
		var assortedValues = curCharacterMap.get(newCharacter);
		if (assortedValues != null)
		{
			if (!visible)
				visible = true;

			// animation
			animation.addByPrefix(newCharacter, assortedValues[0], assortedValues[1], assortedValues[2]);
			// if (character != newCharacter)
			animation.play(newCharacter);

			if (canChange)
			{
				// offset
				setGraphicSize(Std.int(width * assortedValues[3]));
				updateHitbox();
				setPosition(baseX + assortedValues[4], baseY + assortedValues[5]);

				if (newCharacter == 'pico' || newCharacter == 'fabi')
					flipX = true;
				else
					flipX = false;
			}
		}
		else
			visible = false;

		character = newCharacter;
	}
}
