package gameObjects.userInterface;

import flixel.FlxSprite;

class CreditIcon extends FlxSprite {

    public var sprTracker:FlxSprite;
    public var yOffset:Int = 0;

	public function new(char:String = 'bf-pixel') {
        super();
		loadGraphic(Paths.image('credits/$char'));
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x - 140, sprTracker.y - 5 + yOffset);
	}
}
