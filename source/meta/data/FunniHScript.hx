package meta.data;
// maybe this will get used in the future
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import hscript.Interp;
import hscript.Parser;
import meta.state.PlayState;
// had to cheat off psych engines paper for this one

class FunniHScript {
    public static var parser:Parser = new Parser();
    public var storedScript:String = "";
    public var interp:Interp;
    public var variables(get, never):Map<String, Dynamic>;
    var safeToRun:Bool = false;

    public function new() {
        interp = new Interp();
        interp.variables.set("FlxG", FlxG);
        interp.variables.set("PlayState", PlayState);
		interp.variables.set("game", PlayState.instance);
        interp.variables.set("FlxTimer", FlxTimer);
        interp.variables.set("FlxTween", FlxTween);
    }

	function get_variables() {
        return interp.variables;
	}

    public function storeCode(codeToStore:String) {
        // dry run to make sure the code is valid
        try {
			runDaCode(codeToStore, [], false, true);
            storedScript = codeToStore;
            safeToRun = true;
        }
        catch(e) {}
    }

    public function runDaCode(funcToRun:String, arguments:Array<Dynamic>, wTryCatch=true, isDryRun=false) {
        if (!safeToRun && !isDryRun) return;
        var runStuff = () -> {
			@:privateAccess
			FunniHScript.parser.line = 1;
			FunniHScript.parser.allowTypes = true;
            if (!isDryRun && storedScript != "" && !StringTools.contains(storedScript, 'function $funcToRun')) return;
            var codeToRun:String = (!isDryRun ? '\n${funcToRun}(${arguments.join(", ")});' : funcToRun);
			interp.execute(FunniHScript.parser.parseString(storedScript + codeToRun));
        };

        if (!wTryCatch) { 
            runStuff();
            return;
        }

        try {
            runStuff();
            return;
        }
        catch(e:Dynamic) {
            trace('Hscript failed to run $e');
            return;
        }
    }
}