// https://github.com/KadeDev/Kade-Engine/blob/stable/source/Caching.hx
package meta.state.charting;

import flixel.FlxSprite;
import meta.MusicBeat.MusicBeatState;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxG;

class CachingOrLoadingStateIdk extends MusicBeatState {
	public static var bitmapData:Map<String, FlxGraphic> = new Map();
    override function create() {
		var sex = PlayState.getPrecachedCharacters();
        var coolEasyThing = [].concat(sex['dad']).concat(sex['bf']).concat(sex['gf']);

        if (coolEasyThing.length != 0) {
            trace('caching some shit');
            for (x in coolEasyThing) {
                

                /*var img = Paths.getPath('images/characters/$x.png', IMAGE);
                var imgData = OpenFlAssets.getBitmapData(img);
                var graphThing = FlxGraphic.fromBitmapData(imgData);
                graphThing.persist = true;
				graphThing.destroyOnNoUse = false;
                bitmapData.set(x, graphThing);*/
				var testSprite = new FlxSprite(Paths.image('characters/$x'));
                testSprite.screenCenter(XY);
                add(testSprite);
                remove(testSprite);
				FlxG.bitmap.add(Paths.image('characters/$x'));
                trace('cached $x');
            }
            PlayState.cleanUpPreCache();
			FlxG.switchState(new PlayState());
        }
        else Main.switchState(this, new PlayState());

        
    }
    
}