package;

import dialogue.Action;
import dialogue.Bla;
import dialogue.BlaWithChoices;
import dialogue.StartDialogue;
import localization.Keys_text;
import kha.Scene;
import kha.Sprite;

using Lambda;

class Dialogues {
	
	static var dlgChoices : Map<String, Int>;
	
	static public function init() {
		// TODO: load choices from previous playthroughs
		dlgChoices = new Map();
		dlgChoices[Keys_text.DLG_GELD_GEFUNDEN_1_C] = -1;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2_C] = 0;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2A_3_C] = 1;
		dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2B_1_C] = 0;
	}
	
	static public function startDlg(mann: Sprite, eheweib: Sprite) {
		Dialogue.insert([new Bla(Keys_text.DLG_START_1, mann)
					 ,new Bla(Keys_text.DLG_START_2, eheweib)
					 ,new Bla(Keys_text.DLG_START_3, eheweib)
					 ,new Bla(Keys_text.DLG_START_4, mann)
					 ,new Bla(Keys_text.DLG_START_5, eheweib)
					 ,new Bla(Keys_text.DLG_START_6, mann)]);
	}
	
	static public function setGeldGefundenMannDlg(mann: Sprite, coin: Sprite) {
		Dialogue.insert([new BlaWithChoices(Localization.getText(Keys_text.DLG_GELD_GEFUNDEN_1_C), mann, [[new Action([mann, coin], ActionType.TAKE)], []])]);
	}
	
	static public function setVerkaufMannDlg(mann: Sprite, verkaeuferin: Sprite, euro: Sprite, cent: Sprite, broetchen: Sprite ) {
		var part2b : Array<Dialogue.DialogueItem> = [
			new Bla(Keys_text.DLG_VERKAUFEN_2B_1, verkaeuferin)
			, new Bla(Keys_text.DLG_VERKAUFEN_2B_2, mann)
			, new Action([mann, euro], ActionType.GIVE)
		];
		
		var part2a : Array<Dialogue.DialogueItem>;
		if (cent == null) {
			var part2a2b : Array<Dialogue.DialogueItem>;
			if (dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2B_1_C] == 0) {
				part2a2b = [
					new Action([mann, euro], ActionType.GIVE)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2B_1A, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2B_1A_1, mann)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
				];
			} else {
				part2a2b = [
					new Action([mann, euro], ActionType.GIVE)
				];
			}
			
			var part2a2a : Array<Dialogue.DialogueItem>;
			if (dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2A_3_C] == 0) {
				part2a2a = [
					new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
					, new Action([mann, euro], ActionType.GIVE)
				];
			} else {
				part2a2a = [
					new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3B, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3B_1, mann)
					, new Action([mann, euro], ActionType.GIVE)
				];
			}
			part2a = [
				new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin)
				, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2A_2_C, mann, [part2a2a, part2a2b])
			];
		} else {
			part2a = [ new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin)
					 , new Bla(Keys_text.DLG_VERKAUFEN_2A_2_GELD, mann)
					 , new Action([mann, euro], ActionType.GIVE)
					 ];
		}
		var part1 = [ new Bla(Keys_text.DLG_VERKAUFEN_1, verkaeuferin)
					, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2_C, mann, [part2a, part2b])
					, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1,verkaeuferin)
					, new Action([mann, broetchen], ActionType.TAKE)
					, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_2,mann)
					];
		Dialogue.insert(part1);
	}
	
	static public function setVerkaufVerkDlg(mann: Sprite, verkaeuferin: Sprite, oneEuroOneCent : Bool ) {
		var part1 : Array<Dialogue.DialogueItem> = [
			new Bla(Keys_text.DLG_VERKAUFEN_1, verkaeuferin)
		];
		
		var part2 : Array<Dialogue.DialogueItem>;
		if (dlgChoices[Keys_text.DLG_VERKAUFEN_2_C] == 0) {
			if (oneEuroOneCent) {
				part2 = [
					new Bla(Keys_text.DLG_VERKAUFEN_2A, mann)
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin) 
					, new Bla(Keys_text.DLG_VERKAUFEN_2A_2_GELD, mann)
				];
			} else {
				if (dlgChoices[Keys_text.DLG_VERKAUFEN_2A_2_C] == 0) {
					var part2a2a3a : Array<Dialogue.DialogueItem> = [
						new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
					];
					
					var part2a2a3b : Array<Dialogue.DialogueItem> = [
						new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3B_1, mann)
					];
					
					part2 = [
						new Bla(Keys_text.DLG_VERKAUFEN_2A, mann)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A, mann)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
						, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2A_2A_3_C, verkaeuferin, [part2a2a3a,part2a2a3b])
					];
				} else {
					var part2a2b1a : Array<Dialogue.DialogueItem> = [
						new Bla(Keys_text.DLG_VERKAUFEN_2A_2B_1A_1, mann)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A, verkaeuferin)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
					];
					
					part2 = [
						new Bla(Keys_text.DLG_VERKAUFEN_2A, mann)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin)
						, new Bla(Keys_text.DLG_VERKAUFEN_2A_2B, mann)
						, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2A_2B_1_C, verkaeuferin, [part2a2b1a, []])
					];
				}
			}
		} else {
			part2 = [
				new Bla(Keys_text.DLG_VERKAUFEN_2B, mann)
			];
		}
		
		
		var part3 : Array<Dialogue.DialogueItem> = [
			new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1, verkaeuferin)
			, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_2,mann)
		];
		Dialogue.insert(part1.concat(part2).concat(part3));
	}
	
	static public function setTestDlg(mann : Sprite, eheweib: Sprite, verkaeuferin: Sprite, euro: Sprite, cent: Sprite, broetchen: Sprite) {
		var t2 = new StartDialogue(setTestDlg.bind(mann, eheweib, verkaeuferin, euro, cent, broetchen));
		
		var test = new BlaWithChoices("Welchen Dialog testen?\n"
			+ "(1): Geld Gefunden\n"
			+ "(2): Geld Verlohren\n"
			+ "(3): Brötchen kaufen\n"
			+ "(4): Brötchen verkaufen\n"
			+ "(5): Gefeuert werden\n", mann, [
				[new StartDialogue(setGeldGefundenMannDlg.bind(mann, cent)), t2]
				, [/* TODO! */ t2 ]
				, [new StartDialogue(setVerkaufMannDlg.bind(mann, verkaeuferin, euro, cent, broetchen)), t2 ]
				, [new StartDialogue(setVerkaufVerkDlg.bind(mann, verkaeuferin, cent != null)), t2 ]
				, [/* TODO! */ t2 ]
			]);
		
		Dialogue.insert([ test ]);
	}
}
