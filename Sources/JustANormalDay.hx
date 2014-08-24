package ;
import kha.Sprite;
import localization.Keys_text;

enum VictoryCondition {
	PLAYED_MANN;
	PLAYED_VERKAEUFERIN;
	CENT_DROPPED;
	CENT_TAKEN;
	MEHRKORN;
	MATHEGENIE;
}

class UpdateData {
	public function new(time: Float, left: Bool, right: Bool, up: Bool, advanceDialogue: Bool) {
		this.time = time;
		this.left = left;
		this.right = right;
		this.up = up;
		this.advanceDialogue = advanceDialogue;
	}
	
	public var time : Float;
	
	public var left : Bool;
	public var right : Bool;
	public var up : Bool;
	
	public var advanceDialogue : Bool;
}

class JustANormalDay
{
	static var the : JustANormalDay;
	
	var mann: ZeroEightFifteenMan;
	var eheweib: Sprite;
	var verkaeuferin: Sprite;
	
	var victoryConditions : Map<VictoryCondition, Bool>;
	
	static public inline function getVictoryCondition(condition: VictoryCondition) : Bool {
		return the.victoryConditions[condition];
	}
	static public inline function setVictoryCondition(condition: VictoryCondition, value: Bool) : Void {
		the.victoryConditions[condition] = value;
	}
	
	var dlgChoices : Map<String, Int>;
	
	static public inline function getDlgChoice(key: String) : Int {
		return the.dlgChoices[key];
	}
	static public inline function setDlgChoice(key: String, value: Int) : Void {
		the.dlgChoices[key] = value;
	}
	
	public function new(mann: ZeroEightFifteenMan, eheweib: Sprite, verkaeuferin: Verkaeuferin) {
		the = this;
		this.mann = mann;
		this.eheweib = eheweib;
		this.verkaeuferin = verkaeuferin;
		
		updateData = new Map();
		updateData[mann] = new Array();
		updateData[verkaeuferin] = [
			new UpdateData(1, false, false, true, false)
			, new UpdateData(2, false, false, false, false)
			, new UpdateData(3, false, true, false, false)
			, new UpdateData(8.5, false, true, true, false)
			, new UpdateData(10, false, true, false, false)
			, new UpdateData(12, false, false, false, false)
		];
		updateData[verkaeuferin].reverse();
		
		// TODO: Load previous data...
		
		victoryConditions = new Map();
		for (condition in VictoryCondition.createAll()) {
			victoryConditions[condition] = false;
		}
	
		// TODO: load choices from previous playthroughs
		dlgChoices = new Map();
		dlgChoices[Keys_text.DLG_GELD_GEFUNDEN_1_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2A_3_C] = 1;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2B_1_C] = 0;
	}
	
	
	public var has1Cent : Bool = false;
	public var bought2Wasserweck : Bool = false;
	
	var updateData : Map<Player, Array<UpdateData>>;
	var lastData : UpdateData;
	var updateDelay : Float = 0;
	
	public function update(gametime: Float) {
		var player = Player.current();
		var changed = lastData == null || player.left != lastData.left || player.right != lastData.right || player.up != lastData.up || TenUp3.instance.advanceDialogue;
		if (changed) {
			updateData[player].push(lastData);
			lastData = new UpdateData(gametime, player.left, player.right, player.up, TenUp3.instance.advanceDialogue);
		}
		
		for (key in updateData.keys()) {
			if (key == player) continue;
			
			var known = updateData[key].pop();
			if (known != null && known.time <= gametime + updateDelay) {
				updateDelay = known.time - gametime;
				haxe.Log.clear();
				trace(updateDelay);
				updatePlayer(key, known);
			} else {
				updateData[key].push(known);
			}
		}
	}
	
	function updatePlayer(player: Player, known: UpdateData) {
		player.left = known.left;
		player.right = known.right;
		if (known.up) {
			player.setUp();
		} else {
			player.up = false;
		}
		// TODO: dialog
	}
}