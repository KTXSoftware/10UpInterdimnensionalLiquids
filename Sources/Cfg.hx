package;

import kha.Loader;
import kha.math.Vector2;
import kha.math.Vector2i;
import kha.Sprite;
import kha.Storage;
import localization.Keys_text;

class Cfg
{
	static var the : Cfg;
	
	public static var mann: ZeroEightFifteenMan;
	public static var eheweib: Sprite;
	public static var verkaeuferin: Verkaeuferin;
	public static var mafioso: Mafioso;
	public static var euro: Sprite;
	public static var cent: Sprite;
	public static var broetchen: Sprite;
	public static var broetchen_mehrkorn: Sprite;
	public static var theke: Sprite;
	public static var backdoor: Door;
	public static var bratpfanne: Sprite;
	public static var verkaeuferinPositions : Array<Vector2i>;
	public static var mannPositions : Array<Vector2i>;
	
	var victoryConditions : Map<VictoryCondition, Bool>;
	var profX: Float = -1;
	var profY: Float = -1;
	var map: Array<Array<Int>> = null;
	var _language : String;
	
	static public var language(get, set): String;
	static function get_language():String { return the._language; }
	static function set_language(value:String):String { return the._language = value; }
	
	static public inline function getVictoryCondition(condition: VictoryCondition) : Bool {
		return the.victoryConditions[condition];
	}
	
	static public inline function setVictoryCondition(condition: VictoryCondition, value: Bool) : Void {
		the.victoryConditions[condition] = value;
	}
	
	static public function getProfPosition(): Vector2 {
		if (the.profX < 0) return null;
		return new Vector2(the.profX, the.profY);
	}
	
	static public function setProfPosition(x: Float, y: Float): Void {
		the.profX = x;
		the.profY = y;
	}
	
	static public function getMap(): Array<Array<Int>> {
		return the.map;
	}
	
	static public function setMap(map: Array<Array<Int>>): Void {
		the.map = map;
	}
	
	var dlgChoices : Map<String, Int>;
	
	static public inline function getDlgChoice(key: String) : Int {
		return the.dlgChoices[key];
	}
	static public inline function setDlgChoice(key: String, value: Int) : Void {
		the.dlgChoices[key] = value;
	}
	
	static public function init() {
		var data = Storage.defaultFile().readObject();
		if (data == null) the = new Cfg();
		else the = cast data;
		
		Player.init();
		Cfg.mann = null;
		Cfg.mannPositions = new Array();
		Cfg.verkaeuferin = null;
		Cfg.verkaeuferinPositions = new Array();
		Cfg.eheweib = null;
		Cfg.mafioso = null;
		Cfg.backdoor = null;
		Cfg.euro = new Sprite(Loader.the.getImage("euro"));
		Cfg.euro.scaleX = Cfg.euro.scaleY = 0.5;
		Cfg.cent = new Sprite(Loader.the.getImage("cent"));
		Cfg.cent.scaleX = Cfg.cent.scaleY = 0.5;
		Cfg.broetchen = new Broetchen();
		Cfg.broetchen_mehrkorn = new Broetchen(true);
		Cfg.bratpfanne = new Bratpfanne();
		
		#if JUST_A_NORMAL_DAY
		#else
		Cfg.setVictoryCondition(VictoryCondition.WATER, false);
		Cfg.setVictoryCondition(VictoryCondition.SLEEPY, false);
		Cfg.setVictoryCondition(VictoryCondition.GULLI, false);
		Cfg.setVictoryCondition(VictoryCondition.TENUPWEG, false);
		#end
	}
	
	static public function save(): Void {
		Storage.defaultFile().writeObject(the);
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