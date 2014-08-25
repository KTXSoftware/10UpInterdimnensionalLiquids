package;

import kha.math.Vector2i;
import kha.Sprite;
import kha.Storage;
import localization.Keys_text;

enum VictoryCondition {
	PLAYED_MANN;
	PLAYED_VERKAEUFERIN;
	CENT_DROPPED;
	CENT_TAKEN;
	MEHRKORN;
	MATHEGENIE;
	
	WATER;
	SLEEPY;
	GULLI;
	TENUPWEG;
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

class Cfg
{
	static var the : Cfg;
	
	public static var mann: ZeroEightFifteenMan;
	public static var eheweib: Sprite;
	public static var verkaeuferin: Verkaeuferin;
	public static var mafioso: Sprite;
	public static var euro: Sprite;
	public static var cent: Sprite;
	public static var broetchen: Sprite;
	public static var verkaeuferinPositions : Array<Vector2i> = new Array();
	public static var mannPositions : Array<Vector2i> = new Array();
	
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
	
	static public function init() {
		the = new Cfg();
		// TODO: load previous data
	}
	
	private function new() {
		victoryConditions = new Map();
		for (condition in VictoryCondition.createAll()) {
			victoryConditions[condition] = false;
		}
		
		dlgChoices = new Map();
		dlgChoices[Keys_text.DLG_GELD_GEFUNDEN_1_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2A_3_C] = 1;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2B_1_C] = 0;
	}
}